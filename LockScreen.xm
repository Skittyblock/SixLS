// Six (LS), by Skitty
// iOS 6 Style Lock Screen for iOS 11/12

#import "Tweak.h"
#import "SIXLockScreenView.h"
#import "SIXLockScreenViewController.h"

#define isiPad ([(NSString *)[UIDevice currentDevice].model hasPrefix:@"iPad"])

static NSMutableDictionary *settings;
static bool enabled;
static bool disableHome;
static NSString *slideText;
static bool chargeView;
static bool wallpaperGradient;
static bool militaryTime;
static bool modernTime;
static bool classicNotifications;
static bool lockSound;
static bool unlockSound;
static bool chargeSound;
static bool disableTimeBar;
static bool disableSlideBar;

static bool isLocked = true;
static bool unlockAllowed = NO;

static NSMutableArray *viewsToLayout = [NSMutableArray new];

static CGFloat statusHeight;

static CSMainPageView *mainPageView;

// Preference Updates
static void refreshPrefs() {
  CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("xyz.skitty.sixls"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
  if(keyList) {
    settings = (NSMutableDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, CFSTR("xyz.skitty.sixls"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
    CFRelease(keyList);
  } else {
    settings = nil;
  }
  if (!settings) {
    settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/xyz.skitty.sixls.plist"];
  }

  enabled = [([settings objectForKey:@"enabled"] ?: @(YES)) boolValue];
  disableHome = [([settings objectForKey:@"disableHome"] ?: @(NO)) boolValue];
  slideText = ([settings objectForKey:@"slideText"] ?: @"slide to unlock");
  chargeView = [([settings objectForKey:@"chargeView"] ?: @(YES)) boolValue];
  wallpaperGradient = [([settings objectForKey:@"wallpaperGradient"] ?: @(YES)) boolValue];
  militaryTime = [([settings objectForKey:@"militaryTime"] ?: @(NO)) boolValue];
  modernTime = [([settings objectForKey:@"modernTime"] ?: @(NO)) boolValue];
  classicNotifications = [([settings objectForKey:@"classicNotifications"] ?: @(YES)) boolValue];
  lockSound = [([settings objectForKey:@"lockSound"] ?: @(YES)) boolValue];
  unlockSound = [([settings objectForKey:@"unlockSound"] ?: @(YES)) boolValue];
  chargeSound = [([settings objectForKey:@"chargeSound"] ?: @(YES)) boolValue];
  disableTimeBar = [([settings objectForKey:@"disableTimeBar"] ?: @(NO)) boolValue];
  disableSlideBar = [([settings objectForKey:@"disableSlideBar"] ?: @(NO)) boolValue];
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  refreshPrefs();
}

static void setIsLocked(bool locked) {
  isLocked = locked;
  unlockAllowed = NO;
  for (UIView *view in viewsToLayout) {
    [view layoutSix];
  }
}

// Unlock Sound
%hook SBCoverSheetPrimarySlidingViewController
- (void)viewWillDisappear:(BOOL)arg1 {
  %orig;
  if (enabled && unlockSound && mainPageView.sixView.alpha == 1) {
    SystemSoundID sound = 0;
    AudioServicesDisposeSystemSoundID(sound);
    AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain([NSURL fileURLWithPath:@"/Library/Application Support/Six/unlock.caf"]), &sound);
		AudioServicesPlaySystemSound((SystemSoundID)sound);
  }
}
%end

// Lock Sound
%hook SBSleepWakeHardwareButtonInteraction
- (void)_playLockSound {
  if (enabled && lockSound) {
    SystemSoundID sound = 0;
    AudioServicesDisposeSystemSoundID(sound);
    AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain([NSURL fileURLWithPath:@"/Library/Application Support/Six/lock.caf"]), &sound);
    AudioServicesPlaySystemSound((SystemSoundID)sound);
  } else {
    %orig;
  }
}
%end

// Charge Sound
%hook SBUIController
- (void)playConnectedToPowerSoundIfNecessary {
  if (enabled && chargeSound && self.isOnAC) {
    SystemSoundID sound = 0;
    AudioServicesDisposeSystemSoundID(sound);
    AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain([NSURL fileURLWithPath:@"/Library/Application Support/Six/connect_power.caf"]), &sound);
		AudioServicesPlaySystemSound((SystemSoundID)sound);
  } else {
    %orig;
  }
}
%end

