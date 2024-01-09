//
//  QHYYLabelRoomViewController.m
//  QHChatExampleDemo
//
//  Created by qihuichen on 2024/1/9.
//

#import "QHYYLabelRoomViewController.h"

#import "QHChatLiveYYLabelView.h"

@interface QHYYLabelRoomViewController ()

@end

@implementation QHYYLabelRoomViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)p_initChatView {
    QHChatBaseConfig *config = [QHChatBaseConfig new];
    config.bLongPress = YES;
//    config.bOpenScorllFromBottom = YES;
//    config.maxChatCount4closeScorllFromBottom = 12;
    config.chatCountMax = 130;
    config.chatCountDelete = 30;
    config.chatCountMax4Temp = 60;
    config.chatCountDelete4Temp = 20;
    config.chatCountMax4Remove = 130;
    config.chatCountDelete4Remove = 30;
    QHChatCellConfig cellConfig = config.cellConfig;
    cellConfig.cellLineSpacing = 1;
    cellConfig.fontSize = 14;
    cellConfig.cellWidth = [UIScreen mainScreen].bounds.size.width;
    config.cellConfig = cellConfig;
    QHChatLiveYYLabelView *v = [QHChatLiveYYLabelView createChatViewToSuperView:self.chatContainerView withConfig:config];
//    v.delegate = self;
    
    self.chatView = v;
}

- (void)p_sendAction {
    NSDictionary *body2 = @{@"uid": @"test", @"rid": @"123456", @"nickname": @"顾小杰", @"content": @"会议几点开始啊，好期待。"};
    NSDictionary *sayMeg2 = @{@"op": @"chat", @"body": body2};
    [self.chatView insertChatData:@[sayMeg2]];
}

@end
