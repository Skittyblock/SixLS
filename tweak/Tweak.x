// Six (LS), by Skitty
// iOS 6 Style Lock Screen for iOS 11-14

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <CoverSheet/CoverSheet.h>
#import <UserNotificationsKit/UserNotificationsKit.h>
#import <SpringBoardFoundation/SBFLockScreenDateViewController.h>
#import "Headers/SpringBoard/SpringBoard.h"
#import "SixLSManager.h"
#import "SixLS-Swift.h"

// Settings
static NSMutableDictionary *settings;
static BOOL enabled;

static BOOL disableHome;
static NSString *slideText;
static BOOL chargeView;
static BOOL wallpaperGradient;
static BOOL militaryTime;
static BOOL classicNotifications;
static BOOL lockSound;
static BOOL unlockSound;
static BOOL chargeSound;
static BOOL disableTimeBar;
static BOOL disableSlideBar;

static BOOL isLocked = YES;
static BOOL unlockAllowed = NO;

static NSMutableArray *objectsToUpdate;
static CSMainPageContentViewController *mainPageController;

// Preference updates
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
	classicNotifications = [([settings objectForKey:@"classicNotifications"] ?: @(YES)) boolValue];
	lockSound = [([settings objectForKey:@"lockSound"] ?: @(YES)) boolValue];
	unlockSound = [([settings objectForKey:@"unlockSound"] ?: @(YES)) boolValue];
	chargeSound = [([settings objectForKey:@"chargeSound"] ?: @(YES)) boolValue];
	disableTimeBar = [([settings objectForKey:@"disableTimeBar"] ?: @(NO)) boolValue];
	disableSlideBar = [([settings objectForKey:@"disableSlideBar"] ?: @(NO)) boolValue];

	if ([slideText isEqualToString:@""]) slideText = @"slide to unlock";

	[SixLSManager sharedInstance].militaryTime = militaryTime;
	[SixLSManager sharedInstance].disableDateBar = disableTimeBar;
	[SixLSManager sharedInstance].disableLockBar = disableSlideBar;
	[SixLSManager sharedInstance].disableWallpaperShadow = !wallpaperGradient;
	[SixLSManager sharedInstance].disableChargingView = !chargeView;
	[SixLSManager sharedInstance].disableClassicNotifications = !classicNotifications;
	[SixLSManager sharedInstance].unlockText = slideText;

	[[NSNotificationCenter defaultCenter] postNotificationName:@"observePreferences" object:nil];

	if (!objectsToUpdate) objectsToUpdate = [NSMutableArray new];
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	refreshPrefs();
}

static void setIsLocked(BOOL locked) {
	isLocked = locked;
	unlockAllowed = NO;
	for (NSObject *object in objectsToUpdate) {
		if ([object respondsToSelector:@selector(layoutSix)]) {
			[(CSMainPageContentViewController *)object layoutSix];
		}
	}
}

// Add Six view to lock screen
%hook CSMainPageContentViewController // SBDashBoardMainPageContentViewController
%property (nonatomic, retain) LockScreenView *sixView;

- (void)viewDidLoad {
	%orig;

	CSMainPageContentViewController *telf = self; // we love telf (typed self)!

	mainPageController = self;

	telf.sixView = [[LockScreenView alloc] initWithFrame:telf.view.bounds];
	telf.sixView.translatesAutoresizingMaskIntoConstraints = NO;
	[telf.view addSubview:telf.sixView];

	[telf.sixView.widthAnchor constraintEqualToAnchor:telf.view.widthAnchor].active = YES;
	[telf.sixView.heightAnchor constraintEqualToAnchor:telf.view.heightAnchor].active = YES;

	[objectsToUpdate addObject:self];
	[self layoutSix];
}

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	[self layoutSix];
}

