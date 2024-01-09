//
//  QHTKRoomChatViewController.h
//  QHChatDemo
//
//  Created by Anakin chen on 2019/11/8.
//  Copyright © 2019 Chen Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QHChatMan/QHChatMan.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHTKRoomChatViewController : UIViewController <QHChatBaseViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *chatSuperView;

- (void)p_setup;
- (void)p_chat;

@end

NS_ASSUME_NONNULL_END
