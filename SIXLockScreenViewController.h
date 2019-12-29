// Six (LS) Custom Lock Screen View Controller

#import "Tweak.h"
#import "SIXNotificationAlertView.h"

@interface SIXLockScreenViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) UIView *statusBarBackground;
@property (nonatomic, retain) UIImageView *topBar;
@property (nonatomic, retain) UIImageView *bottomBar;
@property (nonatomic, retain) UIImageView *trackBackground;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UIImageView *cameraGrabber;
@property (nonatomic, retain) UIPanGestureRecognizer *cameraPanRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *cameraTapRecognizer;
@property (nonatomic, retain) _UIGlintyStringView *slideText;
@property (nonatomic, retain) UISlider *unlockSlider;
@property (nonatomic, retain) UIView *slideUpBackground;
@property (nonatomic, retain) CSScrollView *scrollView;
@property (nonatomic, retain) id notificationList;
@property (nonatomic, retain) NSMutableArray *notificationRequests;
@property (nonatomic, retain) NSMutableArray *cellHeights;
@property (nonatomic, retain) SIXNotificationAlertView *notificationView;
@property (nonatomic, retain) UITableView *notificationTable;
@property (nonatomic, retain) NSString *unlockText;
@property (nonatomic, assign) int statusBarHeight;
@property (nonatomic, assign) bool useNotifications;
@property (nonatomic, assign) bool militaryTime;
@property (nonatomic, assign) bool modernTime;
@property (nonatomic, assign) bool disableTimeBar;
@property (nonatomic, assign) bool disableSlideBar;
- (void)showBars;
- (void)hideBars;
- (void)layoutSix;
- (void)updateViews;
- (void)updateTime;
- (void)showNotificationTable;
- (void)insertNotificationRequest:(NCNotificationRequest *)request;
- (void)removeNotificationRequest:(NCNotificationRequest *)request;
@end
