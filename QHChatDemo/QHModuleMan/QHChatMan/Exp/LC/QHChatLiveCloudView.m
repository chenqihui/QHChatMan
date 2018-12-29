//
//  QHChatLiveCloudView.m
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/28.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import "QHChatLiveCloudView.h"

#import "QHChatLiveCloudNewDataView.h"
#import "QHChatLiveCloudContentViewCell.h"
#import "QHChatLiveCloudDateViewCell.h"

#import "QHChatLiveCloudUtil.h"

#define kQHCHAT_LC_CONTENT_CELLIDENTIFIER @"QHChatLCContentCellIdentifier"
#define kQHCHAT_LC_DATE_CELLIDENTIFIER @"QHChatLCDateCellIdentifier"

#define kQHCHAT_LC_SHOWDATE_TIME 160
#define kQHCHAT_LC_SHOWDATE_KEY @"lcstk"

NSString *const kChatOpKey = @"op";
NSString *const kChatOpValueChat = @"chat";
NSString *const kChatOpValueGift = @"gift";
NSString *const kChatOpValueDate = @"qhlcdate";
NSString *const kChatOpValueEnter = @"enter";

@interface QHChatLiveCloudView ()

@property (nonatomic, strong) NSDate *lastInsertDate;
@property (nonatomic) CGFloat dateStringHeight;

@end

@implementation QHChatLiveCloudView

#pragma mark - Public

- (void)lcInsertChatData:(NSArray<NSDictionary *> *)data {
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = kQHCHAT_LC_SHOWDATE_TIME;
    if (_lastInsertDate != nil) {
        interval = [nowDate timeIntervalSinceDate:_lastInsertDate];
    }
    if (interval >= kQHCHAT_LC_SHOWDATE_TIME) {
        // [NSDateFormatter类的使用(持续更新) - MeteoriteMan的博客 - CSDN博客](https://blog.csdn.net/qq_18683985/article/details/80249852)
        // [德尔福 - 获得年度最佳周 - Stack Overflow](https://stackoverflow.com/questions/7816747/get-week-of-the-year)
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日 aahh:mm"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        NSString *dateString = [formatter stringFromDate:nowDate];
        NSDictionary *dataMeg = @{kChatOpKey: kChatOpValueDate, kQHCHAT_LC_SHOWDATE_KEY: dateString};
        [self insertChatData:@[dataMeg]];
    }
    [self insertChatData:data];
    _lastInsertDate = nowDate;
}

#pragma mark - QHChatBaseViewProtocol

- (void)qhChatCustomChatViewSetup {
    _dateStringHeight = [QHChatBaseUtil calculateString:@"陈" size:CGSizeMake(CGFLOAT_MAX, 100) font:[UIFont systemFontOfSize:10]].height;
}

- (void)qhChatAddCell2TableView:(UITableView *)tableView {
    [tableView registerClass:[QHChatLiveCloudContentViewCell class] forCellReuseIdentifier:kQHCHAT_LC_CONTENT_CELLIDENTIFIER];
    [tableView registerClass:[QHChatLiveCloudDateViewCell class] forCellReuseIdentifier:kQHCHAT_LC_DATE_CELLIDENTIFIER];
}

- (NSMutableAttributedString *)qhChatAnalyseContent:(NSDictionary *)data {
    NSString *op = data[kChatOpKey];
    NSMutableAttributedString *content = nil;
    if ([op isEqualToString:kChatOpValueChat] == YES) {
        content = [QHChatLiveCloudUtil toChat:data];
    }
    else if ([op isEqualToString:kChatOpValueDate] == YES) {
    }
    else if ([op isEqualToString:kChatOpValueGift] == YES) {
        content = [QHChatLiveCloudUtil toGift:data];
    }
    else if ([op isEqualToString:kChatOpValueEnter] == YES) {
        content = [QHChatLiveCloudUtil toEnter:data];
    }
    return content;
}

- (UIView<QHChatBaseNewDataViewProtcol> *)qhChatTakeHasNewDataView {
    QHChatLiveCloudNewDataView *view = [QHChatLiveCloudNewDataView createViewToSuperView:self];
    return view;
}

- (CGFloat)qhChatAnalyseHeight:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHChatBaseModel *model = self.chatDatasArray[indexPath.row];
    NSDictionary *data = model.originChatDataDic;
    NSString *op = data[kChatOpKey];
    if ([op isEqualToString:kChatOpValueChat] == YES ||
        [op isEqualToString:kChatOpValueGift] == YES ||
        [op isEqualToString:kChatOpValueEnter] == YES) {
        if (model.chatAttributedText == nil) {
            return 0;
        }
        CGFloat w = self.config.cellConfig.cellWidth - QHCHAT_LC_CONTENT_EDGEINSETS.left - QHCHAT_LC_CONTENT_EDGEINSETS.right - QHCHAT_LC_CONTENT_TEXT_EDGEINSETS.left - QHCHAT_LC_CONTENT_TEXT_EDGEINSETS.right;
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGRect rect = [model.chatAttributedText boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:options context:nil];
        CGFloat h = rect.size.height + self.config.cellConfig.cellLineSpacing + QHCHAT_LC_CONTENT_EDGEINSETS.top + QHCHAT_LC_CONTENT_EDGEINSETS.bottom + QHCHAT_LC_CONTENT_TEXT_EDGEINSETS.top + QHCHAT_LC_CONTENT_TEXT_EDGEINSETS.bottom;
        return h;
    }
    else if ([op isEqualToString:kChatOpValueDate] == YES) {
        return QHCHAT_LC_DATE_SPACE_TOP + _dateStringHeight;
    }
    return -1;
}

- (UITableViewCell *)qhChatChatView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *chatCell = nil;
    QHChatBaseModel *model = self.chatDatasArray[indexPath.row];
    NSDictionary *data = model.originChatDataDic;
    NSString *op = data[kChatOpKey];
    if ([op isEqualToString:kChatOpValueChat] == YES ||
        [op isEqualToString:kChatOpValueGift] == YES ||
        [op isEqualToString:kChatOpValueEnter] == YES) {
        QHChatLiveCloudContentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQHCHAT_LC_CONTENT_CELLIDENTIFIER];
        cell.contentL.attributedText = model.chatAttributedText;
        chatCell = cell;
    }
    else if ([op isEqualToString:kChatOpValueDate] == YES) {
        QHChatLiveCloudDateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQHCHAT_LC_DATE_CELLIDENTIFIER];
        cell.contentL.text = data[kQHCHAT_LC_SHOWDATE_KEY];
        chatCell = cell;
    }
    return chatCell;
}

- (BOOL)qhChatUseReplace:(NSDictionary *)newData old:(NSDictionary *)lastData {
    if (self.chatDatasArray.count >= 3 && lastData != nil) {
        NSString *op = newData[kChatOpKey];
        if ([op isEqualToString:kChatOpValueEnter] == YES) {
            NSString *op1 = lastData[kChatOpKey];
            if ([op1 isEqualToString:kChatOpValueEnter] == YES) {
                return YES;
            }
        }
    }
    return NO;
}

@end
