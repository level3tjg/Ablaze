#import <dlfcn.h>
#import <mach-o/dyld.h>
#import "Ablaze.h"

@interface _TtCV16MusicApplication8Backdrop17CompositeRenderer : NSObject
@end

@interface MPCPlaybackEngine : NSObject
@property NSInteger audioSessionOptions;
@end

@interface MTKView : UIView
@property(nonatomic, readwrite, getter=isPaused) BOOL paused;
@property(nonatomic, assign) CGSize drawableSize;
@end