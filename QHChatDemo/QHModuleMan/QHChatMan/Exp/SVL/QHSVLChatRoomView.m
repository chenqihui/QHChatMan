//
//  QHSVLChatRoomView.m
//  QHChatDemo
//
//  Created by Anakin chen on 2019/6/19.
//  Copyright © 2019 Chen Network Technology. All rights reserved.
//

#import "QHSVLChatRoomView.h"

#import <QHChatMan/QHChatMan.h>

#import "QHSVLRoomChatContentViewCell.h"
#import "QHSVLRoomChatViewUtilHeader.h"

#define kQHCHAT_LC_CONTENT_CELLIDENTIFIER @"SVLQHChatLCContentCellIdentifier"

/*
 
 控制 UILabel 行距 和 UITableViewCell 间距 相等的实现
 
 参考：
 
 * [在iOS中如何正确的实现行间距与行高 - 掘金](https://juejin.im/post/5abc54edf265da23826e0dc9)
 * [UILabel 垂直居中问题 - MIRAGE086的专栏 - CSDN博客](https://blog.csdn.net/MIRAGE086/article/details/46990923)
 * [iOS UILabel中文字与边框间距的自定义 - 掘金](https://juejin.im/post/5a312950f265da4320033ebc)
 */

@interface QHSVLChatRoomView () <QHChatBaseViewCellDelegate>

@property (nonatomic) CGFloat imageStringHeight;
@property (nonatomic) CGFloat lineH;

@end

@implementation QHSVLChatRoomView

#pragma mark - QHChatBaseViewProtocol

- (void)qhChatCustomChatViewSetup {
    
    // Test
//    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:@"陈"];
//    [QHSVLRoomChatViewUtil addSVLCellDefualAttributes:s lineSpacing:4 fontSize:15];
//    CGRect rect = [s boundingRectWithSize:CGSizeMake(40, CGFLOAT_MAX) options:options context:nil];
//
//    NSMutableAttributedString *s2 = [[NSMutableAttributedString alloc] initWithString:@"陈陈陈"];
//    [QHSVLRoomChatViewUtil addSVLCellDefualAttributes:s2 lineSpacing:4 fontSize:15];
//    CGRect rect2 = [s2 boundingRectWithSize:CGSizeMake(40, CGFLOAT_MAX) options:options context:nil];
    
    /*
     lineSpacing | height | rows |
     0           | 17.9   | 1    |
     0           | 35.6   | 2    |
     4           | 15.3   | 1    |
     4           | 30.6   | 2    |
     
     lineHeight: 17.900390625
     pointSize: 15
     
     */
    
    UIFont *ff = [UIFont boldSystemFontOfSize:self.config.cellConfig.fontSize];
    _imageStringHeight = ff.pointSize; // 真正的f文字占用的高度
}

- (void)qhChatAddCell2TableView:(UITableView *)tableView {
    [tableView registerClass:[QHSVLRoomChatContentViewCell class] forCellReuseIdentifier:kQHCHAT_LC_CONTENT_CELLIDENTIFIER];
}

- (NSMutableAttributedString *)qhChatAnalyseContent:(NSDictionary *)data {
    NSString *formatString = @"<font color='#FFFFFF'>%@</font>";
    NSString *contentString = [NSString stringWithFormat:formatString, data[@"c"]];
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    [chatData appendAttributedString:[QHChatBaseUtil toHTML:contentString]];
    return chatData;
}

- (CGFloat)qhChatAnalyseHeight:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
    if (model.chatAttributedText == nil) {
        return 0;
    }
    CGFloat w = self.config.cellConfig.cellWidth - SVLQHCHAT_LC_CONTENT_EDGEINSETS.left - SVLQHCHAT_LC_CONTENT_EDGEINSETS.right - SVLQHCHAT_LC_CONTENT_TEXT_EDGEINSETS.left - SVLQHCHAT_LC_CONTENT_TEXT_EDGEINSETS.right;
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [model.chatAttributedText boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:options context:nil];
    UIFont *f = [UIFont boldSystemFontOfSize:self.config.cellConfig.fontSize];
    CGFloat sh = 0;
    if (self.config.cellConfig.cellLineSpacing > 0) {
        if (_lineH <= 0) {
            NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:@"陈"];
            [QHSVLRoomChatViewUtil addSVLCellDefualAttributes:s lineSpacing:self.config.cellConfig.cellLineSpacing fontSize:self.config.cellConfig.fontSize];
            _lineH = s.size.height;
        }
        if (rect.size.height > _lineH) {
            sh += self.config.cellConfig.cellLineSpacing;
        }
        else {
            sh = -(f.lineHeight - f.pointSize)/2;
        }
    }
    else {
       sh += (f.lineHeight - f.pointSize) / 2;
    }
    CGFloat h = rect.size.height + sh + SVLQHCHAT_LC_CONTENT_EDGEINSETS.top + SVLQHCHAT_LC_CONTENT_EDGEINSETS.bottom + SVLQHCHAT_LC_CONTENT_TEXT_EDGEINSETS.top + SVLQHCHAT_LC_CONTENT_TEXT_EDGEINSETS.bottom;
    return h;
}

- (UITableViewCell *)qhChatChatView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *chatCell = nil;
    QHChatBaseModel *model = [self.buffer getChatData:indexPath.row];
    if (model.chatAttributedText != nil) {
        QHSVLRoomChatContentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQHCHAT_LC_CONTENT_CELLIDENTIFIER];
        cell.contentL.attributedText = model.chatAttributedText;
        cell.delegate = self;
//        if (indexPath.row%2 == 0) {
//            cell.svlContentL.backgroundColor = [UIColor orangeColor];
//        }
//        else {
//            cell.svlContentL.backgroundColor = [UIColor blueColor];
//        }
        chatCell = cell;
    }
    return chatCell;
}

- (void)qhChatAddCellDefualAttributes:(NSMutableAttributedString *)attr {
    [QHSVLRoomChatViewUtil addSVLCellDefualAttributes:attr lineSpacing:self.config.cellConfig.cellLineSpacing fontSize:self.config.cellConfig.fontSize];
}

@end
