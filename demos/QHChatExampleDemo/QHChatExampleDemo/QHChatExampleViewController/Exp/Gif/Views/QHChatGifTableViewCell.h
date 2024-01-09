//
//  QHChatGifTableViewCell.h
//  QHChatExampleDemo
//
//  Created by qihuichen on 2024/1/8.
//

#import "QHTKRoomChatContentViewCell.h"

#import "QHGifTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHChatGifTableViewCell : QHTKRoomChatContentViewCell

@property (nonatomic, strong, readonly) QHGifTextView *contentTV;

@end

NS_ASSUME_NONNULL_END
