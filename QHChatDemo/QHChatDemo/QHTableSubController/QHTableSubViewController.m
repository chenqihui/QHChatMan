//
//  QHTableSubViewController.m
//  QHTableViewDemo
//
//  Created by chen on 17/3/21.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "QHTableSubViewController.h"

#import "QHChatBaseView.h"
#import "NSTimer+QHEOCBlocksSupport.h"

@interface QHTableSubViewController () <QHChatBaseViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (nonatomic, strong) QHChatBaseView *chatView;

@end

@implementation QHTableSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    QHChatBaseView *v = [QHChatBaseView createChatViewToSuperView:_contentV];
    v.delegate = self;
    QHChatCellConfig cellConfig = v.config.cellConfig;
    cellConfig.cellLineSpacing = 1;
    cellConfig.fontSize = 13;
    cellConfig.cellWidth = [UIScreen mainScreen].bounds.size.width - 40;
    v.config.cellConfig = cellConfig;
    v.backgroundColor = [UIColor orangeColor];
    
    _chatView = v;
    
    __weak typeof(self) weakSelf = self;
    NSArray *ds = @[@"窗前明月光", @"窗前明月光，疑是地上霜；举头望明月，低头思故乡。窗前明月光，疑是地上霜；举头望明月，低头思故乡。窗前明月光，疑是地上霜；举头望明月，低头思故乡。", @"举头望明月", @"低头思故乡，疑是地上霜；举头望明月，低头思故乡。低头思故乡，疑是地上霜；举头望明月，低头思故乡。窗前明月光，疑是地上霜；举头望明月，低头思故乡。窗前明月光，疑是地上霜；举头望明月，低头思故乡。窗前明月光，疑是地上霜；举头望明月，低头思故乡。"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < ds.count; i++) {
            if (weakSelf == nil) {
                break;
            }
            NSDictionary *d = ds[i];
            [v insertChatData:@[@{@"c": d}]];
            if (i == ds.count - 1) {
                i = 0;
            }
            sleep(1);
        }
    });
    
//    NSArray *ds = @[@{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}, @{@"c": @"窗前明月光"}];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(3);
//        [v insertChatData:ds];
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timerAction:(int)i {
    NSLog(@"%i", i);
}

#pragma mark - QHChatBaseViewDelegate

- (void)chatView:(QHChatBaseView *)view didSelectRowWithData:(NSDictionary *)chatData {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:chatData[@"c"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)goAction:(id)sender {
}

@end
