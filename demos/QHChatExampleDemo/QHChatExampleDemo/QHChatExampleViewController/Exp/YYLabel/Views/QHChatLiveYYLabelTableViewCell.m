//
//  QHChatLiveYYLabelTableViewCell.m
//  QHChatExampleDemo
//
//  Created by qihuichen on 2024/1/9.
//

#import "QHChatLiveYYLabelTableViewCell.h"

#import <QHChatMan/QHChatMan.h>

@implementation QHChatLiveYYLabelTableViewCell

- (void)p_addContentLabel {
    YYLabel *contentL = [[YYLabel alloc] initWithFrame:CGRectZero];
    contentL.userInteractionEnabled = YES;
    contentL.backgroundColor = [UIColor clearColor];
    contentL.numberOfLines = 0;
    contentL.font = [UIFont systemFontOfSize:14];
    contentL.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    contentL.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentV addSubview:contentL];
    [QHChatViewUtil fullScreen:contentL edgeInsets:QHCHAT_LC_CONTENT_TEXT_EDGEINSETS];
    self.contentYYL = contentL;
}

@end
