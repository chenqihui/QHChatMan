//
//  QHGifTextView.m
//  QHChatDemo
//
//  Created by Anakin chen on 2020/9/17.
//  Copyright © 2020 Chen Network Technology. All rights reserved.
//

#import "QHGifTextView.h"

#import "QHGifTextAttachment.h"
#import "QHTKRoomChatVIewUtil+Gif.h"

@interface QHGifTextView ()

@property (nonatomic, copy) NSAttributedString *attrGif;

@end

@implementation QHGifTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self p_setup];
    }
    return self;
}

- (void)layoutSubviews {
    [self p_setGifAttributedText];
    [self p_start];
}

#pragma mark - Public

- (void)start {
    [self p_start];
}

#pragma mark - Private

- (void)p_setup {
    self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
    self.editable = NO;
    self.selectable = NO;
    self.scrollEnabled = NO;
}

- (void)p_setGifAttributedText {
    if (self.attributedText.string.length == 0 && self.attrGif == nil) {
        return;
    }
    
    if (self.attrGif != nil && [self.attrGif.string isEqualToString:self.attributedText.string]) {
        return;
    }
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }

    self.attrGif = [self.attributedText copy];
    
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[QHGifTextAttachment class]]) {
            QHGifTextAttachment *gifTextAttachment = value;
            self.selectedRange = range;
            CGRect rect = [self firstRectForRange:self.selectedTextRange];
            
            UIImageView *iv = [QHTKRoomChatVIewUtil gif:gifTextAttachment.gifName];
            iv.frame = (CGRect){rect.origin.x, rect.origin.y + 5, gifTextAttachment.gifWidth, gifTextAttachment.gifWidth};
            iv.backgroundColor = [UIColor clearColor];
            [self addSubview:iv];
        }
    }];
    self.selectedRange = NSMakeRange(0, 0);
}

- (void)p_start {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [(UIImageView *)v startAnimating];
        }
    }
}

@end
