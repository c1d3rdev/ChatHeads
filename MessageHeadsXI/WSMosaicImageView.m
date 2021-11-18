//
//  WSMosaicImageView.m
//  imageTest
//
//  Created by Will Smillie on 8/17/18.
//  Copyright © 2018 Red Door Endeavors. All rights reserved.
//

#import "WSMosaicImageView.h"

#define ratio 1.5//1.618
#define margin 3
#define diameter (self.frame.size.width/ratio)-margin

@interface WSMosaicImageView (){
    NSMutableArray *images;
}
@end

@implementation WSMosaicImageView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        images = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

-(void)addImage:(UIImage *)image withInitials:(NSString *)initials{
    if (!image) {
        BMInitialsPlaceholderView *placeholder = [[BMInitialsPlaceholderView alloc] initWithDiameter:self.frame.size.height];
        [placeholder batchUpdateViewWithInitials:[self initialStringForPersonString:initials] circleColor:[self randomCircleColor] textColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:24]];
        
        UIGraphicsBeginImageContextWithOptions(placeholder.bounds.size, placeholder.opaque, 0.0);
        [placeholder.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();


        [images addObject:img];
    }else{
        [images addObject:image];
    }

    [self layout];
}

-(void)setImagseArray:(NSArray *)images{
    images = [images mutableCopy];
    [self layout];
}


-(void)layout{
    self.frame = CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height);

    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }

    for (int i=0; i<images.count; i++) {
        [self addSubview:[self imageViewForIndex:i]];
    }
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

-(void)updateLayout{
    
}

-(UIImageView *)imageViewForIndex:(NSUInteger)i{
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:[self frameForIndex:i]];
    imgv.contentMode = UIViewContentModeScaleAspectFill;
    imgv.image = images[i];
    
    if (images.count > 1) {
        imgv.layer.cornerRadius = imgv.frame.size.height/2;
        imgv.clipsToBounds = YES;
        imgv.layer.borderWidth = 2;
        imgv.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    return imgv;
}

-(CGRect)frameForIndex:(NSUInteger)i{
    switch (images.count) {
        case 1:
            return self.bounds;
        case 2:
            return [self frameForIndexOutOfTwo:i];
        default:
            return [self frameForIndexOutOfTwo:i];
    }
}

-(CGRect)frameForIndexOutOfTwo:(NSUInteger)i{
    if (i==0) {
        return CGRectMake(margin, margin, diameter, diameter);
    }else{
        return CGRectMake(diameter-(margin*5), diameter-(margin*5), diameter, diameter);
    }
}

//-(CGRect)frameForIndexOutOfThree:(NSUInteger)i{
//    if (i==0) {
//        return CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
//    }else if (i==1) {
//        return CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height/2);
//    }else{
//        return CGRectMake(self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height);
//    }
//}
//
//-(CGRect)frameForIndexOutOfFour:(NSUInteger)i{
//    if (i==0) {
//        return CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
//    }else if (i==1) {
//        return CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height/2);
//    }else if (i==2){
//        return CGRectMake(self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height);
//    }else{
//        return CGRectMake(0, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height);
//    }
//}
//


- (UIColor *)randomCircleColor {
    return [UIColor colorWithHue:arc4random() % 256 / 256.0 saturation:0.7 brightness:0.8 alpha:1.0];
}

- (NSString *)initialStringForPersonString:(NSString *)personString {

    if (personString) {
        if (personString.length > 0) {
            NSMutableString * firstCharacters = [NSMutableString string];
            NSArray * words = [personString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            for (NSString * word in words) {
                if ([word length] > 0) {
                    NSString * firstLetter = [word substringToIndex:1];
                    [firstCharacters appendString:[firstLetter uppercaseString]];
                }
            }
            return firstCharacters;
        }
    }

    return @"🤷";
}




@end
