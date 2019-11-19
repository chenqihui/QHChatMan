//
//  QHChatBaseView.m
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/20.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import "QHChatBaseView.h"

#import "QHViewUtil.h"
#import "NSTimer+QHEOCBlocksSupport.h"

#import "QHChatBaseViewCell.h"
#import "QHChatBaseNewDataView.h"

#define kQHCHATBASE_CELLIDENTIFIER @"QHChatbaseCellIdentifier"

@interface QHChatBaseView () <UITableViewDataSource, UITableViewDelegate, QHChatBaseViewCellDelegate>

@property (nonatomic, strong, readwrite) UITableView *mainTableV;
@property (nonatomic, strong, readwrite) NSMutableArray<QHChatBaseModel *> *chatDatasArray;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *chatDatasTempArray;
@property (nonatomic) BOOL bAutoReloadChat;
@property (nonatomic, strong) NSTimer *reloadTimer;
@property (nonatomic, strong) UIView<QHChatBaseNewDataViewProtcol> *hasNewDataView;

@property (nonatomic) dispatch_queue_t chatReloadQueue;
@property (nonatomic) BOOL bOutHeight;

@end

@implementation QHChatBaseView

- (void)dealloc {
#if DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    [self p_closeReloadTimer];
    _chatDatasArray = nil;
    _chatDatasTempArray = nil;
    _hasNewDataView = nil;
}

- (instancetype)init {
    return [self initWithConfig:[QHChatBaseConfig new]];
}

- (instancetype)initWithConfig:(QHChatBaseConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
        [self p_setup];
    }
    return self;
}

#pragma mark - Public

+ (instancetype)createChatViewToSuperView:(UIView *)superView {
    QHChatBaseView *subView = [[self alloc] init];
    [superView addSubview:subView];
    [QHViewUtil fullScreen:subView];
    
    return subView;
}

+ (instancetype)createChatViewToSuperView:(UIView *)superView withConfig:(QHChatBaseConfig *)config {
    QHChatBaseView *subView = [[self alloc] initWithConfig:config];
    [superView addSubview:subView];
    [QHViewUtil fullScreen:subView];
    
    return subView;
}

- (void)insertChatData:(NSArray<NSDictionary *> *)data {
    if (data == nil || data.count <= 0) {
        return;
    }
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:_cmd withObject:data waitUntilDone:NO];
        return;
    }
    
    [_chatDatasTempArray addObjectsFromArray:data];
    if (_chatDatasTempArray.count > _config.chatCountMax) {
        [_chatDatasTempArray removeObjectsInRange:NSMakeRange(0, _config.chatCountDelete)];
    }
    [self p_reloadAndRefresh:NO];
}

- (void)clearChatData {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:NO];
        return;
    }
    [self p_closeReloadTimer];
    [_chatDatasTempArray removeAllObjects];
    [_chatDatasArray removeAllObjects];
    _bAutoReloadChat = YES;
    [_hasNewDataView hide];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.mainTableV reloadData];
    [CATransaction commit];
    
    if (_config.bOpenScorllFromBottom == YES) {
        _bOutHeight = NO;
    }
}

- (void)scrollToBottom {
    [self p_closeReloadTimer];
    _hasNewDataView.hidden = YES;
    _bAutoReloadChat = YES;
    if (self.chatDatasArray.count > 0) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.mainTableV reloadData];
        [CATransaction commit];
        
        CGFloat hasCellHeight = 0;
        
        if (_config.bOpenScorllFromBottom == YES) {
            _bOutHeight = NO;
            hasCellHeight = [self p_hasCellHeight];
            if (hasCellHeight >= self.mainTableV.bounds.size.height) {
                _bOutHeight = YES;
            }
        }
        
        if (_bOutHeight == YES || _config.bOpenScorllFromBottom == NO) {
            if (self.mainTableV.isDragging == NO && self.mainTableV.tracking == NO) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatDatasArray.count - 1 inSection:0];
                [self.mainTableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        else {
            [self p_updateTableContentInset:hasCellHeight];
        }
    }
    [self p_reloadAndRefresh:NO];
}


#pragma mark - Private

- (void)p_setup {
    [self p_setupData];
    [self p_setupUI];
    [self qhChatCustomChatViewSetup];
}

