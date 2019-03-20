#import "Brooch.h"




static NSMutableDictionary *settings;
BOOL enabled = true;
NSString *highlight = @"default";
UIColor *highlightCustomColor = [UIColor redColor];
NSString *highlightCustomColorFallback = @"FF000000";
float highlightCornerRadius = 4;
UIColor *highlightDefaultColor = [UIColor colorWithRed:0.976 green:0.282 blue:0.216 alpha:1.00];

NSString *label = @"default";
UIColor *labelCustomColor = [UIColor whiteColor];
NSString *labelCustomColorFallback = @"FFFFFF";

NSString *border = @"default";
UIColor *borderCustomColor = [UIColor redColor];
NSString *borderCustomColorFallback = @"FF000000";
float borderThickness = 1;
UIColor *borderDefaultColor = [UIColor colorWithRed:0.877 green:0.320 blue:0.254 alpha:1.00];


//Globals
NSInteger labelOffset = 7;
CGFloat labelHeightTransform = 0;
CGFloat dockLabelOffset = 7;

CGFloat labelY = 0;

inline UIColor * getColor(NSString *key,NSString *fallback)
{
     return LCPParseColorString([[NSDictionary dictionaryWithContentsOfFile:kBroochPrefs] objectForKey:key], fallback);
}


void refreshPrefs() {
   settings = nil;
  settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[kBroochPrefs stringByExpandingTildeInPath]];
  if([settings objectForKey:@"highlight"])highlight = [[settings objectForKey:@"highlight"] stringValue];
  if([settings objectForKey:@"highlightCornerRadius"])highlightCornerRadius = [[settings objectForKey:@"highlightCornerRadius"] floatValue];

  if([settings objectForKey:@"label"])label = [[settings objectForKey:@"label"] stringValue];

  if([settings objectForKey:@"border"])border = [[settings objectForKey:@"border"] stringValue];
  if([settings objectForKey:@"borderThickness"])borderThickness = [[settings objectForKey:@"borderThickness"] floatValue];

}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  refreshPrefs();
}



%hook SBIconView
%property (nonatomic,assign) BOOL mdbroochHasNotification;
%property (nonatomic,assign) _UILegibilitySettings* mdbroochDefaultLegibilitySettings;

-(SBMutableIconLabelImageParameters *)_labelImageParameters{
  SBMutableIconLabelImageParameters *orig = %orig;

  if(enabled){
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

      //Hide non badge dock labels
      if ([self.superview isKindOfClass:[objc_getClass("SBRootFolderDockIconListView") class]]){
        [orig setText:@""];
      }
    }
  }

  return orig;
}

-(void)setIcon:(id)arg1{
  %orig;

  if(enabled){
    SBIconImageView *icon = [self _iconImageView];

    //Nasty hack to make sure the label doesnt overlap the icon
    if(labelY == 0)
      labelY = icon.frame.origin.y + icon.frame.size.height + labelOffset;
  }

}


