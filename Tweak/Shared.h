#import <substrate.h>
#import <Foundation/Foundation.h>

#define IN_MUSIC [[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.Music"]
#define IN_SPOTIFY [[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.spotify.client"]
#define IN_TIDAL [[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.aspiro.TIDAL"]
#define IN_BOOM [[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.globaldelight.iBoom"]
#define IN_DEEZER [[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.deezer.Deezer"]
#define IN_YTMUSIC [[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.google.ios.youtubemusic"]
#define IN_MARVIS [[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.adityarajveer.Marvis"]
#define IN_SOUNDCLOUD [[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.soundcloud.TouchApp"]

@interface NSObject (Data)
+ (id)bs_decodeWithData:(NSData *)data;
- (NSData *)bs_encoded;
@end

@interface MTMaterialView : UIView
@end

@interface PLPlatterView : UIView
@property (nonatomic, assign) MTMaterialView *backgroundMaterialView;
@end

@interface CSAdjunctItemView : UIView
@property (nonatomic, assign) PLPlatterView *platterView;
@end

@interface CSAdjunctListItem : NSObject
@property (nonatomic, assign) NSString *identifier;
@property (nonatomic, assign) CSAdjunctItemView *platterView;
@end

@interface CSNowPlayingController : NSObject
@property (nonatomic, assign) UIViewController *controlsViewController;
@end

@interface CSNotificationAdjunctListViewController : UIViewController
@property (nonatomic, assign) NSDictionary *identifiersToItems;
@property (nonatomic, assign) CSNowPlayingController *nowPlayingController;
- (CSAdjunctListItem *)nowPlayingItem;
@end

@interface MRClient : NSObject
@property (nonatomic, readonly) NSString *bundleIdentifier;
@end

@interface MPNowPlayingInfoCenter : NSObject
+ (MPNowPlayingInfoCenter *)defaultCenter;
- (void)becomeActiveSystemFallback;
@end

@interface FBApplicationProcess : NSObject
@property (nonatomic, readonly) NSString *bundleIdentifier;
@end

@interface LSApplicationProxy : NSObject
@property (nonatomic, readonly) NSURL *bundleURL;
+ (LSApplicationProxy *)applicationProxyForIdentifier:(NSString *)bundleIdentifier;
@end

@interface MPCPlayerResponse : NSObject
@end

@interface MPArtworkCatalog : NSObject
+ (MPArtworkCatalog *)staticArtworkCatalogWithImage:(UIImage *)image;
@end

@interface MTKView : UIView
@property (nonatomic, readwrite) BOOL paused;
@property (nonatomic, assign) NSInteger preferredFramesPerSecond;
@property (nonatomic, assign) CGSize drawableSize;
@property (nonatomic, readwrite) BOOL autoResizeDrawable;
@end

@interface SpectrumAnalysis : NSObject
@end

@interface _TtCV16MusicApplication8Backdrop17CompositeRenderer : NSObject
@property (nonatomic, assign) SpectrumAnalysis *spectrumAnalysis;
@end

@interface MusicLyricsBackgroundView : UIView
@property (nonatomic, assign) MPArtworkCatalog *backgroundArtworkCatalog;
@property (nonatomic, assign) _TtCV16MusicApplication8Backdrop17CompositeRenderer *renderer;
@property (nonatomic, assign) MTKView *metalView;
@property (nonatomic, assign) NSNumber *shownOnce;
- (void)trackDidChange:(NSNotification *)notifcation;
@end

@interface MPButton : UIButton
@end

@interface MPRouteButton : UIControl
@end

@interface MPRouteLabel : UIView
@property (nonatomic, assign) UILabel *titleLabel;
@property (nonatomic, assign) UIColor *textColor;
@end

@interface MusicNowPlayingControlsViewController : UIViewController
@property (nonatomic, assign) UILabel *titleLabel;
@property (nonatomic, assign) UIButton *subtitleButton;
@property (nonatomic, assign) UIButton *accessibilityQueueButton;
@property (nonatomic, assign) MPRouteLabel *routeLabel;
@property (nonatomic, assign) UIButton *leftButton;
@property (nonatomic, assign) UIButton *playPauseStopButton;
@property (nonatomic, assign) UIButton *rightButton;
@property (nonatomic, assign) UIButton *accessibilityLyricsButton;
@end

