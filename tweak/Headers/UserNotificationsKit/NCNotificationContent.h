@interface NCNotificationContent : NSObject
@property (nonatomic, retain) NSString *header;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) NSDate *date;
@end
