// Six (LS) Custom Lock Screen View Controller

#import "SIXLockScreenViewController.h"
#import "SIXNotificationCell.h"

#define isiPad ([(NSString *)[UIDevice currentDevice].model hasPrefix:@"iPad"])

@implementation SIXLockScreenViewController

- (void)layoutSix {
  if (self.view.center.y != self.view.bounds.size.height / 2) {
    [self.view setCenter:CGPointMake(self.view.center.x, [UIScreen mainScreen].bounds.size.height / 2)];
  }

  if (!self.statusBarBackground) {
    self.statusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.statusBarHeight)];
    self.statusBarBackground.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.55];
  }

  if (!self.topBar) {
    self.topBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight, [UIScreen mainScreen].bounds.size.width, 95)];
    self.topBar.image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/Six/lock.png"];
    self.topBar.contentMode = UIViewContentModeScaleToFill;
  }

  if (!self.bottomBar) {
    self.bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 95, [UIScreen mainScreen].bounds.size.width, 95)];
    self.bottomBar.image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/Six/lock.png"];
    self.bottomBar.contentMode = UIViewContentModeScaleToFill;
    [self.bottomBar setUserInteractionEnabled:YES];
  }

  if (!self.trackBackground) {
    self.trackBackground = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 85, 52)];
    self.trackBackground.image = [[UIImage imageWithContentsOfFile:@"/Library/Application Support/Six/track.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13) resizingMode:UIImageResizingModeStretch];
    self.trackBackground.contentMode = UIViewContentModeScaleToFill;
    [self.trackBackground setUserInteractionEnabled:YES];
  }

  if (!self.timeLabel) {
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width, 60)];
    self.timeLabel.text = @"9:41";
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = !isiPad ? [UIFont fontWithName:@"Helvetica-Light" size:58] : [UIFont fontWithName:@"Helvetica-Light" size:68];
    self.timeLabel.layer.masksToBounds = NO;
    self.timeLabel.layer.shadowOffset = CGSizeMake(0, -1);
    self.timeLabel.layer.shadowRadius = 0;
    self.timeLabel.layer.shadowOpacity = 0.6;
  }

  if (!self.dateLabel) {
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 30)];
    self.dateLabel.text = @"Monday, December 9";
    self.dateLabel.backgroundColor = [UIColor clearColor];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    self.dateLabel.layer.masksToBounds = NO;
    self.dateLabel.layer.shadowOffset = CGSizeMake(0, -1);
    self.dateLabel.layer.shadowRadius = 0;
    self.dateLabel.layer.shadowOpacity = 0.4;
  }

  if (!self.cameraGrabber && !isiPad) {
    self.cameraGrabber = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 21.5, 30, 52)];
    self.cameraGrabber.image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/Six/camera.png"];
    self.cameraGrabber.contentMode = UIViewContentModeScaleToFill;
    [self.cameraGrabber setUserInteractionEnabled:YES];
  }

  if (!self.cameraPanRecognizer) {
    self.cameraPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cameraDragged:)];
  }

  if (!self.cameraTapRecognizer) {
    self.cameraTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraTapped:)];
  }

  if (!self.slideText) {
    self.slideText = [[_UIGlintyStringView alloc] initWithText:self.unlockText andFont:[UIFont fontWithName:@"Helvetica" size:21]];
    self.slideText.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2) - (([UIScreen mainScreen].bounds.size.width - 155) / 2) - 12.5, 11, [UIScreen mainScreen].bounds.size.width - 155, 30);
    [self.slideText setChevronStyle:0];
    self.slideText.layer.sublayers[0].sublayers[2].backgroundColor = [UIColor colorWithWhite:1 alpha:0.65].CGColor;
  }

  if (!self.unlockSlider) {
    self.unlockSlider = [[UISlider alloc] initWithFrame:CGRectMake(23, [UIScreen mainScreen].bounds.size.height - 71, [UIScreen mainScreen].bounds.size.width - 91, 47)];

    UIImage *thumbImage = [UIImage imageWithContentsOfFile:@"/Library/Application Support/Six/thumb.png"];
    [self.unlockSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    [self.unlockSlider setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.unlockSlider setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];

    [self.unlockSlider addTarget:self action:@selector(sliderStopped:) forControlEvents: UIControlEventTouchUpInside];
    [self.unlockSlider addTarget:self action:@selector(sliderStopped:) forControlEvents: UIControlEventTouchUpOutside];
    [self.unlockSlider addTarget:self action:@selector(sliderStopped:) forControlEvents: UIControlEventTouchCancel];
    [self.unlockSlider addTarget:self action:@selector(sliderMoved:) forControlEvents: UIControlEventValueChanged];
  }

  if (!self.slideUpBackground) {
    self.slideUpBackground = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.slideUpBackground.backgroundColor = [UIColor blackColor];
  }

  if (self.notificationList.allNotificationRequests.count == 0) {
    if (self.notificationView) {
      [self.notificationView removeFromSuperview];
    }
    if (self.notificationTable) {
      [self.notificationTable removeFromSuperview];
    }
    if (self.notificationRequests) {
      self.notificationRequests = nil;
    }
    if (self.cellHeights) {
      self.cellHeights = nil;
    }
  }
  if (self.notificationTable) {
    [self.notificationTable reloadData];
  }

  [self.unlockSlider setValue:0 animated:NO];

  self.slideText.alpha = 1;
  self.slideText.text = self.unlockText;
  [self.slideText show];
  // Hacky fix. Unfortunatly only works if layoutSix is called twice?
  self.slideText.layer.sublayers[0].sublayers[2].backgroundColor = [UIColor colorWithWhite:1 alpha:0.65].CGColor;

  [self updateTime];
  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];

  [self.view addSubview:self.statusBarBackground];
  [self.view addSubview:self.topBar];
  [self.view addSubview:self.bottomBar];
  [self.topBar addSubview:self.timeLabel];
  [self.topBar addSubview:self.dateLabel];
  [self.bottomBar addSubview:self.trackBackground];
  [self.bottomBar addSubview:self.cameraGrabber];
  [self.cameraGrabber addGestureRecognizer:self.cameraPanRecognizer];
  [self.cameraGrabber addGestureRecognizer:self.cameraTapRecognizer];
  [self.trackBackground addSubview:self.slideText];
  [self.view addSubview:self.unlockSlider];
  [self.view addSubview:self.slideUpBackground];
}
- (void)updateViews {
  if (self.view.center.y != self.view.bounds.size.height / 2) {
    [self.view setCenter:CGPointMake(self.view.center.x, [UIScreen mainScreen].bounds.size.height / 2)];
  }

  if (self.notificationList.allNotificationRequests.count == 0) {
    if (self.notificationView) {
      [self.notificationView removeFromSuperview];
    }
    if (self.notificationTable) {
      [self.notificationTable removeFromSuperview];
    }
    if (self.notificationRequests) {
      self.notificationRequests = nil;
    }
    if (self.cellHeights) {
      self.cellHeights = nil;
    }
  }

  [self.unlockSlider setValue:0 animated:NO];

  self.slideText.alpha = 1;
  self.slideText.text = self.unlockText;
  [self.slideText show];
  // Hacky fix. Unfortunatly only works if layoutSix is called twice?
  self.slideText.layer.sublayers[0].sublayers[2].backgroundColor = [UIColor colorWithWhite:1 alpha:0.65].CGColor;
}
- (void)cameraDragged:(UIPanGestureRecognizer*)sender {
  if ( isiPad ) {
    return;
  }
  CGPoint translatedPoint = [sender translationInView:self.view];
  translatedPoint = CGPointMake(self.view.center.x, self.view.center.y + translatedPoint.y);

  if (!(translatedPoint.y > [UIScreen mainScreen].bounds.size.height/2)) {
    [self.view setCenter:translatedPoint];
  }

  [sender setTranslation:CGPointMake(0, 0) inView:self.view];

  if (sender.state == UIGestureRecognizerStateEnded) {
    [UIView animateWithDuration:0.4 animations:^{
      if (self.view.center.y + self.view.bounds.size.height / 2 > [UIScreen mainScreen].bounds.size.height / 2 + 95) {
        [self.view setCenter:CGPointMake(self.view.center.x, [UIScreen mainScreen].bounds.size.height / 2)];
      } else {
        [self.view setCenter:CGPointMake(self.view.center.x, -[UIScreen mainScreen].bounds.size.height / 2)];
      }
    } completion:^(BOOL finished) {
      if (self.view.center.y == -[UIScreen mainScreen].bounds.size.height / 2) {
        [self.scrollView scrollToPageAtIndex:2 animated:NO withCompletion:^{
          [self.view setCenter:CGPointMake(self.view.center.x, [UIScreen mainScreen].bounds.size.height / 2)];
        }];
      }
    }];
  }
}
- (void)cameraTapped:(UITapGestureRecognizer*)sender {
  if ( isiPad ) {
    return;
  }
  if (sender.state == UIGestureRecognizerStateEnded) {
    [UIView animateWithDuration:0.2 animations:^{
      [self.view setCenter:CGPointMake(self.view.center.x, self.view.center.y - 20)];
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:0.2 animations:^{
        [self.view setCenter:CGPointMake(self.view.center.x, self.view.center.y + 20)];
      }];
    }];
  }
}
- (void)updateTime {
  NSDate *now = [NSDate date];
  NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
  if (self.militaryTime) {
    [timeFormat setDateFormat:@"HH:mm"];
  } else {
    [timeFormat setDateFormat:@"h:mm"];
  }
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"EEEE, MMMM d"];
  self.timeLabel.text = [timeFormat stringFromDate:now];
  self.dateLabel.text = [dateFormat stringFromDate:now];
}
- (void)sliderStopped:(UISlider *)slider {
  if (slider.value < 1) {
    [UIView animateWithDuration:0.1 animations:^{
      [slider setValue:0 animated:YES];
      self.slideText.alpha = 1;
    }];
  } else {
    [[NSClassFromString(@"SBLockScreenManager") sharedInstance] lockScreenViewControllerRequestsUnlock];
  }
}
- (void)sliderMoved:(UISlider *)slider {
  self.slideText.alpha = 1 - slider.value * 3;
}
- (void)hideBars {
  if (self.topBar.frame.origin.y == self.statusBarHeight) {
    [UIView animateWithDuration:0.3 animations:^{
      CGRect topBarFrame = self.topBar.frame;
      CGRect bottomBarFrame = self.bottomBar.frame;
      CGRect unlockSliderFrame = self.unlockSlider.frame;
      topBarFrame.origin.y -= 100 + self.statusBarHeight;
      bottomBarFrame.origin.y += 100 + self.statusBarHeight;
      unlockSliderFrame.origin.y += 100 + self.statusBarHeight;
      self.topBar.frame = topBarFrame;
      self.bottomBar.frame = bottomBarFrame;
      self.unlockSlider.frame = unlockSliderFrame;
      // TODO: move table up, not hide
      self.notificationTable.alpha = 0;
    } completion:^(BOOL finished) {
      [self.unlockSlider setValue:0 animated:NO];
      self.slideText.alpha = 1;
    }];
  }
}
- (void)showBars {
  if (self.topBar.frame.origin.y == -100) {
    [self.unlockSlider setValue:0 animated:NO];
    self.slideText.alpha = 1;
    if (self.notificationTable) {
      for (SIXNotificationCell *cell in self.notificationTable.visibleCells) {
        [cell hideSlider];
      }
    }
    if (self.notificationView) {
      [self.notificationView hideSlider];
    }

    [UIView animateWithDuration:0.3 animations:^{
      CGRect topBarFrame = self.topBar.frame;
      CGRect bottomBarFrame = self.bottomBar.frame;
      CGRect unlockSliderFrame = self.unlockSlider.frame;
      topBarFrame.origin.y += 100 + self.statusBarHeight;
      bottomBarFrame.origin.y -= 100 + self.statusBarHeight;
      unlockSliderFrame.origin.y -= 100 + self.statusBarHeight;
      self.topBar.frame = topBarFrame;
      self.bottomBar.frame = bottomBarFrame;
      self.unlockSlider.frame = unlockSliderFrame;
      self.notificationTable.alpha = 1;
    }];
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.notificationRequests.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self.cellHeights[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SIXNotificationCell *cell = [[SIXNotificationCell alloc] initWithRequest:self.notificationRequests[indexPath.row]];

  if (cell.messageLabel.frame.size.height == 0) {
    cell.messageLabel.frame = CGRectMake(50, 38, self.view.frame.size.width - 64, 15);
  }
  NSNumber *cellHeight = [NSNumber numberWithFloat:32 + cell.messageLabel.frame.size.height];

  if (!self.cellHeights) {
    self.cellHeights = [NSMutableArray arrayWithObjects:cellHeight, nil];
  } else {
    [self.cellHeights insertObject:cellHeight atIndex:indexPath.row];
  }

  cell.militaryTime = self.militaryTime;
  cell.modernTime = self.modernTime;

  return cell;
}

- (void)showNotificationTable {
  if (!self.notificationTable) {
    self.notificationTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight + 95, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.statusBarHeight + 190)) style:UITableViewStylePlain];
    self.notificationTable.backgroundColor = [UIColor clearColor];
    self.notificationTable.separatorColor = [UIColor clearColor];
    self.notificationTable.allowsSelection = NO;
    self.notificationTable.delegate = self;
    self.notificationTable.dataSource = self;
    [self.view addSubview:self.notificationTable];

    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -480, [UIScreen mainScreen].bounds.size.width, 480)];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [self.notificationTable addSubview:backgroundView];
  }

  [self.notificationTable reloadData];
}

