#include "Spotify.h"

extern NSMutableDictionary *prefs;

%hook SPTNowPlayingScrollViewController
%property (nonatomic, retain) MusicLyricsBackgroundView *ablazeView;
- (void)viewDidLoad {
	%orig;
	self.ablazeView = [%c(MusicLyricsBackgroundView) new];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingInfoDidChange) name:@"kMRMediaRemoteNowPlayingInfoDidChangeNotification" object:nil];
	self.ablazeView.frame = UIScreen.mainScreen.bounds;
	[self.view insertSubview:self.ablazeView atIndex:0];
}
- (void)viewWillAppear:(BOOL)animated {
	%orig;
	self.ablazeView.crossfadeDuration = 0.0;
	[self performSelector:@selector(nowPlayingInfoDidChange)];
}
- (void)viewDidAppear:(BOOL)animated {
	%orig;
	self.ablazeView.crossfadeDuration = [prefs[@"crossfadeDuration"] floatValue];
}
- (void)viewDidDisappear:(BOOL)animated {
	%orig;
	self.ablazeView.crossfadeDuration = 0.0;
}
%new
- (void)nowPlayingInfoDidChange {
	[self.backgroundViewController.viewModel.imageLoader loadImageForURL:self.backgroundViewController.viewModel.nowPlayingModel.currentTrack.coverArtURL imageSize:CGSizeMake(640, 640) completion:^(UIImage *artwork) {
		self.ablazeView.backgroundArtwork = artwork;
	}];
}
%end

%hook SPTNowPlayingBackgroundViewController
- (void)viewDidLoad {
	%orig;
	self.view.hidden = YES;
}
%end

%ctor {
  if ([prefs[@"enableSpotify"] boolValue] && IN_SPOTIFY) {
		%init(_ungrouped);
	}
}