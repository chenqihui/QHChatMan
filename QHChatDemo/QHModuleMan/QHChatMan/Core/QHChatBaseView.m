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

@end

@implementation QHChatBaseView

- (void)dealloc {
#if DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    [self p_closeReloadTimer];
}

- (instancetype)init {
    self = [super init];
    if (self) {
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

- (void)insertChatData:(NSArray<NSDictionary *> *)data {
    if (data == nil || data.count <= 0) {
        return;
    }
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:_cmd withObject:data waitUntilDone:NO];
        return;
    }
    
    BOOL bRefresh = (_chatDatasTempArray.count <= 0);
    [_chatDatasTempArray addObjectsFromArray:data];
    [self p_reloadAndRefresh:bRefresh];
}

#pragma mark - Private

- (void)p_setup {
    [self p_setupData];
    [self p_setupUI];
    [self qhChatCustomChatViewSetup];
}

- (void)p_setupData {
    _config = [QHChatBaseConfig new];
    _chatDatasArray = [NSMutableArray new];
    _chatDatasTempArray = [NSMutableArray new];
    _bAutoReloadChat = YES;
    self.backgroundColor = [UIColor clearColor];
}

- (void)p_setupUI {
    [self p_addTableView];
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

- (void)p_reloadAndRefresh:(BOOL)bRefresh {
    if (_bAutoReloadChat == YES) {
        if (_reloadTimer == nil || _reloadTimer.isValid == NO) {
            __weak typeof(self) weakSelf = self;
            _reloadTimer = [NSTimer qheoc_scheduledTimerWithTimeInterval:_config.chatReloadDuration block:^{
                [weakSelf p_reloadAction];
            } repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_reloadTimer forMode:NSRunLoopCommonModes];
        }
        if (bRefresh == YES) {
            // [NSTimer的使用 停止 暂停 重启 - wahaha13168 - CSDN博客](https://blog.csdn.net/wahaha13168/article/details/52804048)
            // setFireDate 会立即触发 Timer 并重新计时，而 fire 只是立即触发
            [_reloadTimer setFireDate:[NSDate date]];
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
    NSInteger tempArrayCount = tempArray.count;
    [tempArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL bReplace = [self qhChatUseReplace:obj old:[self.chatDatasArray lastObject].originChatDataDic];
        QHChatBaseModel *model = [[QHChatBaseModel alloc] initWithChatData:obj];
        model.cellConfig = self.config.cellConfig;
        if (bReplace == YES) {
            [self.chatDatasArray replaceObjectAtIndex:self.chatDatasArray.count - 1 withObject:model];
            if (tempArrayCount == 1) {
                [self.mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.chatDatasArray.count - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else {
            [self.chatDatasArray addObject:model];
            if (tempArrayCount == 1) {
                [self.mainTableV insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.chatDatasArray.count - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }];
    tempArray = nil;
    
    if (_chatDatasArray.count > _config.chatCountMax) {
        [_chatDatasArray removeObjectsInRange:NSMakeRange(0, _config.chatCountDelete)];
    }
    
    if (tempArrayCount > 1) {
    // [IOS开发之CLAyer 隐式动画 - 简书](https://www.jianshu.com/p/930cea99023d)
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.mainTableV reloadData];
        [CATransaction commit];
    }
    if (self.mainTableV.isDragging == NO && self.mainTableV.tracking == NO) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatDatasArray.count - 1 inSection:0];
        [self.mainTableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
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
        _reloadTimer = nil;
    }
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

- (void)p_clickNewDataViewAction {
    _hasNewDataView.hidden = YES;
    _bAutoReloadChat = YES;
    [self p_reloadAndRefresh:YES];
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
    NSIndexPath *indexPath = [_mainTableV indexPathForCell:viewCell];
    QHChatBaseModel *model = _chatDatasArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(chatView:didSelectRowWithData:)] == YES) {
        [self.delegate chatView:self didSelectRowWithData:model.originChatDataDic];
    }
}

- (void)deselectViewCell:(UITableViewCell *)viewCell {
    NSIndexPath *indexPath = [_mainTableV indexPathForCell:viewCell];
    QHChatBaseModel *model = _chatDatasArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(chatView:didSelectRowWithData:)] == YES) {
        [self.delegate chatView:self didSelectRowWithData:model.originChatDataDic];
    }
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
