//Apple
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//iOSOpenDev
#import <rocketbootstrap/rocketbootstrap.h>

//Project
#import "FCChatHeadsController.h"
#import "MHWindowManager.h"
#import "ChatHeadsMessagingServer.h"
#import "MHWindow.h"
#import "interfaces.h"
#import "FCChatHeadsController.h"
#import "ContextInterfaces.h"

#define tweakName @"ChatHeads"
#define SETTINGS        [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@", @"com.c1d3r.ChatHeadsSettings.plist"]]



#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


static NSDictionary *settings;
static SBUserNotificationAlert *startupAlert;
static SBUserNotificationAlert *pirateAlert;

static MHWindow *window;
static MHViewController *vc;


/////////////////
// Springboard //
/////////////////

//%group SB
%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)arg1{
    %orig();

    //write the file
    if (![[NSFileManager defaultManager] fileExistsAtPath:[MHWindow settingsPath]])
    {
        NSLog(@"[MH] Thanks for installing ChatHeads, hold tight while we get setup! !");
        [@{} writeToFile:[MHWindow settingsPath] atomically:NO];

        NSMutableDictionary *settings = [MHWindow settings];
        [settings writeToFile:[MHWindow settingsPath] atomically:YES];
    }

    settings = [MHWindow settings];
            window = [MHWindow sharedWindow];
            vc = (MHViewController *)window.rootViewController;
            window.alpha = 0;
}


-(void)noteInterfaceOrientationChanged:(long long)arg1 duration:(double)arg2 updateMirroredDisplays:(BOOL)arg3 force:(BOOL)arg4 logMessage:(id)arg5{

    if (arg1 == 1){
        [ChatHeadsController setChatHeadsHidden:NO];
    }else{
        if (ChatHeadsController.isExpanded) {
            [ChatHeadsController collapseChatHeads];
        }
        [ChatHeadsController setChatHeadsHidden:YES];
    }

    %orig;
}

//Home Button Methods
-(void)_simulateHomeButtonPress{
    if (ChatHeadsController.isExpanded) {
        [ChatHeadsController collapseChatHeads];
    }else{
        %orig;
    }
}
-(void)_simulateHomeButtonPressWithCompletion:(/*^block*/id)arg1 {
    if (ChatHeadsController.isExpanded) {
        [ChatHeadsController collapseChatHeads];
    }else{
        %orig;
    }
}
- (void)_handleMenuButtonEvent {
    if (ChatHeadsController.isExpanded) {
        [ChatHeadsController collapseChatHeads];
    }else{
        %orig;
    }
}
%end
%hook SBHomeHardwareButton
-(void)singlePressUp:(id)arg1{
    if (ChatHeadsController.isExpanded) {
        [ChatHeadsController collapseChatHeads];
    }else{
        %orig;
    }
}
%end

%hook SBLockHardwareButton
-(void)singlePress:(id)arg1 {
    if (ChatHeadsController.isExpanded) {
        [ChatHeadsController collapseChatHeads];
    }
    %orig;
}
%end

%hook SBFluidSwitcherGestureManager
-(void)grabberTongueBeganPulling:(id)arg1 withDistance:(double)arg2 andVelocity:(double)arg3 {
    if (ChatHeadsController.isExpanded) {
        [ChatHeadsController collapseChatHeads];
    }
    %orig;
}
%end



//%hook SBFluidSwitcherGestureManager
//
//-(void)grabberTongueBeganPulling:(id)arg1 withDistance:(double)arg2 andVelocity:(double)arg3 {
//    if (ChatHeadsController.isExpanded) {
//        [ChatHeadsController collapseChatHeads];
//        [self grabberTongueCanceledPulling:arg1 withDistance:arg2 andVelocity:arg3];
//    }
//    %orig;
//}
//%end


//App Switcher
//%hook SBDeckSwitcherViewController
//-(void)viewDidAppear:(BOOL)animated{
//    if (ChatHeadsController.isExpanded) {
//        [ChatHeadsController collapseChatHeads];
//    }
//    %orig;
//}
//
//-(void)scrollViewKillingProgressUpdated:(double)arg1 ofContainer:(id)arg2 {
//    if (SYSTEM_VERSION_GREATER_THAN(@"11.0")){
//        NSString *id = [[[arg2 valueForKey:@"appLayout"] valueForKey:@"allItems"] valueForKey:@"displayIdentifier"][0];
//        if ([[ChatHeadsMessagingServer sharedInstance].registeredAppIds containsObject:id]){
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"ChatHeads" message:@"This app is locked because it is required to be in the background to present ChatHeads. Would you like to unlock it?" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
//            UIAlertAction* kill = [UIAlertAction actionWithTitle:@"Unlock" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
//                [[ChatHeadsMessagingServer sharedInstance].registeredAppIds removeObject:[[[arg2 valueForKey:@"appLayout"] valueForKey:@"allItems"] valueForKey:@"displayIdentifier"][0]];
//            }];
//            [alert addAction:defaultAction];
//            [alert addAction:kill];
//            [vc presentViewController:alert animated:YES completion:nil];
//        }else{
//            %orig;
//        }
//    }
//}
//%end


//Prevent Banners

%hook BBServer
// 11
-(void)publishBulletin:(BBBulletin *)bulletin destinations:(unsigned int)arg2 alwaysToLockScreen:(BOOL)arg3{
    if ([[%c(SBLockStateAggregator) sharedInstance] lockState] == 0){
        if ([SETTINGS[@"preventNotifications"] boolValue] && [[ChatHeadsMessagingServer sharedInstance].registeredAppIds containsObject:bulletin.sectionID]){
            %orig;
        }else{
            %orig;
        }
    }else{
        %orig;
    }
}

// 12
-(void)publishBulletin:(BBBulletin *)bulletin destinations:(unsigned long long)arg2{
    if ([[%c(SBLockStateAggregator) sharedInstance] lockState] == 0){
        if ([SETTINGS[@"preventNotifications"] boolValue] && [[ChatHeadsMessagingServer sharedInstance].registeredAppIds containsObject:bulletin.sectionID]){
            NSLog(@"[MH] preventNotifications notification for %@", bulletin.sectionID);
            %orig;

        }else{
            %orig;
        }
    }else{
        %orig;
    }
}
%end

%hook SBLockStateAggregator
-(void)_updateLockState{
    %orig;
    unsigned long long o = [[self valueForKey:@"_lockState"] longLongValue];
    if (o == 0){
        [UIView animateWithDuration:0.2 animations:^{
            window.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            window.alpha = 0;
        }];
    }
}
%end



%ctor {
    @autoreleasepool {
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        if([bundleID isEqualToString:@"com.apple.springboard"]){
            [ChatHeadsMessagingServer load];
            %init();
        }
    }
}