// Doesn't work 100%. There are still issues with this I need to research.
%hook NCNotificationDispatcher
- (void)destination:(id)arg1 executeAction:(id)arg2 forNotificationRequest:(id)arg3 requestAuthentication:(bool)arg4 withParameters:(id)arg5 completion:(id)arg6 {
  %orig;
  [mainPageView.sixController removeNotificationRequest:arg3];
}
%end
/*
// Hide Page Dots
// Weird way to do this, I know. It was the only way I could get it to work.
%hook SBDashBoardMainPageContentViewController
- (void)aggregateAppearance:(SBDashBoardAppearance *)arg1 {
  if (enabled && isLocked && !disableSlideBar) {
    SBDashBoardComponent *pageControl = [[%c(SBDashBoardComponent) pageControl] hidden:YES];
    [arg1 addComponent:pageControl];
    %orig(arg1);
  } else {
    %orig;
  }
}
%end
*/
// Hide Clock
%hook SBFLockScreenDateView
- (void)layoutSubviews {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  if (enabled && isLocked && !disableTimeBar) {
    self.hidden = YES;
    self.alpha = 0;
  } else {
    self.hidden = NO;
    self.alpha = 1;
  }
}
%end

// Hide Big Lock Icon
%hook SBUIProudLockIconView
- (void)layoutSubviews {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  if (enabled && isLocked && !disableTimeBar) {
    self.hidden = YES;
    self.alpha = 0;
  } else {
    self.hidden = NO;
    self.alpha = 1;
  }
}
%end

%hook SBUIFaceIDCameraGlyphView
- (void)layoutSubviews {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  if (enabled && isLocked && !disableTimeBar) {
    self.hidden = YES;
    self.alpha = 0;
  } else {
    self.hidden = NO;
    self.alpha = 1;
  }
}
%end

// Disable Swipe Gesture
%hook SBCoverSheetScreenEdgePanGestureRecognizer
- (BOOL)isEnabled {
  if (enabled && isLocked && !disableSlideBar) {
    return NO;
  } else {
    return %orig;
  }
}
%end

%hook SBCoverSheetSlidingViewController
- (void)_handleDismissGesture:(id)arg1 {
    if (enabled && isLocked && !disableSlideBar) {
        return;
    }
    %orig;
}
// Disable Home Button
- (void)setPresented:(BOOL)arg1 animated:(BOOL)arg2 withCompletion:(id)arg3 {
  if (enabled && isLocked && disableHome && !arg1 && !unlockAllowed) {
    return;
  }
  %orig;
}
%end

// BUG: Won't display stock charging view if disable home is enabled
// Is this what's causing alarm issues for people?
%hook SBDashBoardModalPresentationViewController
- (void)presentContentViewController:(UIViewController *)arg1 animated:(BOOL)arg2 completion:(/*^block*/id)arg3 {
  for (UIView *view in arg1.view.subviews) {
    if ([view isKindOfClass:%c(SBLockScreenBatteryChargingView)] || [view isKindOfClass:%c(_SBLockScreenSingleBatteryChargingView)]) {
      if (chargeView) {
        return;
      } else {
        %orig;
        return;
      }
    }
  }
  if (enabled && isLocked && disableHome && !unlockAllowed) {
    return;
  }
  %orig;
}
%end

%hook SBLockScreenManager
- (void)lockScreenViewControllerRequestsUnlock {
  unlockAllowed = YES;
  %orig;
}
%end

// Fix Disable Home with Notification Sliders
// Yes, I'm hooking my own classes.
%hook SIXNotificationCell
- (void)sliderStopped:(UISlider *)slider {
  if (slider.value == 1) {
    unlockAllowed = YES;
  }
  %orig;
}
%end

