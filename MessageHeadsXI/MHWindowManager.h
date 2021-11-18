//
//  MHWindowManager.h
//  MessageHeadsXI
//
//  Created by Will Smillie on 3/11/19.
//

#import <Foundation/Foundation.h>
#import "interfaces.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHWindowManager : NSObject
+(instancetype) sharedInstance;

@property (nonatomic, strong) NSMutableDictionary *currentData;
@property (nonatomic) BOOL hasRecievedData;

@end

NS_ASSUME_NONNULL_END
