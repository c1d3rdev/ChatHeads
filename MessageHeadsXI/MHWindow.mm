#line 1 "/Users/willsmillie/Desktop/Dev/iOS/Jailbreak/MessageHeadsXI/MessageHeadsXI/MHWindow.xm"







#import "MHWindow.h"
#import <AppSupport/AppSupport.h>


@implementation MHWindow


+ (id)sharedWindow {
    static MHWindow *window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[self alloc] init];
    });
    
    return window;
}

- (id)init{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        self.windowLevel = UIWindowLevelAlert-1;
        [self setHidden:NO];
        self.alpha = 1;
        self.rootViewController = [[MHViewController alloc] init];
        self.userInteractionEnabled = YES;
        
        
        CPDistributedMessagingCenter * messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.c1d3r.MessageHeadsXI"];
        [messagingCenter runServerOnCurrentThread];
        
        
        [messagingCenter registerForMessageName:@"messageThatHasInfo" target:self selector:@selector(handleMessageNamed:withUserInfo:)];
        [messagingCenter registerForMessageName:@"message" target:self selector:@selector(handleSimpleMessageNamed:)];
    }
    return self;
    [self makeKeyAndVisible];
}

-(void)makeKeyAndVisible{
    [super makeKeyAndVisible];
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitTestResult = [super hitTest:point withEvent:event];
    if ([hitTestResult isKindOfClass:[FCChatHead class]]) {
        return hitTestResult;
    }
    
    return nil;
}

@end
