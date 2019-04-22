// Six (LS) Headers
// This is pretty messy, but it works.

#import <AudioToolbox/AudioServices.h>

@interface UIApplication (Private)
+ (id)sharedApplication;
- (id)_mainScene;
- (void)launchApplicationWithIdentifier:(id)arg1 suspended:(bool)arg2;
@end

@interface UIWindow (Private)
+ (void)_setAllWindowsKeepContextInBackground:(bool)arg1;
@end

@interface UIView (Six)
- (void)layoutSix;
@end

@interface AVAudioPlayer : NSObject
@property (nonatomic, assign) int numberOfLoops;
@property (nonatomic, assign) int volume;
- (id)initWithContentsOfURL:(id)arg1 error:(id)arg2;
- (void)play;
@end

@interface SBDashBoardChargingViewController : UIViewController
@end

@interface SBDashBoardModalPresentationViewController : UIViewController
@end

@interface SBDashBoardViewController : UIViewController
@property (assign,getter=isAuthenticated,nonatomic) BOOL authenticated;
@end

@interface SBLockScreenManager : NSObject
@property (nonatomic, readonly) BOOL isUILocked;
+ (id)sharedInstance;
- (void)lockScreenViewControllerRequestsUnlock;
- (void)crashSB;
@end

@interface SBDockView : UIView
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, assign) CGFloat dockHeight;
@end

@interface SBStatusBarLegibilityView : UIView
@property (nonatomic, retain) UIImageView *backgroundImageView;
- (void)layoutSix;
@end

@interface SBFolderIconBackgroundView : UIView
@property (nonatomic, retain) UIImageView *backgroundImageView;
@end

@interface SBIconLegibilityLabelView : UIImageView
@end

@interface UIStatusBar : UIView
@property (nonatomic, retain) UIView *backgroundView;
+ (double)_heightForStyle:(long long)arg1 orientation:(long long)arg2 forStatusBarFrame:(BOOL)arg3 ;
- (BOOL)isDoubleHeight;
- (id)_backgroundView;
- (void)setForegroundColor:(UIColor *)arg1 ;
@end

@interface UIStatusBar_Modern : UIStatusBar
@property (nonatomic,retain) UIStatusBar *statusBar;
- (id)statusBar;
- (CGFloat)defaultHeight;
@end

@interface SBIconImageView : UIView
- (id)contentsImage;
@end

@interface SBRootFolderDockIconListView : UIView
- (CGSize)defaultIconSize;
- (UIInterfaceOrientation)orientation;
- (void)resetupIcons;
- (void)updateReflection;
@end

@interface _UIGlintyStringView : UIView
@property (nonatomic,copy) NSString *text;
- (id)initWithText:(id)arg1 andFont:(id)arg2;
- (void)setChevronStyle:(int)arg1;
- (void)show;
- (void)hide;
@end

@class SIXLockScreenViewController, SIXLockScreenView;

@interface SBDashBoardMainPageView : UIView
@property (nonatomic, retain) UIImageView *wallpaperGradient;
@property (nonatomic, retain) UIView *batteryView;
@property (nonatomic, retain) UIImageView *batteryImage;
@property (nonatomic, retain) SIXLockScreenViewController *sixController;
@property (nonatomic, retain) SIXLockScreenView *sixView;
+ (id)sharedInstance;
- (void)layoutSix;
- (void)updateFrames;
@end

@interface SBFLockScreenDateView : UIView
- (void)layoutSix;
@end

@interface SBDashBoardFixedFooterViewController : UIViewController
- (void)layoutSix;
@end

@interface SBDashBoardFixedFooterView : UIView
- (void)layoutSix;
@end

@interface SBPagedScrollView : UIScrollView
- (void)layoutSix;
-(BOOL)scrollToPageAtIndex:(unsigned long long)arg1 animated:(BOOL)arg2 withCompletion:(/*^block*/id)arg3;
@end

@interface SBDashBoardView : UIView
- (void)layoutSix;
@end

@interface SBUIProudLockIconView : UIView
- (void)layoutSix;
@end

@interface SBUIFaceIDCameraGlyphView : UIView
- (void)layoutSix;
@end

@interface SBCoverSheetSlidingViewController
@property (nonatomic, assign) UIGestureRecognizer *dismissGestureRecognizer;
- (void)layoutSix;
- (UIGestureRecognizer*)dismissGestureRecognizer;
@end

@interface SBDashBoardTeachableMomentsContainerViewController : UIViewController
- (void)layoutSix;
@end

@interface SBFolderBackgroundView: UIView
@end

@interface SBFloatyFolderBackgroundClipView : UIView
@property (nonatomic, assign) CGFloat cornerRadius;
@end

@interface SBLockScreenBatteryChargingView : UIView
@end

@interface _SBLockScreenSingleBatteryChargingView : SBLockScreenBatteryChargingView
@end

@interface SBDeckSwitcherViewController : UIViewController
@end

@protocol FBSceneClientProvider

- (void)endTransaction;
- (void)beginTransaction;

@end


@protocol FBSceneClient

- (void)host:(id)arg1 didUpdateSettings:(id)arg2 withDiff:(id)arg3 transitionContext:(id)arg4 completion:(void (^)(BOOL))arg5;

@end

@interface FBSSceneSettings : NSObject <NSMutableCopying>

@end

@interface FBSMutableSceneSettings : FBSSceneSettings

@property(nonatomic, getter=isBackgrounded) BOOL backgrounded;

@end

@interface FBSSettingsDiff : NSObject
@end

@interface FBSSceneSettingsDiff : FBSSettingsDiff

