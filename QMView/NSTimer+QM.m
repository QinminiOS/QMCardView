//
//  NSObject+QM.m
//  QMView
//
//  Created by qinmin on 2017/4/2.
//  Copyright © 2017年 Qinmin. All rights reserved.
//

#import "NSTimer+QM.h"

@implementation NSTimer (QM)

+ (NSTimer *)qm_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(qm_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)qm_blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if(block) {
        block();
    }
}

@end
