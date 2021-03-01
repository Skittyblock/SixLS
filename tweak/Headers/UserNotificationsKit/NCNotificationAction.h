@class NCNotificationActionRunner;

@interface NCNotificationAction : NSObject
@property (nonatomic, readonly) NCNotificationActionRunner *actionRunner;
@property (nonatomic, copy, readonly) NSURL *launchURL;
@property (nonatomic, copy, readonly) NSString *launchBundleID;
@end
