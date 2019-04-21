// Six (LS) Custom Notification Cell

#import "Tweak.h"

@interface SIXNotificationCell : UITableViewCell
@property (nonatomic, retain) NCNotificationRequest *request;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, assign) bool militaryTime;
@property (nonatomic, assign) bool modernTime;
@property (nonatomic, retain) UIImageView *trackBackground;
@property (nonatomic, retain) _UIGlintyStringView *slideText;
@property (nonatomic, retain) UISlider *openSlider;
- (id)initWithRequest:(id)arg1;
- (void)showSlider;
- (void)hideSlider;
@end
