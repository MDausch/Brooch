#import "Brooch.h"

NSInteger labelOffset = 7;
CGFloat labelY = 0;

%hook SBIconView
%property (nonatomic,assign) BOOL mdbroochHasNotification;
%property (nonatomic,assign) UIColor* mdbroochTextColor;

-(SBMutableIconLabelImageParameters *)_labelImageParameters{
  SBMutableIconLabelImageParameters *orig = %orig;

  id badgeStuff = [self.icon badgeNumberOrString];
  if(badgeStuff){
    if([badgeStuff isKindOfClass:[NSString class]])
      [orig setText:[NSString stringWithFormat:@" %@ ", badgeStuff]];
    else
      [orig setText:[NSString stringWithFormat:@" %ld ", (long)[badgeStuff integerValue]]];
    self.mdbroochHasNotification = true;

  }else{
    //TODO hide label here if the user doesn't want it
    self.mdbroochHasNotification = false;
  }

  return orig;
}

-(void)setIcon:(id)arg1{
  %orig;

  SBIconImageView *icon = [self _iconImageView];

  //Nasty hack to make sure the label doesnt overlap the icon
  if(labelY == 0)
    labelY = icon.frame.origin.y + icon.frame.size.height + labelOffset;
}

-(void)layoutSubviews{
  %orig;

  if(self.mdbroochHasNotification){
    UIImage *img = [self.icon getIconImage:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{


      if(img){
        NSDictionary *colors = [mdauschUtils colorsFromUIImage:img];

        //Default to background color, unless it is white or black
        UIColor *colorToUse = [colors objectForKey:@"bgColor"];
        UIColor *borderColor = [colors objectForKey:@"primaryColor"];
        if([mdauschUtils getColorLuminence:colorToUse] < .2f || [mdauschUtils getColorLuminence:colorToUse] > .8f){
          borderColor = colorToUse;
          colorToUse = [colors objectForKey:@"primaryColor"];
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
          self.labelView.backgroundColor = colorToUse;
          self.labelView.layer.cornerRadius = 4;
          self.labelView.layer.borderColor = [borderColor CGColor];
          self.labelView.layer.borderWidth = 1;
          self.mdbroochTextColor = borderColor;
          SBMutableIconLabelImageParameters *orig = [self _labelImageParameters];
          [orig setTextColor:[UIColor redColor]];
          [self _updateLabel];
        });
        SBMutableIconLabelImageParameters *orig = [self _labelImageParameters];
        [orig setTextColor:[UIColor redColor]];
        [self _updateLabel];

      }
    });
  }else{
    self.labelView.backgroundColor = [UIColor clearColor];
    self.labelView.layer.borderColor = [[UIColor clearColor] CGColor];
    self.labelView.layer.borderWidth = 0;
  }
}

//Enable dock label
-(void)setContentType:(NSInteger)arg1{
  %orig(0);
}
%end

@interface SBIconParallaxBadgeView : UIView
@end

@interface SBIconBadgeView : UIView
@end

%hook SBIconParallaxBadgeView
-(void)layoutSubviews{
  %orig;
  self.alpha = 0;
  self.hidden = true;
}
-(void)_applyParalaxSettings{
  %orig;
  self.alpha = 0;
  self.hidden = true;

}
%end

%hook SBIconBadgeView
-(SBIconBadgeView *)init{
  SBIconBadgeView *orig = %orig;
  /* orig.hidden = true; */
  return orig;
}
-(void)didMoveToSuperview {
  %orig;

  if ([self.superview isKindOfClass:[objc_getClass("SBIconView") class]]){
    self.hidden = true;
  }else{
    //Make sure to unhide if this is not the case, as badge reuse can be tricky
    self.hidden = false;
  }

}

%end

%hook SBIconLegibilityLabelView
- (CGRect)frame {
    CGRect orig = %orig;
    orig.origin.y = labelY;
    return orig;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y = labelY;
    %orig;
}

- (id)initWithFrame:(CGRect)frame {
    frame.origin.y = labelY;
    self = %orig;

    return self;
}
%end
