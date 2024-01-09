//
//  QHTKGifRoomChatViewController.m
//  QHChatExampleDemo
//
//  Created by qihuichen on 2024/1/8.
//

#import "QHTKGifRoomChatViewController.h"

#import "QHGifChatRoomView.h"

@interface QHTKGifRoomChatViewController ()

@property (nonatomic, strong) QHGifChatRoomView *chatView;

@end

@implementation QHTKGifRoomChatViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)p_setup {
    QHChatBaseConfig *config = [QHChatBaseConfig new];
    config.bLongPress = YES;
    config.bOpenScorllFromBottom = YES;
    config.maxChatCount4closeScorllFromBottom = 16;
    config.chatCountMax = 100;
    config.chatCountDelete = 30;
    QHChatCellConfig cellConfig = config.cellConfig;
    cellConfig.cellLineSpacing = 1;
    cellConfig.fontSize = 14;
    cellConfig.cellWidth = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) *0.7;
    config.cellConfig = cellConfig;
    QHGifChatRoomView *v = [QHGifChatRoomView createChatViewToSuperView:self.chatSuperView withConfig:config];
    v.delegate = self;
    v.backgroundColor = [UIColor clearColor];
    _chatView = v;
    
    NSDictionary *body = @{@"c": @"欢迎来到直播间！XX倡导绿色健康直播，不提倡未成年人进行充值。直播内容和评论严禁包含政治、低俗色情、吸烟酗酒等内容，若有违反，将视情节严重程度给予禁播、永久封禁或停封账户。"};
    NSDictionary *msg = @{@"op": @"notice", @"body": body};
    [self.chatView insertChatData:@[msg]];
}

- (void)p_chat {
    NSDictionary *body = @{@"c": @"主播你好", @"n": @"小跟班"};
    NSDictionary *msg = @{@"op": @"chat", @"body": body};
    [self.chatView insertChatData:@[msg]];
}


@end