%hook SIXNotificationAlertView
- (void)sliderStopped:(UISlider *)slider {
  if (slider.value == 1) {
    unlockAllowed = YES;
  }
  %orig;
}
%end

%group iOS12
// Dectect Notifications
%hook NCNotificationPriorityList
- (int)insertNotificationRequest:(id)arg1 {
  mainPageView.sixController.notificationList = self;
  [mainPageView.sixController insertNotificationRequest:arg1];
  return %orig;
}
%end

%hook SBDashBoardViewController
// Rotate Views
- (void)_calculateAppearanceForCurrentOrientation {
  %orig;
  [mainPageView updateFrames];
}
// Show Charging View
- (void)_transitionChargingViewToVisible:(BOOL)arg1 showBattery:(BOOL)arg2 animated:(BOOL)arg3 {
  if (enabled && chargeView) {
    [mainPageView layoutSix];
  } else {
    %orig;
  }
}
// Set isLocked
- (void)viewWillAppear:(BOOL)arg1 {
  %orig;
  setIsLocked(!self.authenticated);
}
%end

// Animate LS Bars
%hook SBDashBoardPasscodeViewController
- (void)viewWillAppear:(BOOL)arg1 {
  %orig;
  if (enabled) {
    [mainPageView.sixController hideBars];
  }
}
- (void)viewWillDisappear:(BOOL)arg1 {
  %orig;
  if (enabled) {
    unlockAllowed = NO;
    [mainPageView.sixController showBars];
  }
}
%end

