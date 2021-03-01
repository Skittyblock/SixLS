// SixLSManager.h

#import "Headers/UserNotificationsKit/NCNotificationRequest.h"
#import "Headers/CoverSheet/CSScrollView.h"

@interface SixLSManager : NSObject

@property (nonatomic, assign) BOOL militaryTime;
@property (nonatomic, assign) BOOL disableDateBar;
@property (nonatomic, assign) BOOL disableLockBar;
@property (nonatomic, assign) BOOL disableWallpaperShadow;
@property (nonatomic, assign) BOOL disableChargingView;
@property (nonatomic, assign) BOOL disableClassicNotifications;
@property (nonatomic, retain) NSString *unlockText;

@property (nonatomic, retain) CSScrollView *csScrollView;

+ (instancetype)sharedInstance;
- (void)unlock;
- (void)openNotification:(NCNotificationRequest *)request;
- (void)openCamera;

@end
