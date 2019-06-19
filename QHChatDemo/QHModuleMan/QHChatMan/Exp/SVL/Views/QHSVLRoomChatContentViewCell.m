//
//  QHSVLRoomChatContentViewCell.m
//  QHChatDemo
//
//  Created by Anakin chen on 2019/6/19.
//  Copyright © 2019 Chen Network Technology. All rights reserved.
//

#import "QHSVLRoomChatContentViewCell.h"

#import "QHViewUtil.h"

@interface QHSVLRoomChatContentViewCell ()

@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong, readwrite) UILabel *contentL;

@end


@implementation QHSVLRoomChatContentViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Private

- (void)p_setup {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self p_addContentView];
    [self p_addContentLabel];
}

- (void)p_addContentView {
    _contentV = [[UIView alloc] initWithFrame:CGRectZero];
    _contentV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_contentV];
    
    UIView *subView = _contentV;
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(subView);
    NSString *lcString = [NSString stringWithFormat:@"|-%f-[subView]->=%f-|", SVLQHCHAT_LC_CONTENT_EDGEINSETS.left, SVLQHCHAT_LC_CONTENT_EDGEINSETS.right];
    [subView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lcString options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    NSString *lcString2 = [NSString stringWithFormat:@"V:|-%f-[subView]-%f-|", SVLQHCHAT_LC_CONTENT_EDGEINSETS.top, SVLQHCHAT_LC_CONTENT_EDGEINSETS.bottom];
    [subView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lcString2 options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
}

- (void)p_addContentLabel {
    _contentL = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentL.font = [UIFont systemFontOfSize:15];
    _contentL.numberOfLines = 0;
    _contentL.lineBreakMode = NSLineBreakByWordWrapping;
    _contentL.backgroundColor = [UIColor clearColor];
    [_contentV addSubview:_contentL];
    [QHViewUtil fullScreen:_contentL edgeInsets:SVLQHCHAT_LC_CONTENT_TEXT_EDGEINSETS];
}

@end
