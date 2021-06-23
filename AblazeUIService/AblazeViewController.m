#include "AblazeViewController.h"

@implementation AblazeViewController

- (instancetype)init {
  if (self = [super init]) {
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(nowPlayingInfoDidChange)
               name:@"kMRMediaRemoteNowPlayingInfoDidChangeNotification"
             object:nil];
    self.overrideUserInterfaceStyle = NO;
    self.ablazeView = [NSClassFromString(@"MusicLyricsBackgroundView") new];
    self.ablazeView.frame = UIScreen.mainScreen.bounds;
    self.ablazeView.layer.securityMode = kCALayerSecurityModeSecure;
    self.view.layer.securityMode = kCALayerSecurityModeSecure;
    [self.view addSubview:self.ablazeView];
  }
  return self;
}

- (void)setBackgroundArtwork:(UIImage *)artwork {
  self.ablazeView.backgroundArtwork = artwork;
}

- (void)nowPlayingInfoDidChange {
  MRMediaRemoteGetNowPlayingInfo(
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(CFDictionaryRef result) {
        if (result) {
          NSData *imageData = [(__bridge NSDictionary *)result
              objectForKey:@"kMRMediaRemoteNowPlayingInfoArtworkData"];
          MRClient *client = [[MRClient alloc]
              initWithData:[(__bridge NSDictionary *)result
                               objectForKey:@"kMRMediaRemoteNowPlayingInfoClientPropertiesData"]];
          if (imageData)
            if ([self.bundleIdentifier isEqualToString:@"com.apple.springboard"] ||
                [self.bundleIdentifier isEqualToString:client.bundleIdentifier])
              self.ablazeView.backgroundArtwork = [UIImage imageWithData:imageData];
        }
      });
}

- (void)setCrossfadeDuration:(NSNumber *)duration {
  self.ablazeView.crossfadeDuration = [duration floatValue];
}

+ (BOOL)_shouldUseXPCObjects {
  return NO;
}

+ (NSXPCInterface *)_exportedInterface {
  return [NSXPCInterface interfaceWithProtocol:@protocol(AblazeViewControllerRemoteService)];
}

+ (NSXPCInterface *)_remoteViewControllerInterface {
  return [NSXPCInterface interfaceWithProtocol:@protocol(AblazeViewControllerRemoteHost)];
}

@end