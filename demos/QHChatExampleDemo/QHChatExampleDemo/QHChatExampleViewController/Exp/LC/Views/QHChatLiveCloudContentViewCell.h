//
//  QHChatLiveCloudContentViewCell.h
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/28.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define QHCHAT_LC_CONTENT_EDGEINSETS UIEdgeInsetsMake(15, 15, 0, 15)
#define QHCHAT_LC_CONTENT_TEXT_EDGEINSETS UIEdgeInsetsMake(5, 10, 5, 10)

@interface QHChatLiveCloudContentViewCell : UITableViewCell

@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong, readonly) UILabel *contentL;

- (void)p_addContentLabel;

@end

NS_ASSUME_NONNULL_END
