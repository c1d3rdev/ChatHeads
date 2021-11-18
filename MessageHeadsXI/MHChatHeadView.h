//
//  MHChatHeadView.h
//  MessageHeadsXI
//
//  Created by Will Smillie on 8/6/18.
//

#import <UIKit/UIKit.h>
#import "FCChatHeadsController.h"
#import <GLGroupChatPicView/GLGroupChatPicView.h>
#import "WSMosaicImageView.h"

@interface MHChatHeadView : UIView

@property (nonatomic, strong) NSMutableDictionary *chatData;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) WSMosaicImageView *groupChatPicView;
//@property (nonatomic, strong) __block GLGroupChatPicView *groupChatPicView;
@property (nonatomic, strong) UIImageView *appIconImageView;

@end
