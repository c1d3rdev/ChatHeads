//
//  ChatHeadHelpers.m
//  MessageHeadsXI
//
//  Created by Will Smillie on 3/7/20.
//

#import "ChatHeadHelpers.h"

@implementation ChatHeadHelpers


+(UIImage *)imageForBundleId:(NSString *)bundleId{
    if (@available(iOS 13, *)) {
        return [self iconImageForIdentifier:bundleId];
    } else {
        SBApplication *app = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleId];
        id appIcon = [[NSClassFromString(@"SBApplicationIcon") alloc] initWithApplication:app];
        UIImage *icon = [appIcon generateIconImage:1];
        return icon;
    }
}


+(NSString *)frontMostBundleId{
    SBApplication *frontMostApp = ((SpringBoard *)[UIApplication sharedApplication])._accessibilityFrontMostApplication;
    return frontMostApp.displayIdentifier;
}

//13 icon gen
+ (UIImage *)iconImageForIdentifier:(NSString *)identifier {
    
    SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
    SBIcon *icon = [iconController.model expectedIconForDisplayIdentifier:identifier];
    
    struct CGSize imageSize;
    imageSize.height = 60;
    imageSize.width = 60;
    
    struct SBIconImageInfo imageInfo;
    imageInfo.size  = imageSize;
    imageInfo.scale = [UIScreen mainScreen].scale;
    imageInfo.continuousCornerRadius = 12;
    
    return [icon generateIconImageWithInfo:imageInfo];
}



@end
