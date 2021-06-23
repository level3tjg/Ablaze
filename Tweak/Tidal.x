#include "Tidal.h"

extern NSDictionary *prefs;

%hook PlayerScene
%property (nonatomic, retain) MusicLyricsBackgroundView *ablazeView;
- (void)viewDidAppear:(BOOL)animated {
  %orig;
  #define self ((PlayerScene *)self)
  self.ablazeView = [%c(MusicLyricsBackgroundView) new];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingInfoDidChange) name:@"kMRMediaRemoteNowPlayingInfoDidChangeNotification" object:nil];
	self.ablazeView.frame = UIScreen.mainScreen.bounds;
  [self performSelector:@selector(nowPlayingInfoDidChange)];
  self.ablazeView.crossfadeDuration = [prefs[@"crossfadeDuration"] floatValue];
	[self.view insertSubview:self.ablazeView atIndex:0];
  self.topGradientContainerView.hidden = YES;
  #undef self
}
%new
- (void)nowPlayingInfoDidChange {
  #define self ((PlayerScene *)self)
  NSDictionary *mediaItemInfo = object_getIvar(self, class_getInstanceVariable([self class], "mediaItemInfo"));
  self.ablazeView.backgroundArtwork = [self.imageService imageForAlbumId:mediaItemInfo[@"albumId"] withImageResourceId:mediaItemInfo[@"imageResourceId"] size:0];
  #undef self
}
%end

%ctor {
  if ([prefs[@"enableTidal"] boolValue] && IN_TIDAL) {
    %init(_ungrouped, PlayerScene = NSClassFromString(@"WiMP.PlayerScene"));
  }
}