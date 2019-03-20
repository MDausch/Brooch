#include "MDBroochRootListController.h"

@implementation MDBroochRootListController
-(id)init
{
  self = [super init];

  if(self){
    UIBarButtonItem *respringButton = [[UIBarButtonItem alloc]
                               initWithTitle:@"Respring"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(respring:)];
    self.navigationItem.rightBarButtonItem = respringButton;
    [respringButton release];
  }
  return self;
}


- (id)specifiers
{
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"MDBroochMain" target:self] retain];
    }
    return _specifiers;
}
-(id)readPreferenceValue:(PSSpecifier *)specifier {
    NSDictionary *POSettings = [NSDictionary dictionaryWithContentsOfFile:kBroochPrefs];

    if(!POSettings[specifier.properties[@"key"]]) {
        return specifier.properties[@"default"];
    }
    return POSettings[specifier.properties[@"key"]];
}


-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*) specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kBroochPrefs]];
    [defaults setObject:value forKey:specifier.properties[@"key"]];
    [defaults writeToFile:kBroochPrefs atomically:YES];
    CFStringRef CPPost = (CFStringRef)CFBridgingRetain(specifier.properties[@"PostNotification"]);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CPPost, NULL, NULL, YES);
}

-(void)respring:(id)sender
{
    pid_t respringID;
    char *argv[] = {"/usr/bin/killall", "backboardd", NULL};
    posix_spawn(&respringID, argv[0], NULL, NULL, argv, NULL);
    waitpid(respringID, NULL, WEXITED);
}


-(void)goToTwitter
{
    NSString *user = @"m_dausch";
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];

}
@end


@implementation MDBroochSegmentCell
-(id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 { //init method
 self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:arg2 specifier:arg3]; //call the super init method
 if (self) {
   [((UISegmentedControl *)[self control]) setTintColor:[UIColor colorWithRed:(135/255.0) green:(70/255.0) blue:(213/255.0) alpha:1.0]]; //change the switch color
 }
 return self;
}
@end
