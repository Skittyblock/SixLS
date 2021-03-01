@interface SBUIController : NSObject
+ (id)sharedInstanceIfExists;
- (BOOL)isOnAC;
- (BOOL)_powerSourceWantsToPlayChime;
@end
