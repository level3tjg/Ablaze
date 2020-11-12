#import "Shared.h"

%group Tidal

%hook PlayerScene
%property (nonatomic, retain) MusicLyricsBackgroundView *lyricsBackgroundView;
%end

%end

void (*tidal_orig_viewDidAppear)(PlayerScene *self, SEL _cmd, BOOL animated);
void tidal_hook_viewDidAppear(PlayerScene *self, SEL _cmd, BOOL animated){
  tidal_orig_viewDidAppear(self, _cmd, animated);
  MSHookIvar<UIView *>(self.parentViewController, "gradientContainer").hidden = true;
  MSHookIvar<UIImageView *>(self.parentViewController, "blurryImageView").hidden = true;
  if (!self.lyricsBackgroundView) {
    self.lyricsBackgroundView = [[AblazeManager sharedInstance] globalBackgroundView];
    [[MPNowPlayingInfoCenter defaultCenter] becomeActiveSystemFallback];
  }
  MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 0;
  self.lyricsBackgroundView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
  [self.view insertSubview:self.lyricsBackgroundView atIndex:0];
  [UIView animateWithDuration:1.5 animations:^(void){
    self.lyricsBackgroundView.alpha = 1;
  }];
  [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:NO block:^(NSTimer * _Nonnull timer){
    self.lyricsBackgroundView.backgroundArtworkCatalog = [MPArtworkCatalog staticArtworkCatalogWithImage:MSHookIvar<UIImageView *>(self.itemsCollectionView.subviews[0], "trackImageView").image];
    MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 1.0;
  }];
}

void InitTidal() {
  %init(Tidal, PlayerScene = NSClassFromString(@"WiMP.PlayerScene"));
  MSHookMessageEx(NSClassFromString(@"WiMP.PlayerScene"), @selector(viewDidAppear:), (IMP)tidal_hook_viewDidAppear, (IMP *)&tidal_orig_viewDidAppear);
}