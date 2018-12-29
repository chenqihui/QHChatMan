//
//  QHChatBaseUtil+DYText.h
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/27.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import "QHChatBaseUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHChatBaseUtil (DYText)

+ (NSMutableAttributedString *)enter:(NSDictionary *)data;

+ (NSMutableAttributedString *)system:(NSDictionary *)data;

+ (NSMutableAttributedString *)say:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
