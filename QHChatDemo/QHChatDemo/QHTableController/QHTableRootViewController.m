//
//  QHTableRootViewController.m
//  QHTableDemo
//
//  Created by chen on 17/3/13.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "QHTableRootViewController.h"

#import "QHDetailRootViewController.h"
#import "QHTableSubViewController.h"
#import "QHDouyuViewController.h"
#import "QHLiveCloudViewController.h"

@interface QHTableRootViewController ()

@property (nonatomic, strong) NSMutableArray *arData;

@end

@implementation QHTableRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[@"QHChatMan", @"QHChatDouyu", @"QHLiveCloud"];
    self.arData = [NSMutableArray arrayWithArray:array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCellIdentity" forIndexPath:indexPath];
    
    cell.textLabel.text = self.arData[indexPath.row];
    
    return cell;
}

#pragma mark - 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = self.arData[indexPath.row];
    
    UIViewController *subVC = nil;
    if ([title isEqualToString:@"QHChatMan"] == YES) {
        subVC = [[QHTableSubViewController alloc] init];
    }
    else if ([title isEqualToString:@"QHChatDouyu"] == YES) {
        subVC = [[QHDouyuViewController alloc] init];
    }
    else if ([title isEqualToString:@"QHLiveCloud"] == YES) {
        subVC = [[QHLiveCloudViewController alloc] init];
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        subVC = [storyboard instantiateViewControllerWithIdentifier:@"QHDetailRootID"];
    }
    
    [subVC.navigationItem setTitle:title];
    [self.navigationController pushViewController:subVC animated:YES];
}

@end
