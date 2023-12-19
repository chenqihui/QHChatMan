//
//  QHChatBaseBuffer.h
//  QHChatDemo
//
//  Created by Anakin chen on 2020/5/27.
//  Copyright © 2020 Chen Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QHChatMan/QHChatBaseConfig.h>

@class QHChatBaseModel;

NS_ASSUME_NONNULL_BEGIN

static inline void onMainThreadAsync(void (^block)(void)) {
    if ([NSThread isMainThread]) block();
    else dispatch_async(dispatch_get_main_queue(), block);
}

static inline void onGlobalThreadAsync(void (^block)(void)) {
    if (![NSThread isMainThread]) block();
    else dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

@interface QHChatBaseBuffer : NSObject

@property (nonatomic, weak) QHChatBaseConfig *config;

//@property (nonatomic) dispatch_semaphore_t lock;

@property (nonatomic, strong, readonly) NSMutableArray<QHChatBaseModel *> *chatDatasArray;
@property (nonatomic, strong, readonly) NSMutableArray<NSDictionary *> *chatDatasTempArray;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, QHChatBaseModel *> *removeChatDatasDic;

- (void)append2TempArray:(NSArray<NSDictionary *> *)data;
- (void)append2Array:(QHChatBaseModel *)model;
- (void)append2RmoveArray:(QHChatBaseModel *)model;
- (QHChatBaseModel *)getChatData:(NSInteger)index;
- (void)clearTempArray;
- (void)clear;
- (void)replaceObjectAtLastIndexWith:(QHChatBaseModel *)model;
- (BOOL)removeObjectsInRange;
- (NSInteger)remove:(NSString *)cid;

@end

NS_ASSUME_NONNULL_END
