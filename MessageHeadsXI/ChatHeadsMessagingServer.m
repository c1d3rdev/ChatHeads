//
//  SwitchesMessagingServer.m
//  switches
//
//  Created by Will Smillie on 6/11/19.
//

#import "ChatHeadsMessagingServer.h"
#import "interfaces.h"
#import "MHViewController.h"

#define SETTINGS [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@", @"com.c1d3r.ChatHeadsSettings.plist"]]

@implementation ChatHeadsMessagingServer

+ (void)load {
    NSLog(@"[MH] CHMS is loading");
    [self sharedInstance];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once = 0;
    __strong static ChatHeadsMessagingServer *sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
    });
    NSLog(@"[MH] created a shared instance: %@", sharedInstance);
    return sharedInstance;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.registeredAppIds = [[NSMutableArray alloc] init];
        self.mutedConversations = [[NSMutableArray alloc] init];

        _messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.c1d3r.messagehub"];
        rocketbootstrap_distributedmessagingcenter_apply(_messagingCenter);
        [_messagingCenter runServerOnCurrentThread];
        [_messagingCenter registerForMessageName:@"registeredApps" target:self selector:@selector(clientRequestedRegisteredAppsFromNotification:withUserInfo:)];
        [_messagingCenter registerForMessageName:@"registerExtension" target:self selector:@selector(registerExtension:withUserInfo:)];
        [_messagingCenter registerForMessageName:@"messageReceived" target:self selector:@selector(messageReceived:withUserInfo:)];
        [_messagingCenter registerForMessageName:@"toggleExtension" target:self selector:@selector(toggleExtension:withUserInfo:)];
        [_messagingCenter registerForMessageName:@"debug" target:self selector:@selector(presentDebugAlert:withUserInfo:)];
        [_messagingCenter registerForMessageName:@"alert" target:self selector:@selector(presentAlert:withUserInfo:)];
    }
    
    return self;
}

-(NSDictionary *)clientRequestedRegisteredAppsFromNotification:(NSString *)name userInfo:(NSDictionary *)userInfo{
    NSLog(@"[MH] clientRequestedRegisteredAppsFromNotification");
    return @{@"apps": self.registeredAppIds};
}

-(void)registerExtension:(NSString *)name withUserInfo:(NSDictionary *)userInfo{
    NSLog(@"[MH] registerExtension");

    if (![self.registeredAppIds containsObject:userInfo[@"bundleId"]]) {
        [self.registeredAppIds addObject:userInfo[@"bundleId"]];
    }
    NSLog(@"[MH] registered! %@", self.registeredAppIds);
    
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"com.c1d3r.messagehub.%@.didRegister", userInfo[@"bundleId"]] object:nil userInfo:@{@"enabled": [NSNumber numberWithBool:SETTINGS[userInfo[@"bundleId"]]]}];
}

-(void)messageReceived:(NSString *)name withUserInfo:(NSDictionary *)userInfo{
    NSLog(@"[MH] messageReceived");

    NSString *frontMostBundleId = [[(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication] bundleIdentifier];
    
    if (![self.mutedConversations containsObject:userInfo[@"conversationId"]]) {
        if ([userInfo[@"bundleId"] isEqualToString:frontMostBundleId] && ![SETTINGS[@"spawnHeadWhileInApp"] boolValue]) {
            return;
        }
        [[MHViewController sharedInstance] addChatIfNeeded:userInfo];
    }
}

-(void)toggleExtension:(NSString *)name withUserInfo:(NSDictionary *)userInfo{
    NSLog(@"[MH] toggleExtension");
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"com.c1d3r.messagehub.%@.didRegister", userInfo[@"bundleId"]] object:nil userInfo:@{@"enabled": userInfo[@"value"]}];
}

-(void)presentDebugAlert:(NSString *)name withUserInfo:(NSDictionary *)userInfo{
    if ([SETTINGS[@"debug"] boolValue]) {
        [self debugAlertWithMessage:userInfo[@"message"]];
    }
}

-(void)presentAlert:(NSString *)name withUserInfo:(NSDictionary *)userInfo{
    NSLog(@"[MH] presentAlert");
    [self alertWithMessage:userInfo[@"message"]];
}



-(void)debugAlertWithMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ChatHeads Debug" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
    [[MHViewController sharedInstance] presentViewController:alert animated:YES completion:nil];
}

-(void)alertWithMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ChatHeads" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
    [[MHViewController sharedInstance] presentViewController:alert animated:YES completion:nil];
}

@end