-(void)layoutSubviews{
  %orig;


  if(enabled && self.mdbroochHasNotification){
    if(self.labelView.backgroundColor == nil){
      UIImage *img = [self.icon getIconImage:0];

      //Handle folder view
      if(!img && [self.icon isKindOfClass:[objc_getClass("SBFolderIcon") class]]){
        SBFolderIcon *folder = (SBFolderIcon *)self.icon;
        SBApplicationIcon *icon = [[folder applicationIconsWithBadgesSortedByImportance] objectAtIndex:0];
        img = [icon generateIconImage:0];
      }

      if(([highlight isEqualToString:@"dynamic"] || [label isEqualToString:@"dynamic"] || [border isEqualToString:@"dynamic"])  && img){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
          NSDictionary *colors = [mdauschUtils colorsFromUIImage:img];

          //Default to background color, unless it is white or black
          UIColor *colorToUse = [colors objectForKey:@"bgColor"];
          UIColor *borderColor = [colors objectForKey:@"primaryColor"];
          if([mdauschUtils getColorLuminence:colorToUse] < .2f || [mdauschUtils getColorLuminence:colorToUse] > .8f){
            borderColor = colorToUse;
            colorToUse = [colors objectForKey:@"primaryColor"];
          }

          dispatch_sync(dispatch_get_main_queue(), ^{
            if([highlight isEqualToString:@"dynamic"]){
              self.labelView.backgroundColor = colorToUse;
              self.labelView.layer.cornerRadius = highlightCornerRadius;
            }else if([highlight isEqualToString:@"default"]){
              self.labelView.backgroundColor = highlightDefaultColor;
              self.labelView.layer.cornerRadius = highlightCornerRadius;
            }else if([highlight isEqualToString:@"custom"]){
              self.labelView.backgroundColor = getColor(@"highlightCustomColor",highlightCustomColorFallback);
              self.labelView.layer.cornerRadius = highlightCornerRadius;
            }else{
              self.labelView.backgroundColor = [UIColor clearColor];
              self.labelView.layer.cornerRadius = 0;
            }

            if([label isEqualToString:@"dynamic"]){
              _UILegibilitySettings *legi = [[_UILegibilitySettings alloc]initWithStyle:1
                                       primaryColor: borderColor
                                       secondaryColor:[UIColor colorWithWhite:0.25 alpha:1]
                                       shadowColor:[UIColor colorWithWhite:0.1 alpha:0.23]];
              [self setLegibilitySettings:legi];

            }else if([label isEqualToString:@"default"]){
              if(self.mdbroochDefaultLegibilitySettings)
                [self setLegibilitySettings:self.mdbroochDefaultLegibilitySettings];

            }else if([label isEqualToString:@"custom"]){
              _UILegibilitySettings *legi = [[_UILegibilitySettings alloc]initWithStyle:1
                                       primaryColor: getColor(@"labelCustomColor",labelCustomColorFallback)
                                       secondaryColor:[UIColor colorWithWhite:0.25 alpha:1]
                                       shadowColor:[UIColor colorWithWhite:0.1 alpha:0.23]];
              [self setLegibilitySettings:legi];
            }

            if([border isEqualToString:@"dynamic"]){
              self.labelView.layer.borderWidth = borderThickness;
              self.labelView.layer.borderColor = [borderColor CGColor];
            }else if([border isEqualToString:@"default"]){
              self.labelView.layer.borderWidth = borderThickness;
              self.labelView.layer.borderColor = [borderDefaultColor CGColor];
            }else if([border isEqualToString:@"custom"]){
              self.labelView.layer.borderWidth = borderThickness;
              self.labelView.layer.borderColor = [getColor(@"borderCustomColor",labelCustomColorFallback) CGColor];
            }else{
              self.labelView.layer.borderWidth = 0;
              self.labelView.layer.borderColor = [[UIColor clearColor] CGColor];
            }
          });
        });
      }else{
       if([highlight isEqualToString:@"default"]){
          self.labelView.backgroundColor = highlightDefaultColor;
          self.labelView.layer.cornerRadius = highlightCornerRadius;
        }else if([highlight isEqualToString:@"custom"]){
          self.labelView.backgroundColor = getColor(@"highlightCustomColor",highlightCustomColorFallback);
          self.labelView.layer.cornerRadius = highlightCornerRadius;
        }else{
          self.labelView.backgroundColor = nil;
          self.labelView.layer.cornerRadius = 0;
        }

        if([label isEqualToString:@"default"]){
          _UILegibilitySettings *legi = [[_UILegibilitySettings alloc]initWithStyle:1
                                   primaryColor: [UIColor whiteColor]
                                   secondaryColor:[UIColor colorWithWhite:0.25 alpha:1]
                                   shadowColor:[UIColor colorWithWhite:0.1 alpha:0.23]];
          [self setLegibilitySettings:legi];

        }else if([label isEqualToString:@"custom"]){
          _UILegibilitySettings *legi = [[_UILegibilitySettings alloc]initWithStyle:1
                                   primaryColor: getColor(@"labelCustomColor",labelCustomColorFallback)
                                   secondaryColor:[UIColor colorWithWhite:0.25 alpha:1]
                                   shadowColor:[UIColor colorWithWhite:0.1 alpha:0.23]];
          [self setLegibilitySettings:legi];
        }

        if([border isEqualToString:@"default"]){
          self.labelView.layer.borderWidth = borderThickness;
          self.labelView.layer.borderColor = [borderDefaultColor CGColor];
        }else if([border isEqualToString:@"custom"]){
          self.labelView.layer.borderWidth = borderThickness;
          self.labelView.layer.borderColor = [getColor(@"borderCustomColor",labelCustomColorFallback) CGColor];
        }else{
          self.labelView.layer.borderWidth = 0;
          self.labelView.layer.borderColor = [[UIColor clearColor] CGColor];
        }
      }
    }
  }else{
    self.labelView.backgroundColor = nil;
    self.labelView.layer.borderColor = [[UIColor clearColor] CGColor];
    self.labelView.layer.borderWidth = 0;
    if(self.mdbroochDefaultLegibilitySettings)
      [self setLegibilitySettings:self.mdbroochDefaultLegibilitySettings];
  }
}

