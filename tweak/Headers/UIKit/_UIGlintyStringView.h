@interface _UIGlintyStringView : UIView
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIFont *font;
- (id)initWithText:(NSString *)text andFont:(UIFont *)font;
- (void)setChevronStyle:(int)style;
- (void)show;
- (void)hide;
- (void)updateText;
@end
