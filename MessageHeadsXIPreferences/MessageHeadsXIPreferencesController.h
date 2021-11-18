//
//  MessageHeadsXIPreferencesController.h
//  MessageHeadsXIPreferences
//
//  Created by Will Smillie on 8/18/18.
//  Copyright (c) 2018 ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
//#import "interfaces.h"
#import <spawn.h>
#import <L360Confetti/L360ConfettiArea.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <objc/runtime.h>
#include <stdio.h>
#import <MessageUI/MessageUI.h>

#import <AppList.h>

@interface MessageHeadsXIPreferencesController : PSListController<L360ConfettiAreaDelegate, MFMailComposeViewControllerDelegate, PaywallViewControllerDelegate>

@property(nonatomic, strong) L360ConfettiArea *confettiArea;
@property(nonatomic, strong) NSMutableArray *dylibsArray;

- (id)getValueForSpecifier:(PSSpecifier*)specifier;
- (void)setValue:(id)value forSpecifier:(PSSpecifier*)specifier;
- (void)followOnTwitter:(PSSpecifier*)specifier;
- (void)visitWebSite:(PSSpecifier*)specifier;
- (void)makeDonation:(PSSpecifier*)specifier;
- (void)support:(PSSpecifier*)specifier;


-(void)burst;

@end
