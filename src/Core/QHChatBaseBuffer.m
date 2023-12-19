//
//  QHChatBaseBuffer.m
//  QHChatDemo
//
//  Created by Anakin chen on 2020/5/27.
//  Copyright © 2020 Chen Network Technology. All rights reserved.
//

#import "QHChatBaseBuffer.h"

#import <QHChatMan/QHChatBaseModel.h>

// [iOS 十种线程锁](https://www.jianshu.com/p/7e9dd2cb78a8)

@interface QHChatBaseBuffer ()

@property (nonatomic, strong, readwrite) NSMutableArray<QHChatBaseModel *> *chatDatasArray;
@property (nonatomic, strong, readwrite) NSMutableArray<NSDictionary *> *chatDatasTempArray;
@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, QHChatBaseModel *> *removeChatDatasDic;

@end

@implementation QHChatBaseBuffer

- (void)dealloc {
    [self p_clear];
    _chatDatasArray = nil;
    _chatDatasTempArray = nil;
    _removeChatDatasDic = nil;
#if DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self p_setup];
    }
    return self;
}

#pragma mark - Public

- (void)append2TempArray:(NSArray<NSDictionary *> *)data {
    [self p_lock:^{
        [self.chatDatasTempArray addObjectsFromArray:data];
        if (self.chatDatasTempArray.count > self.config.chatCountMax) {
            [self.chatDatasTempArray removeObjectsInRange:NSMakeRange(0, self.config.chatCountDelete)];
        }
    }];
}

- (void)append2Array:(QHChatBaseModel *)model {
    [self p_lock:^{
        [self.chatDatasArray addObject:model];
    }];
}

- (void)append2RmoveArray:(QHChatBaseModel *)model {
    if (model.cid == nil || model.cid.length <= 0) {
        return;
    }
    [self p_lock:^{
        self.removeChatDatasDic[model.cid] = model;
    }];
}

- (QHChatBaseModel *)getChatData:(NSInteger)index {
    __block QHChatBaseModel *data = nil;
    [self p_lock:^{
        if (self.chatDatasArray.count > index) {
            data = self.chatDatasArray[index];
        }
    }];
    return data;
}

- (void)clearTempArray {
    [self p_lock:^{
        [self.chatDatasTempArray removeAllObjects];
    }];
}

- (void)clear {
    [self p_clear];
}

- (void)replaceObjectAtLastIndexWith:(QHChatBaseModel *)model {
    [self p_lock:^{
        [self.chatDatasArray replaceObjectAtIndex:self.chatDatasArray.count - 1 withObject:model];
    }];
}

- (BOOL)removeObjectsInRange {
    __block BOOL bDeleteChatData = NO;
    [self p_lock:^{
        if (self.chatDatasArray.count > self.config.chatCountMax) {
            [self.chatDatasArray removeObjectsInRange:NSMakeRange(0, self.config.chatCountDelete)];
            bDeleteChatData = YES;
        }
        if (self.removeChatDatasDic.count > self.config.chatCountMax) {
            NSArray *keys = self.removeChatDatasDic.allKeys;
            [self.removeChatDatasDic removeObjectsForKeys:[keys subarrayWithRange:NSMakeRange(0, self.config.chatCountDelete)]];
        }
    }];
    return bDeleteChatData;
}

- (NSInteger)remove:(NSString *)cid {
    QHChatBaseModel *m = self.removeChatDatasDic[cid];
    NSInteger index = -1;
    if (m) {
        index = [self.chatDatasArray indexOfObject:m];
        [self.chatDatasArray removeObject:m];
        [self.removeChatDatasDic removeObjectForKey:cid];
    }
    [self.chatDatasTempArray removeObject:m.originChatDataDic];
    return index;
}

#pragma mark - Private

- (void)p_setup {
//    _lock = dispatch_semaphore_create(1);
    
    _chatDatasTempArray = [NSMutableArray new];
    _chatDatasArray = [NSMutableArray new];
    _removeChatDatasDic = [NSMutableDictionary new];
}

- (void)p_lock:(void(^)(void))block {
//    if (self.config.hasUnlock == NO) {
//        dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
//        block();
//        dispatch_semaphore_signal(_lock);
//    }
//    else {
//        block();
//    }
    block();
}

- (void)p_clear {
    [self.chatDatasTempArray removeAllObjects];
    [self.chatDatasArray removeAllObjects];
    [self.removeChatDatasDic removeAllObjects];
}

@end
