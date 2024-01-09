//
//  QHLiveCloudViewController.h
//  QHChatDemo
//
//  Created by Anakin chen on 2018/12/28.
//  Copyright © 2018 Chen Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QHChatLiveCloudView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHLiveCloudViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *chatContainerView;

@property (nonatomic, strong) QHChatLiveCloudView *chatView;

- (void)p_sendAction;

@end

NS_ASSUME_NONNULL_END
