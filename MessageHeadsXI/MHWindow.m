//
//  UIWindow.m
//  MessageHeadsXI
//
//  Created by Will Smillie on 8/3/18.
//

#import "MHWindow.h"

#import "interfaces.h"
#import <rocketbootstrap/rocketbootstrap.h>


@implementation MHWindow


+ (id)sharedWindow {
    static MHWindow *window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[self alloc] init];
    });
    
    return window;
}

- (id)init{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        self.windowLevel = UIWindowLevelStatusBar;
        [self setHidden:NO];
        self.alpha = 1;
        self.rootViewController = [MHViewController sharedInstance];
        self.userInteractionEnabled = YES;
    }
    return self;
    [self makeKeyAndVisible];
}

-(void)makeKeyAndVisible{
    [super makeKeyAndVisible];
}
- (bool)_shouldCreateContextAsSecure{
    return YES;
}
- (BOOL)_shouldAutorotateToInterfaceOrientation:(int)arg1{
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitTestResult = [super hitTest:point withEvent:event];
    if (ChatHeadsController.isExpanded | (self.rootViewController.presentedViewController != nil)) {
        return hitTestResult;
    }else{
        if ([hitTestResult isKindOfClass:[FCChatHead class]]) {
            return hitTestResult;
        }
        return nil;
    }
}


#pragma mark - settings

+(NSString*)settingsPath{
    return [NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(), @"com.c1d3r.ChatHeadsSettings.plist"];
}
+(NSMutableDictionary *)settings{
    return [NSMutableDictionary dictionaryWithContentsOfFile:[self settingsPath]];
}

@end
