//
//  QHTKRoomChatVIewUtil+Gif.h
//  QHChatExampleDemo
//
//  Created by qihuichen on 2024/1/8.
//

#import <UIKit/UIKit.h>

#import "QHTKRoomChatVIewUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHTKRoomChatVIewUtil (Gif)

+ (NSMutableAttributedString *)toChatGif:(NSDictionary *)data;


+ (UIImage *)download:(NSString *)url;
+ (UIImageView *)gif:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
