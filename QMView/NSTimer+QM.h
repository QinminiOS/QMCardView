
#import <Foundation/Foundation.h>

@interface NSTimer (QM)

+ (NSTimer *)qm_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;

@end