-(void)setLegibilitySettings:(_UILegibilitySettings *)arg1 {

  //Store old legibility settings, and then never touch it again
  if(!self.mdbroochDefaultLegibilitySettings && arg1)
    self.mdbroochDefaultLegibilitySettings = arg1;

  %orig;


}

//Enable dock label
-(void)setContentType:(NSInteger)arg1{
  if(enabled)
    %orig(0);
  else
    %orig();
}
%end

%hook SBIconParallaxBadgeView
-(void)layoutSubviews{
  %orig;
  if(enabled){
    self.alpha = 0;
    self.hidden = true;
  }
}
-(void)_applyParalaxSettings{
  %orig;
  if(enabled){
    self.alpha = 0;
    self.hidden = true;
  }
}
%end

%hook SBIconBadgeView
-(void)didMoveToSuperview {
  %orig;
  if(enabled){
    if ([self.superview isKindOfClass:[objc_getClass("SBIconView") class]]){
      self.hidden = true;
    }else{
      //Make sure to unhide if this is not the case, as badge reuse can be tricky
      self.hidden = false;
    }
  }
}
%end


%hook SBIconLegibilityLabelView
- (CGRect)frame {
  CGRect orig = %orig;

  if(enabled){
    //TODO Dock adjustment pref
    if ([self.superview.superview isKindOfClass:[objc_getClass("SBRootFolderDockIconListView") class]]){
      orig.origin.y = labelY + 5;
    }else{
      orig.origin.y = labelY;
    }

    //Fixes snowboards sizing issue on labels
    if(labelHeightTransform == 0)
      labelHeightTransform = orig.size.height * self.transform.a;
    orig.size.height = labelHeightTransform;
    return orig;
  }
  return orig;
}

- (void)setFrame:(CGRect)frame {
  if(enabled){
    //TODO Dock adjustment pref
    if ([self.superview.superview isKindOfClass:[objc_getClass("SBRootFolderDockIconListView") class]]){
      frame.origin.y = labelY + dockLabelOffset;
    }else{
      frame.origin.y = labelY;
    }

    //Fixes snowboards sizing issue on labels
    if(labelHeightTransform == 0)
      labelHeightTransform = frame.size.height * self.transform.a;
    frame.size.height = labelHeightTransform;
  }

  %orig;
}

- (id)initWithFrame:(CGRect)frame {
  if(enabled){
    //TODO Dock adjustment pref
    if ([self.superview.superview isKindOfClass:[objc_getClass("SBRootFolderDockIconListView") class]]){
      frame.origin.y = labelY + dockLabelOffset;
    }else{
      frame.origin.y = labelY;
    }

    //Fixes snowboards sizing issue on labels
    if(labelHeightTransform == 0)
      labelHeightTransform = frame.size.height * self.transform.a;
    frame.size.height = labelHeightTransform;
  }

  self = %orig;
  return self;
}

-(void)layoutSubviews{
  %orig;
  if(enabled){
    //Fixes snowboards sizing issue on labels
    self.transform = CGAffineTransformMakeScale(1,1);
  }
}
%end


%ctor
{
 @autoreleasepool {
   settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[kBroochPrefs stringByExpandingTildeInPath]];
   CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("ch.mdaus.brooch.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
   refreshPrefs();
 }
}
