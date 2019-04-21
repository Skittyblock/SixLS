#include "SIXRootListController.h"

#define kTintColor [UIColor colorWithRed:0.81 green:0.36 blue:0.38 alpha:1.0]

@interface SIXHeader : UITableViewCell {
  UILabel *label;
  UILabel *underLabel;
}
@end

@implementation SIXHeader
- (id)initWithSpecifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
  if (self) {
    #define kWidth [[UIApplication sharedApplication] keyWindow].frame.size.width
    NSArray *subtitles = [NSArray arrayWithObjects:@"The iOS 6 Lock Screen", @"By Skitty", @"Free and Open-Source!", nil];

    CGRect labelFrame = CGRectMake(0, -15, kWidth, 80);
    CGRect underLabelFrame = CGRectMake(0, 35, kWidth, 60);

    label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setNumberOfLines:1];
    label.font = [UIFont systemFontOfSize:50];
    [label setText:@"Six (LS)"];
    label.textColor = kTintColor;
    label.textAlignment = NSTextAlignmentCenter;

    underLabel = [[UILabel alloc] initWithFrame:underLabelFrame];
    [underLabel setNumberOfLines:1];
    underLabel.font = [UIFont systemFontOfSize:20];
    uint32_t rnd = arc4random_uniform([subtitles count]);
    [underLabel setText:[subtitles objectAtIndex:rnd]];
    underLabel.textColor = [UIColor grayColor];
    underLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:label];
    [self addSubview:underLabel];
  }
  return self;
}
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
  CGFloat prefHeight = 75.0;
  return prefHeight;
}
@end

@implementation SIXRootListController
- (id)init {
  self = [super init];

  if (self) {
    UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
    self.navigationItem.rightBarButtonItem = respringButton;

    // Ha! Who needs libcephei? Not me.
    // BUG: changes the whole settings tint color
  }

  return self;
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
  self.view.tintColor = kTintColor;
  keyWindow.tintColor = kTintColor;
  [UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]].onTintColor = kTintColor;
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
  keyWindow.tintColor = nil;
}
- (NSArray *)specifiers {
  if (!_specifiers) {
    _specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
  }

  return _specifiers;
}
- (void)respring {
  NSTask *task = [[[NSTask alloc] init] autorelease];
  [task setLaunchPath:@"/usr/bin/killall"];
  [task setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
  [task launch];
}
@end
