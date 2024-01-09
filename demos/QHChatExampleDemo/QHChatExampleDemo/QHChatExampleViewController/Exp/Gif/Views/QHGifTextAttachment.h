//
//  QHGifTextAttachment.h
//  QHChatDemo
//
//  Created by Anakin chen on 2020/9/17.
//  Copyright © 2020 Chen Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHGifTextAttachment : NSTextAttachment

@property (nonatomic, strong) NSString *gifName;

@property (nonatomic) CGFloat gifWidth;

@end

NS_ASSUME_NONNULL_END
