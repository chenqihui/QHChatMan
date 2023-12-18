//
//  QHChatLiveCloudNewDataView.m
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/28.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import "QHChatLiveCloudNewDataView.h"

#import <QHChatMan/QHChatMan.h>

@implementation QHChatLiveCloudNewDataView

#pragma mark - Public

+ (instancetype)createViewToSuperView:(UIView *)superView {
    QHChatLiveCloudNewDataView *view = [[self alloc] init];
    [superView addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(view);
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(35)]-15-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(133)]" options:NSLayoutFormatAlignAllBaseline metrics:0 views:viewsDict]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [view p_setup];
    
    return view;
}

#pragma mark - Private

// [iOS view的圆角和阴影并存 - 帮助那些有需要的人 - CSDN博客](https://blog.csdn.net/iitvip/article/details/8518260)
- (void)p_setup {
    self.backgroundColor = [UIColor whiteColor];
//    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 17.5;
    self.layer.shadowColor = QHCOLOR_RGBA(0xE5, 0xE5, 0xE5, 1).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2.5);
    self.layer.shadowOpacity = 1;
    self.hidden = YES;
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectZero];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = QHCOLOR_RGBA(0x66, 0x66, 0x66, 1);
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.text = @"点击查看更多消息";
    [self addSubview:titleL];
    
    titleL.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *subViewsDict = NSDictionaryOfVariableBindings(titleL);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleL]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:subViewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleL]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:subViewsDict]];
    titleL = nil;
}

#pragma mark - QHChatBaseNewDataViewProtcol

- (void)update:(id)data {
    [self show];
}

@end
