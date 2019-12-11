//
//  QHBgRoomViewController.m
//  QHChatDemo
//
//  Created by Anakin chen on 2019/12/8.
//  Copyright © 2019 Chen Network Technology. All rights reserved.
//

#import "QHBgRoomViewController.h"

#import "QHBGChatRoomView.h"

@interface QHBgRoomViewController ()

@property (weak, nonatomic) IBOutlet UIView *chatSuperView;
@property (nonatomic, strong) QHBGChatRoomView *chatView;

@end

@implementation QHBgRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    QHChatBaseConfig *config = [QHChatBaseConfig new];
    config.bLongPress = YES;
    config.chatCountMax = 100;
    config.chatCountDelete = 30;
    QHChatCellConfig cellConfig = config.cellConfig;
    cellConfig.cellLineSpacing = 1;
    cellConfig.fontSize = 14;
    cellConfig.cellWidth = 240;
    config.cellConfig = cellConfig;
    QHBGChatRoomView *v = [QHBGChatRoomView createChatViewToSuperView:_chatSuperView withConfig:config];
    v.backgroundColor = [UIColor clearColor];
    
    _chatView = v;
    
    
    NSDictionary *body = @{@"c": @"主播你好", @"n": @"小跟班"};
    NSDictionary *msg = @{@"op": @"chat", @"body": body};
    NSDictionary *body1 = @{@"n": @"小跟班", @"c": @"欢迎来到直播间！XX倡导绿色健康直播，不提倡未成年人进行充值。直播内容和评论严禁包含政治、低俗色情、吸烟酗酒等内容，若有违反，将视情节严重程度给予禁播、永久封禁或停封账户。"};
    NSDictionary *msg1 = @{@"op": @"chat", @"body": body1};
    [self.chatView insertChatData:@[msg, msg1]];
}

@end
