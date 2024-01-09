//
//  QHChatLiveCloudContentViewCell.m
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/28.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import "QHChatLiveCloudContentViewCell.h"

#import <QHChatMan/QHChatMan.h>

@interface QHChatLiveCloudContentViewCell ()

@property (nonatomic, strong, readwrite) UILabel *contentL;

@end

@implementation QHChatLiveCloudContentViewCell

- (void)dealloc {
#if DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_setup];
    }
    return self;
}

#pragma mark - Private

- (void)p_setup {
    self.backgroundColor = [UIColor clearColor];
    [self p_addContentView];
    [self p_addContentLabel];
}

- (void)p_addContentView {
    _contentV = [[UIView alloc] initWithFrame:CGRectZero];
    _contentV.backgroundColor = [UIColor whiteColor];
    _contentV.layer.masksToBounds = YES;
    _contentV.layer.cornerRadius = 2.5;
    _contentV.layer.borderWidth = 1;
    _contentV.layer.borderColor = QHCOLOR_RGBA(0xE5, 0xE5, 0xE5, 1).CGColor;
    [self.contentView addSubview:_contentV];
    
    UIView *subView = _contentV;
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    // [ios-AutoLayout(自动布局代码控制)简单总结_Capacity_新浪博客](http://blog.sina.com.cn/s/blog_7c336a830102vaht.html)
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(subView);
    NSString *lcString = [NSString stringWithFormat:@"|-%f-[subView]->=%f-|", QHCHAT_LC_CONTENT_EDGEINSETS.left, QHCHAT_LC_CONTENT_EDGEINSETS.right];
    [subView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lcString options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    NSString *lcString2 = [NSString stringWithFormat:@"V:|-%f-[subView]-%f-|", QHCHAT_LC_CONTENT_EDGEINSETS.top, QHCHAT_LC_CONTENT_EDGEINSETS.bottom];
    [subView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lcString2 options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
}

- (void)p_addContentLabel {
    _contentL = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentL.font = [UIFont systemFontOfSize:15];
    _contentL.numberOfLines = 0;
    // [苹果开发中文网站-UILabel 设置NSLineBreakByCharWrapping无效？ | iOS开发 - CocoaChina CocoaChina_让移动开发更简单](http://www.cocoachina.com/bbs/read.php?tid=257338)
    _contentL.lineBreakMode = NSLineBreakByCharWrapping;
    _contentL.backgroundColor = [UIColor clearColor];
    [_contentV addSubview:_contentL];
    [QHChatViewUtil fullScreen:_contentL edgeInsets:QHCHAT_LC_CONTENT_TEXT_EDGEINSETS];
}

@end
