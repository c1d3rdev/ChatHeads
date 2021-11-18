//
//  MHViewController.m
//  MessageHeadsXI
//
//  Created by Will Smillie on 8/3/18.
//

#import "MHViewController.h"
#import <Contacts/Contacts.h>
#import <rocketbootstrap/rocketbootstrap.h>
#import <UIImageView+AGCInitials.h>
#import <AudioToolbox/AudioToolbox.h>

#import "interfaces.h"
#import "ChatHeadsMessagingServer.h"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define SETTINGS [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@", @"com.c1d3r.ChatHeadsSettings.plist"]]

#define dylibDirectory @"/Library/MobileSubstrate/DynamicLibraries"

#define toClientApp [NSDistributedNotificationCenter defaultCenter]


@interface MHViewController ()<ContextHostManagerExternalSceneDelegate>{
    NSMutableArray *activeChats;
    NSMutableDictionary *contacts;
    UIView *containerView;
    UIView *activeHostView;
    BOOL resizeWindows;
    BOOL showingCantHost;
}

@end

@implementation MHViewController
@synthesize targetAppId;

+ (instancetype)sharedInstance {
    static dispatch_once_t once = 0;
    __strong static MHViewController *sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    ChatHeadsController.headSuperView = self.view;
    ChatHeadsController.datasource = self;
    ChatHeadsController.delegate = self;
    self.view.backgroundColor = [UIColor clearColor];

    activeChats = [[NSMutableArray alloc] init];
//    resizeWindows = [SETTINGS[@"resizeWindows"] boolValue];
    
    containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    containerView.backgroundColor = [UIColor respondsToSelector:@selector(systemBackgroundColor)] ? [UIColor performSelector:@selector(systemBackgroundColor)] : UIColor.whiteColor;;

    [[ContextHostManager sharedInstance] setSceneDelegate:self];
}

#pragma mark - ChatHeads

-(void)addChatIfNeeded:(NSDictionary *)message{
    if (![activeChats containsObject:message[@"conversationId"]]) {
        [activeChats addObject:message[@"conversationId"]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MHChatHeadView *chatHead = [[MHChatHeadView alloc] init];
        chatHead.chatData = [message mutableCopy];
        
        for (NSDictionary *contact in message[@"recipients"]){
            NSString *name = contact[@"name"];
            UIImage *img = [UIImage imageWithData:contact[@"imageData"]];
            [chatHead.groupChatPicView addImage:img withInitials:name];
        }
        [chatHead.groupChatPicView updateLayout];
        
        if (message[@"bundleId"]) {
            UIImage *icon = [ChatHeadHelpers iconImageForIdentifier:message[@"bundleId"]];
            chatHead.appIconImageView.image = icon;
        }
        
        [ChatHeadsController presentChatHeadWithView:chatHead chatID:message[@"conversationId"]];
        [ChatHeadsController presentMessageFromChatHeads:message[@"message"]];
    });
}

//Prepare the client
-(void)chatHeadsController:(FCChatHeadsController *)chatHeadsController willPresentPopoverForChatID:(NSString *)chatID{
    FCChatHead *chathead = [self chatHeadForChatID:chatID];
    MHChatHeadView *head = [chathead subviews][0];
    NSDictionary *chatData = head.chatData;
    
    [head.groupChatPicView updateLayout];
    
    targetAppId = chatData[@"bundleId"];
    
//    if (resizeWindows) {
//        [toClientApp postNotificationName:[NSString stringWithFormat:@"com.c1d3r.messagehub.%@.updateWindows", targetAppId] object:nil userInfo:@{@"size": NSStringFromCGSize(chatHeadsController.popoverFrame.size)}];
//    }
    [toClientApp postNotificationName:[NSString stringWithFormat:@"com.c1d3r.messagehub.%@.openConversation", targetAppId] object:nil userInfo:@{@"conversationId": chatData[@"conversationId"]}];
}

//Load the host view
- (UIView *)chatHeadsController:(FCChatHeadsController *)chatHeadsController viewForPopoverForChatHeadWithChatID:(NSString *)chatID{
    return containerView;
}

-(void)chatHeadsControllerDidDisplayChatView:(FCChatHeadsController *)chatHeadsController{
    [self beginHosting];
}

- (void)chatHeadsController:(FCChatHeadsController *)chController willDismissPopoverForChatID:(NSString *)chatID{
    NSDictionary *info = [(MHChatHeadView *)[[self chatHeadForChatID:chatID] subviews][0] chatData];
    if ([self safeToHost:info[@"bundleId"]]) {
        [toClientApp postNotificationName:[NSString stringWithFormat:@"com.c1d3r.messagehub.%@.updateWindows", info[@"bundleId"]] object:nil userInfo:@{@"size": NSStringFromCGSize(CGSizeZero), @"forcedOrientation": [NSNumber numberWithLong:[(SpringBoard *)[UIApplication sharedApplication] activeInterfaceOrientation]]}];
    }
}

-(void)chatHeadsController:(FCChatHeadsController *)chController didDismissPopoverForChatID:(NSString *)chatID{
    NSDictionary *info = [(MHChatHeadView *)[[self chatHeadForChatID:chatID] subviews][0] chatData];
    if ([self safeToHost:info[@"bundleId"]]) {
        NSLog(@"[MH] stop hosting: %@", info[@"bundleId"]);
        [[ContextHostManager sharedInstance] stopHostingForBundleId:info[@"bundleId"]];
        [toClientApp postNotificationName:[NSString stringWithFormat:@"com.c1d3r.messagehub.%@.terminate", info[@"bundleId"]] object:nil userInfo:nil];
        [self cleanUpSubviews];
    }
}

