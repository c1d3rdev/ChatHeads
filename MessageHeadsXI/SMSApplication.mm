#line 1 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/MessageHeadsXI/MessageHeadsXI/SMSApplication.xm"







#import "SMSApplication.h"

static CPDistributedMessagingCenter *smsc;


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

@class SMSApplication; 
static _Bool (*_logos_orig$_ungrouped$SMSApplication$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL SMSApplication* _LOGOS_SELF_CONST, SEL, id, id); static _Bool _logos_method$_ungrouped$SMSApplication$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL SMSApplication* _LOGOS_SELF_CONST, SEL, id, id); 

#line 12 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/MessageHeadsXI/MessageHeadsXI/SMSApplication.xm"


static _Bool _logos_method$_ungrouped$SMSApplication$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL SMSApplication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2){
    bool o = _logos_orig$_ungrouped$SMSApplication$application$didFinishLaunchingWithOptions$(self, _cmd, arg1, arg2);
    
    
    smsc = [CPDistributedMessagingCenter centerNamed:@"com.c1d3r.messageheadsxi.messagereceived"];
    rocketbootstrap_distributedmessagingcenter_apply(smsc);
    
    if ([SETTINGS[@"debug"] boolValue]){
        [smsc sendMessageName:@"debug" userInfo:@{@"message" : @"Hooked SMS App"}];
    }
    NSLog(@"[MH] SMS Launched");
    
    
    
    [[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.c1d3r.messageheadsxi.sms.openthread" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        NSLog(@"[MH] SMS Should Open Thread: %@", [notification.userInfo objectForKey:@"conversationId"]);
        
        CKConversation *conversation;
        NSArray *conversations = [[NSClassFromString(@"CKConversationList") sharedConversationList] conversations];
        for (CKConversation *c in conversations){
            if ([c.chat.chatIdentifier isEqualToString:[notification.userInfo objectForKey:@"conversationId"]]){
                conversation = c;
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messagesController showConversation:conversation animate:NO];
        });
    }];
    
    return o;
}














































static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SMSApplication = objc_getClass("SMSApplication"); MSHookMessageEx(_logos_class$_ungrouped$SMSApplication, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$SMSApplication$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$SMSApplication$application$didFinishLaunchingWithOptions$);} }
#line 92 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/MessageHeadsXI/MessageHeadsXI/SMSApplication.xm"
