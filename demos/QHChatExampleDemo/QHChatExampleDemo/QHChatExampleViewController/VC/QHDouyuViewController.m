//
//  QHDouyuViewController.m
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/25.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import "QHDouyuViewController.h"

#import <QHChatMan/QHChatMan.h>

#import "QHChatDouyuView.h"

@interface QHDouyuViewController () <QHChatBaseViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *chatContainerView;

@property (nonatomic, strong) QHChatDouyuView *chatView;
@property (nonatomic, strong) NSTimer *t;

@end

@implementation QHDouyuViewController

- (void)dealloc {
#if DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self p_initChatView];
    [self p_addMessage];

    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakSelf p_doAction];
        [weakSelf test_much];
    });
}

- (void)p_initChatView {
    QHChatDouyuView *v = [QHChatDouyuView createChatViewToSuperView:_chatContainerView];
    v.delegate = self;
    QHChatCellConfig cellConfig = v.config.cellConfig;
    cellConfig.cellLineSpacing = 1;
    cellConfig.fontSize = 15;
    cellConfig.cellWidth = [UIScreen mainScreen].bounds.size.width;
    v.config.cellConfig = cellConfig;
    v.config.cellEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);
    v.config.hasUnlock = NO;
    v.backgroundColor = [UIColor whiteColor];
    
    _chatView = v;
}

- (void)p_addMessage {
    NSDictionary *systemMeg1 = @{@"t": @(3), @"c": @"<font color='#FF0000'>欢迎来到直播间。本直播间提倡健康的直播环境，对直播内容24小时巡查。任何传播违法、违规、低俗等不良信息的行为将被封号。</font>"};
    NSDictionary *systemMeg2 = @{@"t": @(3), @"c": @"<font color='#FF0000'>分享主播可获得经验值奖励，并且帮主播增加热度</font>"};
    NSDictionary *systemMeg3 = @{@"t": @(4), @"c": @"官方认证：直播间的主机骑士", @"l": @(26)};
    [self.chatView insertChatData:@[systemMeg1, systemMeg2, systemMeg3]];
}

- (void)p_doAction {
    NSDictionary *enterMeg1 = @{@"t": @(1), @"n": @"<font color='#999999'>小哥哥</font>", @"l": @(18)};
    NSDictionary *enterMeg2 = @{@"t": @(1), @"n": @"<font color='#999999'>木木子</font>", @"l": @(26)};
    NSDictionary *enterMeg3 = @{@"t": @(1), @"n": @"<font color='#3300CC'>终于会改名字了</font>", @"l": @(40), @"bc": @(1)};
    NSDictionary *sayMeg1 = @{@"t": @(2), @"n": @"<font color='#999999'>小姐姐</font>", @"c": @"这个好听唉", @"l": @(57), @"bc": @(2)};
    NSDictionary *sayMeg2 = @{@"t": @(2), @"n": @"<font color='#999999'>不要叫我</font>", @"c": @"<font color='#33CC66'>好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️</font>", @"l": @(17)};
    NSDictionary *sayMeg3 = @{@"t": @(2), @"n": @"<font color='#999999'>用户1266</font>", @"c": @"<font color='#000000'>玩大乱斗</font>", @"l": @(1)};
    
    NSArray *ds = @[enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (YES) {
            if (weakSelf == nil) {
                break;
            }
            int index = [QHDouyuViewController getRandomNumber:0 to:(int)(ds.count - 1)];
            [weakSelf.chatView insertChatData:@[ds[index]]];
            CGFloat t = [QHDouyuViewController getRandomNumber:10 to:30] * 0.01;
            [NSThread sleepForTimeInterval:t];
        }
    });
}

- (void)test_much {
    NSDictionary *enterMeg1 = @{@"t": @(1), @"n": @"<font color='#999999'>小哥哥</font>", @"l": @(18)};
    NSDictionary *enterMeg2 = @{@"t": @(1), @"n": @"<font color='#999999'>木木子</font>", @"l": @(26)};
    NSDictionary *enterMeg3 = @{@"t": @(1), @"n": @"<font color='#3300CC'>终于会改名字了</font>", @"l": @(40), @"bc": @(1)};
    NSDictionary *sayMeg1 = @{@"t": @(2), @"n": @"<font color='#999999'>小姐姐</font>", @"c": @"这个好听唉", @"l": @(57), @"bc": @(2)};
    NSDictionary *sayMeg2 = @{@"t": @(2), @"n": @"<font color='#999999'>不要叫我</font>", @"c": @"<font color='#33CC66'>好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️好听❤️</font>", @"l": @(17)};
    NSDictionary *sayMeg3 = @{@"t": @(2), @"n": @"<font color='#999999'>用户1266</font>", @"c": @"<font color='#000000'>玩大乱斗</font>", @"l": @(1)};
    
    NSArray *ds = @[enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3, enterMeg1, enterMeg2, enterMeg3, sayMeg1, sayMeg2, sayMeg3];
//    [self.chatView insertChatData:ds];
    
    __weak typeof(self) weakSelf = self;
    _t = [NSTimer qhchateoc_scheduledTimerWithTimeInterval:0.02 block:^{
        int index = [QHDouyuViewController getRandomNumber:0 to:(int)(ds.count - 1)];
        int index2 = [QHDouyuViewController getRandomNumber:0 to:(int)(ds.count - 1)];
        [weakSelf.chatView insertChatData:@[ds[index], ds[index2]]];
    } repeats:YES];
}

#pragma mark - Util

+ (int)getRandomNumber:(int)from to:(int)to {
    if (from > to) {
        int temp = from;
        from = to;
        to = temp;
    }
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - QHChatBaseViewDelegate

- (void)chatView:(QHChatBaseView *)view didSelectRowWithData:(NSDictionary *)chatData {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:chatData[@"c"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - Action

static int i = 0;

- (IBAction)sendAction:(id)sender {
    i++;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *enterMeg1 = @{@"t": @(1), @"n": [NSString stringWithFormat:@"<font color='#999999'>小哥哥%i</font>", i], @"l": @(18)};
        [weakSelf.chatView insertChatData:@[enterMeg1]];
    });
}

- (IBAction)clearAction:(id)sender {
    [self.chatView clearChatData];
}

@end
