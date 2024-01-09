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

- (NSMutableAttributedString *)qhChatAnalyseContent:(NSDictionary *)data {
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
