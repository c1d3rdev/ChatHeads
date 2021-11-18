//
//  MHChatHeadView.m
//  MessageHeadsXI
//
//  Created by Will Smillie on 8/6/18.
//

#import "MHChatHeadView.h"
#import "FCChatHeadsController.h"

@implementation MHChatHeadView

-(instancetype)init{
    if (self = [super initWithFrame:[FCChatHeadsController chatHeadsController].DEFAULT_CHAT_HEAD_FRAME]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 4.0f;
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;

        CGRect f = [FCChatHeadsController chatHeadsController].DEFAULT_CHAT_HEAD_FRAME; f.origin.x = 0; f.origin.y = 0;
        self.groupChatPicView = [[WSMosaicImageView alloc] initWithFrame:f];
        self.groupChatPicView.backgroundColor = [UIColor whiteColor];
        self.groupChatPicView.layer.cornerRadius = [FCChatHeadsController chatHeadsController].DEFAULT_CHAT_HEAD_FRAME.size.height/2;
        self.groupChatPicView.layer.masksToBounds = YES;
        self.groupChatPicView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.groupChatPicView.layer.borderWidth = 0;

        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:self.groupChatPicView.layer.bounds cornerRadius:self.groupChatPicView.layer.cornerRadius] CGPath];
        [self addSubview:self.groupChatPicView];
        
        
        CGRect r = CGRectMake(0, 0, 20, 20);
        self.appIconImageView = [[UIImageView alloc] initWithFrame:r];
        self.appIconImageView.center = CGPointMake(self.groupChatPicView.center.x, self.groupChatPicView.frame.size.height-10);
        self.appIconImageView.backgroundColor = [UIColor whiteColor];
        self.appIconImageView.layer.cornerRadius = 10;
        self.appIconImageView.clipsToBounds = YES;
        self.appIconImageView.layer.borderWidth = 1;
        self.appIconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:self.appIconImageView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect f = [FCChatHeadsController chatHeadsController].DEFAULT_CHAT_HEAD_FRAME; f.origin.x = 0; f.origin.y = 0;
    self.groupChatPicView.frame = f;
}

@end
