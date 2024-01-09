//
//  QHTKChatRoomView.h
//  QHChatDemo
//
//  Created by Anakin chen on 2019/11/8.
//  Copyright © 2019 Chen Network Technology. All rights reserved.
//

#import <QHChatMan/QHChatMan.h>

NSString *const kTKChatOpKey = @"op";
NSString *const kTKChatOpValueChat = @"chat";
NSString *const kTKChatOpValueNotice = @"notice";

NS_ASSUME_NONNULL_BEGIN

@interface QHTKChatRoomView : QHChatBaseView <QHChatBaseViewCellDelegate>

@end

NS_ASSUME_NONNULL_END
