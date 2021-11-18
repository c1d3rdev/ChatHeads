#import <Foundation/Foundation.h>
#import "ContextInterfaces.h"
#import "interfaces.h"
#import <objc/runtime.h>

#define IS_IOS11orHIGHER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)

@class ContextHostManager;
@protocol ContextHostManagerExternalSceneDelegate <NSObject>
-(void)contextManager:(id)manager scene:(FBScene *)scene sceneStackDidChange:(UIView *)sceneStack;
-(void)contextManager:(id)manager scene:(FBScene *)scene externalSceneStackDidChange:(UIView *)sceneStack;
@end

@interface ContextHostManager : NSObject
@property (nonatomic, weak) id <ContextHostManagerExternalSceneDelegate> sceneDelegate;
+ (id)sharedInstance;

-(UIView *)hostViewForBundleID:(NSString *)bundleId;
-(UIView *)hostViewForSceneLayer:(FBSceneLayer *)layer;

-(void)stopHostingForBundleId:(NSString *)bundleId;
-(BOOL)isHostViewHosting:(UIView *)hostView;

@end
