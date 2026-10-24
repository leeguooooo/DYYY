#import <Foundation/Foundation.h>
#import "AWMSafeDispatchTimer.h"

@interface DYYYTimerLifecycleTests : NSObject
+ (void)run;
@end

@implementation DYYYTimerLifecycleTests
+ (void)run {
    for (NSUInteger iteration = 0; iteration < 2000; iteration++) {
        @autoreleasepool {
            AWMSafeDispatchTimer *unusedTimer = [[AWMSafeDispatchTimer alloc] init];
            __weak AWMSafeDispatchTimer *unusedReference = unusedTimer;
            unusedTimer = nil;
            NSCAssert(unusedReference == nil, @"未启动的定时器应正常释放");

            AWMSafeDispatchTimer *activeTimer = [[AWMSafeDispatchTimer alloc] init];
            [activeTimer startWithInterval:60
                                  leeway:0.01
                                   queue:dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
                                 repeats:YES
                                 handler:^{}];
            NSCAssert(activeTimer.isRunning, @"定时器应已启动");
            __weak AWMSafeDispatchTimer *activeReference = activeTimer;
            activeTimer = nil;
            NSCAssert(activeReference == nil, @"运行中的定时器应能直接释放");

            AWMSafeDispatchTimer *cancelledTimer = [[AWMSafeDispatchTimer alloc] init];
            [cancelledTimer startWithInterval:60
                                     leeway:0.01
                                      queue:dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
                                    repeats:YES
                                    handler:^{}];
            NSCAssert(cancelledTimer.isRunning, @"定时器应已启动");
            [cancelledTimer cancel];
            NSCAssert(!cancelledTimer.isRunning, @"取消后应停止运行");
            cancelledTimer = nil;
        }
    }
}
@end

int main(void) {
    @autoreleasepool {
        [DYYYTimerLifecycleTests run];
        puts("AWMSafeDispatchTimer lifecycle tests passed");
    }
    return 0;
}
