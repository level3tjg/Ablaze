#include "Marvis.h"

extern NSDictionary *prefs;

%hook NowPlayingVC
%property (nonatomic, retain) MusicLyricsBackgroundView *ablazeView;
- (void)viewDidAppear:(BOOL)animated {
  %orig;
  #define self ((NowPlayingVC *)self)
  self.ablazeView = [%c(MusicLyricsBackgroundView) new];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingInfoDidChange) name:@"kMRMediaRemoteNowPlayingInfoDidChangeNotification" object:nil];
  self.ablazeView.frame = UIScreen.mainScreen.bounds;
  self.ablazeView.crossfadeDuration = 0.0;
	[self performSelector:@selector(nowPlayingInfoDidChange)];
  self.ablazeView.crossfadeDuration = [prefs[@"crossfadeDuration"] floatValue];
  [self.fullPlayer.bgArtworkIV insertSubview:self.ablazeView atIndex:0];
  #undef self
}
- (void)viewDidLayoutSubviews {
  %orig;
  #define self ((NowPlayingVC *)self)
  self.fullPlayer.blurView.hidden = YES;
  [self performSelector:@selector(nowPlayingInfoDidChange)];
  #undef self
}
%new
- (void)nowPlayingInfoDidChange {
  #define self ((NowPlayingVC *)self)
  if (![self.ablazeView.backgroundArtwork isEqual:self.fullPlayer.artworkIV.image])
    self.ablazeView.backgroundArtwork = self.fullPlayer.artworkIV.image;
  #undef self
}
%end

%ctor {
  if ([prefs[@"enableMarvis"] boolValue] && IN_MARVIS) {
    %init(_ungrouped, NowPlayingVC = NSClassFromString(@"Marvis.NowPlayingVC"));
  }
}