+ (id)diffFromSettings:(id)arg1 toSettings:(id)arg2;

@end

@interface FBSSystemService : NSObject

+ (id)sharedService;
- (void)openApplication:(id)arg1 options:(id)arg2 withResult:(void (^)(void))arg3;

@end

@interface FBSceneHostWrapperView : UIView
-(id)initWithScene:(id)arg1 requester:(id)arg2 ;
@end

@interface FBSceneHostManager : NSObject
- (void)enableHostingForRequester:(id)arg1 orderFront:(BOOL)arg2;
- (void)enableHostingForRequester:(id)arg1 priority:(int)arg2;
- (void)disableHostingForRequester:(id)arg1;
- (id)_hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)arg2;
@end

@interface FBScene
- (id)clientProvider;
- (id)client;
- (id)settings;
- (FBSceneHostManager *)hostManager;
@end

@interface BKSProcessAssertion
- (id)initWithPID:(int)arg1 flags:(unsigned int)arg2 reason:(unsigned int)arg3 name:(id)arg4 withHandler:(id)arg5;
- (id)initWithBundleIdentifier:(id)arg1 flags:(unsigned int)arg2 reason:(unsigned int)arg3 name:(id)arg4 withHandler:(id)arg5;
- (void)invalidate;
@property(readonly, nonatomic) BOOL valid;
@end

@interface SBApplication : NSObject
@property(readonly, nonatomic) int pid;
-(FBScene*) mainScene;
- (void)activate;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
+ (id)sharedInstanceIfExists;
- (NSArray *)runningApplications;
- (id)applicationWithBundleIdentifier:(NSString *)arg1;
@end

@interface SBFolder : NSObject
@property (nonatomic, retain) NSArray *lists;
@end

@interface SBIcon : NSObject
- (SBFolder *)folder;
- (id)application;
@end

@interface SBIconView : UIView
@property (nonatomic, assign) SBIcon *icon;
@property (nonatomic, retain) UIImageView *reflection;
@property (nonatomic, retain) UIImageView *iconShadow;
@property (nonatomic, assign) NSUInteger contentType;
@property (nonatomic, assign) NSInteger location;
@property (nonatomic, assign) bool labelHidden;
- (void)animateTest;
@end

@interface SBUIController : NSObject
+ (id)sharedInstanceIfExists;
- (NSArray *)runningApplications;
- (void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(long long)arg3 activationSettings:(id)arg4 actions:(id)arg5 ;
- (BOOL)isOnAC;
@end

@interface SBActivationSettings : NSObject
- (id)init;
- (void)setFlag:(long long)arg1 forActivationSetting:(unsigned)arg2 ;
@end

@interface SBIconListView : UIView
-(id)initWithModel:(id)arg1 orientation:(long long)arg2 viewMap:(id)arg3;
@end

@interface SBRootIconListView : SBIconListView
- (void)animateTest;
@end

@interface SBFolderIconListView : SBIconListView
@end

@interface SBIconController : UIViewController
+ (id)sharedInstance;
- (SBRootFolderDockIconListView *)dockListView;
- (id)_rootFolderController;
- (long long)orientation;
- (Class)controllerClassForFolder:(id)arg1;
@end

@interface SBRootFolderController : UIViewController
- (void)setInnerFolderController:(id)arg1;
- (id)viewMap;
@end

@interface SBIconScrollView : UIScrollView
@end

@interface SBFolderController : UIViewController
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) SBIconScrollView *scrollView;
- (id)contentView;
- (id)viewMap;
- (id)initWithFolder:(id)arg1 orientation:(long long)arg2 viewMap:(id)arg3;
- (void)popFolderAnimated:(BOOL)arg1 completion:(id)arg2;
@end

@interface SBFolderView : UIView
@end

@interface SBFolderIcon : SBIcon
@property (nonatomic, retain) UIView *sixFolder;
@end

@interface SBWallpaperEffectView : UIView
@end

@interface SBIconListModel : NSObject
@end

@interface SBFolderContainerView : UIView
- (void)setChildFolderContainerView:(id)arg1;
@end

@interface NCNotificationListCollectionView : UICollectionView
- (void)layoutSix;
@end

@interface SBDashBoardComponent : NSObject
+ (id)pageControl;
- (id)hidden:(bool)arg1;
@end

@interface SBDashBoardAppearance : NSObject
- (void)addComponent:(id)arg1;
@end

@interface NCNotificationContent : NSObject
@property (nonatomic, retain) NSString *header;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) NSDate *date;
@end

@interface NCNotificationActionRunner <NSObject>
-(void)executeAction:(id)arg1 fromOrigin:(id)arg2 withParameters:(id)arg3 completion:(/*^block*/id)arg4;
@end

@interface NCNotificationAction : NSObject
@property (nonatomic,readonly) NCNotificationActionRunner *actionRunner;
@property (nonatomic, copy, readonly) NSURL *launchURL;
@property (nonatomic, copy, readonly) NSString *launchBundleID;
@end

@interface NCNotificationOptions : NSObject
@property (nonatomic, assign) NSUInteger messageNumberOfLines;
@end

@interface NCNotificationRequest : NSObject
@property (nonatomic, retain) NCNotificationContent *content;
@property (nonatomic, retain) NCNotificationOptions *options;
@property (nonatomic,readonly) NCNotificationAction *defaultAction;
@end

@interface NCNotificationPriorityList
@property (nonatomic,readonly) NSArray *allNotificationRequests;
@end

@interface NCNotificationCombinedListViewController : UIViewController
@property (nonatomic, retain) NCNotificationPriorityList *notificationPriorityList;
- (void)layoutSix;
@end
