//
//  ViewController.m
//  QHChatExampleDemo
//
//  Created by qihuichen on 2021/10/27.
//

#import "ViewController.h"

#import "QHDouyuViewController.h"
#import "QHLiveCloudViewController.h"
#import "QHSVLRoomChatViewController.h"
#import "QHTKRoomChatViewController.h"
#import "QHBgRoomViewController.h"
#import "QHTFHppleViewController.h"
#import "QHTKGifRoomChatViewController.h"
#import "QHYYLabelRoomViewController.h"

@interface ViewController ()
 
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%li", indexPath.row + 1]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *subVC = nil;
    switch (indexPath.row + 1) {
        case 1:
            subVC = [[QHDouyuViewController alloc] init];
            break;
        case 2:
            subVC = [[QHLiveCloudViewController alloc] init];
            break;
        case 3:
            subVC = [QHSVLRoomChatViewController new];
            break;
        case 4:
            subVC = [QHTKRoomChatViewController new];
            break;
        case 5:
            subVC = [QHBgRoomViewController new];
            break;
        case 6:
            subVC = [QHTFHppleViewController new];
            break;
        case 7:
            subVC = [QHTKGifRoomChatViewController new];
            break;
        case 8:
            subVC = [QHYYLabelRoomViewController new];
            break;
        default:
            break;
    }
    
    if (subVC != nil) {
        [self.navigationController pushViewController:subVC animated:YES];
    }
}


@end
