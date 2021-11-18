#line 1 "Tweak.xm"




#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../MessageHeadsXI/IPC.h"
#import "../MessageHeadsXI/MHWindowManager.h"

static BOOL ignore;
static NSMutableDictionary *oldFrames;
NSInteger wasStatusBarHidden = -1;


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

@class UIWindow; @class UIApplication; 
static void (*_logos_orig$_ungrouped$UIWindow$setFrame$)(_LOGOS_SELF_TYPE_NORMAL UIWindow* _LOGOS_SELF_CONST, SEL, CGRect); static void _logos_method$_ungrouped$UIWindow$setFrame$(_LOGOS_SELF_TYPE_NORMAL UIWindow* _LOGOS_SELF_CONST, SEL, CGRect); static UIApplication* (*_logos_orig$_ungrouped$UIApplication$init)(_LOGOS_SELF_TYPE_INIT UIApplication*, SEL) _LOGOS_RETURN_RETAINED; static UIApplication* _logos_method$_ungrouped$UIApplication$init(_LOGOS_SELF_TYPE_INIT UIApplication*, SEL) _LOGOS_RETURN_RETAINED; static BOOL (*_logos_orig$_ungrouped$UIApplication$_canReceiveDeviceOrientationEvents)(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$UIApplication$_canReceiveDeviceOrientationEvents(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$UIApplication$RA_updateWindowsForSizeChange$isReverting$(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL, CGSize, BOOL); 

#line 14 "Tweak.xm"

static void _logos_method$_ungrouped$UIWindow$setFrame$(_LOGOS_SELF_TYPE_NORMAL UIWindow* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGRect frame){
  if (!ignore) {
    
    if ([MHWindowManager.sharedInstance.currentData[@"shouldOverride"] boolValue]){
        if ([oldFrames objectForKey:@(self.hash)] == nil){
            [oldFrames setObject:[NSValue valueWithCGRect:frame] forKey:@(self.hash)];
        }

        frame.origin.y = 0;
        frame.size.width = [MHWindowManager.sharedInstance.currentData[@"fauxWidth"] floatValue];
        frame.size.height = [MHWindowManager.sharedInstance.currentData[@"fauxHeight"] floatValue];
    }

    _logos_orig$_ungrouped$UIWindow$setFrame$(self, _cmd, frame);
    [self layoutSubviews];
  }else{
    _logos_orig$_ungrouped$UIWindow$setFrame$(self, _cmd, frame);
  }
}




static UIApplication* _logos_method$_ungrouped$UIApplication$init(_LOGOS_SELF_TYPE_INIT UIApplication* __unused self, SEL __unused _cmd) _LOGOS_RETURN_RETAINED{
    id o = _logos_orig$_ungrouped$UIApplication$init(self, _cmd);
    if (!ignore) {

      NSString *bundleId = [UIApplication displayIdentifier];
      oldFrames = [[NSMutableDictionary alloc] init];

      [[NSDistributedNotificationCenter defaultCenter] addObserverForName:[NSString stringWithFormat:@"com.c1d3r.messagehub.%@.updateWindows", bundleId] object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {

          MHWindowManager.sharedInstance.currentData[@"forcedOrientation"] = notification.userInfo[@"forcedOrientation"];
          CGSize size = CGSizeFromString([notification.userInfo objectForKey:@"size"]);

          
          [[UIDevice currentDevice] setOrientation:UIDeviceOrientationPortrait animated:NO];
          

          
          if (CGSizeEqualToSize(size, CGSizeZero)){
              [[self statusBarWindow] setAlpha:1];
              MHWindowManager.sharedInstance.currentData[@"shouldOverride"] = [NSNumber numberWithBool:NO];
              MHWindowManager.sharedInstance.currentData[@"shouldForceOrientation"] = [NSNumber numberWithBool:NO];
              [self RA_updateWindowsForSizeChange:size isReverting:YES];
          }else{
              [[self statusBarWindow] setAlpha:0];
              MHWindowManager.sharedInstance.currentData[@"shouldOverride"] = [NSNumber numberWithBool:YES];
              MHWindowManager.sharedInstance.currentData[@"shouldForceOrientation"] = [NSNumber numberWithBool:YES];
              [self RA_updateWindowsForSizeChange:size isReverting:NO];
          }
      }];
      [[NSDistributedNotificationCenter defaultCenter] addObserverForName:[NSString stringWithFormat:@"com.c1d3r.messagehub.%@.terminate", bundleId] object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
          if ([self respondsToSelector:@selector(terminateWithSuccess)]){
              NSLog(@"[MH] terminating...");
          }
      }];
    }
    return o;
}

static BOOL _logos_method$_ungrouped$UIApplication$_canReceiveDeviceOrientationEvents(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){

    if ([MHWindowManager.sharedInstance.currentData[@"shouldOverride"] boolValue] && !ignore){
        return NO;
    }else{
        return _logos_orig$_ungrouped$UIApplication$_canReceiveDeviceOrientationEvents(self, _cmd);
    }
}



static void _logos_method$_ungrouped$UIApplication$RA_updateWindowsForSizeChange$isReverting$(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGSize size, BOOL revert) {
    if (revert){
        for (UIWindow *window in [[UIApplication sharedApplication] windows]){
            CGRect frame = window.frame;
            if ([oldFrames objectForKey:@(window.hash)] != nil){
                frame = [[oldFrames objectForKey:@(window.hash)] CGRectValue];
                [oldFrames removeObjectForKey:@(window.hash)];
            }
            [window setFrame:frame];
        }
    }else{
        MHWindowManager.sharedInstance.currentData[@"fauxWidth"] = [NSNumber numberWithFloat:size.width];
        MHWindowManager.sharedInstance.currentData[@"fauxHeight"] = [NSNumber numberWithFloat:size.height];

        for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
            CGRect r = CGRectMake(0,0,window.frame.size.width, window.frame.size.height);
            [window setFrame:r];
        }
    }
}


