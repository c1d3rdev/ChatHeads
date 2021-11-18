#line 1 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/MessageHeadsXI/MessageHeadsXI/Messenger.xm"







#import <Foundation/Foundation.h>
#import "Messenger.h"

static CPDistributedMessagingCenter *fbmc;

static NSString *myId;


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

@class MNPushMessageHandler; @class MNAppDelegate; 
static _Bool (*_logos_orig$_ungrouped$MNAppDelegate$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL MNAppDelegate* _LOGOS_SELF_CONST, SEL, id, id); static _Bool _logos_method$_ungrouped$MNAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL MNAppDelegate* _LOGOS_SELF_CONST, SEL, id, id); static void (*_logos_orig$_ungrouped$MNPushMessageHandler$handleAPNSMessage$supportsPreview$userActionInfo$source$fetchCompletionHandler$)(_LOGOS_SELF_TYPE_NORMAL MNPushMessageHandler* _LOGOS_SELF_CONST, SEL, id, _Bool, id, long long, id); static void _logos_method$_ungrouped$MNPushMessageHandler$handleAPNSMessage$supportsPreview$userActionInfo$source$fetchCompletionHandler$(_LOGOS_SELF_TYPE_NORMAL MNPushMessageHandler* _LOGOS_SELF_CONST, SEL, id, _Bool, id, long long, id); 

#line 15 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/MessageHeadsXI/MessageHeadsXI/Messenger.xm"

static _Bool _logos_method$_ungrouped$MNAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL MNAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2){
    NSLog(@"[MH] FBM didFinishLaunchingWithOptions");
    bool o = _logos_orig$_ungrouped$MNAppDelegate$application$didFinishLaunchingWithOptions$(self, _cmd, arg1, arg2);
    
    
    
    fbmc = [CPDistributedMessagingCenter centerNamed:@"com.c1d3r.messageheadsxi.messagereceived"];
    rocketbootstrap_distributedmessagingcenter_apply(fbmc);
    
    if ([SETTINGS[@"debug"] boolValue]){
        [fbmc sendMessageName:@"debug" userInfo:@{@"message" : @"Hooked FB Messenger App"}];
    }
    
    
    
    [[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.c1d3r.messageheadsxi.fbm.openthread" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        
        [self application:arg1 openURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb-messenger://user-thread/%@",  [notification.userInfo objectForKey:@"conversationId"]]] sourceApplication:nil annotation:nil];
    }];
    
    return o;
}




static void _logos_method$_ungrouped$MNPushMessageHandler$handleAPNSMessage$supportsPreview$userActionInfo$source$fetchCompletionHandler$(_LOGOS_SELF_TYPE_NORMAL MNPushMessageHandler* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, _Bool arg2, id arg3, long long arg4, id arg5){
    _logos_orig$_ungrouped$MNPushMessageHandler$handleAPNSMessage$supportsPreview$userActionInfo$source$fetchCompletionHandler$(self, _cmd, arg1, arg2, arg3, arg4, arg5);
    
    
    FBMMessage *m = arg1;
    
    if ([SETTINGS[@"debug"] boolValue]){
        [fbmc sendMessageName:@"debug" userInfo:@{@"message" : @"FB Messenger Received Message"}];
    }
    
    if ([m.tags containsObject:@"montage"]){
        return;
    }
    
    
    
    NSString *text = m.text.rawContentValueOnlyToBeVisibleToUser;
    NSString *senderId = m.senderId;
    NSString *bundleId = @"com.facebook.Messenger";
    NSString *key;
    
    
    FBMGroupThreadKey *groupKey = MSHookIvar<id>(m.threadKey, "_groupThreadKey_groupThreadKey");
    FBMCanonicalThreadKey *singleKey = MSHookIvar<id>(m.threadKey, "_canonicalThreadKey_canonicalThreadKey");
    if (groupKey){
        key = groupKey.threadFbId;
    }else{
        key = singleKey.userId;
    }
    
    if (!key | key.length == 0){
        return;
    }
    
    [fbmc sendMessageName:@"messagereceived" userInfo:@{@"conversationId" : key,
                                                        @"senderIds" : @[senderId],
                                                        @"message" : text,
                                                        @"bundleId" : bundleId
                                                        }];
}





static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$MNAppDelegate = objc_getClass("MNAppDelegate"); MSHookMessageEx(_logos_class$_ungrouped$MNAppDelegate, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$MNAppDelegate$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$MNAppDelegate$application$didFinishLaunchingWithOptions$);Class _logos_class$_ungrouped$MNPushMessageHandler = objc_getClass("MNPushMessageHandler"); MSHookMessageEx(_logos_class$_ungrouped$MNPushMessageHandler, @selector(handleAPNSMessage:supportsPreview:userActionInfo:source:fetchCompletionHandler:), (IMP)&_logos_method$_ungrouped$MNPushMessageHandler$handleAPNSMessage$supportsPreview$userActionInfo$source$fetchCompletionHandler$, (IMP*)&_logos_orig$_ungrouped$MNPushMessageHandler$handleAPNSMessage$supportsPreview$userActionInfo$source$fetchCompletionHandler$);} }
#line 87 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/MessageHeadsXI/MessageHeadsXI/Messenger.xm"
