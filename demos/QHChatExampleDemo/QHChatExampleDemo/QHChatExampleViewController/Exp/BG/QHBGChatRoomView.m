//
//  QHBGChatRoomView.m
//  QHChatDemo
//
//  Created by Anakin chen on 2019/12/8.
//  Copyright © 2019 Chen Network Technology. All rights reserved.
//

#import "QHBGChatRoomView.h"

#import "QHBGRoomChatContentViewCell.h"

#define kQHCHAT_BG_CONTENT_CELLIDENTIFIER @"BGQHChatLCContentCellIdentifier"

@implementation QHBGChatRoomView

- (void)qhChatAddCell2TableView:(UITableView *)tableView {
    [tableView registerClass:[QHBGRoomChatContentViewCell class] forCellReuseIdentifier:kQHCHAT_BG_CONTENT_CELLIDENTIFIER];
}

- (UITableViewCell *)qhChatChatView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *chatCell = nil;
    QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
    if (model.chatAttributedText != nil) {
        QHBGRoomChatContentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQHCHAT_BG_CONTENT_CELLIDENTIFIER];
        cell.contentL.attributedText = model.chatAttributedText;
        [cell cellUpdateConstraints];
        chatCell = cell;
    }
    
    return chatCell;
}

@end