static __attribute__((constructor)) void _logosLocalCtor_7a5d1c33(int __unused argc, char __unused **argv, char __unused **envp){
  NSMutableArray *appsToIgnore = [[NSMutableArray alloc] initWithObjects:@"com.apple.springboard", @"com.apple.SiriViewService", @"com.apple.InCallService", nil];
  NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
  if ([appsToIgnore containsObject:bundleIdentifier]){
    ignore = YES;
  }
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$UIWindow = objc_getClass("UIWindow"); MSHookMessageEx(_logos_class$_ungrouped$UIWindow, @selector(setFrame:), (IMP)&_logos_method$_ungrouped$UIWindow$setFrame$, (IMP*)&_logos_orig$_ungrouped$UIWindow$setFrame$);Class _logos_class$_ungrouped$UIApplication = objc_getClass("UIApplication"); MSHookMessageEx(_logos_class$_ungrouped$UIApplication, @selector(init), (IMP)&_logos_method$_ungrouped$UIApplication$init, (IMP*)&_logos_orig$_ungrouped$UIApplication$init);MSHookMessageEx(_logos_class$_ungrouped$UIApplication, @selector(_canReceiveDeviceOrientationEvents), (IMP)&_logos_method$_ungrouped$UIApplication$_canReceiveDeviceOrientationEvents, (IMP*)&_logos_orig$_ungrouped$UIApplication$_canReceiveDeviceOrientationEvents);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(CGSize), strlen(@encode(CGSize))); i += strlen(@encode(CGSize)); memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$UIApplication, @selector(RA_updateWindowsForSizeChange:isReverting:), (IMP)&_logos_method$_ungrouped$UIApplication$RA_updateWindowsForSizeChange$isReverting$, _typeEncoding); }} }
#line 116 "Tweak.xm"
