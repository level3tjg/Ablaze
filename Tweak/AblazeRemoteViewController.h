#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "Ablaze.h"

@interface CALayerHost : CALayer
@property BOOL inheritsSecurity;
@property BOOL rendersAsynchronously;
@end

@interface _UIRemoteView : UIView
@property(nonatomic, readonly, strong) CALayerHost *layer;
@end

@interface _UIRemoteViewController (Private)
@property BOOL serviceViewShouldShareTouchesWithHost;
@end

@interface AblazeRemoteViewController : _UIRemoteViewController
+ (NSInvocation *)requestViewControllerWithConnectionHandler:(void (^)(AblazeRemoteViewController *,
                                                                       NSError *))block;
@end