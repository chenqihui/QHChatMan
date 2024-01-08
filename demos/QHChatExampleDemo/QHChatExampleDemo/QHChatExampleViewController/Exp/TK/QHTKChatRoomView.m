//
//  QHTKChatRoomView.m
//  QHChatDemo
//
//  Created by Anakin chen on 2019/11/8.
//  Copyright © 2019 Chen Network Technology. All rights reserved.
//

#import "QHTKChatRoomView.h"

#import "QHTKRoomChatVIewUtil.h"
#import "QHTKRoomChatContentViewCell.h"

#define kQHCHAT_TK_CONTENT_CELLIDENTIFIER @"TKQHChatLCContentCellIdentifier"

NSString *const kTKChatOpKey = @"op";
NSString *const kTKChatOpValueChat = @"chat";
NSString *const kTKChatOpValueNotice = @"notice";

@interface QHTKChatRoomView ()

@end

@implementation QHTKChatRoomView

#pragma mark - QHChatBaseViewProtocol

- (void)qhChatCustomChatViewSetup {
}

- (void)qhChatAddCell2TableView:(UITableView *)tableView {
    [tableView registerClass:[QHTKRoomChatContentViewCell class] forCellReuseIdentifier:kQHCHAT_TK_CONTENT_CELLIDENTIFIER];
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

- (CGFloat)qhChatAnalyseHeight:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
    if (model.chatAttributedText == nil) {
        return 0;
    }
    UIEdgeInsets contentEI = TKQHCHAT_LC_CONTENT_EDGEINSETS;
    UIEdgeInsets contentTextEI = TKQHCHAT_LC_CONTENT_TEXT_EDGEINSETS;
    
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
        QHTKRoomChatContentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQHCHAT_TK_CONTENT_CELLIDENTIFIER];
        cell.contentL.attributedText = model.chatAttributedText;
        cell.delegate = self;
//        [cell cellUpdateConstraints];
        chatCell = cell;
    }
    
    return chatCell;
}

- (void)qhChatAddCellDefualAttributes:(NSMutableAttributedString *)attr {
    if (attr == nil) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = self.config.cellConfig.cellLineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attr addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:self.config.cellConfig.fontSize], NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, attr.length)];
}

- (void)qhlongPressAction:(UILongPressGestureRecognizer *)gec {
    if (gec.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(chatView:didLongSelectRowWithData:)]) {
            CGPoint point = [gec locationInView:self.mainTableV];
            NSIndexPath *indexPath = [self.mainTableV indexPathForRowAtPoint:point];
            QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
            NSDictionary *data = model.originChatDataDic;
            NSString *op = data[kTKChatOpKey];
            if ([op isEqualToString:kTKChatOpValueChat] == YES) {
                [self.delegate chatView:self didLongSelectRowWithData:data];
            }
        }
    }
}

@end
