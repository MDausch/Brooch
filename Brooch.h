#import <libmdauschutils.h>
#import <UIKit/_UILegibilitySettings.h>
#import <Foundation/Foundation.h>
#import <UIKit/UiKit.h>
#import <objc/runtime.h>

@interface _UILegibilityView : UIView
@end



@interface SBIconLabelImageParameters : NSObject
@property (nonatomic,copy,readonly) NSString * text;                                   //@synthesize text=_text - In the implementation block
@property (nonatomic,readonly) CGSize maxSize;                                         //@synthesize maxSize=_maxSize - In the implementation block
@property (nonatomic,readonly) UIFont * font;                                          //@synthesize font=_font - In the implementation block
@property (nonatomic,readonly) double scale;                                           //@synthesize scale=_scale - In the implementation block
@property (nonatomic,readonly) BOOL canEllipsize;                                      //@synthesize canEllipsize=_canEllipsize - In the implementation block
@property (nonatomic,readonly) BOOL canTighten;                                        //@synthesize canTighten=_canTighten - In the implementation block
@property (nonatomic,readonly) BOOL containsEmoji;                                     //@synthesize containsEmoji=_containsEmoji - In the implementation block
@property (nonatomic,readonly) BOOL canUseMemoryPool;                                  //@synthesize canUseMemoryPool=_canUseMemoryPool - In the implementation block
@property (nonatomic,readonly) long long style;                                        //@synthesize style=_style - In the implementation block
@property (nonatomic,readonly) UIColor * textColor;                                    //@synthesize textColor=_textColor - In the implementation block
@property (nonatomic,readonly) BOOL accessibilityIncreaseContrastEnabled;              //@synthesize accessibilityIncreaseContrastEnabled=_accessibilityIncreaseContrastEnabled - In the implementation block
@property (nonatomic,readonly) UIColor * focusHighlightColor;                          //@synthesize focusHighlightColor=_focusHighlightColor - In the implementation block
@property (nonatomic,readonly) UIEdgeInsets textInsets;                                //@synthesize textInsets=_textInsets - In the implementation block
@property (nonatomic,readonly) UIEdgeInsets fontLanguageInsets;                        //@synthesize fontLanguageInsets=_fontLanguageInsets - In the implementation block
@property (nonatomic,readonly) long long iconLocation;                                 //@synthesize iconLocation=_iconLocation - In the implementation block
@end



@interface SBMutableIconLabelImageParameters : SBIconLabelImageParameters

@property (nonatomic,copy) NSString * text;
@property (assign,nonatomic) CGSize maxSize;
@property (nonatomic,retain) UIFont * font;
@property (assign,nonatomic) double scale;
@property (assign,nonatomic) BOOL containsEmoji;
@property (assign,nonatomic) BOOL canEllipsize;
@property (assign,nonatomic) BOOL canTighten;
@property (assign,nonatomic) BOOL canUseMemoryPool;
@property (assign,nonatomic) long long style;
@property (nonatomic,retain) UIColor * textColor;
@property (assign,nonatomic) BOOL accessibilityIncreaseContrastEnabled;
@property (nonatomic,retain) UIColor * focusHighlightColor;
@property (assign,nonatomic) UIEdgeInsets textInsets;
@property (assign,nonatomic) UIEdgeInsets fontLanguageInsets;
@property (assign,nonatomic) long long iconLocation;
-(void)setAccessibilityIncreaseContrastEnabled:(BOOL)arg1 ;
-(void)setCanEllipsize:(BOOL)arg1 ;
-(void)setCanTighten:(BOOL)arg1 ;
-(void)setContainsEmoji:(BOOL)arg1 ;
-(void)setCanUseMemoryPool:(BOOL)arg1 ;
-(void)setFocusHighlightColor:(UIColor *)arg1 ;
-(void)setFontLanguageInsets:(UIEdgeInsets)arg1 ;
-(void)setIconLocation:(long long)arg1 ;
-(void)setTextInsets:(UIEdgeInsets)arg1 ;
-(id)copy;
-(void)setText:(NSString *)arg1 ;
-(void)setFont:(UIFont *)arg1 ;
-(void)setStyle:(long long)arg1 ;
-(void)setTextColor:(UIColor *)arg1 ;
-(void)setScale:(double)arg1 ;
-(void)setMaxSize:(CGSize)arg1 ;
@end

@interface SBIconLegibilityLabelView : _UILegibilityView
-(void)setImageParameters:(SBIconLabelImageParameters *)arg1 ;
-(id)initWithSettings:(_UILegibilitySettings *)arg1 ;
-(void)updateIconLabelWithSettings:(id)arg1 imageParameters:(id)arg2 ;
@end


@interface SBIcon : NSObject
-(id)badgeNumberOrString;
-(id)getIconImage:(int)arg1 ;
@end

@interface SBIconImageView : UIImageView
@end

@interface SBIconView : UIView
@property (nonatomic,retain) UIView * labelView;
@property (nonatomic,retain) SBIcon * icon;
@property (nonatomic,assign) BOOL mdbroochHasNotification;
@property (nonatomic,retain) _UILegibilitySettings * legibilitySettings;
@property (nonatomic,assign) _UILegibilitySettings* mdbroochDefaultLegibilitySettings;

-(SBIconImageView *)_iconImageView;
-(id)_labelImageParameters;
-(void)_updateLabel;
-(void)setLegibilitySettings:(_UILegibilitySettings *)arg1;
@end