%new
- (void)layoutSix {
	CSMainPageContentViewController *telf = self;
	if (telf.sixView) {
		telf.sixView.notifications = telf.sixView.notificationList.allNotificationRequests;
		[telf.view bringSubviewToFront:telf.sixView];
		if (enabled && isLocked) {
			[mainPageController.sixView present];
			telf.sixView.hidden = NO;
		} else {
			telf.sixView.hidden = YES;
		}
	}
}

%end

// Unlock Sound
%hook SBCoverSheetPrimarySlidingViewController

- (void)viewWillDisappear:(BOOL)arg1 {
	%orig;
	if (enabled && unlockSound && mainPageController.sixView.alpha == 1) {
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

// iOS 10 - 12
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

// iOS 13 - 14
- (void)playChargingChimeIfAppropriate {
	if (enabled && chargeSound && [self _powerSourceWantsToPlayChime]) {
		SystemSoundID sound = 0;
		AudioServicesDisposeSystemSoundID(sound);
		AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain([NSURL fileURLWithPath:@"/Library/Application Support/Six/connect_power.caf"]), &sound);
		AudioServicesPlaySystemSound((SystemSoundID)sound);
	} else {
		%orig;
	}
}

%end

%hook CSPasscodeViewController // SBDashBoardPasscodeViewController

- (void)viewWillDisappear:(BOOL)arg1 {
	%orig;
	if (enabled) {
		unlockAllowed = NO;
		[mainPageController.sixView presentAnimated];
	}
}

%end

// Allow unlock after sliding
%hook SBLockScreenManager

- (void)lockScreenViewControllerRequestsUnlock {
	unlockAllowed = YES;

	// unlock sound
	if (enabled && unlockSound) {
		SystemSoundID sound = 0;
		AudioServicesDisposeSystemSoundID(sound);
		AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain([NSURL fileURLWithPath:@"/Library/Application Support/Six/unlock.caf"]), &sound);
		AudioServicesPlaySystemSound((SystemSoundID)sound);
	}

	%orig;
}

%end

// Disable Lock Screen Page Scrolling
%hook CSCoverSheetViewController // SBDashBoardViewController

- (void)viewDidLoad {
	%orig;
	[objectsToUpdate addObject:self];
	[self layoutSix];
}

- (void)viewWillAppear:(BOOL)arg1 {
	%orig;
	CSCoverSheetViewController *telf = self;
	setIsLocked(!telf.authenticated);
}

- (void)_transitionChargingViewToVisible:(BOOL)arg1 showBattery:(BOOL)arg2 animated:(BOOL)arg3 {
	if (enabled && chargeView) {
		[mainPageController.sixView updateChargingState];
	} else {
		%orig;
	}
}

%new
- (void)layoutSix {
	CSCoverSheetViewController *telf = self;
	[SixLSManager sharedInstance].csScrollView = telf.view.scrollView;
	if (enabled && isLocked && !disableSlideBar) {
		telf.view.scrollView.scrollEnabled = NO;
	} else {
		telf.view.scrollView.scrollEnabled = YES;
	}
}

%end

// Hide home bar, unlock text, page dots, etc.
%hook CSFixedFooterViewController // SBDashBoardFixedFooterViewController

- (void)viewDidLoad {
	%orig;
	[objectsToUpdate addObject:self];
	[self layoutSix];
}

%new
- (void)layoutSix {
	CSFixedFooterViewController *telf = self;
	if (enabled && isLocked && !disableSlideBar) {
		telf.view.hidden = YES;
	} else {
		telf.view.hidden = NO;
	}
}

%end

// Hide time/date view
%hook SBFLockScreenDateViewController // SBLockScreenDateViewController

- (void)viewDidLoad {
	%orig;
	[objectsToUpdate addObject:self];
	[self layoutSix];
}

%new
- (void)layoutSix {
	SBFLockScreenDateViewController *telf = self;
	if (enabled && isLocked && !disableTimeBar) {
		telf.view.hidden = YES;
	} else {
		telf.view.hidden = NO;
	}
}

%end

// Disable home button to unlock
%hook SBCoverSheetSlidingViewController

