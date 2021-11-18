//
//  MHViewController.h
//  MessageHeadsXI
//
//  Created by Will Smillie on 8/3/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FCChatHeads.h"
#import "ContextHostManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "MHChatHeadView.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <Lottie/Lottie.h>
#import <ChatHeadHelpers.h>

@interface MHViewController : UIViewController <FCChatHeadsControllerDatasource,FCChatHeadsControllerDelegate>

+ (instancetype)sharedInstance;

-(void)addChatIfNeeded:(NSString *)chatId;
-(void)alertWithMessage:(NSString *)message;

@property (nonatomic, strong) NSString *targetAppId;

@end
