// Six (LS) Custom Notification Cell

#import "Tweak.h"
#import "SIXNotificationCell.h"

@implementation SIXNotificationCell

- (id)initWithRequest:(NCNotificationRequest *)request {
  self = [super init];

  if (self) {
    self.request = request;

    self.textLabel.text = @"";
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 6.5, [UIScreen mainScreen].bounds.size.width-111, 15)];
    if (!request.content.title && request.content.header) {
      self.titleLabel.text = request.content.header;
    } else {
      self.titleLabel.text = request.content.title;
    }
    if (!request.content.message && !request.content.subtitle) {
      self.titleLabel.frame = CGRectMake(47, 16, 200, 15);
    }
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    self.titleLabel.layer.masksToBounds = NO;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.titleLabel.layer.shadowRadius = 0;
    self.titleLabel.layer.shadowOpacity = 0.4;
    [self addSubview:self.titleLabel];

    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 24.5, [UIScreen mainScreen].bounds.size.width-56, 15)];
    self.messageLabel.text = request.content.message;
    self.messageLabel.numberOfLines = 4;
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    self.messageLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    self.messageLabel.layer.masksToBounds = NO;
    self.messageLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.messageLabel.layer.shadowRadius = 0;
    self.messageLabel.layer.shadowOpacity = 0.4;
    [self.messageLabel sizeToFit];
    [self addSubview:self.messageLabel];

    if (self.messageLabel.frame.size.height == 0) {
      self.messageLabel.frame = CGRectMake(47, 24.5, 200, 15);
    }

    NSString *notificationDate;

    if (request.content.date) {
      NSDate *now = [NSDate date];
      NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:request.content.date toDate:now options:0];

      if (components.day > 0) {
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        // TODO: format based on system settings?
        [timeFormat setDateFormat:@"MM/dd/yy"];
        notificationDate = [timeFormat stringFromDate:request.content.date];
      } else if (components.hour > 0) {
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        if (self.militaryTime) {
          [timeFormat setDateFormat:@"HH:mm"];
        } else {
          [timeFormat setDateFormat:@"h:mm a"];
        }
        notificationDate = [timeFormat stringFromDate: request.content.date];
      } else if (components.minute > 0 && self.modernTime) {
        notificationDate = [NSString stringWithFormat:@"%ldm ago", components.minute];
      } else if (self.modernTime) {
        notificationDate = @"now";
      } else {
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        if (self.militaryTime) {
          [timeFormat setDateFormat:@"HH:mm"];
        } else {
          [timeFormat setDateFormat:@"h:mm a"];
        }
        notificationDate = [timeFormat stringFromDate:request.content.date];
      }
    }

    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 64, 7, 55, 15)];
    if (!request.content.message && !request.content.subtitle) {
      self.timeLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 64, 16, 55, 15);
    }
    self.timeLabel.text = notificationDate;
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment =
NSTextAlignmentRight;
    self.timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    self.timeLabel.layer.masksToBounds = NO;
    self.timeLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.timeLabel.layer.shadowRadius = 0;
    self.timeLabel.layer.shadowOpacity = 0.4;
    [self addSubview:self.timeLabel];

    self.trackBackground = [[UIImageView alloc] initWithFrame:CGRectMake(6, (32 + self.messageLabel.frame.size.height)/2 - 17.5, [UIScreen mainScreen].bounds.size.width - 12, 35)];
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
    self.slideText.layer.sublayers[0].sublayers[2].backgroundColor = [UIColor colorWithWhite:1 alpha:0.65].CGColor;
    [self.trackBackground addSubview:self.slideText];

    self.openSlider = [[UISlider alloc] initWithFrame:CGRectMake(9, (32 + self.messageLabel.frame.size.height)/2 - 14.5, [UIScreen mainScreen].bounds.size.width - 18,
29)];
    [self.openSlider setValue:0 animated:NO];

    CGSize newSize = CGSizeMake(29, 29);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [request.content.icon drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self.openSlider setThumbImage:icon forState:UIControlStateNormal];
    [self.openSlider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [self.openSlider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];

    [self.openSlider addTarget:self action:@selector(showSlider) forControlEvents: UIControlEventTouchDown];
    [self.openSlider addTarget:self action:@selector(sliderStopped:) forControlEvents: UIControlEventTouchUpInside];
    [self.openSlider addTarget:self action:@selector(sliderStopped:) forControlEvents: UIControlEventTouchUpOutside];
    [self.openSlider addTarget:self action:@selector(sliderStopped:) forControlEvents: UIControlEventTouchCancel];
    [self.openSlider addTarget:self action:@selector(sliderMoved:) forControlEvents: UIControlEventValueChanged];
    [self addSubview:self.openSlider];

    UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    topSeparator.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
    [self addSubview: topSeparator];

    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 31 + self.messageLabel.frame.size.height, [UIScreen mainScreen].bounds.size.width, 1)];
    bottomSeparator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    [self addSubview:bottomSeparator];
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
    self.timeLabel.alpha = 0;
    self.messageLabel.alpha = 0;
  }];
}

- (void)hideSlider {
  [UIView animateWithDuration:0.2 animations:^{
    self.trackBackground.alpha = 0;
    self.slideText.alpha = 0;
    self.titleLabel.alpha = 1;
    self.timeLabel.alpha = 1;
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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 13.0) {
      [self.request.defaultAction.actionRunner executeAction:self.request.defaultAction fromOrigin:nil withParameters:nil completion:nil];
    } else {
      [self.request.defaultAction.actionRunner executeAction:self.request.defaultAction fromOrigin:nil endpoint:nil withParameters:nil completion:nil];
    }
  }
}

- (void)sliderMoved:(UISlider *)slider {
  self.slideText.alpha = 1 - slider.value * 3;
}

@end