// iOS 14
- (void)setPresented:(BOOL)presented forUserGesture:(BOOL)gesture animated:(BOOL)animated withCompletion:(id)completion {
	if (enabled && isLocked && disableHome && !presented && !unlockAllowed) {
		return;
	}
	%orig;
}

// iOS 11 - 13
- (void)setPresented:(BOOL)presented animated:(BOOL)animated withCompletion:(id)completion {
	if (enabled && isLocked && disableHome && !presented && !unlockAllowed) {
		return;
	}
	%orig;
}

%end

// Hide charging view
%hook CSModalPresentationViewController // SBDashBoardModalPresentationViewController

- (void)presentContentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(id)completion {
	for (UIView *view in viewController.view.subviews) {
		if ([view isKindOfClass:%c(SBLockScreenBatteryChargingView)] ||
			[view isKindOfClass:%c(_SBLockScreenSingleBatteryChargingView)] ||
			[view isKindOfClass:%c(CSBatteryChargingView)] || 
			[view isKindOfClass:%c(_CSSingleBatteryChargingView)]) {
			if (chargeView) {
				return [mainPageController.sixView updateChargingState];
	  		} else {
				return %orig;
	  		}
		}
  	}
  	if (enabled && isLocked && disableHome && !unlockAllowed) {
		return;
  	}
  	%orig;
}

%end

// Hide notifications
%hook NCNotificationStructuredListViewController // NCNotificationListViewController

- (void)viewDidLoad {
	%orig;
	[objectsToUpdate addObject:self];
	[self layoutSix];
}

%new
- (void)layoutSix {
	NCNotificationStructuredListViewController *telf = self;
	if (enabled && isLocked && classicNotifications) {
		telf.view.hidden = YES;
	} else {
		telf.view.hidden = NO;
	}
}

%end

// Notifications
%hook NCNotificationDispatcher

- (void)destination:(id)destination executeAction:(id)action forNotificationRequest:(id)request requestAuthentication:(bool)requestAuth withParameters:(id)parameters completion:(id)completion {
	%orig;
	[mainPageController.sixView removeNotification:request];
}

%end

%hook NCNotificationMasterList // NCNotificationPriorityList

- (int)insertNotificationRequest:(NCNotificationRequest *)request {
	int result = %orig;

	NCNotificationMasterList *telf = self;

	if ([self respondsToSelector:@selector(incomingSectionList)]) {
		mainPageController.sixView.notificationList = telf.incomingSectionList;
	} else if ([self respondsToSelector:@selector(allNotificationRequests)]) {
		mainPageController.sixView.notifications = [self allNotificationRequests];
	}

	return result;
}

%end

// Fix disable home with notification sliders
%hook SixLSNotificationAlertView

- (void)sliderStopped:(UISlider *)slider {
	if (slider.value == 1) {
		unlockAllowed = YES;
	}
	%orig;
}

%end

%hook SixLSNotificationCell

- (void)sliderStopped:(UISlider *)slider {
	if (slider.value == 1) {
		unlockAllowed = YES;
	}
	%orig;
}

%end

// Notched device hooks
%group Notched

// Hide big lock icon
%hook SBUIProudLockIconView

- (void)layoutSubviews {
	%orig;
	[objectsToUpdate addObject:self];
	[self layoutSix];
}

%new
- (void)layoutSix {
	if (enabled && isLocked && !disableTimeBar) {
		self.hidden = YES;
	} else {
		self.hidden = NO;
	}
}

%end

// Hide face id glyph
%hook SBUIFaceIDCameraGlyphView

- (void)layoutSubviews {
	%orig;
	[objectsToUpdate addObject:self];
	[self layoutSix];
}

%new
- (void)layoutSix {
	if (enabled && isLocked && !disableTimeBar) {
		self.hidden = YES;
	} else {
		self.hidden = NO;
	}
}

%end

// Hide quick actions
%hook CSCoverSheetViewController // SBDashBoardViewController

