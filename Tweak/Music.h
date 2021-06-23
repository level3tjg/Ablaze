#import "Ablaze.h"
#include "AblazeRemoteViewController.h"
#include "UIView+Recursion.h"

@interface MPModelObject : NSObject
@end

@interface MPModelSong : MPModelObject
- (MPArtworkCatalog *)artworkCatalog;
@end

@interface MPModelGenericObject : MPModelObject
@property MPModelSong *song;
@end

@interface MPCPlayerResponseItem : NSObject
@property MPModelGenericObject *metadataObject;
@end

@interface MusicNowPlayingControlsViewController : UIViewController
@property(nonatomic, retain) UIView *ablazeView;
@property(nonatomic, strong) NSProxy *ablazeProxy;
@end