#include "LockScreen.h"
#include <MediaRemote/MediaRemote.h>

extern NSDictionary *prefs;
static AblazeRemoteViewController *ablazeViewController;
extern void initLSBackground();

%hook CSCoverSheetViewController
%property (nonatomic, retain) UIView *ablazeView;
%property (nonatomic, strong) NSProxy *ablazeProxy;
- (void)viewWillAppear:(BOOL)animated {
  if (self.showingMediaControls) {
    if (!self.ablazeView) {
      [self addChildViewController:ablazeViewController];
      self.ablazeView = ablazeViewController.view;
      self.ablazeProxy = ablazeViewController.serviceViewControllerProxy;
      self.ablazeView.frame = UIScreen.mainScreen.bounds;
      self.ablazeView.alpha = 1;
    }
  }
  %orig;
}
%new
- (void)nowPlayingInfoDidChange {
  MRMediaRemoteGetNowPlayingInfo(
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(CFDictionaryRef result) {
        if (result) {
          NSData *imageData = [(__bridge NSDictionary *)result
              objectForKey:@"kMRMediaRemoteNowPlayingInfoArtworkData"];
          if (imageData)
            [self.ablazeProxy performSelector:@selector(setBackgroundArtwork:) withObject:[UIImage imageWithData:imageData]];
        }
      });
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
- (void)_insertItem:(CSAdjunctListItem *)item animated:(BOOL)animated {
  %orig;
  if (self.ablazeView) {
    if ([item.identifier isEqualToString:@"SBDashBoardNowPlayingAssertionIdentifier"]) {
      if (animated)
        [UIView animateWithDuration:1 animations:^{
          self.ablazeView.alpha = 1;
        }];
      else
        self.ablazeView.alpha = 1;
    }
  }
}
- (void)_removeItem:(CSAdjunctListItem *)item animated:(BOOL)animated {
  %orig;
  if (self.ablazeView) {
    if ([item.identifier isEqualToString:@"SBDashBoardNowPlayingAssertionIdentifier"]) {
      if (animated)
        [UIView animateWithDuration:1 animations:^{
          self.ablazeView.alpha = 0;
        }];
      else
        self.ablazeView.alpha = 0;
    }
  }
}
%end

%ctor {
  if (false && IN_SPRINGBOARD) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [AblazeRemoteViewController requestViewControllerWithConnectionHandler:^(AblazeRemoteViewController *viewController, NSError *error) {
        if (!error) {
          ablazeViewController = viewController;
          [ablazeViewController.serviceViewControllerProxy performSelector:@selector(setBundleIdentifier:) withObject:NSBundle.mainBundle.bundleIdentifier];
          %init(_ungrouped);
          initLSBackground();
        } else {
          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ablaze" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
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