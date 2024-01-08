//
//  QHGifChatRoomView.m
//  QHChatExampleDemo
//
//  Created by qihuichen on 2024/1/8.
//

#import "QHGifChatRoomView.h"

#import "QHChatGifTableViewCell.h"

#define kQHCHAT_GIF_CONTENT_CELLIDENTIFIER @"QHChatGIFContentCellIdentifier"

@implementation QHGifChatRoomView

#pragma mark - QHChatBaseViewProtocol

- (void)qhChatAddCell2TableView:(UITableView *)tableView {
    [super qhChatAddCell2TableView:tableView];
    [tableView registerClass:[QHChatGifTableViewCell class] forCellReuseIdentifier:kQHCHAT_GIF_CONTENT_CELLIDENTIFIER];
}

- (NSMutableAttributedString *)qhChatAnalyseContent:(NSDictionary *)data {
    NSString *op = data[kTKChatOpKey];
    NSMutableAttributedString *content = nil;
    if ([op isEqualToString:kTKChatOpValueChat] == YES) {
        content = [QHTKRoomChatVIewUtil toChat:data isAnchor:YES isCurrentUser:NO];
    }
    else if ([op isEqualToString:kTKChatOpValueNotice] == YES) {
        content = [QHTKRoomChatVIewUtil toNotice:data];
    }
    return content;
}

- (UITableViewCell *)qhChatChatView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *chatCell = nil;
    QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
    if (model.chatAttributedText != nil) {
        QHTKRoomChatContentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQHCHAT_TK_CONTENT_CELLIDENTIFIER];
        cell.contentL.attributedText = model.chatAttributedText;
        cell.delegate = self;
//        [cell cellUpdateConstraints];
        chatCell = cell;
    }
    
    return chatCell;
}


@end