- (void)p_setupData {
    _chatDatasArray = [NSMutableArray new];
    _chatDatasTempArray = [NSMutableArray new];
    _bAutoReloadChat = YES;
    self.backgroundColor = [UIColor clearColor];
    
    _chatReloadQueue = dispatch_queue_create("com.qhchat.queue", NULL);
    if (_config.bOpenScorllFromBottom == YES) {
        _bOutHeight = NO;
    }
    else {
        _bOutHeight = YES;
    }
}

- (void)p_setupUI {
    [self p_addTableView];
    
    if (_config.bLongPress) {
        UILongPressGestureRecognizer *longPressGec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        if (_config.minimumPressDuration > 0) {
            longPressGec.minimumPressDuration = _config.minimumPressDuration;
        }
        [_mainTableV addGestureRecognizer:longPressGec];
    }
}

- (void)p_addTableView {
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableV.dataSource = self;
    tableV.delegate = self;
    // [UITableView 滚动到底部 闪一下的问题](https://dongjiawang.top/2017/07/31/2017-07-31-UITableView-auto-bottom/)
    tableV.estimatedRowHeight = 0;
    tableV.estimatedSectionHeaderHeight = 0;
    tableV.estimatedSectionFooterHeight = 0;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.backgroundColor = [UIColor clearColor];
    tableV.tableFooterView = [UIView new];
    tableV.clipsToBounds = YES;
    tableV.scrollsToTop = YES;
    tableV.showsHorizontalScrollIndicator = NO;
    tableV.showsVerticalScrollIndicator = NO;
    tableV.allowsSelection = NO;
    [self addSubview:tableV];
    [QHViewUtil fullScreen:tableV];
    
    _mainTableV = tableV;
    
    //    [tableView registerClass:[QHChatBaseViewCell class] forCellReuseIdentifier:kQHCHATBASE_CELLIDENTIFIER];
    
    [self qhChatAddCell2TableView:_mainTableV];
}

- (void)p_reloadAndRefresh:(BOOL)bRefreshImmediately {
    if (_bAutoReloadChat == YES) {
        if (_reloadTimer == nil || _reloadTimer.isValid == NO) {
            __weak typeof(self) weakSelf = self;
            _reloadTimer = [NSTimer qheoc_scheduledTimerWithTimeInterval:_config.chatReloadDuration block:^{
                dispatch_sync(weakSelf.chatReloadQueue, ^{
                    [weakSelf p_reloadAction];
                });
            } repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_reloadTimer forMode:NSRunLoopCommonModes];
        }
        if (bRefreshImmediately == YES) {
            // [NSTimer的使用 停止 暂停 重启 - wahaha13168 - CSDN博客](https://blog.csdn.net/wahaha13168/article/details/52804048)
            // setFireDate 会立即触发 Timer 并重新计时，而 fire 只是立即触发
            // 该延迟可以避免加载过清空时，公屏列表出现空白的情况
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MIN(0.05, _config.chatReloadDuration/2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.reloadTimer setFireDate:[NSDate date]];
            });
        }
    }
    else {
        [self.hasNewDataView update:@(_chatDatasTempArray.count)];
    }
}

- (void)p_reloadAction {
    if (_chatDatasTempArray.count <= 0) {
        [self p_closeReloadTimer];
        return;
    }
    if (_bAutoReloadChat == NO) {
        [self.hasNewDataView update:@(_chatDatasTempArray.count)];
        [self p_closeReloadTimer];
        return;
    }
    
    NSArray<NSDictionary *> *tempArray = [NSArray arrayWithArray:_chatDatasTempArray];
    [_chatDatasTempArray removeAllObjects];
    
    __block BOOL isReplaceChatData = NO;
    [tempArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL bReplace = [self qhChatUseReplace:obj old:[self.chatDatasArray lastObject].originChatDataDic];
        QHChatBaseModel *model = [[QHChatBaseModel alloc] initWithChatData:obj];
        model.cellConfig = self.config.cellConfig;
        if (bReplace == YES) {
            [self.chatDatasArray replaceObjectAtIndex:self.chatDatasArray.count - 1 withObject:model];
            isReplaceChatData = YES;
        }
        else {
            [self.chatDatasArray addObject:model];
        }
    }];
    
    BOOL bDeleteChatData = NO;
    if (_chatDatasArray.count > _config.chatCountMax) {
        [_chatDatasArray removeObjectsInRange:NSMakeRange(0, _config.chatCountDelete)];
        bDeleteChatData = YES;
    }
    
    // 只有当加入的数据为1个，且是替换，和此次没有删除数据时，才启动指定刷新
    if (tempArray.count == 1 && bDeleteChatData == NO && isReplaceChatData == YES) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.chatDatasArray.count - 1) inSection:0];
