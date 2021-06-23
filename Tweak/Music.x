#include "Music.h"

extern NSMutableDictionary *prefs;

static AblazeRemoteViewController *ablazeViewController;

%hook MusicLyricsBackgroundView
- (void)setAlpha:(CGFloat)alpha {
  %orig(0.0101);
}
%end

%hook MusicNowPlayingControlsViewController
%property (nonatomic, retain) UIView *ablazeView;
%property (nonatomic, strong) NSProxy *ablazeProxy;
- (void)viewDidLoad {
  %orig;
  [self addChildViewController:ablazeViewController];
  self.ablazeView = ablazeViewController.view;
  self.ablazeProxy = ablazeViewController.serviceViewControllerProxy;
  self.ablazeView.frame = UIScreen.mainScreen.bounds;
  self.ablazeView.alpha = 0.99;
}
- (void)viewWillAppear:(BOOL)animated {
  %orig;
  [self.ablazeProxy performSelector:@selector(setCrossfadeDuration:) withObject:@0];
  [self performSelector:@selector(nowPlayingInfoDidChange)];
  [self.view insertSubview:self.ablazeView atIndex:0];
}
- (void)viewDidAppear:(BOOL)animated {
  %orig;
  [self.ablazeProxy performSelector:@selector(setCrossfadeDuration:) withObject:prefs[@"crossfadeDuration"]];
}
- (void)viewDidDisappear:(BOOL)animated {
  %orig;
  [self.ablazeView removeFromSuperview];
  [self.ablazeProxy performSelector:@selector(setCrossfadeDuration:) withObject:@0];
}
%new
- (void)nowPlayingInfoDidChange {
  MPCPlayerResponseItem *currentItem = object_getIvar(self.parentViewController, class_getInstanceVariable([self.parentViewController class], "currentItem"));
  if (currentItem) {
    MPArtworkCatalog *artworkCatalog = [currentItem.metadataObject.song artworkCatalog];
    if (artworkCatalog.hasImageOnDisk)
      [self.ablazeProxy performSelector:@selector(setBackgroundArtwork:) withObject:[artworkCatalog bestImageFromDisk]];
    else
      [artworkCatalog requestImageWithCompletionHandler:^(UIImage *artwork) {
        [self.ablazeProxy performSelector:@selector(setBackgroundArtwork:) withObject:artwork];
      }];
  }
}
%end

%hook NowPlayingQueueHeaderView
- (void)setBackgroundColor:(UIColor *)color {
  %orig([UIColor clearColor]);
}
%end

%hook BackdropView
- (void)setHidden:(bool)hidden {
  %orig(YES);
}
%end

%ctor {
  if ([prefs[@"enableMusic"] boolValue] && IN_MUSIC) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [AblazeRemoteViewController requestViewControllerWithConnectionHandler:^(AblazeRemoteViewController *viewController, NSError *error) {
        if (!error) {
          ablazeViewController = viewController;
          [ablazeViewController.serviceViewControllerProxy performSelector:@selector(setBundleIdentifier:) withObject:NSBundle.mainBundle.bundleIdentifier];
          %init(_ungrouped, BackdropView = NSClassFromString(@"MusicApplication.BackdropView"), NowPlayingQueueHeaderView = NSClassFromString(@"MusicApplication.NowPlayingQueueHeaderView"));
        } else {
          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ablaze" message:[NSString stringWithFormat:@"Error connecting to AlbazeUIService\n\n%@", error] preferredStyle:UIAlertControllerStyleAlert];
          [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
          }]];
          UIWindow *keyWindow;
          for (UIWindow *window in UIApplication.sharedApplication.windows) {
            if (window.isKeyWindow) {
              keyWindow = window;
              break;
            }
          }
          [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
      }];
    });
  }
}