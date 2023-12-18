//
//  QHChatLiveCloudUtil.m
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/29.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import "QHChatLiveCloudUtil.h"

#import <QHChatMan/QHChatMan.h>

@implementation QHChatLiveCloudUtil

+ (NSMutableAttributedString *)toChat:(NSDictionary *)data {
    NSDictionary *body = data[@"body"];
    NSString *n = body[@"nickname"];
    NSString *c = body[@"content"];
    NSString *contentString = [NSString stringWithFormat:@"<font color='#999999'>%@：</font><font color='#151515'>%@</font>", n, c];
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    [chatData appendAttributedString:[QHChatBaseUtil toHTML:contentString]];
    
    return chatData;
}

+ (NSMutableAttributedString *)toGift:(NSDictionary *)data {
    NSDictionary *body = data[@"body"];
    NSString *n = body[@"nickname"];
    NSString *c = body[@"giftName"];
    NSString *contentString = [NSString stringWithFormat:@"<font color='#999999'>%@ 送 </font><font color='#F5A623'>%@</font>", n, c];
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    [chatData appendAttributedString:[QHChatBaseUtil toHTML:contentString]];
    
    NSInteger giftCount = [body[@"giftCount"] integerValue];
    if (giftCount > 1) {
        NSString *giftCountString = [NSString stringWithFormat:@"<font color='#F5A623'> x%li</font>", (long)giftCount];
        [chatData appendAttributedString:[QHChatBaseUtil toHTML:giftCountString]];
    }
    
    return chatData;
}

+ (NSMutableAttributedString *)toEnter:(NSDictionary *)data {
    NSDictionary *body = data[@"body"];
    NSString *n = body[@"nickname"];
    NSString *contentString = [NSString stringWithFormat:@"欢迎 <font color='#999999'>%@</font> 光临直播间", n];
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    [chatData appendAttributedString:[QHChatBaseUtil toHTML:contentString]];
    
    return chatData;
}

@end
