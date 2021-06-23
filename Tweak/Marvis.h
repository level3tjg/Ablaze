#import "Ablaze.h"

@interface ArtworkView : UIImageView
@end

@interface PlayerView : UIView
@property ArtworkView *artworkIV;
@property ArtworkView *bgArtworkIV;
@property UIVisualEffectView *blurView;
@end

@interface FullPlayerView : PlayerView
@property UIView *roundedView;
@end

@interface MiniPlayerView : PlayerView
@end

@interface NowPlayingVC : UIViewController
@property(nonatomic, retain) MusicLyricsBackgroundView *ablazeView;
@property FullPlayerView *fullPlayer;
@property MiniPlayerView *miniPlayer;
@property UIVisualEffectView *bgOverlayView;
@end