//
//  QHChatBaseUtil.m
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/27.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import "QHChatBaseUtil.h"

@implementation QHChatBaseUtil

+ (void)addCellDefualAttributes:(NSMutableAttributedString *)attr lineSpacing:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize {
    if (attr == nil) {
        return;
    }
    // [NSAttributedString 的使用 - 简书](https://www.jianshu.com/p/3f85f91d1208)
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, attr.length)];
}

+ (NSAttributedString *)toHTML:(NSString *)content {
    if (content == nil || content.length <= 0) {
        return nil;
    }
    NSError *error = nil;
    NSAttributedString *attributedString = nil;
    @try {
        attributedString = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:&error];
    } @catch (NSException *exception) {
        attributedString = nil;
    } @finally {
    }
    if (error != nil) {
        return nil;
    }
    return attributedString;
}

+ (NSAttributedString *)toContent:(NSString *)content color:(UIColor *)color {
    if (content == nil || content.length <= 0) {
        return nil;
    }
    NSAttributedString *contentAttr = [[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:color}];
    return contentAttr;
}

+ (NSAttributedString *)toImage:(UIImage *)image size:(CGSize)size offBottom:(CGFloat)offBottom {
    return [self p_toImage:image size:size offBottom:offBottom];
}

// [Null passed to a callee that requires a non-nul... - 简书](https://www.jianshu.com/p/3d030d367a34)
+ (NSAttributedString *)toImage:(UIImage *)image size:(CGSize)size offBottom:(CGFloat)offBottom addContentBlock:(nullable AddContentBlock)block {
    UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
    imageV.frame = (CGRect){CGPointZero, size};
    if (block != nil) {
        block(imageV);
    }
    UIImage *i = [self convertViewToImage:imageV];
    return [self p_toImage:i size:size offBottom:offBottom];
}

+ (NSAttributedString *)p_toImage:(UIImage *)image size:(CGSize)size offBottom:(CGFloat)offBottom {
    CGSize sizeF = image.size;
    if (size.width > 0) {
        CGFloat h = size.height;
        CGFloat w = image.size.width * h / image.size.height;
        sizeF = CGSizeMake(w, h);
    }
    NSAttributedString *imageAttr = nil;
    @try {
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = image;
        textAttachment.bounds = CGRectMake(0, offBottom, sizeF.width, sizeF.height);
        imageAttr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    } @catch (NSException *exception) {
        imageAttr = [[NSAttributedString alloc] initWithString:@""];
    } @finally {
        
    }
    return imageAttr;
}

+ (UIImage *)convertViewToImage:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    //    [view drawRect:CGRectMake(0, 50, view.frame.size.width, view.frame.size.height)];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view.layer.contents = nil;
    
    return image;
}

+ (CGSize)calculateString:(NSString *)string size:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    expectedLabelSize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

@end

@implementation QHChatViewUtil

+ (void)fullScreen:(UIView *)subView {
    [self fullScreen:subView edgeInsets:UIEdgeInsetsZero];
}

+ (void)fullScreen:(UIView *)subView edgeInsets:(UIEdgeInsets)edgeInsets {
    if (subView == nil || subView.superview == nil) {
        return;
    }
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(subView);
    NSString *lcString = [NSString stringWithFormat:@"|-%f-[subView]-%f-|", edgeInsets.left, edgeInsets.right];
    [subView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lcString options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    NSString *lcString2 = [NSString stringWithFormat:@"V:|-%f-[subView]-%f-|", edgeInsets.top, edgeInsets.bottom];
    [subView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lcString2 options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
}

+ (void)fullScreen2:(UIView *)subView {
    if (subView == nil || subView.superview == nil) {
        return;
    }
    UIView *superV = subView.superview;
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    [superV addConstraint:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superV attribute:NSLayoutAttributeTop multiplier:1. constant:0]];
    [superV addConstraint:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superV attribute:NSLayoutAttributeBottom multiplier:1. constant:0]];
    [superV addConstraint:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superV attribute:NSLayoutAttributeLeading multiplier:1. constant:0]];
    [superV addConstraint:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superV attribute:NSLayoutAttributeTrailing multiplier:1. constant:0]];
}

@end

@implementation NSTimer (QHChatEOCBlocksSupport)

+ (NSTimer *)qhchateoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(qhchateoc_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)qhchateoc_blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
