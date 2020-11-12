#import "Shared.h"

%group Marvis
%hook NowPlayingVC
%property (nonatomic, retain) MusicLyricsBackgroundView *lyricsBackgroundView;
- (void)viewDidDisappear:(BOOL)animated {
  %orig;
  MSHookIvar<float>(((UIViewController *)self).lyricsBackgroundView.renderer, "crossfadeDuration") = 0.0;
}
%end
%end

void (*marvis_orig_viewDidLoad)(NowPlayingVC *self, SEL _cmd);
void marvis_hook_viewDidLoad(NowPlayingVC *self, SEL _cmd){
  marvis_orig_viewDidLoad(self, _cmd);
  if(!self.lyricsBackgroundView)
    self.lyricsBackgroundView = [[AblazeManager sharedInstance] globalBackgroundView];
  [[MPNowPlayingInfoCenter defaultCenter] becomeActiveSystemFallback];
  MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 1.0;
  self.lyricsBackgroundView.frame = self.view.frame;
  [self.lyricsBackgroundView removeFromSuperview];
  self.fullPlayer.roundedView.subviews[2].hidden = YES;
  [self.fullPlayer.roundedView.subviews[1] insertSubview:self.lyricsBackgroundView atIndex:0];
  if (!self.lyricsBackgroundView.backgroundArtworkCatalog) {
    UIImageView *artworkView = (UIImageView *)self.fullPlayer.roundedView.subviews[5].subviews[0];
    UIImage *artworkImage = artworkView.image;
    self.lyricsBackgroundView.backgroundArtworkCatalog = [MPArtworkCatalog staticArtworkCatalogWithImage:artworkImage];
  }
  [UIView animateWithDuration:1.5 animations:^(void){
    self.lyricsBackgroundView.alpha = 1;
  }];
  [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:NO block:^(NSTimer * _Nonnull timer){
    MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 1.0;
  }];
}

void InitMarvis(){
  %init(Marvis, NowPlayingVC = NSClassFromString(@"Marvis.NowPlayingVC"));
  MSHookMessageEx(NSClassFromString(@"Marvis.NowPlayingVC"), @selector(viewDidLayoutSubviews), (IMP)marvis_hook_viewDidLoad, (IMP *)&marvis_orig_viewDidLoad);
}