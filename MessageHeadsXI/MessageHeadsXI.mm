#line 1 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/ChatHeads/MessageHeadsXI/MessageHeadsXI.xm"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#import <rocketbootstrap/rocketbootstrap.h>

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








#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class BBServer; @class SBLockHardwareButton; @class SBFluidSwitcherGestureManager; @class SpringBoard; @class SBHomeHardwareButton; @class SBLockStateAggregator; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIApplication *); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, UIApplication *); static void (*_logos_orig$_ungrouped$SpringBoard$noteInterfaceOrientationChanged$duration$updateMirroredDisplays$force$logMessage$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, long long, double, BOOL, BOOL, id); static void _logos_method$_ungrouped$SpringBoard$noteInterfaceOrientationChanged$duration$updateMirroredDisplays$force$logMessage$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, long long, double, BOOL, BOOL, id); static void (*_logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPress)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPress(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPressWithCompletion$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPressWithCompletion$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SpringBoard$_handleMenuButtonEvent)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SpringBoard$_handleMenuButtonEvent(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBHomeHardwareButton$singlePressUp$)(_LOGOS_SELF_TYPE_NORMAL SBHomeHardwareButton* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SBHomeHardwareButton$singlePressUp$(_LOGOS_SELF_TYPE_NORMAL SBHomeHardwareButton* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SBLockHardwareButton$singlePress$)(_LOGOS_SELF_TYPE_NORMAL SBLockHardwareButton* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SBLockHardwareButton$singlePress$(_LOGOS_SELF_TYPE_NORMAL SBLockHardwareButton* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SBFluidSwitcherGestureManager$grabberTongueBeganPulling$withDistance$andVelocity$)(_LOGOS_SELF_TYPE_NORMAL SBFluidSwitcherGestureManager* _LOGOS_SELF_CONST, SEL, id, double, double); static void _logos_method$_ungrouped$SBFluidSwitcherGestureManager$grabberTongueBeganPulling$withDistance$andVelocity$(_LOGOS_SELF_TYPE_NORMAL SBFluidSwitcherGestureManager* _LOGOS_SELF_CONST, SEL, id, double, double); static void (*_logos_orig$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$)(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST, SEL, BBBulletin *, unsigned int, BOOL); static void _logos_method$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST, SEL, BBBulletin *, unsigned int, BOOL); static void (*_logos_orig$_ungrouped$BBServer$publishBulletin$destinations$)(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST, SEL, BBBulletin *, unsigned long long); static void _logos_method$_ungrouped$BBServer$publishBulletin$destinations$(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST, SEL, BBBulletin *, unsigned long long); static void (*_logos_orig$_ungrouped$SBLockStateAggregator$_updateLockState)(_LOGOS_SELF_TYPE_NORMAL SBLockStateAggregator* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBLockStateAggregator$_updateLockState(_LOGOS_SELF_TYPE_NORMAL SBLockStateAggregator* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBLockStateAggregator(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBLockStateAggregator"); } return _klass; }
#line 44 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/ChatHeads/MessageHeadsXI/MessageHeadsXI.xm"


static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIApplication * arg1){
    _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, arg1);

    
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


static void _logos_method$_ungrouped$SpringBoard$noteInterfaceOrientationChanged$duration$updateMirroredDisplays$force$logMessage$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, long long arg1, double arg2, BOOL arg3, BOOL arg4, id arg5){

    if (arg1 == 1){
        [ChatHeadsController setChatHeadsHidden:NO];
    }else{
        if (ChatHeadsController.isExpanded) {
            [ChatHeadsController collapseChatHeads];
        }
        [ChatHeadsController setChatHeadsHidden:YES];
    }

    _logos_orig$_ungrouped$SpringBoard$noteInterfaceOrientationChanged$duration$updateMirroredDisplays$force$logMessage$(self, _cmd, arg1, arg2, arg3, arg4, arg5);
}