// Lock Screen Views
%hook SBDashBoardMainPageView
%property (nonatomic, retain) UIImageView *wallpaperGradient;
%property (nonatomic, retain) UIView *batteryView;
%property (nonatomic, retain) UIImageView *batteryImage;
%property (nonatomic, retain) SIXLockScreenViewController *sixController;
%property (nonatomic, retain) SIXLockScreenView *sixView;
- (void)layoutSubviews {
  %orig;
  if (!mainPageView) {
    mainPageView = (CSMainPageView *)self;
    [viewsToLayout addObject:self];
    if (isiPad) {
      [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFrames) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
  }
  [self layoutSix];
}
%new
- (void)updateFrames {
  [self layoutSix];
  self.sixController.statusBarBackground.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusHeight);

  if (!isiPad) {
    self.sixController.topBar.frame = CGRectMake(0, statusHeight, [UIScreen mainScreen].bounds.size.width, 95);
    self.sixController.bottomBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 95, [UIScreen mainScreen].bounds.size.width, 95);
    self.sixController.trackBackground.frame = CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 85, 52);
    self.sixController.timeLabel.frame = CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width, 60);
    self.sixController.dateLabel.frame = CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 30);
    self.sixController.cameraGrabber.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 21.5, 30, 52);
    self.sixController.slideText.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2) - (([UIScreen mainScreen].bounds.size.width - 155) / 2) - 12.5, 11, [UIScreen mainScreen].bounds.size.width - 155, 30);
    self.sixController.unlockSlider.frame = CGRectMake(23, [UIScreen mainScreen].bounds.size.height - 71, [UIScreen mainScreen].bounds.size.width - 91, 47);
  } else {
    self.sixController.topBar.frame = CGRectMake(0, statusHeight, [UIScreen mainScreen].bounds.size.width, 100);
    self.sixController.bottomBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100, [UIScreen mainScreen].bounds.size.width, 100);
    self.sixController.trackBackground.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2) - 128, 24, 256, 52);
    self.sixController.timeLabel.frame = CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 60);
    self.sixController.dateLabel.frame = CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, 30);
    self.sixController.slideText.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2) - (([UIScreen mainScreen].bounds.size.width - 155) / 2) - 110, 11, 365, 30);
    self.sixController.unlockSlider.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2) - 127, [UIScreen mainScreen].bounds.size.height - 71, 245, 47);
  }

  self.sixController.slideUpBackground.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
  if (self.sixController.notificationTable) {
    self.sixController.notificationTable.frame = CGRectMake(0, statusHeight + 95, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (statusHeight + 190));
  }
}
%new
- (void)layoutSix {
  if (enabled && isLocked) {
    if (!statusHeight) {
      statusHeight = [%c(UIStatusBar) _heightForStyle:306 orientation:1 forStatusBarFrame:NO];
      if (statusHeight == 0) {
        statusHeight = [%c(UIStatusBar_Modern) _heightForStyle:1 orientation:1 forStatusBarFrame:NO];
      }
    }

    // Charging View
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

    if (!self.batteryView) {
      self.batteryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
      self.batteryView.backgroundColor = [UIColor blackColor];
    }

    if (!self.batteryImage) {
      [self.batteryImage removeFromSuperview];
      self.batteryImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-132, [UIScreen mainScreen].bounds.size.height/2-71, 264, 129)];
    }

    double num = ([[UIDevice currentDevice] batteryLevel]*100.0)/(100.0/16.0);
    if (num > 0) {
      num = floor(num) + 1.0;
    }

    NSString *path = [NSString stringWithFormat:@"/Library/Application Support/Six/BatteryBG_%.f.png", num];
    self.batteryImage.image = [UIImage imageWithContentsOfFile:path];
    self.batteryImage.contentMode = UIViewContentModeScaleToFill;

    if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging && chargeView) {
      [self insertSubview:self.batteryView atIndex:0];
      [self.batteryView addSubview:self.batteryImage];
    } else {
      [self.batteryView removeFromSuperview];
      [self.batteryImage removeFromSuperview];
    }

    // Wallpaper Shadow
    if (!self.wallpaperGradient) {
      self.wallpaperGradient = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
      self.wallpaperGradient.image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/Six/sb.png"];
      self.wallpaperGradient.contentMode = UIViewContentModeScaleToFill;
    }

    if (wallpaperGradient) {
      [self insertSubview:self.wallpaperGradient atIndex:0];
    } else {
      [self.wallpaperGradient removeFromSuperview];
    }

    // Main Lock Screen Views
    if (!self.sixController) {
      self.sixController = [[%c(SIXLockScreenViewController) alloc] init];
      self.sixView = [[%c(SIXLockScreenView) alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
      self.sixController.view = self.sixView;
      for (UIView *view in viewsToLayout) {
        if ([view isKindOfClass:%c(SBPagedScrollView)]) {
          self.sixController.scrollView = ((CSScrollView *)view);
        }
       }

      self.sixController.statusBarHeight = statusHeight;
      self.sixController.unlockText = slideText;
      self.sixController.militaryTime = militaryTime;
      self.sixController.modernTime = modernTime;
      self.sixController.useNotifications = classicNotifications;
      self.sixController.disableTimeBar = disableTimeBar;
      self.sixController.disableSlideBar = disableSlideBar;
      self.sixView.statusBarHeight = statusHeight;
      self.sixView.useNotifications = classicNotifications;
      [self.sixController layoutSix];
    }

    self.sixView.alpha = 1;
    [self.sixController updateViews];
    [self addSubview:self.sixView];
  } else {
    if (self.batteryView) {
      [self.batteryView removeFromSuperview];
      [self.batteryImage removeFromSuperview];
    }
    if (self.wallpaperGradient) {
      [self.wallpaperGradient removeFromSuperview];
    }
    if (self.sixView) {
      self.sixView.alpha = 0;
      [self.sixView removeFromSuperview];
    }
  }
}
%end

// Disable Lock Screen Page Scrolling
%hook SBPagedScrollView
- (void)layoutSubviews {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  if (enabled && isLocked && !disableSlideBar) {
    self.scrollEnabled = NO;
  } else {
    self.scrollEnabled = YES;
  }
}
%end

// Hide Home Bar, Swipe to Unlock, etc.
%hook SBDashBoardFixedFooterViewController
- (void)viewDidLoad {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  if (enabled && isLocked && !disableSlideBar) {
    self.view.hidden = YES;
    self.view.alpha = 0;
  } else {
    self.view.hidden = NO;
    self.view.alpha = 1;
  }
}
%end

