//
//  QHChatBaseViewCell.h
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/23.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QHChatBaseViewCellDelegate <NSObject>

@optional

- (void)selectViewCell:(UITableViewCell *)viewCell;

- (void)deselectViewCell:(UITableViewCell *)viewCell;

@end

@interface QHChatBaseViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentL;
//@property (nonatomic, strong, readonly) UITextView *contentTV;

@property (nonatomic, weak) id<QHChatBaseViewCellDelegate> delegate;

- (void)makeContent:(UIEdgeInsets)edgeInsets;

- (void)p_addTapGesture;

@end

NS_ASSUME_NONNULL_END
