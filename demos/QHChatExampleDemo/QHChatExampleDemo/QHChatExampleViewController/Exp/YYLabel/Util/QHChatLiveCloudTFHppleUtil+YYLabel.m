//
//  QHChatLiveCloudTFHppleUtil+YYLabel.m
//  QHChatExampleDemo
//
//  Created by qihuichen on 2024/1/9.
//

#import "QHChatLiveCloudTFHppleUtil+YYLabel.h"

#import "QHTKRoomChatVIewUtil+Gif.h"

@implementation QHChatLiveCloudTFHppleUtil (YYLabel)

+ (NSMutableAttributedString *)toChat2:(NSDictionary *)data {
    NSDictionary *body = data[@"body"];
    NSString *n = body[@"nickname"];
    NSString *c = body[@"content"];
    NSString *contentString = [NSString stringWithFormat:@"<font color='#999999'>%@：</font><font color='#999999'>%@ </font><font t='gif2' src='http://www.png' name=''/><font color='#999999'> 哈喽</font>", n, c];
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    [QHTKRoomChatVIewUtil anaylzeHtml:&chatData content:contentString];
    
    return chatData;
}

@end