-(void)chatHeadsController:(FCChatHeadsController *)chController willRemoveChatHeadWithChatID:(NSString *)chatID{
    NSDictionary *info = [(MHChatHeadView *)[[self chatHeadForChatID:chatID] subviews][0] chatData];
    if ([self safeToHost:info[@"bundleId"]]) {
        [[ContextHostManager sharedInstance] stopHostingForBundleId:info[@"bundleId"]];
    }
}



- (void)didLongPressOnChatHead:(FCChatHead *)head{
    AudioServicesPlaySystemSound(1519); // Peek feedback

    ChatHeadsController.isPresentingAlert = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    MHChatHeadView *chview = [head subviews][0];
    NSDictionary *chatData = chview.chatData;

    [alert addAction:[UIAlertAction actionWithTitle:@"Mute Conversation (until respring)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ChatHeadsMessagingServer sharedInstance].mutedConversations addObject:chatData[@"conversationId"]];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Open App" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (ChatHeadsController.isExpanded) {
            [ChatHeadsController collapseChatHeads];
        }
        [[UIApplication sharedApplication] launchApplicationWithIdentifier:chatData[@"bundleId"] suspended:NO];
    }]];



    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    [self presentViewController:alert animated:YES completion:^{
        ChatHeadsController.isPresentingAlert = NO;
    }];
}


#pragma mark - Helpers

-(void)beginHosting{
    if ([self safeToHost:targetAppId]) {
        if (targetAppId && ![[ContextHostManager sharedInstance] isHostViewHosting:activeHostView]) {
            [[UIApplication sharedApplication] launchApplicationWithIdentifier:targetAppId suspended:YES];
            [[ContextHostManager sharedInstance] hostViewForBundleID:targetAppId];
            NSLog(@"Attempting to host...");
            [self performSelector:@selector(beginHosting) withObject:nil afterDelay:0.5];
        }else{
            NSLog(@"Hosting!");
        }
    }else{
        [self showCantHostView];
    }
}

#pragma mark - ContextHostManagerExternalSceneDelegate

-(void)contextManager:(id)manager scene:(FBScene *)scene sceneStackDidChange:(UIView *)sceneStack{
    [self cleanUpSubviews];
    activeHostView = sceneStack;
    [containerView addSubview:sceneStack];
    [self layoutContextView];
}

-(void)contextManager:(id)manager scene:(FBScene *)scene externalSceneStackDidChange:(UIView *)sceneStack{
    [activeHostView addSubview:sceneStack];
    [self layoutContextView];
}


-(void)layoutContextView{
    CGRect frame = activeHostView.frame;
    frame.origin.x = 0;
    frame.origin.y = -NEGATIVE_SPACE;
    activeHostView.frame = frame;
    
    for (UIView *v in activeHostView.subviews) {
        v.frame = activeHostView.bounds;
    }
    
//    [UIView animateWithDuration:0.3 animations:^{
//        activeHostView.alpha = 1;
//    }];
}

-(void)cleanUpSubviews{
    activeHostView = nil;
    for (UIView *v in containerView.subviews) {
        if (![v isKindOfClass:[UIActivityIndicatorView class]]) {
            [v removeFromSuperview];
        }
    }
}


-(BOOL)safeToHost:(NSString *)bundleId{
    NSString *frontMostBundleId = [[(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication] bundleIdentifier];
    return ![frontMostBundleId isEqualToString:bundleId];
}


-(void)showCantHostView{
    showingCantHost = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *wontHostLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, 80)];
        wontHostLabel.numberOfLines = 3;
        [wontHostLabel setTextAlignment:NSTextAlignmentCenter];
        wontHostLabel.text = @"Hi, I can't show you this app right now because it is already open,\nso here is a whale instead.";
        wontHostLabel.center = CGPointMake(containerView.center.x, containerView.center.y+60);
        [containerView addSubview:wontHostLabel];

        LOTAnimationView *animation = [LOTAnimationView animationWithFilePath:@"/Library/Application Support/MHXI/empty_status.json"];
        animation.frame = CGRectMake(0, 0, 200, 200);
        [animation setContentMode:UIViewContentModeScaleAspectFit];
        animation.center = CGPointMake(containerView.center.x, containerView.center.y-60);
        [containerView addSubview:animation];
        [animation setLoopAnimation:YES];
        [animation play];
    });
}



static SBApplication *applicationForID(NSString *applicationID){
    id controller = [NSClassFromString(@"SBApplicationController") sharedInstance];

    if ([controller respondsToSelector:@selector(applicationWithDisplayIdentifier:)]) {
        return [controller applicationWithDisplayIdentifier:applicationID];
    } else {
        return [controller applicationWithBundleIdentifier:applicationID];
    }
}

-(FCChatHead *)chatHeadForChatID:(NSString *)chatID{
    for (FCChatHead *c in ChatHeadsController.chatHeads) {
        if ([c.chatID isEqualToString:chatID]) {
            return c;
        }
    }
    return nil;
}


@end