- (void)insertNotificationRequest:(NCNotificationRequest *)request {
  for (NCNotificationRequest *arrayRequest in self.notificationRequests) {
    if (arrayRequest == request) {
      return;
    }
  }

  if (!self.notificationRequests) {
    self.notificationRequests = [NSMutableArray arrayWithObjects:request, nil];
  } else {
    [self.notificationRequests insertObject:request atIndex:0];
  }

  if (self.useNotifications) {
    if (self.notificationList.allNotificationRequests.count > 0) {
      [self showNotificationTable];
      if (self.notificationView) {
        [self.notificationView removeFromSuperview];
        return;
      }
    } else if (self.notificationTable) {
      [self.notificationTable removeFromSuperview];
      self.notificationTable = nil;
    }

    if (self.notificationView) {
      [self.notificationView removeFromSuperview];
    }

    self.notificationView = [[NSClassFromString(@"SIXNotificationAlertView") alloc] initWithRequest:request];
    [self.view addSubview:self.notificationView];
  }
}
- (void)removeNotificationRequest:(NCNotificationRequest *)request {
  bool remove = false;
  if (self.notificationRequests.count > 0) {
    for (NCNotificationRequest *arrayRequest in self.notificationRequests) {
      if (arrayRequest == request) {
        remove = true;
      }
    }
    if (remove) {
      [self.cellHeights removeObjectAtIndex:[self.notificationRequests indexOfObject:request]];
      [self.notificationRequests removeObject:request];
      if (self.useNotifications) {
        [self showNotificationTable];
      }
    }
  }
}
@end
