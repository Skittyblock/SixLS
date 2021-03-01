@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
- (void)lockScreenViewControllerRequestsUnlock;
@end
