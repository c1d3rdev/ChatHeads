//
//  MessageHeadsXIPreferencesController.m
//  MessageHeadsXIPreferences
//
//  Created by Will Smillie on 8/18/18.
//  Copyright (c) 2018 ___ORGANIZATIONNAME___. All rights reserved.
//

#import "MessageHeadsXIPreferencesController.h"
#import "PaywallViewController.h"
#import <Preferences/PSSpecifier.h>
#import <rocketbootstrap/rocketbootstrap.h>

#import "ExtensionsTableViewController.h"

#define kSetting_Example_Name @"NameOfAnExampleSetting"
#define kSetting_Example_Value @"ValueOfAnExampleSetting"

#define kSetting_TemplateVersion_Name @"TemplateVersionExample"
#define kSetting_TemplateVersion_Value @"1.0"

#define kSetting_Text_Name @"TextExample"
#define kSetting_Text_Value @"Go Red Sox!"

#define kUrl_FollowOnTwitter @"https://twitter.com/c1d3rDev"
#define kUrl_FollowAhmedOnTwitter @"https://twitter.com/lazynagy"
#define kUrl_MakeDonation @"https://paypal.me/willsmillie"

#define kPrefs_Path @"/var/mobile/Library/Preferences"
#define kPrefs_KeyName_Key @"key"
#define kPrefs_KeyName_Defaults @"defaults"

#define tweakName @"ChatHeads"
NSString *const dylibDirectory = @"/Library/MobileSubstrate/DynamicLibraries";

@implementation MessageHeadsXIPreferencesController
@synthesize confettiArea, dylibsArray;

-(void)viewDidLoad{
    [super viewDidLoad];

    UIBarButtonItem* respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(confirmRespring:)];
    self.navigationItem.rightBarButtonItem = respringButton;
    
    self.table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    confettiArea = [[L360ConfettiArea alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    confettiArea.userInteractionEnabled = NO;
    confettiArea.delegate = self;
    
    
    dylibsArray = [[NSMutableArray alloc] init];
    [self loadDylibs];

                if (dylibsArray.count == 0) {
                UIAlertController *noDylibs = [UIAlertController alertControllerWithTitle:@"No Extensions!" message:@"You'll need to install some extensions for chatheads to work! Each supported chat app has it's own extension to prevent everything from breaking if one extension becomes outdated." preferredStyle:UIAlertControllerStyleAlert];
                [noDylibs addAction:[UIAlertAction actionWithTitle:@"Show Me!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self viewExtensions:nil];
                }]];
                [noDylibs addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:noDylibs animated:YES completion:nil];
            }


    [self.table.superview insertSubview:confettiArea aboveSubview:self.table];
}

-(void)burst{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please Respring!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self respring];
    }]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    
    [confettiArea burstAt:confettiArea.center confettiWidth:10.0f numberOfConfetti:60];
}

-(void)paywallViewControllerDidCompleteAuthorization:(PaywallViewController *)paywallViewController{
    [self burst];
}

-(void)paywallViewControllerDidCancel:(PaywallViewController *)paywallViewController{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)respring{
    pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}


-(void)viewWillAppear:(BOOL)view{
    [super viewWillAppear:view];
}


- (void)loadDylibs {
    @autoreleasepool {
        NSError *dylibError = nil;
        NSArray *dylibContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dylibDirectory error:&dylibError];
        if (dylibContents == nil && dylibError != nil) {
            NSLog(@"[MH] Content Reading Erroing: %@", dylibError);
        }
        else {
            [dylibsArray removeAllObjects];
            
            for (NSString *dylibName in dylibContents) {
                if ([dylibName containsString:@"MH"] && [dylibName containsString:@"Support"]) {
                    if ([dylibName rangeOfString:@".dylib"].location != NSNotFound || [dylibName rangeOfString:@".disabled"].location != NSNotFound) {
                        NSMutableDictionary *dylib = [[NSMutableDictionary alloc] init];
                        
                        if ([dylibName rangeOfString:@".dylib"].location != NSNotFound) {
                            dylib[@"status"] = @(true);
                        }else if ([dylibName rangeOfString:@".disabled"].location != NSNotFound) {
                            dylib[@"status"] = @(false);
                        }
                        
                        NSRange dylibRange = [dylibName rangeOfString:@"."];
                        if (dylibRange.location != NSNotFound) {
                            dylib[@"name"] = [dylibName substringWithRange:NSMakeRange(0, dylibRange.location)];
                        }
                    
                        
                        dylib[@"path"] = [NSString stringWithFormat:@"%@/%@", dylibDirectory, dylibName];
                        dylib[@"plistPath"] = [NSString stringWithFormat:@"%@/%@.plist", dylibDirectory, dylib[@"name"]];
                        
                        NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:dylib[@"plistPath"]];
                        NSString *bundleId = plist[@"Filter"][@"Bundles"][0];
                        dylib[@"appId"] = bundleId;
                        dylib[@"appDisplayName"] = [[ALApplicationList sharedApplicationList] applications][bundleId];
                        
                        [dylibsArray addObject:dylib];
                    }
                }
            }
                
            if (dylibsArray.count > 1) {
                [dylibsArray sortUsingComparator:^NSComparisonResult(NSMutableDictionary *obj1, NSMutableDictionary *obj2) {
                    return [obj1[@"appDisplayName"] compare:obj2[@"appDisplayName"]];
                }];
            }
            
            [self reloadSpecifiers];
        }
    }
}