//        if (isReplaceChatData == YES) {
            [self.mainTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        }
//        else {
//            [self.mainTableV insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        }
    }
    else {
    // [IOS开发之CLAyer 隐式动画 - 简书](https://www.jianshu.com/p/930cea99023d)
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.mainTableV reloadData];
        [CATransaction commit];
    }
    
    CGFloat hasCellHeight = 0;
    if (_bOutHeight == NO) {
        hasCellHeight = [self p_hasCellHeight];
        if (hasCellHeight >= self.mainTableV.bounds.size.height) {
            _bOutHeight = YES;
        }
    }
    
    if (_bOutHeight == YES || _config.bOpenScorllFromBottom == NO) {
        if (self.mainTableV.isDragging == NO && self.mainTableV.tracking == NO) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatDatasArray.count - 1 inSection:0];
            [self.mainTableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    else {
        [self p_updateTableContentInset:hasCellHeight];
    }
    tempArray = nil;
}

- (void)p_refreshAutoReloadChat {
    NSIndexPath *indexPath = [[_mainTableV indexPathsForVisibleRows] lastObject];
    
    if (indexPath.row == _chatDatasArray.count - 1) {
        _bAutoReloadChat = YES;
    }
    
    if (_bAutoReloadChat == NO) {
        //当向上滑动，隐藏全部cell时，vidx是nil，就要从新判断下；
        _bAutoReloadChat = (_mainTableV.contentOffset.y >= _mainTableV.contentSize.height);
    }
    
    if (_bAutoReloadChat == YES) {
        [_hasNewDataView hide];
    }
}

- (void)p_closeReloadTimer {
    if (_reloadTimer != nil) {
        [_reloadTimer invalidate];
    }
    _reloadTimer = nil;
}

- (NSAttributedString *)p_goContent:(NSIndexPath *)indexPath {
    QHChatBaseModel *model = _chatDatasArray[indexPath.row];
    if (model.chatAttributedText != nil && [_config isEqualToCellConfig:model.cellConfig] == YES) {
        return model.chatAttributedText;
    }
    model.cellConfig = _config.cellConfig;
    
    NSMutableAttributedString *content = [self qhChatAnalyseContent:_chatDatasArray[indexPath.row].originChatDataDic];
    
    if (content != nil) {
        [self qhChatAddCellDefualAttributes:content];
        model.chatAttributedText = content;
    }
    return content;
}

- (CGFloat)p_goHeight:(NSIndexPath *)indexPath {
    QHChatBaseModel *model = _chatDatasArray[indexPath.row];
    if (model.cellHeight > 0 && [_config isEqualToCellConfig:model.cellConfig] == YES) {
        return model.cellHeight;
    }
    
    NSAttributedString *content = [self p_goContent:indexPath];
    CGFloat h = 0;
    CGFloat hh = [self qhChatAnalyseHeight:_mainTableV heightForRowAtIndexPath:indexPath];
    if (hh >= 0) {
        h = hh;
    }
    else {
        if (content != nil) {
            // [iOS 计算NSString宽高与计算NSAttributedString的宽高 - 简书](https://www.jianshu.com/p/76ab08089941)
            CGFloat needWidth = (_config.cellConfig.cellWidth - _config.cellEdgeInsets.left - _config.cellEdgeInsets.right);
            NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            CGRect rect = [content boundingRectWithSize:CGSizeMake(needWidth, CGFLOAT_MAX) options:options context:nil];
            // +cellLineSpacing 是由于上面计算出是包括设置的行距，所以只加一次为最后一行
            h = rect.size.height + _config.cellConfig.cellLineSpacing + _config.cellEdgeInsets.top + _config.cellEdgeInsets.bottom;
        }
    }
    
    model.cellHeight = h;
    return model.cellHeight;
}

