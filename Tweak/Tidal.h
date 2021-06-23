#import "Ablaze.h"
#include "UIView+Recursion.h"

@interface WMPImageService : NSObject
- (UIImage *)imageForAlbumId:(NSString *)albumId
         withImageResourceId:(NSString *)imageResourceId
                        size:(NSInteger)size;
@end

@interface WMPAbstractScene : UIViewController
@property WMPImageService *imageService;
@end

@interface PlayerScene : WMPAbstractScene
@property(nonatomic, retain) MusicLyricsBackgroundView *ablazeView;
@property UIView *topGradientContainerView;
@property UICollectionView *itemsCollectionView;
@end

@interface PlayerMediaItemCell : UICollectionViewCell
@property UIImageView *trackImageView;
@end