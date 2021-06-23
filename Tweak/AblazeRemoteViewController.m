#include "AblazeRemoteViewController.h"

@implementation AblazeRemoteViewController
+ (BOOL)_shouldUseXPCObjects {
  return NO;
}

+ (NSInvocation *)requestViewControllerWithConnectionHandler:(void (^)(AblazeRemoteViewController *,
                                                                       NSError *))block {
  return [self requestViewController:@"AblazeViewController"
      fromServiceWithBundleIdentifier:@"com.level3tjg.AblazeUIService"
                    connectionHandler:^(_UIRemoteViewController *remoteViewController,
                                        NSError *error) {
                      // remoteViewController.serviceViewShouldShareTouchesWithHost = YES;
                      // remoteViewController.view.layer.securityMode = kCALayerSecurityModeSecure;
                      // _UIRemoteView *remoteView = object_getIvar(
                      //     remoteViewController,
                      //     class_getInstanceVariable([remoteViewController class],
                      //                               "_serviceViewControllerRemoteView"));
                      // remoteView.layer.rendersAsynchronously = YES;
                      block((AblazeRemoteViewController *)remoteViewController, error);
                    }];
}

+ (NSXPCInterface *)exportedInterface {
  return [NSXPCInterface interfaceWithProtocol:@protocol(AblazeViewControllerRemoteHost)];
}

+ (NSXPCInterface *)serviceViewControllerInterface {
  return [NSXPCInterface interfaceWithProtocol:@protocol(AblazeViewControllerRemoteService)];
}

- (void)nowPlayingInfoDidChange {
  [self.parentViewController performSelector:@selector(nowPlayingInfoDidChange)];
}

@end