// Hide Quick Actions
%hook SBDashBoardView
- (void)layoutSubviews {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  UIView *quickActions = MSHookIvar<UIView *>(self, "_quickActionsView");
  if (enabled && isLocked && !disableSlideBar) {
    quickActions.hidden = YES;
    quickActions.alpha = 0;
  } else {
    quickActions.hidden = NO;
    quickActions.alpha = 1;
  }
}
%end

// Hide pill view
%hook SBTeachableMomentsContainerViewController
- (void)viewDidLoad {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  if (enabled && isLocked && !disableSlideBar) {
    self.view.hidden = YES;
    self.view.alpha = 0;
  } else {
    self.view.hidden = NO;
    self.view.alpha = 1;
  }
}
%end

// Move Notifications
%hook NCNotificationListCollectionView
- (UIEdgeInsets)adjustedContentInset {
  UIEdgeInsets inset = %orig;
  if (enabled && isLocked && !classicNotifications && !disableTimeBar) {
    inset.top = statusHeight + 100;
  }
  return inset;
}
- (CGPoint)minimumContentOffset {
  CGPoint offset = %orig;
  if (enabled && isLocked && !classicNotifications && !disableTimeBar) {
    offset.y = 0;
  }
  return offset;
}
- (void)layoutSubviews {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  if (enabled && isLocked && classicNotifications) {
    self.hidden = YES;
  } else {
    self.hidden = NO;
  }
}
%end
%end

%group iOS13
// Dectect Notifications
%hook NCNotificationMasterList
- (int)insertNotificationRequest:(id)arg1 {
  mainPageView.sixController.notificationList = self;
  [mainPageView.sixController insertNotificationRequest:arg1];
  return %orig;
}
%end

%hook CSCoverSheetViewController
// Rotate Views
- (void)_calculateAppearanceForCurrentOrientation {
  %orig;
  [mainPageView updateFrames];
}
// Show Charging View
- (void)_transitionChargingViewToVisible:(BOOL)arg1 showBattery:(BOOL)arg2 animated:(BOOL)arg3 {
  if (enabled && chargeView) {
    [mainPageView layoutSix];
  } else {
    %orig;
  }
}
// Set isLocked
- (void)viewWillAppear:(BOOL)arg1 {
  %orig;
  setIsLocked(!self.authenticated);
}
%end

// Animate LS Bars
%hook CSPasscodeViewController
- (void)viewWillAppear:(BOOL)arg1 {
  %orig;
  if (enabled) {
    [mainPageView.sixController hideBars];
  }
}
- (void)viewWillDisappear:(BOOL)arg1 {
  %orig;
  if (enabled) {
    unlockAllowed = NO;
    [mainPageView.sixController showBars];
  }
}
%end

