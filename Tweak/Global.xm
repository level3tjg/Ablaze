#import "Shared.h"
#import <MediaRemote/MediaRemote.h>
#import <notify.h>
#import <mach-o/dyld.h>

NSString *prefsPath = @"/var/mobile/Library/Preferences/com.level3tjg.ablaze.plist";

extern void InitSpringBoard();
extern void InitMusic();
extern void InitSpotify();
extern void InitTidal();
extern void InitBoom();
extern void InitYTMusic();
extern void InitMarvis();
extern void InitLockScreenBG();
extern void InitLockScreenPlayer();

@implementation AblazeManager

+ (void)load {
  [self sharedInstance];
}

+ (id)sharedInstance {
  static dispatch_once_t once = 0;
  __strong static id sharedInstance = nil;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (id)init {
  if(self = [super init]){
    [self refreshPrefs];
  }
  return self;
}

- (void)refreshPrefs {
  _prefs = [NSDictionary dictionaryWithContentsOfFile:prefsPath];
}

- (NSDictionary *)prefs {
  return _prefs;
}

- (MusicLyricsBackgroundView *)globalBackgroundView {
  if (!_globalBackgroundView) {
    _globalBackgroundView = [%c(MusicLyricsBackgroundView) new];
    _globalBackgroundView.alpha = 0.0101;
  }
  return _globalBackgroundView;
}

@end

@implementation UIView (Recursion)
- (NSMutableArray *)allSubviews {
  NSMutableArray *arr = [NSMutableArray array];
  [arr addObject:self];
  for (UIView *subview in self.subviews)
   [arr addObjectsFromArray:(NSArray *)[subview allSubviews]];
  return arr;
}
- (UIViewController *)parentViewController {
  UIResponder *responder = self;
  while ([responder isKindOfClass:[UIView class]])
    responder = [responder nextResponder];
  return (UIViewController *)responder;
}
@end

%hook UIImage
%new
- (UIImage *)maskWithImage:(UIImage *)mask {
  CGImageRef imageReference = self.CGImage;
  CGImageRef maskReference = mask.CGImage;
  
  CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
             CGImageGetHeight(maskReference),
             CGImageGetBitsPerComponent(maskReference),
             CGImageGetBitsPerPixel(maskReference),
             CGImageGetBytesPerRow(maskReference),
             CGImageGetDataProvider(maskReference),
             NULL,
             NO
             );
  
  CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
  CGImageRelease(imageMask);
  
  UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
  CGImageRelease(maskedReference);
  
  return maskedImage;
}
%end

%hook MusicLyricsBackgroundView
%property (nonatomic, assign) UIViewController *lyricsViewController;
- (MusicLyricsBackgroundView *)init {
  MusicLyricsBackgroundView *orig = %orig;
  [[NSNotificationCenter defaultCenter] addObserver:orig selector:@selector(trackDidChange:) name:@"kMRMediaRemoteNowPlayingInfoDidChangeNotification" object:nil];
  return orig;
}
%new
- (void)trackDidChange:(NSNotification *)notification {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(CFDictionaryRef result) {
      if (result) {
        NSData *imageData = [(__bridge NSDictionary *)result objectForKey:@"kMRMediaRemoteNowPlayingInfoArtworkData"];
        MRClient *client = [[%c(MRClient) alloc] initWithData:[(__bridge NSDictionary *)result objectForKey:@"kMRMediaRemoteNowPlayingInfoClientPropertiesData"]];
        BOOL isMusic = [client.bundleIdentifier isEqualToString:@"com.apple.Music"];
        BOOL isSpotify = [client.bundleIdentifier isEqualToString:@"com.spotify.client"];
        BOOL isTidal = [client.bundleIdentifier isEqualToString:@"com.aspiro.TIDAL"];
        BOOL isBoom = [client.bundleIdentifier isEqualToString:@"com.globaldelight.iBoom"];
        BOOL isYTMusic = [client.bundleIdentifier isEqualToString:@"com.google.ios.youtubemusic"];
        dispatch_async(dispatch_get_main_queue(), ^(){
          if(imageData)
            if(IN_SPRINGBOARD || (IN_MUSIC && isMusic) || (IN_MARVIS && isMusic) || (IN_SPOTIFY && isSpotify) || (IN_TIDAL && isTidal) || (IN_BOOM && isBoom) || (IN_YTMUSIC && isYTMusic))
              if ([NSStringFromClass([self class]) isEqualToString:@"MusicLyricsBackgroundView"])
                self.backgroundArtworkCatalog = [MPArtworkCatalog staticArtworkCatalogWithImage:[UIImage imageWithData:imageData]];
        });
      }
    });
  });
}
%new
- (_TtCV16MusicApplication8Backdrop17CompositeRenderer *)renderer {
  return MSHookIvar<_TtCV16MusicApplication8Backdrop17CompositeRenderer *>(self, "renderer");
}
%new
- (MTKView *)metalView {
  return MSHookIvar<MTKView *>(self, "metalView");
}
- (void)layoutSubviews {
  %orig;
  self.metalView.drawableSize = CGSizeMake(0,0);
}
%end

