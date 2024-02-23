// SixLSManager.m

#import "SixLSManager.h"
#import <UIKit/UIKit.h>
#import "Headers/SpringBoard/SBLockScreenManager.h"
#import "Headers/UserNotificationsKit/NCNotificationAction.h"
#import "Headers/UserNotificationsKit/NCNotificationActionRunner.h"

@implementation SixLSManager

+ (instancetype)sharedInstance {
	static SixLSManager *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[SixLSManager alloc] init];
	});
	return sharedInstance;
}

- (void)unlock {
	[[NSClassFromString(@"SBLockScreenManager") sharedInstance] lockScreenViewControllerRequestsUnlock];
}

- (void)openNotification:(NCNotificationRequest *)request {
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 13.0) {
		[request.defaultAction.actionRunner executeAction:request.defaultAction fromOrigin:nil withParameters:nil completion:nil];
	} else {
		[request.defaultAction.actionRunner executeAction:request.defaultAction fromOrigin:nil endpoint:nil withParameters:nil completion:nil];
	}
}

- (void)openCamera {
	int index = 2;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 14.0) index = 1;
	[self.csScrollView scrollToPageAtIndex:index animated:NO withCompletion:nil];
}

@end
