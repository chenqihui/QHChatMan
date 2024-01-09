//
//  QHChatGifTableViewCell.m
//  QHChatExampleDemo
//
//  Created by qihuichen on 2024/1/8.
//

#import "QHChatGifTableViewCell.h"

#import <QHChatMan/QHChatMan.h>

@interface QHChatGifTableViewCell ()

@property (nonatomic, strong, readwrite) QHGifTextView *contentTV;

@end

@implementation QHChatGifTableViewCell

- (void)dealloc {
#if DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}

#pragma mark - Private

- (void)p_addContentLabel {
    QHGifTextView *contentTV = [QHGifTextView new];
    contentTV.backgroundColor = [UIColor clearColor];
    [self.contentV addSubview:contentTV];
    [QHChatViewUtil fullScreen:contentTV edgeInsets:TKQHCHAT_GIF_CONTENT_TEXT_EDGEINSETS];
    _contentTV = contentTV;
}

@end
