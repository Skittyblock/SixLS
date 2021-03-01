@class NCNotificationContent, NCNotificationOptions, NCNotificationAction;

@interface NCNotificationRequest : NSObject
@property (nonatomic, retain) NCNotificationContent *content;
@property (nonatomic, retain) NCNotificationOptions *options;
@property (nonatomic, readonly) NCNotificationAction *defaultAction;
@property (nonatomic, retain) NSDate *timestamp;
@end
