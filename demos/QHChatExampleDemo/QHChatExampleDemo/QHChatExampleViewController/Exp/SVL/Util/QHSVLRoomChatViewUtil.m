//
//  QHSVLRoomChatViewUtil.m
//  QHChatDemo
//
//  Created by Anakin chen on 2019/6/19.
//  Copyright © 2019 Chen Network Technology. All rights reserved.
//

#import "QHSVLRoomChatViewUtil.h"

@implementation QHSVLRoomChatViewUtil

+ (void)addSVLCellDefualAttributes:(NSMutableAttributedString *)attr lineSpacing:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize {
    if (attr == nil) {
        return;
    }
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    shadow.shadowBlurRadius = 1;
    UIFont *f = [UIFont boldSystemFontOfSize:fontSize];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    if (lineSpacing > 0) {
        paragraphStyle.lineSpacing = lineSpacing - (f.lineHeight - f.pointSize);
    }
    else {
        paragraphStyle.lineSpacing = 0;
    }
    CGFloat baselineOffset = (f.lineHeight - f.pointSize) / 2;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attr addAttributes:@{NSFontAttributeName: f, NSParagraphStyleAttributeName: paragraphStyle, NSShadowAttributeName: shadow, NSBaselineOffsetAttributeName: @(baselineOffset)} range:NSMakeRange(0, attr.length)];
}

@end
