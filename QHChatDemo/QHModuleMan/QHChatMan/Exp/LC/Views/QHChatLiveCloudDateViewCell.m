//
//  QHChatLiveCloudDateViewCell.m
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/28.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import "QHChatLiveCloudDateViewCell.h"

#import <QHChatMan/QHChatMan.h>

@interface QHChatLiveCloudDateViewCell ()

@property (nonatomic, strong, readwrite) UILabel *contentL;

@end

@implementation QHChatLiveCloudDateViewCell

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
    [self p_addContentLabel];
}

- (void)p_addContentLabel {
    _contentL = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentL.font = [UIFont systemFontOfSize:10];
    _contentL.numberOfLines = 0;
    _contentL.textAlignment = NSTextAlignmentCenter;
    _contentL.textColor = QHCOLOR_RGBA(0xCC, 0xCC, 0xCC, 1);
    _contentL.lineBreakMode = NSLineBreakByWordWrapping;
    _contentL.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_contentL];
    [QHChatViewUtil fullScreen:_contentL edgeInsets:UIEdgeInsetsMake(QHCHAT_LC_DATE_SPACE_TOP, 0, 0, 0)];
}

@end
