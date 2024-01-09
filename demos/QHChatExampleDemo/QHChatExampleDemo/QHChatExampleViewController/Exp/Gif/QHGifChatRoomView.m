//
//  QHGifChatRoomView.m
//  QHChatExampleDemo
//
//  Created by qihuichen on 2024/1/8.
//

#import "QHGifChatRoomView.h"

#import "QHChatGifTableViewCell.h"
#import "QHTKRoomChatVIewUtil+Gif.h"

#define kQHCHAT_GIF_CONTENT_CELLIDENTIFIER @"QHChatGIFContentCellIdentifier"

@implementation QHGifChatRoomView

#pragma mark - QHChatBaseViewProtocol

- (void)qhChatAddCell2TableView:(UITableView *)tableView {
    [super qhChatAddCell2TableView:tableView];
    [tableView registerClass:[QHChatGifTableViewCell class] forCellReuseIdentifier:kQHCHAT_GIF_CONTENT_CELLIDENTIFIER];
}

- (NSMutableAttributedString *)qhChatAnalyseContent:(NSDictionary *)data emojiType:(NSUInteger)type {
    NSString *op = data[kTKChatOpKey];
    NSMutableAttributedString *content = nil;
    if ([op isEqualToString:kTKChatOpValueChat] == YES) {
        content = [QHTKRoomChatVIewUtil toChatGif:data];
    }
    else if ([op isEqualToString:kTKChatOpValueNotice] == YES) {
        content = [QHTKRoomChatVIewUtil toNotice:data];
    }
    return content;
}

- (CGFloat)qhChatAnalyseHeight:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
    if (model.chatAttributedText == nil) {
        return 0;
    }
    UIEdgeInsets contentEI = TKQHCHAT_LC_CONTENT_EDGEINSETS;
    UIEdgeInsets contentTextEI = TKQHCHAT_GIF_CONTENT_TEXT_EDGEINSETS;
    
    CGFloat w = self.config.cellConfig.cellWidth - contentEI.left - contentEI.right - contentTextEI.left - contentTextEI.right;
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [model.chatAttributedText boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:options context:nil];
    CGFloat h = rect.size.height + self.config.cellConfig.cellLineSpacing + contentEI.top + contentEI.bottom + contentTextEI.top + contentTextEI.bottom;
    return h;
}

- (UITableViewCell *)qhChatChatView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *chatCell = nil;
    QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
    if (model.chatAttributedText != nil) {
        QHChatGifTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQHCHAT_GIF_CONTENT_CELLIDENTIFIER];
        cell.contentTV.attributedText = model.chatAttributedText;
        cell.delegate = self;
        [cell.contentTV start];
        chatCell = cell;
    }
    
    return chatCell;
}


@end
