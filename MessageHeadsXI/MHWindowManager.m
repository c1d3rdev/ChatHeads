//
//  MHWindowManager.m
//  MessageHeadsXI
//
//  Created by Will Smillie on 3/11/19.
//

#import "MHWindowManager.h"

@implementation MHWindowManager

+(instancetype) sharedInstance
{
    if (![NSBundle.mainBundle.bundleIdentifier isEqual:@"com.apple.springboard"]) {
        static MHWindowManager *sharedMyManager = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedMyManager = [[self alloc] init];
        });
        return sharedMyManager;
    }else{
        return nil;
    }
}

-(instancetype)init{
    if (self = [super init]) {
        self.currentData = [[NSMutableDictionary alloc] init];
    }
    return self;
}


@end
