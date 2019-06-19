//
//  QHChatBaseConfig.h
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/23.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// [iOS笔记—对象的结构体属性单个修改方式 - csdn_hhg的博客 - CSDN博客](https://blog.csdn.net/csdn_hhg/article/details/69388824)
struct QHChatCellConfig {
    CGFloat fontSize;
    CGFloat cellWidth;
    // 一定要设置 行距 不为0，因为 UILabel 绘制本身是有上下空白处
    CGFloat cellLineSpacing;
};
typedef struct QHChatCellConfig QHChatCellConfig;

NS_ASSUME_NONNULL_BEGIN

@interface QHChatBaseConfig : NSObject

@property (nonatomic, strong) NSString *fontName;

// 只对 QHChatBaseViewCell & 默认计算的高度 有效，自定义的需要自己获取计算
@property (nonatomic) QHChatCellConfig cellConfig;
// 只对 QHChatBaseViewCell 有效
@property (nonatomic) UIEdgeInsets cellEdgeInsets;

@property (nonatomic) NSInteger chatCountMax;
@property (nonatomic) NSInteger chatCountDelete;
@property (nonatomic) CGFloat chatReloadDuration;

- (BOOL)isEqualToCellConfig:(QHChatCellConfig)cellConfig;

@end

NS_ASSUME_NONNULL_END