- (void)layoutSix {
	%orig;
	CSCoverSheetViewController *telf = self;
	UIView *quickActions = [telf.view valueForKey:@"_quickActionsView"];
	if (enabled && isLocked && !disableSlideBar) {
		quickActions.hidden = YES;
	} else {
		quickActions.hidden = NO;
	}
}

%end

// Hide pill and swipe up to unlock text
%hook CSTeachableMomentsContainerViewController // SBTeachableMomentsContainerViewController

- (void)viewDidLoad {
	%orig;
	[objectsToUpdate addObject:self];
	[self layoutSix];
}

%new
- (void)layoutSix {
	CSTeachableMomentsContainerViewController *telf = self;
	if (enabled && isLocked && !disableSlideBar) {
		telf.view.hidden = YES;
	} else {
		telf.view.hidden = NO;
	}
}

%end

// Disable swipe to unlock gesture
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

- (void)_handleDismissGesture:(id)gesture {
	if (enabled && isLocked && !disableSlideBar) {
		return;
	}
	%orig;
}

%end

%end

static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	setIsLocked(YES);
}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("xyz.skitty.sixls.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, displayStatusChanged, CFSTR("com.apple.iokit.hid.displayStatus"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

	refreshPrefs();

	// swap version-specific classes
	// logos should probably make this easier
	BOOL isLegacy = [[[UIDevice currentDevice] systemVersion] floatValue] < 13.0;

	NSString *CSCoverSheetViewController = isLegacy ? @"SBDashBoardViewController" : @"CSCoverSheetViewController";
	NSString *CSMainPageContentViewController = isLegacy ? @"SBDashBoardMainPageContentViewController" : @"CSMainPageContentViewController";
	NSString *CSPasscodeViewController = isLegacy ? @"SBDashBoardPasscodeViewController" : @"CSPasscodeViewController";
	NSString *CSFixedFooterViewController = isLegacy ? @"SBDashBoardFixedFooterViewController" : @"CSFixedFooterViewController";
	NSString *SBFLockScreenDateViewController = isLegacy ? @"SBLockScreenDateViewController" : @"SBFLockScreenDateViewController";
	NSString *CSModalPresentationViewController = isLegacy ? @"SBDashBoardModalPresentationViewController" : @"CSModalPresentationViewController";
	NSString *NCNotificationStructuredListViewController = isLegacy ? @"NCNotificationListViewController" : @"NCNotificationStructuredListViewController";
	NSString *NCNotificationMasterList = isLegacy ? @"NCNotificationPriorityList" : @"NCNotificationMasterList";

	NSString *SixLSNotificationAlertView = @"SixLS.NotificationAlertView";
	NSString *SixLSNotificationCell = @"SixLS.NotificationCell";

	NSString *CSTeachableMomentsContainerViewController = isLegacy ? @"SBTeachableMomentsContainerViewController" : @"CSTeachableMomentsContainerViewController";

	%init(CSCoverSheetViewController=NSClassFromString(CSCoverSheetViewController), CSMainPageContentViewController=NSClassFromString(CSMainPageContentViewController), CSPasscodeViewController=NSClassFromString(CSPasscodeViewController), CSFixedFooterViewController=NSClassFromString(CSFixedFooterViewController), SBFLockScreenDateViewController=NSClassFromString(SBFLockScreenDateViewController), CSModalPresentationViewController=NSClassFromString(CSModalPresentationViewController), NCNotificationStructuredListViewController=NSClassFromString(NCNotificationStructuredListViewController), NCNotificationMasterList=NSClassFromString(NCNotificationMasterList), SixLSNotificationAlertView=NSClassFromString(SixLSNotificationAlertView), SixLSNotificationCell=NSClassFromString(SixLSNotificationCell));
	%init(Notched, CSCoverSheetViewController=NSClassFromString(CSCoverSheetViewController), CSTeachableMomentsContainerViewController=NSClassFromString(CSTeachableMomentsContainerViewController));
}
