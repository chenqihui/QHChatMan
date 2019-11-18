//
//  QHTKRoomChatViewController.m
//  QHChatDemo
//
//  Created by Anakin chen on 2019/11/8.
//  Copyright © 2019 Chen Network Technology. All rights reserved.
//

/*
 [ios – 如何从底部向上填充UITableView？ - 代码日志](https://codeday.me/bug/20180821/225804.html)
 [一種讓UITableView的資料從下往上增長的方式 - IT閱讀](https://www.itread01.com/p/418616.html)
 [从底部加载tableview,向上滚动(反向tableview)(iOS) - 代码日志](https://codeday.me/bug/20190323/811221.html)
*/

#import "QHTKRoomChatViewController.h"

#import "QHTKChatRoomView.h"
#import "NSTimer+QHEOCBlocksSupport.h"

@interface QHTKRoomChatViewController () <QHChatBaseViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *chatSuperView;
@property (nonatomic, strong) QHTKChatRoomView *chatView;
@property (nonatomic, strong) NSTimer *t;

@end

@implementation QHTKRoomChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    QHChatBaseConfig *config = [QHChatBaseConfig new];
    config.bLongPress = YES;
    config.bOpenScorllFromBottom = YES;
    config.chatCountMax = 100;
    config.chatCountDelete = 30;
    QHChatCellConfig cellConfig = config.cellConfig;
    cellConfig.cellLineSpacing = 1;
    cellConfig.fontSize = 14;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        cellConfig.cellWidth = [UIScreen mainScreen].bounds.size.height;
    else
        cellConfig.cellWidth = [UIScreen mainScreen].bounds.size.width*0.7;
    config.cellConfig = cellConfig;
    QHTKChatRoomView *v = [QHTKChatRoomView createChatViewToSuperView:_chatSuperView withConfig:config];
    v.delegate = self;
    v.backgroundColor = [UIColor clearColor];
    [self addMaskView:v height:0.1];
    
    _chatView = v;
    
    NSDictionary *body = @{@"c": @"欢迎来到直播间！XX倡导绿色健康直播，不提倡未成年人进行充值。直播内容和评论严禁包含政治、低俗色情、吸烟酗酒等内容，若有违反，将视情节严重程度给予禁播、永久封禁或停封账户。"};
    NSDictionary *msg = @{@"op": @"notice", @"body": body};
    [self.chatView insertChatData:@[msg]];
    
//    __weak typeof(self) weakSelf = self;
//    NSTimer *t = [NSTimer qheoc_scheduledTimerWithTimeInterval:0.1 block:^{
////        [weakSelf sayAction:nil];
//        NSDictionary *body = @{@"c": @"欢迎来到直播间！XX倡导绿色健康直播，不提倡未成年人进行充值。直播内容和评论严禁包含政治、低俗色情、吸烟酗酒等内容，若有违反，将视情节严重程度给予禁播、永久封禁或停封账户。"};
//        NSDictionary *msg = @{@"op": @"notice", @"body": body};
//        [weakSelf.chatView insertChatData:@[msg]];
//    } repeats:YES];
//    [t fire];
//    _t = t;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    BOOL isLandscape = (NSInteger)size.width > (NSInteger)size.height;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self p_changeUI:isLandscape];
        });
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}

- (void)p_changeUI:(BOOL)isLandscape {
    [_chatView updateConstraints];
    QHChatCellConfig cellConfig = _chatView.config.cellConfig;
    cellConfig.cellWidth = isLandscape ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width * 0.7;
    _chatView.config.cellConfig = cellConfig;
    [self.chatView scrollToBottom];
}

#pragma mark - Util

- (void)addMaskView:(UIView *)superView height:(CGFloat)height {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    CGRect frame = CGRectMake(0, 0, MIN([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width), MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)*(2.0/7.0));
    gradientLayer.frame = frame;
    gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor blackColor].CGColor, (__bridge id)[UIColor blackColor].CGColor, (__bridge id)[UIColor clearColor].CGColor];
    gradientLayer.locations = @[@(0), @(height), @(0.999), @(1)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    UIView *maskView = [[UIView alloc] initWithFrame:frame];
    [maskView.layer addSublayer:gradientLayer];
    superView.maskView = maskView;
}

#pragma mark - Action

- (IBAction)sayAction:(id)sender {
    NSDictionary *body = @{@"c": @"主播你好", @"n": @"小跟班"};
    NSDictionary *msg = @{@"op": @"chat", @"body": body};
    [self.chatView insertChatData:@[msg]];
}

@end
