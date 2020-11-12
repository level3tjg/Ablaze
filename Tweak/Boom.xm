#import "Shared.h"

%group Boom

%hook BMFullPlayerViewController
%property (nonatomic, retain) MusicLyricsBackgroundView *lyricsBackgroundView;
%end

%hook NSObject
- (void)removeObserver:(id)observer forKeyPath:(NSString *)key {
  @try{
    %orig;
  }
  @catch(NSException *e){
  }
}
%end

%end

void (*boom_orig_viewDidLoad)(BMFullPlayerViewController *self, SEL _cmd);
void boom_hook_viewDidLoad(BMFullPlayerViewController *self, SEL _cmd){
  boom_orig_viewDidLoad(self, _cmd);
  if (!self.lyricsBackgroundView)
    self.lyricsBackgroundView = [[AblazeManager sharedInstance] globalBackgroundView];
  [[MPNowPlayingInfoCenter defaultCenter] becomeActiveSystemFallback];
  MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 0.0;
  self.lyricsBackgroundView.frame = [UIScreen mainScreen].bounds;
  [self.scrollView insertSubview:self.lyricsBackgroundView atIndex:0];
}

void (*boom_orig_viewDidAppear)(BMFullPlayerViewController *self, SEL _cmd, BOOL animated);
void boom_hook_viewDidAppear(BMFullPlayerViewController *self, SEL _cmd, BOOL animated){
  boom_orig_viewDidAppear(self, _cmd, animated);
  [self.contentView.layer performSelector:@selector(setColors:) withObject:nil];
  self.lyricsBackgroundView.backgroundArtworkCatalog = [MPArtworkCatalog staticArtworkCatalogWithImage:self.albumImageView.image];
  self.lyricsBackgroundView.metalView.drawableSize = self.contentView.frame.size;
  self.contentView.backgroundColor = [UIColor blackColor];
  [UIView animateWithDuration:1.0 animations:^(void){
    self.contentView.backgroundColor = [UIColor clearColor];
    self.lyricsBackgroundView.alpha = 1;
  }];
  [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:NO block:^(NSTimer * _Nonnull timer){
    MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 1.0;
  }];
}

void (*boom_orig_viewWillDisappear)(BMFullPlayerViewController *self, SEL _cmd, BOOL animated);
void boom_hook_viewWillDisappear(BMFullPlayerViewController *self, SEL _cmd, BOOL animated){
  boom_orig_viewWillDisappear(self, _cmd, animated);
  MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 0.0;
}

void InitBoom() {
  %init(Boom, BMFullPlayerViewController = NSClassFromString(@"Boom.BMFullPlayerViewController"));
  MSHookMessageEx(NSClassFromString(@"Boom.BMFullPlayerViewController"), @selector(viewDidLoad), (IMP)boom_hook_viewDidLoad, (IMP *)&boom_orig_viewDidLoad);
  MSHookMessageEx(NSClassFromString(@"Boom.BMFullPlayerViewController"), @selector(viewDidAppear:), (IMP)boom_hook_viewDidAppear, (IMP *)&boom_orig_viewDidAppear);
  MSHookMessageEx(NSClassFromString(@"Boom.BMFullPlayerViewController"), @selector(viewWillDisappear:), (IMP)boom_hook_viewWillDisappear, (IMP *)&boom_orig_viewWillDisappear);
}