// Lock Screen Views
%hook CSMainPageView
%property (nonatomic, retain) UIImageView *wallpaperGradient;
%property (nonatomic, retain) UIView *batteryView;
%property (nonatomic, retain) UIImageView *batteryImage;
%property (nonatomic, retain) SIXLockScreenViewController *sixController;
%property (nonatomic, retain) SIXLockScreenView *sixView;
- (void)layoutSubviews {
  %orig;
  if (!mainPageView) {
    mainPageView = self;
    [viewsToLayout addObject:self];
    if (isiPad) {
      [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFrames) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
  }
  [self layoutSix];
}
%new
- (void)updateFrames {
  [self layoutSix];
  self.sixController.statusBarBackground.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusHeight);

  if (!isiPad) {
    self.sixController.topBar.frame = CGRectMake(0, statusHeight, [UIScreen mainScreen].bounds.size.width, 95);
    self.sixController.bottomBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 95, [UIScreen mainScreen].bounds.size.width, 95);
    self.sixController.trackBackground.frame = CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 85, 52);
    self.sixController.timeLabel.frame = CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width, 60);
    self.sixController.dateLabel.frame = CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 30);
    self.sixController.cameraGrabber.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 21.5, 30, 52);
    self.sixController.slideText.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2) - (([UIScreen mainScreen].bounds.size.width - 155) / 2) - 12.5, 11, [UIScreen mainScreen].bounds.size.width - 155, 30);
    self.sixController.unlockSlider.frame = CGRectMake(23, [UIScreen mainScreen].bounds.size.height - 71, [UIScreen mainScreen].bounds.size.width - 91, 47);
  } else {
    self.sixController.topBar.frame = CGRectMake(0, statusHeight, [UIScreen mainScreen].bounds.size.width, 100);
    self.sixController.bottomBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100, [UIScreen mainScreen].bounds.size.width, 100);
    self.sixController.trackBackground.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2) - 128, 24, 256, 52);
    self.sixController.timeLabel.frame = CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 60);
    self.sixController.dateLabel.frame = CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, 30);
    self.sixController.slideText.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2) - (([UIScreen mainScreen].bounds.size.width - 155) / 2) - 110, 11, 365, 30);
    self.sixController.unlockSlider.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2) - 127, [UIScreen mainScreen].bounds.size.height - 71, 245, 47);
  }

  self.sixController.slideUpBackground.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
  if (self.sixController.notificationTable) {
    self.sixController.notificationTable.frame = CGRectMake(0, statusHeight + 95, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (statusHeight + 190));
  }
}
%new
- (void)layoutSix {
  if (enabled && isLocked) {
    if (!statusHeight) {
      statusHeight = [%c(UIStatusBar) _heightForStyle:306 orientation:1 forStatusBarFrame:NO];
      if (statusHeight == 0) {
        statusHeight = [%c(UIStatusBar_Modern) _heightForStyle:1 orientation:1 forStatusBarFrame:NO];
      }
    }

    // Charging View
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

    if (!self.batteryView) {
      self.batteryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
      self.batteryView.backgroundColor = [UIColor blackColor];
    }

    if (!self.batteryImage) {
      [self.batteryImage removeFromSuperview];
      self.batteryImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-132, [UIScreen mainScreen].bounds.size.height/2-71, 264, 129)];
    }

    double num = ([[UIDevice currentDevice] batteryLevel]*100.0)/(100.0/16.0);
    if (num > 0) {
      num = floor(num) + 1.0;
    }

    NSString *path = [NSString stringWithFormat:@"/Library/Application Support/Six/BatteryBG_%.f.png", num];
    self.batteryImage.image = [UIImage imageWithContentsOfFile:path];
    self.batteryImage.contentMode = UIViewContentModeScaleToFill;

    if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging && chargeView) {
      [self insertSubview:self.batteryView atIndex:0];
      [self.batteryView addSubview:self.batteryImage];
    } else {
      [self.batteryView removeFromSuperview];
      [self.batteryImage removeFromSuperview];
    }

    // Wallpaper Shadow
    if (!self.wallpaperGradient) {
      self.wallpaperGradient = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
      self.wallpaperGradient.image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/Six/sb.png"];
      self.wallpaperGradient.contentMode = UIViewContentModeScaleToFill;
    }

    if (wallpaperGradient) {
      [self insertSubview:self.wallpaperGradient atIndex:0];
    } else {
      [self.wallpaperGradient removeFromSuperview];
    }

    // Main Lock Screen Views
    if (!self.sixController) {
      self.sixController = [[%c(SIXLockScreenViewController) alloc] init];
      self.sixView = [[%c(SIXLockScreenView) alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
      self.sixController.view = self.sixView;
      for (UIView *view in viewsToLayout) {
        if ([view isKindOfClass:%c(CSScrollView)]) {
          self.sixController.scrollView = ((CSScrollView *)view);
        }
       }

      self.sixController.statusBarHeight = statusHeight;
      self.sixController.unlockText = slideText;
      self.sixController.militaryTime = militaryTime;
      self.sixController.modernTime = modernTime;
      self.sixController.useNotifications = classicNotifications;
      self.sixController.disableTimeBar = disableTimeBar;
      self.sixController.disableSlideBar = disableSlideBar;
      self.sixView.statusBarHeight = statusHeight;
      self.sixView.useNotifications = classicNotifications;
      [self.sixController layoutSix];
    }

    self.sixView.alpha = 1;
    [self.sixController updateViews];
    [self addSubview:self.sixView];
  } else {
    if (self.batteryView) {
      [self.batteryView removeFromSuperview];
      [self.batteryImage removeFromSuperview];
    }
    if (self.wallpaperGradient) {
      [self.wallpaperGradient removeFromSuperview];
    }
    if (self.sixView) {
      self.sixView.alpha = 0;
      [self.sixView removeFromSuperview];
    }
  }
}
%end

