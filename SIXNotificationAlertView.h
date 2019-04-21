// Six (LS) Custom Notification Alert View

#import "Tweak.h"

@interface SIXNotificationAlertView : UIView
@property (nonatomic, retain) NCNotificationRequest *request;
@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UIImageView *trackBackground;
@property (nonatomic, retain) _UIGlintyStringView *slideText;
@property (nonatomic, retain) UISlider *openSlider;
- (id)initWithRequest:(id)arg1;
- (void)showSlider;
- (void)hideSlider;
@end
