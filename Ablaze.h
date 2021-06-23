#import <Foundation/Foundation.h>
#include <MRYIPCCenter.h>
#import <UIKit/UIKit.h>

#ifndef IN_SPRINGBOARD
#define IN_SPRINGBOARD \
  [NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"]
#endif
#define IN_SPOTIFY [NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.spotify.client"]
#define IN_MUSIC [NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.Music"]
#define IN_TIDAL [NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.aspiro.TIDAL"]
#define IN_MARVIS [NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.adityarajveer.Marvis"]

extern NSString *kCALayerSecurityModeSecure;

@interface CALayer (Secure)
@property NSString *securityMode;
@end

@interface MPArtworkCatalog : NSObject
@property BOOL hasImageOnDisk;
+ (instancetype)staticArtworkCatalogWithImage:(UIImage *)image;
- (UIImage *)bestImageFromDisk;
- (void)requestRadiosityImageWithCompletionHandler:(id)completionHandler;
- (void)requestImageWithCompletionHandler:(id)completionHandler;
@end

@interface MusicLyricsBackgroundView : UIView
@property float crossfadeDuration;
@property UIImage *backgroundArtwork;
@property MPArtworkCatalog *backgroundArtworkCatalog;
@end

@interface _UIRemoteViewController : UIViewController
+ (NSInvocation *)requestViewController:(NSString *)className
        fromServiceWithBundleIdentifier:(NSString *)bundleIdentifier
                      connectionHandler:(void (^)(_UIRemoteViewController *, NSError *))callback;
- (NSProxy *)serviceViewControllerProxy;
@end

@interface NSXPCInterface : NSObject
+ (instancetype)interfaceWithProtocol:(Protocol *)protocol;
@end

@protocol AblazeViewControllerRemoteHost
@end

@protocol AblazeViewControllerRemoteService
- (instancetype)init;
- (void)viewDidLoad;
- (void)setBackgroundArtwork:(UIImage *)image;
- (void)setCrossfadeDuration:(NSNumber *)duration;
- (void)trackDidChange:(NSNotification *)notification;
- (void)setBundleIdentifier:(NSString *)bundleIdentifier;
@end