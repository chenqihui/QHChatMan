//
//  QHChatLiveCloudUtil.h
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/29.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHChatLiveCloudUtil : NSObject

+ (NSMutableAttributedString *)toChat:(NSDictionary *)data;

+ (NSMutableAttributedString *)toGift:(NSDictionary *)data;

+ (NSMutableAttributedString *)toEnter:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
