//
//  QHTKRoomChatVIewUtil+Gif.m
//  QHChatExampleDemo
//
//  Created by qihuichen on 2024/1/8.
//

#import "QHTKRoomChatVIewUtil+Gif.h"

#import <QHChatMan/QHChatMan.h>

@implementation QHTKRoomChatVIewUtil (Gif)

+ (NSMutableAttributedString *)toChatGif:(NSDictionary *)data isAnchor:(BOOL)anchor isCurrentUser:(BOOL)user {
    NSDictionary *body = data[@"body"];
    NSString *n = body[@"n"];
    NSString *c = body[@"c"];
    NSString *formatString = nil;
    if (anchor == YES) {
        formatString = @"<font color='#FF55A2'>%@：</font><font color='#FF509F'>%@</font>";
    }
    else if (user == YES) {
        formatString = @"<font color='#4FCCFF'>%@：</font><font color='#4FCCFF'>%@</font>";
    }
    else {
        formatString = @"<font color='#FFFFFF'>%@：</font><font color='#FFFFFF'>%@</font>";
    }
    NSString *contentString = [NSString stringWithFormat:formatString, n, c];
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    [chatData appendAttributedString:[QHChatBaseUtil toHTML:contentString]];
    
    return chatData;
}

@end
