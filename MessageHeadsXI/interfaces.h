//
//  interfaces.h
//  MessageHeadsXI
//
//  Created by Will Smillie on 7/17/18.
//
//#import <Preferences/Preferences.h>
#import "ContextInterfaces.h"
#import "IPC.h"


@interface UIApplication (Private)
- (id)displayIdentifier;
@end
@interface UITextEffectsWindow : UIWindow
+ (id)sharedTextEffectsWindow;
@end

@interface UIDevice (mh)
-(void)setOrientation:(long long)arg1 animated:(BOOL)arg2 ;
@end


@interface BBServer : NSObject
-(void)withdrawBulletinID:(id)arg1 ;
-(void)withdrawBulletinRequestsWithRecordID:(id)arg1 forSectionID:(id)arg2;
-(void)_removeBulletins:(id)arg1 forSectionID:(id)arg2 shouldSync:(BOOL)arg3 ;
-(void)_removeBulletin:(id)arg1 shouldSync:(BOOL)arg2;
-(void)_clearBulletinIDs:(id)arg1 forSectionID:(id)arg2 shouldSync:(BOOL)arg3 ;
@end
@interface BBBulletinServer
-(void)observer:(id)arg1 removeBulletin:(id)arg2;
-(void)_dismissWithdrawnBannerIfNecessaryFromBulletinIDs:(id)arg1;
@end
@interface BBBulletin : NSObject
@property (copy, nonatomic) NSString* sectionID;
@property (nonatomic,copy) NSString * recordID;
@property (nonatomic,copy) NSString * bulletinID;
@property (nonatomic,retain) NSDictionary * context;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic,copy) NSString * message;
@property (assign,nonatomic) BOOL clearable;
@property (nonatomic,retain) NSDate * date;
@property (nonatomic,retain) NSDate * publicationDate;
@property (nonatomic,retain) NSDate * lastInterruptDate;
-(void)setShowsMessagePreview:(BOOL)arg1 ;
-(NSString *)bulletinID;
-(NSString *)recordID;
-(void)noteFinishedWithBulletinID:(id)arg1 ;
-(id)dismissAction;
-(void)setDefaultAction:(id)arg1 ;
-(id)responseForAction:(id)arg1 ;
@property (nonatomic,copy) NSMutableDictionary *actions;
@end
@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(bool)arg1;
@end

@interface SBBannerController : NSObject
+ (id)sharedInstance;

- (id)_bannerContext;
- (void)_replaceIntervalElapsed;
- (void)_dismissIntervalElapsed;
@end
@interface BBBulletinRequest : BBBulletin
@end
@interface BBAction : NSObject
+ (id)action;
+ (id)actionWithLaunchURL:(id)url;
@end
@interface SBBulletinBannerController : NSObject
+ (id)sharedInstance;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(NSUInteger)arg3;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(NSUInteger)arg3 playLightsAndSirens:(BOOL)arg4 withReply:(id)arg5;
@end
@interface SBLockScreenManager
+(id)sharedInstance;
-(BOOL)isUILocked;
@end
@interface SBLockScreenViewControllerBase
-(BOOL)isInScreenOffMode;
@end


@interface UIApplication (MHXI)
-(void)_setForcedUserInterfaceLayoutDirection:(long long)arg1 ;
+(id)sharedApplication;
- (id)_mainScene;
+(NSString *)displayIdentifier;
-(void) RA_updateWindowsForSizeChange:(CGSize)size isReverting:(BOOL)revert;
-(void) RA_forceRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation isReverting:(BOOL)reverting;
-(BOOL)_isSupportedOrientation:(long long)arg1 ;
-(void)noteActiveInterfaceOrientationWillChangeToOrientation:(long long)arg1 ;
-(void)_setStatusBarOrientation:(long long)arg1 animated:(BOOL)arg2 ;
-(void)_setStatusBarOrientation:(long long)arg1 animated:(BOOL)arg2 ;
-(id)statusBarWindow;
-(void)terminateWithSuccess;
@end
@interface UIWindow (MHXI)
+ (void)setAllWindowsKeepContextInBackground:(BOOL)arg1;
-(void)setKeepContextInBackground:(BOOL)arg1 ;
-(void)_setStatusBarOrientation:(long long)arg1 animated:(BOOL)arg2 ;
-(void)_setRotatableViewOrientation:(long long)arg1 updateStatusBar:(BOOL)arg2 duration:(double)arg3 force:(BOOL)arg4 ;