static void _logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPress(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    if (ChatHeadsController.isExpanded) {
        [ChatHeadsController collapseChatHeads];
    }else{
        _logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPress(self, _cmd);
    }
}
static void _logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPressWithCompletion$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
    if (ChatHeadsController.isExpanded) {
        [ChatHeadsController collapseChatHeads];
    }else{
        _logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPressWithCompletion$(self, _cmd, arg1);
    }
}
static void _logos_method$_ungrouped$SpringBoard$_handleMenuButtonEvent(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if (ChatHeadsController.isExpanded) {
        [ChatHeadsController collapseChatHeads];
    }else{
        _logos_orig$_ungrouped$SpringBoard$_handleMenuButtonEvent(self, _cmd);
    }
}


static void _logos_method$_ungrouped$SBHomeHardwareButton$singlePressUp$(_LOGOS_SELF_TYPE_NORMAL SBHomeHardwareButton* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
    if (ChatHeadsController.isExpanded) {
        [ChatHeadsController collapseChatHeads];
    }else{
        _logos_orig$_ungrouped$SBHomeHardwareButton$singlePressUp$(self, _cmd, arg1);
    }
}



static void _logos_method$_ungrouped$SBLockHardwareButton$singlePress$(_LOGOS_SELF_TYPE_NORMAL SBLockHardwareButton* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
    if (ChatHeadsController.isExpanded) {
        [ChatHeadsController collapseChatHeads];
    }
    _logos_orig$_ungrouped$SBLockHardwareButton$singlePress$(self, _cmd, arg1);
}



static void _logos_method$_ungrouped$SBFluidSwitcherGestureManager$grabberTongueBeganPulling$withDistance$andVelocity$(_LOGOS_SELF_TYPE_NORMAL SBFluidSwitcherGestureManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, double arg2, double arg3) {
    if (ChatHeadsController.isExpanded) {
        [ChatHeadsController collapseChatHeads];
    }
    _logos_orig$_ungrouped$SBFluidSwitcherGestureManager$grabberTongueBeganPulling$withDistance$andVelocity$(self, _cmd, arg1, arg2, arg3);
}

















































static void _logos_method$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BBBulletin * bulletin, unsigned int arg2, BOOL arg3){
    if ([[_logos_static_class_lookup$SBLockStateAggregator() sharedInstance] lockState] == 0){
        if ([SETTINGS[@"preventNotifications"] boolValue] && [[ChatHeadsMessagingServer sharedInstance].registeredAppIds containsObject:bulletin.sectionID]){
            _logos_orig$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$(self, _cmd, bulletin, arg2, arg3);
        }else{
            _logos_orig$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$(self, _cmd, bulletin, arg2, arg3);
        }
    }else{
        _logos_orig$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$(self, _cmd, bulletin, arg2, arg3);
    }
}


static void _logos_method$_ungrouped$BBServer$publishBulletin$destinations$(_LOGOS_SELF_TYPE_NORMAL BBServer* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BBBulletin * bulletin, unsigned long long arg2){
    if ([[_logos_static_class_lookup$SBLockStateAggregator() sharedInstance] lockState] == 0){
        if ([SETTINGS[@"preventNotifications"] boolValue] && [[ChatHeadsMessagingServer sharedInstance].registeredAppIds containsObject:bulletin.sectionID]){
            NSLog(@"[MH] preventNotifications notification for %@", bulletin.sectionID);
            _logos_orig$_ungrouped$BBServer$publishBulletin$destinations$(self, _cmd, bulletin, arg2);

        }else{
            _logos_orig$_ungrouped$BBServer$publishBulletin$destinations$(self, _cmd, bulletin, arg2);
        }
    }else{
        _logos_orig$_ungrouped$BBServer$publishBulletin$destinations$(self, _cmd, bulletin, arg2);
    }
}



