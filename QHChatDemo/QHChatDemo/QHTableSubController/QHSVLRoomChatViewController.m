//
//  QHSVLRoomChatViewController.m
//  QHChatDemo
//
//  Created by Anakin chen on 2019/6/19.
//  Copyright © 2019 Chen Network Technology. All rights reserved.
//

#import "QHSVLRoomChatViewController.h"

#import "QHSVLChatRoomView.h"

@interface QHSVLRoomChatViewController () <QHChatBaseViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *chatSuperView;
@property (nonatomic, strong) QHSVLChatRoomView *chatView;

@end

@implementation QHSVLRoomChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    QHSVLChatRoomView *v = [QHSVLChatRoomView createChatViewToSuperView:_chatSuperView];
    v.delegate = self;
    QHChatCellConfig cellConfig = v.config.cellConfig;
    cellConfig.cellLineSpacing = 6;
    cellConfig.fontSize = 15;
    cellConfig.cellWidth = [UIScreen mainScreen].bounds.size.width - 60;
    v.config.cellConfig = cellConfig;
    
    _chatView = v;
}

- (IBAction)sendAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *sayMeg1 = @{@"c": @"顾小杰：会议几点开始啊，好期待。会议几点开始啊，好期待。会议几点开始啊，好期待。会议几点开始啊，好期待。"};
        NSDictionary *sayMeg2 = @{@"c": @"顾小杰:会议几点开始啊，好期待。"};
        [weakSelf.chatView insertChatData:@[sayMeg1, sayMeg2]];
    });
}

@end