- (CGFloat)p_hasCellHeight {
    NSInteger numRows = [self tableView:self.mainTableV numberOfRowsInSection:0];
    CGFloat hasCellHeight = 0;
    for (NSInteger i = 0; i < numRows; i++) {
        hasCellHeight += [self tableView:self.mainTableV heightForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    return hasCellHeight;
}

- (void)p_updateTableContentInset:(CGFloat)height {
    CGFloat contentInsetTop = MAX(self.mainTableV.bounds.size.height - height, 0);
    self.mainTableV.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0);
}

#pragma mark - QHChatBaseViewProtocol

- (void)qhChatCustomChatViewSetup {
}

- (void)qhChatAddCell2TableView:(UITableView *)tableView {
}

- (NSMutableAttributedString *)qhChatAnalyseContent:(NSDictionary *)data {
    NSMutableAttributedString *c = [[NSMutableAttributedString alloc] initWithString:data[@"c"]];
    return c;
}

- (UIView<QHChatBaseNewDataViewProtcol> *)qhChatTakeHasNewDataView {
    QHChatBaseNewDataView *view = [QHChatBaseNewDataView createViewToSuperView:self];
    return view;
}

- (CGFloat)qhChatAnalyseHeight:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return -1;
}

- (UITableViewCell *)qhChatChatView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)qhChatMakeAfterChatBaseViewCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)qhChatAddCellDefualAttributes:(NSMutableAttributedString *)attr {
    [QHChatBaseUtil addCellDefualAttributes:attr lineSpacing:_config.cellConfig.cellLineSpacing fontSize:_config.cellConfig.fontSize];
}

- (BOOL)qhChatUseReplace:(NSDictionary *)newData old:(NSDictionary *)lastData {
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _chatDatasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHChatBaseModel *model = _chatDatasArray[indexPath.row];
    if (model.chatAttributedText == nil) {
        NSAttributedString *content = [self p_goContent:indexPath];
        model.chatAttributedText = content;
    }
    UITableViewCell *customCell = [self qhChatChatView:tableView cellForRowAtIndexPath:indexPath];
    if (customCell != nil) {
        return customCell;
    }
    QHChatBaseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQHCHATBASE_CELLIDENTIFIER];
    if (cell == nil) {
        cell = [[QHChatBaseViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kQHCHATBASE_CELLIDENTIFIER];
        [cell makeContent:_config.cellEdgeInsets];
    }
    cell.contentL.attributedText = model.chatAttributedText;
    cell.delegate = self;
    [self qhChatMakeAfterChatBaseViewCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = [self p_goHeight:indexPath];
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _bAutoReloadChat = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self p_refreshAutoReloadChat];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self p_refreshAutoReloadChat];
}

#pragma mark - QHChatBaseViewCellDelegate

- (void)selectViewCell:(UITableViewCell *)viewCell {
    if ([self.delegate respondsToSelector:@selector(chatView:didSelectRowWithData:)] == YES) {
        NSIndexPath *indexPath = [_mainTableV indexPathForCell:viewCell];
        QHChatBaseModel *model = _chatDatasArray[indexPath.row];
        [self.delegate chatView:self didSelectRowWithData:model.originChatDataDic];
    }
}

- (void)deselectViewCell:(UITableViewCell *)viewCell {
    if ([self.delegate respondsToSelector:@selector(chatView:didDeselectRowWithData:)] == YES) {
        NSIndexPath *indexPath = [_mainTableV indexPathForCell:viewCell];
        QHChatBaseModel *model = _chatDatasArray[indexPath.row];
        [self.delegate chatView:self didDeselectRowWithData:model.originChatDataDic];
    }
}

#pragma mark - Action

- (void)longPressAction:(UILongPressGestureRecognizer *)gec {
    if (gec.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(chatView:didLongSelectRowWithData:)]) {
            CGPoint point = [gec locationInView:_mainTableV];
            NSIndexPath *indexPath = [_mainTableV indexPathForRowAtPoint:point];
            QHChatBaseModel *model = _chatDatasArray[indexPath.row];
        
            [self.delegate chatView:self didLongSelectRowWithData:model.originChatDataDic];
        }
    }
}

- (void)p_clickNewDataViewAction {
    _hasNewDataView.hidden = YES;
    if (_chatDatasArray.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatDatasArray.count - 1 inSection:0];
        [self.mainTableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    _bAutoReloadChat = YES;
    [self p_reloadAndRefresh:YES];
}

#pragma mark - Get

- (UIView<QHChatBaseNewDataViewProtcol> *)hasNewDataView {
    if (_hasNewDataView == nil) {
        _hasNewDataView = [self qhChatTakeHasNewDataView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_clickNewDataViewAction)];
        [_hasNewDataView addGestureRecognizer:tap];
        
        tap = nil;
    }
    return _hasNewDataView;
}

@end
