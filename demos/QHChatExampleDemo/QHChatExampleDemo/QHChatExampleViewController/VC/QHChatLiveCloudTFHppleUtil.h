//
//  QHChatLiveCloudTFHppleUtil.h
//  QHChatDemo
//
//  Created by Anakin chen on 2020/1/13.
//  Copyright © 2020 Chen Network Technology. All rights reserved.
//

#import "QHChatLiveCloudUtil.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (QHPlusPlus)

+ (UIColor *)qh_colorWithHexString:(NSString *)hexString;
+ (UIColor *)qh_colorWithHexString:(NSString *)hexString alpha:(float)opacity;

@end

@interface QHChatLiveCloudTFHppleUtil : QHChatLiveCloudUtil

+ (void)anaylzeHtml:(NSMutableAttributedString **)chatData content:(NSString *)contentString;

@end

NS_ASSUME_NONNULL_END
