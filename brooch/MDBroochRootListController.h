#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#include <CoreFoundation/CoreFoundation.h>
#include <spawn.h>
#define kBroochPrefs @"/var/mobile/Library/Preferences/ch.mdaus.brooch.plist"


@interface MDBroochRootListController : PSListController

@end


@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(PSSpecifier *)specifier;
- (CGFloat)preferredHeightForWidth:(CGFloat)width;
@end

@interface PSControlTableCell : PSTableCell
	-(UIControl *)control;
@end


@interface PSSegmentTableCell : PSControlTableCell
	-(id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 ;
  - (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier;
  - (CGFloat)preferredHeightForWidth:(CGFloat)width;

@end

@interface MDBroochSegmentCell : PSSegmentTableCell
@end