@end

@interface UIScreen (MH)
-(void)_setInterfaceOrientation:(long long)arg1 ;
@end


@interface UIStatusBarWindow : UIWindow
@end

@interface SBMedusaDecoratedDeviceApplicationSceneViewController : UIViewController
@end


@interface SBDeviceApplicationSceneViewController

@end
@interface SBDeviceApplicationSceneHandle
-(NSString *)sceneIdentifier;
-(id)_initWithScene:(id)arg1 ;
-(id)_initWithApplication:(id)arg1 definition:(id)arg2 scene:(id)arg3 displayIdentity:(id)arg4;
@end

@interface UIApplicationSceneSettings

@end



@interface SBApplication (ContextHostManager)
@property NSString *bundleIdentifier;
@property NSString *displayIdentifier;
@property NSString *displayName;
@end


@interface FBSceneLayerManager : NSObject
@property (nonatomic,readonly) NSOrderedSet * layers;                   //@synthesize layers=_layers - In the implementation block
@end

@interface FBSceneHostManager : NSObject
-(void)setDefaultBackgroundColorWhileHosting:(UIColor *)arg1 ;
-(void)setDefaultBackgroundColorWhileNotHosting:(UIColor *)arg1 ;
-(id)hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)arg2 ;
-(void)enableHostingForRequester:(id)arg1 orderFront:(BOOL)arg2 ;
-(void)disableHostingForRequester:(id)arg1 ;
-(id)initWithLayerManager:(id)arg1 scene:(id)arg2 ;
- (void)enableHostingForRequester:(id)arg1 priority:(int)arg2;
@end

@interface _UIExternalSceneLayerHostView : UIView
-(id)initWithSceneLayer:(id)arg1 parentScene:(id)arg2 ;
@end


@interface _UIContextLayerHostView : UIView
-(id)initWithSceneLayer:(id)arg1 ;
@property (assign,nonatomic) unsigned long long renderingMode;
@end

@interface SBSceneManager
-(id)allScenes;
-(id)sceneIdentityForApplication:(id)arg1;
-(id)scenesMatchingPredicate:(id)arg1 ;
@end


@interface FBSceneLayer
-(NSString *)externalSceneID;
@end

@interface FBSMutableSceneSettings
- (void)setBackgrounded:(bool)arg1;
-(id)otherSettings;
@property (assign,getter=isForeground,nonatomic) BOOL foreground;
@end

@interface FBScene : NSObject
-(NSString *)identifier;
- (FBSceneHostManager *)hostManager;
- (id)mutableSettings;
-(void)updateSettings:(id)arg1 withTransitionContext:(id)arg2 completion:(/*^block*/id)arg3 ;
- (void)_applyMutableSettings:(id)arg1 withTransitionContext:(id)arg2 completion:(id)arg3;
-(void)updateSettings:(id)arg1 withTransitionContext:(id)arg2 ;
-(void)setMutableSettings:(FBSMutableSceneSettings *)arg1 ;
@end

@interface FBSceneManager
+(id)sharedInstance;
-(id)sceneWithIdentifier:(id)arg1 ;
-(id)fbsSceneWithIdentifier:(id)arg1 ;
-(void)_startLayerHostingForScene:(id)arg1 ;
-(void)_stopLayerHostingForScene:(id)arg1 ;
-(id)_rootWindowForRootDisplayIdentity:(id)arg1 createIfNecessary:(BOOL)arg2 ;
-(id)_rootWindowForDisplayConfiguration:(id)arg1 createIfNecessary:(BOOL)arg2 ;
@end


