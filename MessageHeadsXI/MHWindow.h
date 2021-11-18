//
//  UIWindow.h
//  MessageHeadsXI
//
//  Created by Will Smillie on 8/3/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MHViewController.h"



@interface MHWindow : UIWindow
+ (id)sharedWindow;
- (id)distribute;

+(NSString*)settingsPath;
+(NSMutableDictionary *)settings;
@end