// Disable Lock Screen Page Scrolling
%hook CSScrollView
- (void)layoutSubviews {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  if (enabled && isLocked && !disableSlideBar) {
    self.scrollEnabled = NO;
  } else {
    self.scrollEnabled = YES;
  }
}
%end

// Hide Home Bar, Swipe to Unlock, etc.
%hook CSFixedFooterViewController
- (void)viewDidLoad {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  if (enabled && isLocked && !disableSlideBar) {
    self.view.hidden = YES;
    self.view.alpha = 0;
  } else {
    self.view.hidden = NO;
    self.view.alpha = 1;
  }
}
%end

// Hide Quick Actions
%hook CSCoverSheetView
- (void)layoutSubviews {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  UIView *quickActions = MSHookIvar<UIView *>(self, "_quickActionsView");
  if (enabled && isLocked && !disableSlideBar) {
    quickActions.hidden = YES;
    quickActions.alpha = 0;
  } else {
    quickActions.hidden = NO;
    quickActions.alpha = 1;
  }
}
%end

// Hide pill view
%hook CSTeachableMomentsContainerViewController
- (void)viewDidLoad {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  if (enabled && isLocked && !disableSlideBar) {
    self.view.hidden = YES;
    self.view.alpha = 0;
  } else {
    self.view.hidden = NO;
    self.view.alpha = 1;
  }
}
%end

// Move Notifications
%hook NCNotificationListView
- (UIEdgeInsets)adjustedContentInset {
  UIEdgeInsets inset = %orig;
  if (enabled && isLocked && !classicNotifications && !disableTimeBar) {
    inset.top = statusHeight + 100;
  }
  return inset;
}
- (CGPoint)minimumContentOffset {
  CGPoint offset = %orig;
  if (enabled && isLocked && !classicNotifications && !disableTimeBar) {
    offset.y = 0;
  }
  return offset;
}
- (void)layoutSubviews {
  %orig;
  [viewsToLayout addObject:self];
  [self layoutSix];
}
%new
- (void)layoutSix {
  if (enabled && isLocked && classicNotifications) {
    self.hidden = YES;
  } else {
    self.hidden = NO;
  }
}
%end
%end

static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  setIsLocked(true);
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("xyz.skitty.sixls.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, displayStatusChanged, CFSTR("com.apple.iokit.hid.displayStatus"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  refreshPrefs();

  %init;

  if ([[[UIDevice currentDevice] systemVersion] floatValue] < 13.0) {
    %init(iOS12);
    //%init(NCNotificationMasterList = NSClassFromString(@"NCNotificationPriorityList"), CSCoverSheetViewController = NSClassFromString(@"SBDashBoardViewController"), CSPasscodeViewController = NSClassFromString(@"SBDashBoardPasscodeViewController"), CSMainPageView = NSClassFromString(@"SBDashBoardMainPageView"), CSScrollView = NSClassFromString(@"SBPagedScrollView"), CSFixedFooterViewController = NSClassFromString(@"SBDashBoardFixedFooterViewController"), CSTeachableMomentsContainerViewController = NSClassFromString(@"SBDashBoardTeachableMomentsContainerViewController"), NCNotificationListView = NSClassFromString(@"NCNotificationListCollectionView"));
  } else {
    %init(iOS13);
  }
}
