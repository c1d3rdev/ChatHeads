
// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../MessageHeadsXI/IPC.h"
#import "../MessageHeadsXI/MHWindowManager.h"

static BOOL ignore;
static NSMutableDictionary *oldFrames;
NSInteger wasStatusBarHidden = -1;

%hook UIWindow
-(void)setFrame:(CGRect)frame{
  if (!ignore) {
    // NSString *bundleId = [UIApplication displayIdentifier];
    if ([MHWindowManager.sharedInstance.currentData[@"shouldOverride"] boolValue]){
        if ([oldFrames objectForKey:@(self.hash)] == nil){
            [oldFrames setObject:[NSValue valueWithCGRect:frame] forKey:@(self.hash)];
        }

        frame.origin.y = 0;
        frame.size.width = [MHWindowManager.sharedInstance.currentData[@"fauxWidth"] floatValue];
        frame.size.height = [MHWindowManager.sharedInstance.currentData[@"fauxHeight"] floatValue];
    }

    %orig(frame);
    [self layoutSubviews];
  }else{
    %orig;
  }
}
%end


%hook UIApplication
-(id)init{
    id o = %orig;
    if (!ignore) {

      NSString *bundleId = [UIApplication displayIdentifier];
      oldFrames = [[NSMutableDictionary alloc] init];

      [[NSDistributedNotificationCenter defaultCenter] addObserverForName:[NSString stringWithFormat:@"com.c1d3r.messagehub.%@.updateWindows", bundleId] object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {

          MHWindowManager.sharedInstance.currentData[@"forcedOrientation"] = notification.userInfo[@"forcedOrientation"];
          CGSize size = CGSizeFromString([notification.userInfo objectForKey:@"size"]);

          //        UIInterfaceOrientation interface = [MHWindowManager.sharedInstance.currentData[@"forcedOrientation"] longValue];
          [[UIDevice currentDevice] setOrientation:UIDeviceOrientationPortrait animated:NO];
          //        [self _setForcedUserInterfaceLayoutDirection:interface];

          //Reset
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

-(BOOL)_canReceiveDeviceOrientationEvents{

    if ([MHWindowManager.sharedInstance.currentData[@"shouldOverride"] boolValue] && !ignore){
        return NO;
    }else{
        return %orig;
    }
}

%new
-(void)RA_updateWindowsForSizeChange:(CGSize)size isReverting:(BOOL)revert
{
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
%end

%ctor{
  NSMutableArray *appsToIgnore = [[NSMutableArray alloc] initWithObjects:@"com.apple.springboard", @"com.apple.SiriViewService", @"com.apple.InCallService", nil];
  NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
  if ([appsToIgnore containsObject:bundleIdentifier]){
    ignore = YES;
  }
}
