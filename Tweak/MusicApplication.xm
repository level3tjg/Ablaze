#include "MusicApplication.h"

extern MRYIPCCenter *center;
extern NSMutableDictionary *prefs;

UIUserInterfaceStyle (*orig_userInterfaceStyle)(UITraitCollection *self, SEL _cmd);
UIUserInterfaceStyle hook_userInterfaceStyle(UITraitCollection *self, SEL _cmd) {
  if (![prefs[@"userInterfaceStyle"] boolValue]) {
    if ([NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.level3tjg.AblazeUIService"])
      return [[center callExternalMethod:@selector(userInterfaceStyle) withArguments:nil] intValue];
    else
      return orig_userInterfaceStyle(self, _cmd);
  }
  return [prefs[@"userInterfaceStyle"] intValue];
}

%hook _TtCV16MusicApplication8Backdrop17CompositeRenderer
- (void)drawInMTKView:(MTKView *)view {
	Method userInterfaceStyle = class_getInstanceMethod([UITraitCollection class], @selector(userInterfaceStyle));
	orig_userInterfaceStyle = (UIUserInterfaceStyle (*)(UITraitCollection *, SEL))method_getImplementation(userInterfaceStyle);
	method_setImplementation(userInterfaceStyle, (IMP)hook_userInterfaceStyle);
	%orig;
	method_setImplementation(userInterfaceStyle, (IMP)orig_userInterfaceStyle);
}
%end

%hook MusicLyricsBackgroundView
%new
- (void)setCrossfadeDuration:(float)duration {
  MSHookIvar<float>(MSHookIvar<_TtCV16MusicApplication8Backdrop17CompositeRenderer *>(self, "renderer"), "crossfadeDuration") = duration;
}
%new
- (UIImage *)backgroundArtwork {
  return [self.backgroundArtworkCatalog bestImageFromDisk];
}
%new
- (void)setBackgroundArtwork:(UIImage *)artwork {
  self.backgroundArtworkCatalog = [MPArtworkCatalog staticArtworkCatalogWithImage:artwork];
}
%end

%hook MTKView
- (void)_updateToNativeScale {
  CGSize superSize = self.superview.bounds.size;
  if ([self.superview isMemberOfClass:%c(MusicLyricsBackgroundView)])
    self.drawableSize = CGSizeMake(superSize.width * [prefs[@"scale"] floatValue], superSize.height * [prefs[@"scale"] floatValue]);
  else
    %orig;
}
- (NSInteger)preferredFramesPerSecond {
  return [prefs[@"fps"] intValue];
}
- (void)setPreferredFramesPerSecond:(NSInteger)fps {
  %orig([prefs[@"fps"] intValue]);
}
%end

%hook MPCPlaybackEngine
%new
- (NSInteger)options {
  return [self audioSessionOptions];
}
%new
- (void)setOptions:(NSInteger)options {
  [self setAudioSessionOptions:options];
}
%end

void add_image(const struct mach_header* mh, intptr_t vmaddr_slide) {
  Dl_info info;
  dladdr((void *)vmaddr_slide, &info);
  const char *name = info.dli_fname;
  if (name && strcmp(name, "/Library/Frameworks/MusicApplication.framework/MusicApplication") == 0) {
    dispatch_async(dispatch_get_main_queue(), ^{
      %init(_ungrouped);
    });
  }
}

%ctor {
  _dyld_register_func_for_add_image(add_image);
}
