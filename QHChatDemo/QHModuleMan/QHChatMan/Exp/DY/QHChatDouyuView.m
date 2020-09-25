//
//  QHChatDouyuView.m
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/21.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import "QHChatDouyuView.h"

#import "QHViewUtil.h"
#import "QHChatBaseUtil+DYText.h"

#import "QHChatDouyuTipTableViewCell.h"

#define kQHCHAT_DY_TIP_CELLIDENTIFIER @"QHChatDYTipCellIdentifier"

@implementation QHChatDouyuView

#pragma mark - QHChatBaseViewProtocol

- (void)qhChatAddCell2TableView:(UITableView *)tableView {
    UINib *cellNib = [UINib nibWithNibName:@"QHChatDouyuTipTableViewCell" bundle:nil];
    [tableView registerNib:cellNib forCellReuseIdentifier:kQHCHAT_DY_TIP_CELLIDENTIFIER];
}

- (NSMutableAttributedString *)qhChatAnalyseContent:(NSDictionary *)data {
    NSInteger type = [data[@"t"] integerValue];
    NSMutableAttributedString *content = nil;
    switch (type) {
        case 1:
            content = [QHChatBaseUtil enter:data];
            break;
        case 2:
            content = [QHChatBaseUtil say:data];
            break;
        case 3:
            content = [QHChatBaseUtil system:data];
            break;
        case 4:
        default:
            break;
    }
    return content;
}

- (UIView<QHChatBaseNewDataViewProtcol> *)qhChatTakeHasNewDataView {
    QHChatDouyuNewDataView *view = [QHChatDouyuNewDataView createViewToSuperView:self];
    return view;
}

- (CGFloat)qhChatAnalyseHeight:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
    NSInteger type = [model.originChatDataDic[@"t"] integerValue];
    if (type == 4) {
        return 30;
    }
    return -1;
}

- (UITableViewCell *)qhChatChatView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
    if (model != nil) {
        NSInteger type = [model.originChatDataDic[@"t"] integerValue];
        if (type == 4) {
            QHChatDouyuTipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQHCHAT_DY_TIP_CELLIDENTIFIER];
            cell.contentL.text = model.originChatDataDic[@"c"];
            return cell;
        }
    }
    return nil;
}

- (void)qhChatMakeAfterChatBaseViewCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
    NSInteger type = [model.originChatDataDic[@"bc"] integerValue];
    switch (type) {
        case 1:
            cell.contentView.backgroundColor = QHCOLOR_RGBA(214, 233, 249, 1);
            break;
        case 2:
            cell.contentView.backgroundColor = QHCOLOR_RGBA(254, 239, 214, 1);
            break;
        default:
            cell.contentView.backgroundColor = [UIColor whiteColor];
            break;
    }
}

@end

@implementation QHChatDouyuNewDataView

#pragma mark - Public

+ (instancetype)createViewToSuperView:(UIView *)superView {
    QHChatDouyuNewDataView *view = [[self alloc] init];
    [superView addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(view);
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(26)]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(100)]" options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [view p_setup];
    
    return view;
}

#pragma mark - Private

- (void)p_setup {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    self.hidden = YES;
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = [UIColor orangeColor];
    titleL.font = [UIFont systemFontOfSize:11];
    titleL.text = @"底部有新消息";
    [self addSubview:titleL];
    
    titleL.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *subViewsDict = NSDictionaryOfVariableBindings(titleL);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[titleL]-8-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:subViewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleL]-10-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:subViewsDict]];
    titleL = nil;
}

#pragma mark - QHChatBaseNewDataViewProtcol

- (void)update:(id)data {
    [self show];
}

@end
