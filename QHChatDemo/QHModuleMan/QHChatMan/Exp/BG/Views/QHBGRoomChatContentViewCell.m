//
//  QHBGRoomChatContentViewCell.m
//  QHChatDemo
//
//  Created by Anakin chen on 2019/12/8.
//  Copyright © 2019 Chen Network Technology. All rights reserved.
//

#import "QHBGRoomChatContentViewCell.h"

#import "QHViewUtil.h"

@implementation QHBGRoomChatContentViewCell

- (void)p_addContentView {
    self.contentV = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentV];
    
    UIView *subView = self.contentV;
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(subView);
    
    NSString *lcString = [NSString stringWithFormat:@"|-%f-[subView]->=%f-|", TKQHCHAT_LC_CONTENT_EDGEINSETS.left, TKQHCHAT_LC_CONTENT_EDGEINSETS.right];
    [subView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lcString options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    NSString *lcString2 = [NSString stringWithFormat:@"V:|-%f-[subView]-%f-|", TKQHCHAT_LC_CONTENT_EDGEINSETS.top, TKQHCHAT_LC_CONTENT_EDGEINSETS.bottom];
    [subView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lcString2 options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    
    UIImageView *bgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"111@3x.png" ofType:nil];
    UIImage *image = [UIImage imageNamed:path];
    UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, image.size.height - 1, image.size.width - 1);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    bgV.image = image;
    [self.contentView addSubview:bgV];
    [QHViewUtil fullScreen:bgV];
    
}

@end
