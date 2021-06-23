#import "Ablaze.h"
#include "UIView+Recursion.h"

@interface SPTGLUEImageLoader : NSObject
- (void)loadImageForURL:(NSURL *)url imageSize:(CGSize)size completion:(id)completion;
@end

@interface SPTPlayerTrack : NSObject
@property NSURL *coverArtURL;
@end

@interface SPTNowPlayingModel : NSObject
@property SPTPlayerTrack *currentTrack;
@end

@interface SPTNowPlayingBackgroundViewModelImplementation : NSObject
@property SPTNowPlayingModel *nowPlayingModel;
@property SPTGLUEImageLoader *imageLoader;
@end

@interface SPTNowPlayingBackgroundViewController : UIViewController
@property SPTNowPlayingBackgroundViewModelImplementation *viewModel;
@end

@interface SPTNowPlayingScrollViewController : UIViewController
@property(nonatomic, retain) MusicLyricsBackgroundView *ablazeView;
@property SPTNowPlayingBackgroundViewController *backgroundViewController;
@end