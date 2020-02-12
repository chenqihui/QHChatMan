//
//  QHChatLiveCloudTFHppleUtil.m
//  QHChatDemo
//
//  Created by Anakin chen on 2020/1/13.
//  Copyright © 2020 Chen Network Technology. All rights reserved.
//

#import "QHChatLiveCloudTFHppleUtil.h"

#import "QHChatBaseUtil.h"
#import "TFHpple/TFHpple.h"

@implementation UIColor (QHPlusPlus)

+ (UIColor *)qh_colorWithHexString:(NSString *)hexString
{
    return [UIColor qh_colorWithHexString:hexString alpha:1.];
}

+ (UIColor *)qh_colorWithHexString:(NSString *)hexString alpha:(float)opacity
{
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    if ([[hexString lowercaseString] hasPrefix:@"0x"]) {
        hexString = [hexString substringFromIndex:2];
    }
    if ([hexString length] != 6) {
        return nil;
    }
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexString];
    unsigned hexValue = 0;
    if ([scanner scanHexInt:&hexValue] && [scanner isAtEnd]) {
        int r = ((hexValue & 0xFF0000) >> 16);
        int g = ((hexValue & 0x00FF00) >>  8);
        int b = ( hexValue & 0x0000FF)       ;
        return [self colorWithRed:((float)r / 255)
                            green:((float)g / 255)
                             blue:((float)b / 255)
                            alpha:opacity];
    }
    
    return nil;
}

@end

@implementation QHChatLiveCloudTFHppleUtil

+ (NSMutableAttributedString *)toChat:(NSDictionary *)data {
    NSDictionary *body = data[@"body"];
    NSString *n = body[@"nickname"];
    NSString *c = body[@"content"];
    NSString *contentString = [NSString stringWithFormat:@"<font color='#999999'>%@：</font><font color='#151515'>%@</font>", n, c];
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    [self anaylzeHtml:&chatData content:contentString];
    
    return chatData;
}

+ (NSMutableAttributedString *)toGift:(NSDictionary *)data {
    NSDictionary *body = data[@"body"];
    NSString *n = body[@"nickname"];
    NSString *c = body[@"giftName"];
    NSString *contentString = [NSString stringWithFormat:@"<font color='#999999'>%@ 送 </font><font color='#F5A623'>%@</font>", n, c];
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    [self anaylzeHtml:&chatData content:contentString];
    
    NSInteger giftCount = [body[@"giftCount"] integerValue];
    if (giftCount > 1) {
        NSString *giftCountString = [NSString stringWithFormat:@"<font color='#F5A623'> x%li</font>", (long)giftCount];
        [self anaylzeHtml:&chatData content:giftCountString];
    }
    
    return chatData;
}

+ (NSMutableAttributedString *)toEnter:(NSDictionary *)data {
    NSDictionary *body = data[@"body"];
    NSString *n = body[@"nickname"];
    NSString *contentString = [NSString stringWithFormat:@"欢迎 <font color='#999999'>%@</font> 光临直播间", n];
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    [self anaylzeHtml:&chatData content:contentString];
    
    return chatData;
}

+ (void)anaylzeHtml:(NSMutableAttributedString **)chatData content:(NSString *)contentString {
    NSData *data = [contentString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//font"];
    for (TFHppleElement *element in elements) {
        NSString *color = element.attributes[@"color"];
        if (color == nil) {
            color = @"#FFFFFF";
        }
        [*chatData appendAttributedString:[QHChatBaseUtil toContent:element.text color:[UIColor qh_colorWithHexString:color]]];
    }
}

@end
