// Six (LS) Custom Lock Screen View

#import "SIXLockScreenView.h"

@implementation SIXLockScreenView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  BOOL pointInside = YES;

  if (!self.useNotifications) {
    CGRect frame = CGRectMake(0, self.statusBarHeight + 95, self.frame.size.width, self.frame.size.height - (self.statusBarHeight + 190));
    if (CGRectContainsPoint(frame, point)) pointInside = NO;
  }

  return pointInside;
}
@end
