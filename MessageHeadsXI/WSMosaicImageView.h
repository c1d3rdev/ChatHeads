//
//  WSMosaicImageView.h
//  imageTest
//
//  Created by Will Smillie on 8/17/18.
//  Copyright © 2018 Red Door Endeavors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMInitialsPlaceholderView.h"

@interface WSMosaicImageView : UIView


-(void)addImage:(UIImage *)image withInitials:(NSString *)initials;
-(void)updateLayout;

@end