%hook MTKView
- (void)setDrawableSize:(CGSize)size {
  if ([self.superview isKindOfClass:%c(MusicLyricsBackgroundView)]) {
    NSDictionary *prefs = [[AblazeManager sharedInstance] prefs];
    if ([self.superview.superview isKindOfClass:%c(MTMaterialView)]) {
      size = CGSizeMake(self.frame.size.width*2, self.frame.size.height*2);
    }
    else if (prefs[@"scale"]) {
      size = CGSizeMake(self.frame.size.width*[prefs[@"scale"] floatValue], self.frame.size.height*[prefs[@"scale"] floatValue]);
    }
    else {
      size = self.frame.size;
    }
  }
  %orig;
}
- (void)_updateToNativeScale {
  self.drawableSize = CGSizeMake(0,0);
}
%end

%hook MusicNowPlayingLyricsViewController
%new
- (MusicLyricsBackgroundView *)backgroundView {
  return MSHookIvar<MusicLyricsBackgroundView *>(self, "backgroundView");
}
%end

%hook _TtCV16MusicApplication8Backdrop17CompositeRenderer
%new
- (id)spectrumAnalysis {
  return MSHookIvar<id>(self, "spectrumAnalysis");
}
%end

%ctor{
  if (IN_SPRINGBOARD) {
  InitSpringBoard();
  if (![[NSFileManager defaultManager] fileExistsAtPath:prefsPath]) {
    [@{
    @"enableLockScreen": @NO,
    @"enableLockScreenBG":@NO,
    @"enableSpotify": @YES,
    @"enableMusic": @YES,
    @"enableTidal": @YES,
    @"enableBoom": @YES,
    @"enableDeezer": @YES,
    @"enableVisualize": @YES,
    @"enableColorFix": @YES,
    @"customfps": @NO,
    @"fps": @30,
    @"scale": @1
    } writeToFile:prefsPath atomically:YES];
    [[AblazeManager sharedInstance] refreshPrefs];
  }
  }
  if (!IN_MUSIC)
    [[NSBundle bundleWithPath:@"/Library/Frameworks/MusicApplication.framework"] load];
  BOOL frameworkLoaded = FALSE;
  for (int i = 0; i < _dyld_image_count(); i++)
    if (strstr(_dyld_get_image_name(i), "MusicApplication"))
      frameworkLoaded = TRUE;
  if (frameworkLoaded) {
    %init(_ungrouped);
    NSDictionary *prefs = [[AblazeManager sharedInstance] prefs];
    if (IN_SPRINGBOARD) {
    if ([prefs[@"enableLockScreenBG"] boolValue])
      InitLockScreenBG();
    else if ([prefs[@"enableLockScreen"] boolValue])
      InitLockScreenPlayer();
    }
    else {
      if (IN_MUSIC) {
        if([prefs[@"enableMusic"] boolValue])
          InitMusic();
      }
      if (IN_SPOTIFY) {
        if([prefs[@"enableSpotify"] boolValue])
          InitSpotify();
      }
      if (IN_TIDAL) {
        if([prefs[@"enableTidal"] boolValue])
          InitTidal();
      }
      if (IN_BOOM) {
        if([prefs[@"enableBoom"] boolValue])
          InitBoom();
      }
      if (IN_YTMUSIC) {
        if([prefs[@"enableYTMusic"] boolValue])
          InitYTMusic();
      }
      if (IN_MARVIS) {
        if([prefs[@"enableMarvis"] boolValue])
          InitMarvis();
      }
    }
  }
}