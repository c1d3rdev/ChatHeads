//
//  SwitchesMessagingServer.h
//  switches
//
//  Created by Will Smillie on 6/11/19.
//

#import <Foundation/Foundation.h>
#import "IPC.h"
#import <rocketbootstrap/rocketbootstrap.h>

@interface ChatHeadsMessagingServer : NSObject {
    CPDistributedMessagingCenter * _messagingCenter;
}
+ (instancetype)sharedInstance;
@property (nonatomic, strong) NSMutableArray *registeredAppIds;
@property (nonatomic, strong) NSMutableArray *mutedConversations;

@end
