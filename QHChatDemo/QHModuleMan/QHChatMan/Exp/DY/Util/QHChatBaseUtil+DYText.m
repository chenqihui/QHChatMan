//
//  QHChatBaseUtil+DYText.m
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/27.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import "QHChatBaseUtil+DYText.h"

@implementation QHChatBaseUtil (DYText)

+ (NSMutableAttributedString *)enter:(NSDictionary *)data {
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    [chatData appendAttributedString:[QHChatBaseUtil toUserluckNumber:[NSString stringWithFormat:@"%@", data[@"l"]]]];
    NSString *content = [NSString stringWithFormat:@"%@ <font color='#000000'>光临直播间</font>", data[@"n"]];
    [chatData appendAttributedString:[QHChatBaseUtil toHTML:content]];
    return chatData;
}

+ (NSMutableAttributedString *)system:(NSDictionary *)data {
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    NSString *content = data[@"c"];
    [chatData appendAttributedString:[QHChatBaseUtil toHTML:content]];
    return chatData;
}

+ (NSMutableAttributedString *)say:(NSDictionary *)data {
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    [chatData appendAttributedString:[QHChatBaseUtil toUserluckNumber:[NSString stringWithFormat:@"%@", data[@"l"]]]];
    NSString *content = [NSString stringWithFormat:@"%@: %@", data[@"n"], data[@"c"]];
    [chatData appendAttributedString:[QHChatBaseUtil toHTML:content]];
    return chatData;
}

+ (NSAttributedString *)toUserLevelImage:(UIImage *)image {
    return [QHChatBaseUtil toImage:image size:CGSizeMake(0, 13)];
}

+ (NSAttributedString *)toUserluckNumber:(NSString *)luckNumberString {
    UIImage *image = [UIImage imageNamed:@"dy_level.png"];
    CGFloat w = 32;//image.size.width/13.0f*3;
    NSAttributedString *luckNumberAttributedString = [QHChatBaseUtil toImage:image size:CGSizeMake(w, 13) titleLabelBlock:^(UILabel * _Nonnull titleL) {
        titleL.text = luckNumberString;
    }];
    return luckNumberAttributedString;
}

+ (NSAttributedString *)toImage:(UIImage *)image size:(CGSize)size titleLabelBlock:(void(^)(UILabel *titleL))block {
    NSAttributedString *imageAttr = [self toImage:image size:size addContentBlock:^(UIImageView * _Nonnull imageV) {
        CGFloat xx = size.width/4.0;
        UILabel *titleL = [[UILabel alloc] initWithFrame:(CGRect){CGPointMake(xx, 0), CGSizeMake(size.width - xx - 1, size.height)}];
        [titleL setFont:[UIFont systemFontOfSize:12]];
        [titleL setTextColor:[UIColor whiteColor]];
        [titleL setTextAlignment:NSTextAlignmentCenter];
        titleL.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [imageV addSubview:titleL];
        block(titleL);
    }];
    return imageAttr;
}

@end
