//
//  QHLiveCloudViewController.m
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/28.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import "QHLiveCloudViewController.h"

#import "NSTimer+QHEOCBlocksSupport.h"

@interface QHLiveCloudViewController () <QHChatBaseViewDelegate>

@property (nonatomic, strong) NSTimer *t;

@end

@implementation QHLiveCloudViewController

- (void)dealloc {
    [_t invalidate];
    _t = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self p_initChatView];
}

- (void)p_initChatView {
    QHChatLiveCloudView *v = [QHChatLiveCloudView createChatViewToSuperView:_chatContainerView];
    v.delegate = self;
    QHChatCellConfig cellConfig = v.config.cellConfig;
    cellConfig.cellLineSpacing = 1;
    cellConfig.fontSize = 15;
    cellConfig.cellWidth = [UIScreen mainScreen].bounds.size.width;
    v.config.cellConfig = cellConfig;
    v.config.chatCountMax = 50;
    v.config.chatCountDelete = 5;
    v.config.bInsertReplace = YES;
    
    _chatView = v;
}

#pragma mark - Action

- (IBAction)sendAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *body = @{@"uid": @"test", @"rid": @"123456", @"nickname": @"顾小杰", @"content": @"会议几点开始啊，好期待。会议几点开始啊，好期待。会议几点开始啊，好期待。会议几点开始啊，好期待。"};
        NSDictionary *sayMeg1 = @{@"op": @"chat", @"body": body};
        [weakSelf.chatView lcInsertChatData:@[sayMeg1]];
        NSDictionary *body2 = @{@"uid": @"test", @"rid": @"123456", @"nickname": @"顾小杰", @"content": @"会议几点开始啊，好期待。"};
        NSDictionary *sayMeg2 = @{@"op": @"chat", @"body": body2};
        [weakSelf.chatView lcInsertChatData:@[sayMeg2]];
    });
}

- (IBAction)sendGiftAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *body3 = @{@"uid": @"test", @"rid": @"123456", @"nickname": @"顾小杰", @"giftName": @"酷炫猪", @"giftCount": @(1)};
        NSDictionary *giftMeg1 = @{@"op": @"gift", @"body": body3};
        [weakSelf.chatView lcInsertChatData:@[giftMeg1]];
        NSDictionary *body4 = @{@"uid": @"test", @"rid": @"123456", @"nickname": @"顾小杰", @"giftName": @"酷炫猪", @"giftCount": @(10)};
        NSDictionary *giftMeg2 = @{@"op": @"gift", @"body": body4};
        [weakSelf.chatView lcInsertChatData:@[giftMeg2]];
    });
    
//    if (_t == nil) {
//        static int i = 0;
//        NSTimer *t = [NSTimer qheoc_scheduledTimerWithTimeInterval:0.05 block:^{
//            i++;
//            NSString *n = [NSString stringWithFormat:@"昵称亚婷穗杰正在测试中%i", i];
//            NSString *c = [NSString stringWithFormat:@"亚婷穗杰正在测试中%i", i];
//            NSDictionary *body = @{@"uid": @"test", @"rid": @"123456", @"nickname": n, @"content": c};
//            NSDictionary *sayMeg1 = @{@"op": @"chat", @"body": body};
//            [self.chatView lcInsertChatData:@[sayMeg1]];
//        } repeats:YES];
//        [t fire];
//        _t = t;
//    }
//    else {
//        [_t invalidate];
//        _t = nil;
//    }
}

- (IBAction)enterAction:(id)sender {
    static int i = 0;
    i++;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *body3 = @{@"uid": @"test", @"rid": @"123456", @"nickname": [NSString stringWithFormat:@"顾小杰-%i", i]};
        NSDictionary *enterMeg1 = @{@"op": @"enter", @"body": body3};
        [weakSelf.chatView lcInsertChatData:@[enterMeg1]];
//        i++;
//        NSDictionary *body4 = @{@"uid": @"test", @"rid": @"123456", @"nickname": [NSString stringWithFormat:@"顾小杰-%i", i]};
//        NSDictionary *enterMeg2 = @{@"op": @"enter", @"body": body4};
//        [weakSelf.chatView lcInsertChatData:@[enterMeg2]];
    });
}

@end