static void _logos_method$_ungrouped$SBLockStateAggregator$_updateLockState(_LOGOS_SELF_TYPE_NORMAL SBLockStateAggregator* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    _logos_orig$_ungrouped$SBLockStateAggregator$_updateLockState(self, _cmd);
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




static __attribute__((constructor)) void _logosLocalCtor_fc84ab0b(int __unused argc, char __unused **argv, char __unused **envp) {
    @autoreleasepool {
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        if([bundleID isEqualToString:@"com.apple.springboard"]){
            [ChatHeadsMessagingServer load];
            {Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(noteInterfaceOrientationChanged:duration:updateMirroredDisplays:force:logMessage:), (IMP)&_logos_method$_ungrouped$SpringBoard$noteInterfaceOrientationChanged$duration$updateMirroredDisplays$force$logMessage$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$noteInterfaceOrientationChanged$duration$updateMirroredDisplays$force$logMessage$);MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(_simulateHomeButtonPress), (IMP)&_logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPress, (IMP*)&_logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPress);MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(_simulateHomeButtonPressWithCompletion:), (IMP)&_logos_method$_ungrouped$SpringBoard$_simulateHomeButtonPressWithCompletion$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$_simulateHomeButtonPressWithCompletion$);MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(_handleMenuButtonEvent), (IMP)&_logos_method$_ungrouped$SpringBoard$_handleMenuButtonEvent, (IMP*)&_logos_orig$_ungrouped$SpringBoard$_handleMenuButtonEvent);Class _logos_class$_ungrouped$SBHomeHardwareButton = objc_getClass("SBHomeHardwareButton"); MSHookMessageEx(_logos_class$_ungrouped$SBHomeHardwareButton, @selector(singlePressUp:), (IMP)&_logos_method$_ungrouped$SBHomeHardwareButton$singlePressUp$, (IMP*)&_logos_orig$_ungrouped$SBHomeHardwareButton$singlePressUp$);Class _logos_class$_ungrouped$SBLockHardwareButton = objc_getClass("SBLockHardwareButton"); MSHookMessageEx(_logos_class$_ungrouped$SBLockHardwareButton, @selector(singlePress:), (IMP)&_logos_method$_ungrouped$SBLockHardwareButton$singlePress$, (IMP*)&_logos_orig$_ungrouped$SBLockHardwareButton$singlePress$);Class _logos_class$_ungrouped$SBFluidSwitcherGestureManager = objc_getClass("SBFluidSwitcherGestureManager"); MSHookMessageEx(_logos_class$_ungrouped$SBFluidSwitcherGestureManager, @selector(grabberTongueBeganPulling:withDistance:andVelocity:), (IMP)&_logos_method$_ungrouped$SBFluidSwitcherGestureManager$grabberTongueBeganPulling$withDistance$andVelocity$, (IMP*)&_logos_orig$_ungrouped$SBFluidSwitcherGestureManager$grabberTongueBeganPulling$withDistance$andVelocity$);Class _logos_class$_ungrouped$BBServer = objc_getClass("BBServer"); MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(publishBulletin:destinations:alwaysToLockScreen:), (IMP)&_logos_method$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$, (IMP*)&_logos_orig$_ungrouped$BBServer$publishBulletin$destinations$alwaysToLockScreen$);MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(publishBulletin:destinations:), (IMP)&_logos_method$_ungrouped$BBServer$publishBulletin$destinations$, (IMP*)&_logos_orig$_ungrouped$BBServer$publishBulletin$destinations$);Class _logos_class$_ungrouped$SBLockStateAggregator = objc_getClass("SBLockStateAggregator"); MSHookMessageEx(_logos_class$_ungrouped$SBLockStateAggregator, @selector(_updateLockState), (IMP)&_logos_method$_ungrouped$SBLockStateAggregator$_updateLockState, (IMP*)&_logos_orig$_ungrouped$SBLockStateAggregator$_updateLockState);}
        }
    }
}
