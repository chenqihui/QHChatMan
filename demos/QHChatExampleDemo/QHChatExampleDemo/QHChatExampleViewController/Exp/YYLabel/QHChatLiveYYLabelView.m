//
//  QHChatLiveYYLabelView.m
//  QHChatExampleDemo
//
//  Created by qihuichen on 2024/1/9.
//

#import "QHChatLiveYYLabelView.h"

#import "QHChatLiveCloudTFHppleUtil+YYLabel.h"
#import "QHChatLiveYYLabelTableViewCell.h"

#define kQHCHAT_YYLABEL_CONTENT_CELLIDENTIFIER @"QHChatYYLabelContentCellIdentifier"

@implementation QHChatLiveYYLabelView

- (void)qhChatAddCell2TableView:(UITableView *)tableView {
    [super qhChatAddCell2TableView:tableView];
    [tableView registerClass:[QHChatLiveYYLabelTableViewCell class] forCellReuseIdentifier:kQHCHAT_YYLABEL_CONTENT_CELLIDENTIFIER];
}

- (NSMutableAttributedString *)qhChatAnalyseContent:(NSDictionary *)data emojiType:(NSUInteger)type {
    NSString *op = data[kChatOpKey2];
    NSMutableAttributedString *content = nil;
    if ([op isEqualToString:kChatOpValueChat2] == YES) {
        content = [QHChatLiveCloudTFHppleUtil toChat2:data];
    }
    else if ([op isEqualToString:kChatOpValueGift2] == YES) {
        content = [QHChatLiveCloudTFHppleUtil toGift:data];
    }
    else if ([op isEqualToString:kChatOpValueEnter2] == YES) {
        content = [QHChatLiveCloudTFHppleUtil toEnter:data];
    }
    return content;
}

- (CGFloat)qhChatAnalyseHeight:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
    NSDictionary *data = model.originChatDataDic;
    if (model.chatAttributedText == nil) {
        return 0;
    }
    CGFloat w = self.config.cellConfig.cellWidth - QHCHAT_LC_CONTENT_EDGEINSETS.left - QHCHAT_LC_CONTENT_EDGEINSETS.right - QHCHAT_LC_CONTENT_TEXT_EDGEINSETS.left - QHCHAT_LC_CONTENT_TEXT_EDGEINSETS.right;
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [model.chatAttributedText boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:options context:nil];
    CGFloat h = ceilf(rect.size.height) + QHCHAT_LC_CONTENT_EDGEINSETS.top + QHCHAT_LC_CONTENT_EDGEINSETS.bottom + QHCHAT_LC_CONTENT_TEXT_EDGEINSETS.top + QHCHAT_LC_CONTENT_TEXT_EDGEINSETS.bottom;
    return h;
}

- (UITableViewCell *)qhChatChatView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
    NSDictionary *data = model.originChatDataDic;
    NSString *op = data[kChatOpKey2];
    if ([op isEqualToString:kChatOpValueChat2] == YES) {
        QHChatLiveYYLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQHCHAT_YYLABEL_CONTENT_CELLIDENTIFIER];
        cell.contentYYL.attributedText = model.chatAttributedText;
        return cell;
    }
    return nil;
}

- (NSUInteger)qhChatEmojiType:(NSDictionary *)data {
    return 1;
}

@end
