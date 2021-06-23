#import <MediaRemote/MediaRemote.h>

#import "Ablaze.h"

@interface AblazeViewController : UIViewController
@property MusicLyricsBackgroundView *ablazeView;
@property NSString *bundleIdentifier;
@end

@interface MRClient : NSObject
@property NSString *bundleIdentifier;
- (instancetype)initWithData:(NSData *)data;
@end