@interface FBWindowContextHostManager : NSObject
-(void)_updateHostViewFrameForRequester:(id)arg1 ;
- (void)enableHostingForRequester:(id)arg1 orderFront:(BOOL)arg2;
- (void)enableHostingForRequester:(id)arg1 priority:(int)arg2;
- (void)disableHostingForRequester:(id)arg1;
- (id)hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)arg2;
@end

@interface FBWindowContextHostWrapperView
- (void)updateFrame;
@end

@interface FBWindowContextHostView : UIView
- (BOOL)isHosting;
@end



@interface UIApplication (Private)
-(long long)_frontMostAppOrientation;
-(id)_accessibilityFrontMostApplication;
- (void)_relaunchSpringBoardNow;
- (id)_accessibilityFrontMostApplication;
- (void)launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended;
- (id)displayIdentifier;
- (void)setStatusBarHidden:(bool)arg1 animated:(bool)arg2;
void receivedStatusBarChange(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo);
void receivedLandscapeRotate();
void receivedPortraitRotate();
@end

@interface SBBannerContextView : UIView
@end

@interface SBAppSwitcherModel
+ (id)sharedInstance;
- (id)snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary;
@end

@interface SBAppSwitcherController : NSObject
- (id)_snapshotViewForDisplayItem:(id)arg1;
@end

@interface SBDisplayItem
+ (id)displayItemWithType:(NSString *)arg1 displayIdentifier:(id)arg2;
@end

@interface SBAppSwitcherSnapshotView : NSObject
-(void)_loadSnapshotSync;
@end

@interface _UIBackdropViewSettings : NSObject
+(id)settingsForStyle:(NSInteger)style graphicsQuality:(NSInteger)quality;
+(id)settingsForStyle:(NSInteger)style;
-(void)setDefaultValues;
-(id)initWithDefaultValues;
@end
@interface _UIBackdropViewSettingsCombiner : _UIBackdropViewSettings
@end
@interface _UIBackdropView : UIView
-(id)initWithFrame:(CGRect)frame autosizesToFitSuperview:(BOOL)autoresizes settings:(_UIBackdropViewSettings*)settings;
@end

@interface SBAppToAppWorkspaceTransaction
- (void)begin;
- (id)initWithAlertManager:(id)alertManager exitedApp:(id)app;
- (id)initWithAlertManager:(id)arg1 from:(id)arg2 to:(id)arg3 withResult:(id)arg4;
- (id)initWithTransitionRequest:(id)arg1;
@end

@interface FBWorkspaceEvent : NSObject
+ (instancetype)eventWithName:(NSString *)label handler:(id)handler;
@end

@interface FBWorkspaceEventQueue : NSObject
+ (instancetype)sharedInstance;
- (void)executeOrAppendEvent:(FBWorkspaceEvent *)event;
@end
@interface SBDeactivationSettings
-(id)init;
-(void)setFlag:(int)flag forDeactivationSetting:(unsigned)deactivationSetting;
@end
@interface SBWorkspaceApplicationTransitionContext : NSObject
@property(nonatomic) _Bool animationDisabled; // @synthesize animationDisabled=_animationDisabled;
- (void)setEntity:(id)arg1 forLayoutRole:(int)arg2;
@end
@interface SBWorkspaceDeactivatingEntity
@property(nonatomic) long long layoutRole; // @synthesize layoutRole=_layoutRole;
+ (id)entity;
@end
@interface SBWorkspaceHomeScreenEntity : NSObject
@end
@interface SBMainWorkspaceTransitionRequest : NSObject
- (id)initWithDisplay:(id)arg1;
@end

static int const UITapticEngineFeedbackPeek = 1001;
static int const UITapticEngineFeedbackPop = 1002;
@interface UITapticEngine : NSObject
- (void)actuateFeedback:(int)arg1;
- (void)endUsingFeedback:(int)arg1;
- (void)prepareUsingFeedback:(int)arg1;
@end
@interface UIDevice (Private)
-(UITapticEngine*)_tapticEngine;
@end

OBJC_EXTERN UIImage* _UICreateScreenUIImage(void) NS_RETURNS_RETAINED;
