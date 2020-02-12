//
//  QHChatLiveCloudTFHppleView.m
//  QHChatDemo
//
//  Created by Anakin chen on 2020/1/13.
//  Copyright © 2020 Chen Network Technology. All rights reserved.
//

#import "QHChatLiveCloudTFHppleView.h"

#import "QHChatLiveCloudTFHppleUtil.h"

NSString *const kChatOpKey2 = @"op";
NSString *const kChatOpValueChat2 = @"chat";
NSString *const kChatOpValueGift2 = @"gift";
NSString *const kChatOpValueEnter2 = @"enter";

@implementation QHChatLiveCloudTFHppleView

- (NSMutableAttributedString *)qhChatAnalyseContent:(NSDictionary *)data {
    NSString *op = data[kChatOpKey2];
    NSMutableAttributedString *content = nil;
    if ([op isEqualToString:kChatOpValueChat2] == YES) {
        content = [QHChatLiveCloudTFHppleUtil toChat:data];
    }
    else if ([op isEqualToString:kChatOpValueGift2] == YES) {
        content = [QHChatLiveCloudTFHppleUtil toGift:data];
    }
    else if ([op isEqualToString:kChatOpValueEnter2] == YES) {
        content = [QHChatLiveCloudTFHppleUtil toEnter:data];
    }
    return content;
}

@end
