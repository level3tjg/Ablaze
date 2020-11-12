#import "Shared.h"

%group Spotify

%hook SPTNowPlayingBackgroundViewController
%property (nonatomic, retain) MusicNowPlayingLyricsViewController *lyricsViewController;
%property (nonatomic, retain) MusicLyricsBackgroundView *lyricsBackgroundView;
- (void)viewDidLoad {
	%orig;
	if (!self.lyricsBackgroundView) {
		self.lyricsViewController = [[%c(MusicNowPlayingLyricsViewController) alloc] init];
		self.lyricsBackgroundView = [[AblazeManager sharedInstance] globalBackgroundView];
	}
	[self.lyricsViewController viewDidLoad];
	[self.lyricsViewController viewDidAppear:false];
	MSHookIvar<id>(self.lyricsBackgroundView.renderer, "spectrumAnalysis") = MSHookIvar<id>(self.lyricsViewController.backgroundView.renderer, "spectrumAnalysis");
	[[MPNowPlayingInfoCenter defaultCenter] becomeActiveSystemFallback];
	MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 0.0;
	self.lyricsBackgroundView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*1.5);
	[self.view insertSubview:self.lyricsBackgroundView atIndex:0];
}
- (void)viewWillAppear:(BOOL)animated {
	%orig;
	self.topGradientView.hidden = true;
	self.bottomGradientView.hidden = true;
}
- (void)viewDidAppear:(BOOL)animated {
	%orig;
	if (!self.lyricsBackgroundView.backgroundArtworkCatalog)
		for (UIView *subview in [self.parentViewController.view allSubviews])
			if ([subview isKindOfClass:NSClassFromString(@"SPTNowPlayingCoverArtImageView")])
				self.lyricsBackgroundView.backgroundArtworkCatalog = [MPArtworkCatalog staticArtworkCatalogWithImage:((UIImageView *)subview).image];
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

void InitSpotify() {
  %init(Spotify);
}