@interface MusicNowPlayingLyricsViewController : UIViewController
@property (nonatomic, assign) MPCPlayerResponse *response;
@property (nonatomic, assign) MusicLyricsBackgroundView *backgroundView;
@end

@interface SPTNowPlayingBackgroundViewController : UIViewController
@property (nonatomic, assign) UIView *topGradientView;
@property (nonatomic, assign) UIView *bottomGradientView;
@end

@interface PlayerScene : UIViewController
@property (nonatomic, assign) UIView *itemsCollectionView;
@end

@interface BMFullPlayerViewController : UIViewController
@property (nonatomic, assign) UIView *contentView;
@property (nonatomic, assign) UIImageView *albumImageView;
@property (nonatomic, assign) UIView *scrollView;
@end

@interface DZRPlayerViewController : UIViewController
@property (nonatomic, assign) UIView *backgroundView;
@end

@interface YTImageView : UIView
@property (nonatomic, assign) UIImageView *imageView;
@end

@interface YTMVideoOverlayView : UIView
@property (nonatomic, assign) YTImageView *thumbnailView;
@end

@interface YTPlayerView : UIView
@property (nonatomic, assign) YTMVideoOverlayView *overlayView;
@end

@interface YTPlayerViewController : UIViewController
@property (nonatomic, assign) YTPlayerView *playerView;
@end

@interface YTMWatchViewController : UIViewController
@property (nonatomic, assign) YTPlayerViewController *playerViewController;
@end

@interface YTMNowPlayingViewController : UIViewController
@end

@interface FullPlayerView : UIView
@property (nonatomic) UIView *roundedView;
@property (nonatomic) UIView *lyricsStack;
@end

@interface NowPlayingVC : UIViewController
@property (nonatomic, strong) FullPlayerView *fullPlayer;
@end

@interface UIViewController (Tweak)
@property (nonatomic, retain) MusicNowPlayingLyricsViewController *lyricsViewController;
@property (nonatomic, retain) MusicLyricsBackgroundView *lyricsBackgroundView;
@property (nonatomic, assign) UIVisualEffectView *backgroundView;
@property (nonatomic, readonly) BOOL px_isVisible;
@end

@interface UIView (ShutUP)
@property (nonatomic, assign) UIViewController *lyricsViewController;
@property (nonatomic, assign) UIViewController *parentViewController;
@property (nonatomic, assign) NSMutableArray *allSubviews;
@property (nonatomic, assign) MPArtworkCatalog *artworkCatalog;
@property (nonatomic, readonly) BOOL _maps_isVisible;
@end

@interface AblazeManager : NSObject{
  NSDictionary *_prefs;
  MusicNowPlayingLyricsViewController *_lyricsViewController;
  MusicLyricsBackgroundView *_globalBackgroundView;
}
+ (instancetype)sharedInstance;
- (MusicLyricsBackgroundView *)globalBackgroundView;
- (NSDictionary *)prefs;
@end

@interface UIView (Recursion)
- (UIViewController *)parentViewController;
- (NSMutableArray *)allSubviews;
@end

@interface UIImageAsset (Tweak)
@property (nonatomic, assign) NSString *assetName;
@end

@interface UIImage (Tweak)
@property (nonatomic, assign) UIImageAsset *imageAsset;
- (UIImage *)_flatImageWithColor:(UIColor *)color;
- (UIImage *)maskWithImage:(UIImage *)image;
@end

@interface UIDynamicModifiedColor : UIColor
- (id)initWithBaseColor:(UIColor *)color alphaComponent:(CGFloat)alpha contrast:(NSInteger)contrast;
@end

@interface _TtCVV16MusicApplication4Text7Drawing4View : UIView
@property (nonatomic, retain) NSString *text;
@end

@interface _TtCV16MusicApplication4Text9StackView : UIView
@end

@interface UIDeviceRGBColor : UIColor
@end