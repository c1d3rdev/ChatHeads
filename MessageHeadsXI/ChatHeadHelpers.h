//
//  ChatHeadHelpers.h
//  MessageHeadsXI
//
//  Created by Will Smillie on 3/7/20.
//

#import <Foundation/Foundation.h>
#import "interfaces.h"
#import "ContextInterfaces.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatHeadHelpers : NSObject

+(UIImage *)imageForBundleId:(NSString *)bundleId;
+(NSString *)frontMostBundleId;
+ (UIImage *)iconImageForIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
