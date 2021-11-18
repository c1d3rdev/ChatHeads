#line 1 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/MessageHeadsXI/MessageHeadsXI/WhatsApp.xm"







#import <Foundation/Foundation.h>
#import "WhatsApp.h"

static CPDistributedMessagingCenter *watc;
static WAMessageNotificationCenter *muteChecker;


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

@class WAProfilePictureManager; @class WAChatSessionTransaction; @class WhatsAppAppDelegate; @class WAChatPresenter; @class WAMessageNotificationCenter; 
static _Bool (*_logos_orig$_ungrouped$WhatsAppAppDelegate$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL WhatsAppAppDelegate* _LOGOS_SELF_CONST, SEL, id, id); static _Bool _logos_method$_ungrouped$WhatsAppAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL WhatsAppAppDelegate* _LOGOS_SELF_CONST, SEL, id, id); static void (*_logos_orig$_ungrouped$WAChatSessionTransaction$trackReceivedMessage$)(_LOGOS_SELF_TYPE_NORMAL WAChatSessionTransaction* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$WAChatSessionTransaction$trackReceivedMessage$(_LOGOS_SELF_TYPE_NORMAL WAChatSessionTransaction* _LOGOS_SELF_CONST, SEL, id); static WAMessageNotificationCenter* (*_logos_orig$_ungrouped$WAMessageNotificationCenter$initWithXMPPConnection$chatStorage$)(_LOGOS_SELF_TYPE_INIT WAMessageNotificationCenter*, SEL, id, id) _LOGOS_RETURN_RETAINED; static WAMessageNotificationCenter* _logos_method$_ungrouped$WAMessageNotificationCenter$initWithXMPPConnection$chatStorage$(_LOGOS_SELF_TYPE_INIT WAMessageNotificationCenter*, SEL, id, id) _LOGOS_RETURN_RETAINED; 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$WAProfilePictureManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("WAProfilePictureManager"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$WAChatPresenter(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("WAChatPresenter"); } return _klass; }
#line 14 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/MessageHeadsXI/MessageHeadsXI/WhatsApp.xm"

static _Bool _logos_method$_ungrouped$WhatsAppAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL WhatsAppAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2){
    bool o =  _logos_orig$_ungrouped$WhatsAppAppDelegate$application$didFinishLaunchingWithOptions$(self, _cmd, arg1, arg2);
    
    
    watc = [CPDistributedMessagingCenter centerNamed:@"com.c1d3r.messageheadsxi.messagereceived"];
    rocketbootstrap_distributedmessagingcenter_apply(watc);
    
    if ([SETTINGS[@"debug"] boolValue]){
        [watc sendMessageName:@"debug" userInfo:@{@"message" : @"Hooked WhatsApp"}];
    }
    
    
    
    [[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.c1d3r.messageheadsxi.wat.openthread" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        [self openChatWithPresenter:[_logos_static_class_lookup$WAChatPresenter() forJID:[notification.userInfo objectForKey:@"conversationId"]] animated:NO];
        
    }];
    
    
    return o;
}




static void _logos_method$_ungrouped$WAChatSessionTransaction$trackReceivedMessage$(_LOGOS_SELF_TYPE_NORMAL WAChatSessionTransaction* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
    _logos_orig$_ungrouped$WAChatSessionTransaction$trackReceivedMessage$(self, _cmd, arg1);
    
    WAMessage *m = arg1;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"net.whatsapp.WhatsApp" forKey:@"bundleId"];
    
    
    if ([muteChecker isChatWithJIDMuted:m.fromJID] | (m.messageType == 1)){
        return;
    }
    
    if ([SETTINGS[@"debug"] boolValue]){
        [watc sendMessageName:@"debug" userInfo:@{@"message" : [NSString stringWithFormat:@"WhatsApp Message Received: %lu", m.chatSession.sessionType]}];
    }
    
    NSString *imagePath = [_logos_static_class_lookup$WAProfilePictureManager() fullPathToProfilePictureThumbnailForJID:m.senderJID];
    if (imagePath.length > 0){
        [dict setObject:@[imagePath] forKey:@"profilePicturePaths"];
    }
    if (m.text){
        [dict setObject:m.text forKey:@"message"];
    }
    
    if (m.senderJID){
        [dict setObject:@[m.senderJID] forKey:@"senderIds"];
    }
    
    if (m.fromJID){
        [dict setObject:m.fromJID forKey:@"conversationId"];
    }
    
    [watc sendMessageName:@"messagereceived" userInfo:dict];
}




static WAMessageNotificationCenter* _logos_method$_ungrouped$WAMessageNotificationCenter$initWithXMPPConnection$chatStorage$(_LOGOS_SELF_TYPE_INIT WAMessageNotificationCenter* __unused self, SEL __unused _cmd, id arg1, id arg2) _LOGOS_RETURN_RETAINED{
    id o = _logos_orig$_ungrouped$WAMessageNotificationCenter$initWithXMPPConnection$chatStorage$(self, _cmd, arg1, arg2);
    muteChecker = o;
    return o;
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$WhatsAppAppDelegate = objc_getClass("WhatsAppAppDelegate"); MSHookMessageEx(_logos_class$_ungrouped$WhatsAppAppDelegate, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$WhatsAppAppDelegate$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$WhatsAppAppDelegate$application$didFinishLaunchingWithOptions$);Class _logos_class$_ungrouped$WAChatSessionTransaction = objc_getClass("WAChatSessionTransaction"); MSHookMessageEx(_logos_class$_ungrouped$WAChatSessionTransaction, @selector(trackReceivedMessage:), (IMP)&_logos_method$_ungrouped$WAChatSessionTransaction$trackReceivedMessage$, (IMP*)&_logos_orig$_ungrouped$WAChatSessionTransaction$trackReceivedMessage$);Class _logos_class$_ungrouped$WAMessageNotificationCenter = objc_getClass("WAMessageNotificationCenter"); MSHookMessageEx(_logos_class$_ungrouped$WAMessageNotificationCenter, @selector(initWithXMPPConnection:chatStorage:), (IMP)&_logos_method$_ungrouped$WAMessageNotificationCenter$initWithXMPPConnection$chatStorage$, (IMP*)&_logos_orig$_ungrouped$WAMessageNotificationCenter$initWithXMPPConnection$chatStorage$);} }
#line 84 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/MessageHeadsXI/MessageHeadsXI/WhatsApp.xm"
