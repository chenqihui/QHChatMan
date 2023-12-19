//
//  QHChatBaseUtil.h
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/27.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^AddContentBlock)(UIImageView *imageV);

@interface QHChatBaseUtil : NSObject

+ (void)addCellDefualAttributes:(NSMutableAttributedString *)attr lineSpacing:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize;

+ (NSAttributedString *)toHTML:(NSString *)content;

+ (NSAttributedString *)toContent:(NSString *)content color:(UIColor *)color;

+ (NSAttributedString *)toImage:(UIImage *)image size:(CGSize)size offBottom:(CGFloat)offBottom;
+ (NSAttributedString *)toImage:(UIImage *)image size:(CGSize)size offBottom:(CGFloat)offBottom addContentBlock:(nullable AddContentBlock)block;

+ (CGSize)calculateString:(NSString *)string size:(CGSize)size font:(UIFont *)font;

@end

#define QHCOLOR_RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

@interface QHChatViewUtil : NSObject

+ (void)fullScreen:(UIView *)subView;

+ (void)fullScreen:(UIView *)subView edgeInsets:(UIEdgeInsets)edgeInsets;

@end

/**
 生成一个不会导致循环依赖的Timer
 */
@interface NSTimer (QHChatEOCBlocksSupport)

/**
 生成一个不会导致循环依赖的Timer
 
 @param interval 触发时间
 @param block 触发后的操作
 @param repeats 是否重复触发
 @return timer
 */
+ (NSTimer *)qhchateoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats;

@end

NS_ASSUME_NONNULL_END