- (id)getValueForSpecifier:(PSSpecifier*)specifier
{
	id value = nil;
	
	NSDictionary *specifierProperties = [specifier properties];
	NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key];
    
    // get 'value' from 'defaults' plist (if 'defaults' key and file exists)
    NSMutableString *plistPath = [[NSMutableString alloc] initWithString:[specifierProperties objectForKey:kPrefs_KeyName_Defaults]];
    if (plistPath)
    {
        NSDictionary *dict = (NSDictionary*)[self initDictionaryWithFile:&plistPath asMutable:NO];
        
        id objectValue = [dict objectForKey:specifierKey];

        if (objectValue) {
            value = [NSString stringWithFormat:@"%@", objectValue];
            NSLog(@"[MH] read key '%@' with value '%@' from plist '%@'", specifierKey, value, plistPath);
        }else{
            NSLog(@"[MH] no value for app spec: %@", specifier);

            return nil;
        }
    }
    
	return value;
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier*)specifier;
{
	NSDictionary *specifierProperties = [specifier properties];
	NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key];

    NSMutableString *plistPath = [[NSMutableString alloc] initWithString:[specifierProperties objectForKey:kPrefs_KeyName_Defaults]];
    if (plistPath){
        NSMutableDictionary *dict = (NSMutableDictionary*)[self initDictionaryWithFile:&plistPath asMutable:YES];
        [dict setObject:value forKey:specifierKey];
        [dict writeToFile:plistPath atomically:YES];
        NSLog(@"[MH] saved key '%@' with value '%@' to plist '%@'", specifierKey, value, plistPath);
        
        
//        if ([[[ALApplicationList sharedApplicationList] applications] objectForKey:specifierKey]) {
//            for (NSDictionary *d in dylibsArray) {
//                if ([d[@"appId"] isEqualToString:specifierKey]) {
//                    CPDistributedMessagingCenter *center = [CPDistributedMessagingCenter centerNamed:@"com.c1d3r.messagehub"];
//                    rocketbootstrap_distributedmessagingcenter_apply(center);
//                    [center sendMessageName:@"toggleExtension" userInfo:@{@"bundleId": d[@"appId"], @"value": value}];
//                    break;
//                }
//            }
//        }
    }
}

- (id)initDictionaryWithFile:(NSMutableString**)plistPath asMutable:(BOOL)asMutable
{
	if ([*plistPath hasPrefix:@"/"])
		*plistPath = [NSString stringWithFormat:@"%@.plist", *plistPath];
	else
		*plistPath = [NSString stringWithFormat:@"%@/%@.plist", kPrefs_Path, *plistPath];
	
	Class class;
	if (asMutable)
		class = [NSMutableDictionary class];
	else
		class = [NSDictionary class];
	
	id dict;	
	if ([[NSFileManager defaultManager] fileExistsAtPath:*plistPath])
		dict = [[class alloc] initWithContentsOfFile:*plistPath];	
	else
		dict = [[class alloc] init];
	
	return dict;
}




- (void)followOnTwitter:(PSSpecifier*)specifier
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_FollowOnTwitter]];
}

- (void)followAhmedOnTwitter:(PSSpecifier*)specifier
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_FollowAhmedOnTwitter]];
}

- (void)support:(PSSpecifier*)specifier
{
    // From within your active view controller
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"c1d3rdev@gmail.com" message:@"If you're experiencing crashes, please install CrashReporter and send the crash logs." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
}
    
    
// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)makeDonation:(PSSpecifier *)specifier
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl_MakeDonation]];
}



- (id)specifiers
{
	if (_specifiers == nil) {
		NSMutableArray *specifiers = [[self loadSpecifiersFromPlistName:@"MessageHeadsXIPreferences" target:self] mutableCopy];
        

        
        if (dylibsArray.count >= 1) {
            PSSpecifier *spec = specifiers[0];
            [spec setProperty:@"footerText" forKey:@""];
            [specifiers replaceObjectAtIndex:0 withObject:spec];

            int i = 1;
            for (NSDictionary *dylib in dylibsArray) {
                if (dylib[@"appDisplayName"]) {
                    PSSpecifier* spec = [PSSpecifier preferenceSpecifierNamed:dylib[@"appDisplayName"] target:self set:@selector(setValue:forSpecifier:) get:nil detail:nil cell:[PSTableCell cellTypeFromString:@"PSStaticTextCell"] edit:nil];
//                    [spec setProperty:[NSNumber numberWithBool:false] forKey:@"default"];
//                    [spec setProperty:@(true) forKey:@"enabled"];
                    [spec setProperty:dylib[@"appId"] forKey:@"key"];
//                    [spec setProperty:@"com.c1d3r.ChatHeadsSettings" forKey:@"defaults"];
                    
                    [spec setProperty:[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:dylib[@"appId"]] forKey:@"iconImage"];
                    [specifiers insertObject:spec atIndex:i];
                }
                
                i++;
            }
        }
        
        _specifiers = [specifiers copy];
    }
    
    
    
	
	return _specifiers;
}

-(IBAction)viewExtensions:(id)sender{
    ExtensionsTableViewController *e = [[ExtensionsTableViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:e] animated:YES completion:nil];
}

- (id)init
{
	if ((self = [super init]))
	{
	}
	
	return self;
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
	[super dealloc];
}
#endif






-(IBAction)confirmRespring:(id)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure you want to respring?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        pid_t pid;
        const char* args[] = {"killall", "backboardd", NULL};
        posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
