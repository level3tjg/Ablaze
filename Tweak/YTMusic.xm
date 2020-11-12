#import "Shared.h"

%group YTMusic

%hook YTMNowPlayingViewController
%property (nonatomic, retain) MusicLyricsBackgroundView *lyricsBackgroundView;
- (void)viewDidLoad {
  %orig;
  if (!self.lyricsBackgroundView)
    self.lyricsBackgroundView = [[AblazeManager sharedInstance] globalBackgroundView];
  [[MPNowPlayingInfoCenter defaultCenter] becomeActiveSystemFallback];
  MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 0.0;
  self.lyricsBackgroundView.frame = [UIScreen mainScreen].bounds;
  [self.view insertSubview:self.lyricsBackgroundView atIndex:0];
}
- (void)viewDidAppear:(BOOL)animated {
  %orig;
  if (!self.lyricsBackgroundView.backgroundArtworkCatalog)
    self.lyricsBackgroundView.backgroundArtworkCatalog = [MPArtworkCatalog staticArtworkCatalogWithImage:((YTMWatchViewController *)self.parentViewController).playerViewController.playerView.overlayView.thumbnailView.imageView.image];
  [UIView animateWithDuration:1.5 animations:^(void){
    self.lyricsBackgroundView.alpha = 1;
  }];
  [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:NO block:^(NSTimer * _Nonnull timer){
    MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 1.0;
  }];
}
- (void)viewDidDisappear:(BOOL)animated {
  %orig;
  MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 0.0;
}
%end

%end

void InitYTMusic() {
  %init(YTMusic);
}