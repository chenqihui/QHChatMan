//
//  QHTFHppleViewController.m
//  QHChatDemo
//
//  Created by Anakin chen on 2020/1/13.
//  Copyright © 2020 Chen Network Technology. All rights reserved.
//

/*
 
 由于 NSHTMLTextDocumentType 在 iOS8.3 系统下一定会崩溃，而在实际情况下，iOS8.3 以上都有概率会出现。
 
 * [NSAttributedString的坑 | iMemo的技术博客](http://blog.imemo8.com/2016/12/20/NSAttributedString/)
 
 所以使用其他方式解析
 
 本示例使用了
 
 * [topfunky/hpple: An XML/HTML parser for Objective-C, inspired by Hpricot.](https://github.com/topfunky/hpple)
 
 配置使用 libxml2.tbd
 
 * ['libxml/tree.h' file not found](https://www.jianshu.com/p/df59ba8c8cbc)
 
 */

#import "QHTFHppleViewController.h"

#import "QHChatLiveCloudTFHppleView.h"

@interface QHTFHppleViewController ()

@end

@implementation QHTFHppleViewController

// * [iOS中怎么继承Xib](https://blog.csdn.net/sunjie886/article/details/52175238)
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)p_initChatView {
    QHChatLiveCloudTFHppleView *v = [QHChatLiveCloudTFHppleView createChatViewToSuperView:self.chatContainerView];
    v.delegate = self;
    QHChatCellConfig cellConfig = v.config.cellConfig;
    cellConfig.cellLineSpacing = 1;
    cellConfig.fontSize = 15;
    cellConfig.cellWidth = [UIScreen mainScreen].bounds.size.width;
    v.config.cellConfig = cellConfig;
    v.config.chatCountMax = 50;
    v.config.chatCountDelete = 5;
    
    self.chatView = v;
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf p_doAction];
    });
}

- (void)p_doAction {
    NSDictionary *body7 = @{@"uid": @"test", @"rid": @"123456", @"nickname": [NSString stringWithFormat:@"顾小杰-%i", 1]};
    NSDictionary *enterMeg1 = @{@"op": @"enter", @"body": body7};
    
    NSDictionary *body = @{@"uid": @"test", @"rid": @"123456", @"nickname": @"顾小杰", @"content": @"会议几点开始啊，好期待。会议几点开始啊，好期待。会议几点开始啊，好期待。会议几点开始啊，好期待。"};
    NSDictionary *sayMeg1 = @{@"op": @"chat", @"body": body};
    NSDictionary *body2 = @{@"uid": @"test", @"rid": @"123456", @"nickname": @"顾小杰", @"content": @"会议几点开始啊，好期待。"};
    NSDictionary *sayMeg2 = @{@"op": @"chat", @"body": body2};
    
    NSDictionary *body3 = @{@"uid": @"test", @"rid": @"123456", @"nickname": @"顾小杰", @"giftName": @"酷炫猪", @"giftCount": @(1)};
    NSDictionary *giftMeg1 = @{@"op": @"gift", @"body": body3};
    NSDictionary *body4 = @{@"uid": @"test", @"rid": @"123456", @"nickname": @"顾小杰", @"giftName": @"酷炫猪", @"giftCount": @(10)};
    NSDictionary *giftMeg2 = @{@"op": @"gift", @"body": body4};
    
    NSArray *ds = @[enterMeg1, sayMeg1, sayMeg2, giftMeg1, giftMeg2];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (YES) {
            if (weakSelf == nil) {
                break;
            }
            [weakSelf.chatView lcInsertChatData:ds];
            CGFloat t = [QHTFHppleViewController getRandomNumber:2 to:10] * 0.01;
            [NSThread sleepForTimeInterval:t];
        }
    });
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

@end
