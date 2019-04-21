// Six (LS) Custom Notification Alert View

#import "SIXNotificationAlertView.h"

@implementation SIXNotificationAlertView
- (id)initWithRequest:(NCNotificationRequest *)request {
  self = [super init];

  if (self) {
    self.request = request;
    self.frame = CGRectMake(9, ([UIScreen mainScreen].bounds.size.height - 59.25) / 2, [UIScreen mainScreen].bounds.size.width - 18, 79.5);

    int statusBarHeight = [NSClassFromString(@"UIStatusBar") _heightForStyle:306 orientation:1 forStatusBarFrame:NO];
    if (statusBarHeight == 0) {
      statusBarHeight = [NSClassFromString(@"UIStatusBar_Modern") _heightForStyle:1 orientation:1 forStatusBarFrame:NO];
    }

    self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundView.image = [[UIImage imageWithContentsOfFile:@"/Library/Application Support/Six/notification.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) resizingMode:UIImageResizingModeStretch];
    self.backgroundView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.backgroundView];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, self.frame.size.width - 120, 20)];
    if (!request.content.title && request.content.header) {
      self.titleLabel.text = request.content.header;
    } else {
      self.titleLabel.text = request.content.title;
    }
    if (!request.content.message && !request.content.subtitle) {
      self.titleLabel.frame = CGRectMake(50, (self.frame.size.height - 8.5) / 2 - 10, 200, 20);
    }
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.titleLabel.layer.masksToBounds = NO;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, -1);
    self.titleLabel.layer.shadowRadius = 0;
    self.titleLabel.layer.shadowOpacity = 0.4;
    [self addSubview:self.titleLabel];

    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 38, self.frame.size.width - 64, 15)];
    self.messageLabel.text = request.content.message;
    self.messageLabel.numberOfLines = 4;
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    self.messageLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    self.messageLabel.layer.masksToBounds = NO;
    self.messageLabel.layer.shadowOffset = CGSizeMake(0, -1);
    self.messageLabel.layer.shadowRadius = 0;
    self.messageLabel.layer.shadowOpacity = 0.4;
    [self.messageLabel sizeToFit];
    [self addSubview:self.messageLabel];

    if (self.messageLabel.frame.size.height == 0) {
      self.messageLabel.frame = CGRectMake(50, 38, self.frame.size.width - 64, 15);
    }

    // Weird frame calculating, I know.
    self.frame = CGRectMake(9, (([UIScreen mainScreen].bounds.size.height - (190 + statusBarHeight)) / 2 - (59.5 + self.messageLabel.frame.size.height) / 2) + statusBarHeight + 95, [UIScreen mainScreen].bounds.size.width - 18, 59.5 + self.messageLabel.frame.size.height);
    self.backgroundView.frame = self.bounds;

    self.trackBackground = [[UIImageView alloc] initWithFrame:CGRectMake(11, (self.frame.size.height - 8.5) / 2 - 17.5, self.frame.size.width - 22, 35)];
    self.trackBackground.image = [[UIImage imageWithContentsOfFile:@"/Library/Application Support/Six/track.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 9, 0, 9) resizingMode:UIImageResizingModeStretch];
    self.trackBackground.contentMode = UIViewContentModeScaleToFill;
    self.trackBackground.alpha = 0;
    self.trackBackground.hidden = YES;
    [self addSubview:self.trackBackground];

    self.slideText = [[_UIGlintyStringView alloc] initWithText:@"slide to view" andFont:[UIFont fontWithName:@"Helvetica" size:19]];
    self.slideText.frame = CGRectMake(3, 6, [UIScreen mainScreen].bounds.size.width - 12, 23);
    [self.slideText setChevronStyle:0];
    [self.slideText hide];
    self.slideText.alpha = 0;
    // This actually doesn't work unfortunatly. More research is needed.
    [self.slideText.layer layoutSublayers];
    [self.slideText.layer.sublayers[0] layoutSublayers];
    self.slideText.layer.sublayers[0].sublayers[2].backgroundColor = [UIColor colorWithWhite:1 alpha:0.65].CGColor;
    [self.trackBackground addSubview:self.slideText];

    self.openSlider = [[UISlider alloc] initWithFrame:CGRectMake(14, (self.frame.size.height - 8.5) / 2 - 14.5, self.frame.size.width - 28, 29)];
    [self.openSlider setValue:0 animated:NO];

    CGSize newSize = CGSizeMake(29, 29);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [request.content.icon drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self.openSlider setThumbImage:icon forState:UIControlStateNormal];
    [self.openSlider setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.openSlider setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];

    [self.openSlider addTarget:self action:@selector(showSlider) forControlEvents: UIControlEventTouchDown];
    [self.openSlider addTarget:self action:@selector(sliderStopped:) forControlEvents: UIControlEventTouchUpInside];
    [self.openSlider addTarget:self action:@selector(sliderStopped:) forControlEvents: UIControlEventTouchUpOutside];
    [self.openSlider addTarget:self action:@selector(sliderStopped:) forControlEvents: UIControlEventTouchCancel];
    [self.openSlider addTarget:self action:@selector(sliderMoved:) forControlEvents: UIControlEventValueChanged];
    [self addSubview:self.openSlider];
  }

  return self;
}
- (void)showSlider {
  self.trackBackground.hidden = NO;
  [self.slideText show];

  [UIView animateWithDuration:0.2 animations:^{
    self.trackBackground.alpha = 0.8;
    self.slideText.alpha = 1;
    self.titleLabel.alpha = 0;
    self.messageLabel.alpha = 0;
  }];
}
- (void)hideSlider {
  [UIView animateWithDuration:0.2 animations:^{
    self.trackBackground.alpha = 0;
    self.slideText.alpha = 0;
    self.titleLabel.alpha = 1;
    self.messageLabel.alpha = 1;
  } completion:^(bool finished) {
    [self.openSlider setValue:0 animated:NO];
  }];
}
- (void)sliderStopped:(UISlider *)slider {
  if (slider.value < 1) {
    [UIView animateWithDuration:0.2 animations:^{
      [slider setValue:0 animated:YES];
      self.slideText.alpha = 1;
    } completion:^(bool finished) {
      [self hideSlider];
    }];
  } else {
    // If you ever want to execute a notification action, this is what you do I guess:
    [self.request.defaultAction.actionRunner executeAction:self.request.defaultAction fromOrigin:nil withParameters:nil completion:nil];
  }
}
- (void)sliderMoved:(UISlider *)slider {
  self.slideText.alpha = 1 - slider.value * 3;
}
@end
