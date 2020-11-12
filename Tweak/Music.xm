#import "Shared.h"

_TtCVV16MusicApplication4Text7Drawing4View *textDrawingView;
_TtCV16MusicApplication4Text9StackView *textStackView;

%group Music

%hook MusicNowPlayingControlsViewController
%property (nonatomic, retain) MusicNowPlayingLyricsViewController *lyricsViewController;
%property (nonatomic, retain) MusicLyricsBackgroundView *lyricsBackgroundView;
-(void)viewDidLoad{
  %orig;
  if (!self.lyricsViewController) {
    self.lyricsViewController = [[%c(MusicNowPlayingLyricsViewController) alloc] init];
    self.lyricsBackgroundView = [[AblazeManager sharedInstance] globalBackgroundView];
  }
  [self.lyricsViewController viewDidLoad];
  MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 0.0;
  if ([[[AblazeManager sharedInstance] prefs][@"enableVisualize"] boolValue])
    MSHookIvar<id>(self.lyricsBackgroundView.renderer, "spectrumAnalysis") = MSHookIvar<id>(self.lyricsViewController.backgroundView.renderer, "spectrumAnalysis");
  self.lyricsBackgroundView.frame = self.view.frame;
}
- (void)viewWillAppear:(BOOL)animated {
  %orig;
  [self.view.superview insertSubview:self.lyricsBackgroundView atIndex:0];
}
- (void)viewDidAppear:(BOOL)animated {
  %orig;
  [self.lyricsViewController viewDidAppear:animated];
  [UIView animateWithDuration:1 animations:^(void){
    self.lyricsBackgroundView.alpha = 1;
  }];
  [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:NO block:^(NSTimer * _Nonnull timer){
    MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 1.0;
  }];
}
- (void)viewDidDisappear:(BOOL)animated {
  %orig;
  MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 0.0;
  [self.lyricsViewController viewDidDisappear:animated];
}
- (void)viewDidLayoutSubviews {
  %orig;
  for(UIView *subview in [self.view allSubviews])
    if([subview isKindOfClass:NSClassFromString(@"MusicApplication.ArtworkComponentImageView")])
      self.lyricsBackgroundView.backgroundArtworkCatalog = [MPArtworkCatalog staticArtworkCatalogWithImage:((UIImageView *)subview).image];
  self.view.subviews[3].backgroundColor = [UIColor clearColor];
}
%end

%hook QueueGradientView
- (void)layoutSubviews {
  %orig;
  ((UIView *)self).hidden = true;
}
- (void)setHidden:(BOOL)hidden {
  %orig(true);
}
%end

%hook NowPlayingQueueHeaderView
- (void)layoutSubviews {
  %orig;
  ((UIView *)self).backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
}
- (void)setBackgroundColor:(UIColor *)color {
  %orig([UIColor colorWithRed:0 green:0 blue:0 alpha:0.25]);
}
%end

%hook NowPlayingHistoryHeaderView
- (void)layoutSubviews {
  %orig;
  ((UIView *)self).backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
}
- (void)setBackgroundColor:(UIColor *)color {
  %orig([UIColor colorWithRed:0 green:0 blue:0 alpha:0.25]);
}
%end

%hook TintColorObservingView
- (void)layoutSubviews {
  %orig;
  if ([[self parentViewController] isKindOfClass:NSClassFromString(@"MusicApplication.NowPlayingQueueViewController")])
    ((UIView *)self).backgroundColor = [UIColor clearColor];
}
- (void)setBackgroundColor:(UIColor *)color {
  if ([[self parentViewController] isKindOfClass:NSClassFromString(@"MusicApplication.NowPlayingQueueViewController")])
    color = [UIColor clearColor];
  %orig;
}
%end

%hook _TtCVV16MusicApplication4Text7Drawing4View
- (CGRect)bounds {
  if ([self.parentViewController isKindOfClass:NSClassFromString(@"MusicApplication.NowPlayingQueueViewController")]) {
    textDrawingView = self;
  }
  return %orig;
}
%end

%hook _TtCV16MusicApplication4Text9StackView
- (CGSize)sizeThatFits:(CGSize)size {
  if ([self.parentViewController isKindOfClass:NSClassFromString(@"MusicApplication.NowPlayingQueueViewController")]) {
    textStackView = self;
  }
  return %orig;
}
%end

%hook NSString
- (CGRect)boundingRectWithSize:(CGSize)size options:(NSInteger)opt attributes:(NSDictionary *)attr context:(NSStringDrawingContext *)context {
  if (textStackView) {
    NSMutableDictionary *attributesMutable = [attr mutableCopy];
    attributesMutable[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attr = [attributesMutable copy];
  }
  return %orig;
}
- (void)drawWithRect:(CGRect)rect options:(NSInteger)opt attributes:(NSDictionary *)attr context:(NSStringDrawingContext *)context {
  if (textDrawingView) {
    NSMutableDictionary *attributesMutable = [attr mutableCopy];
    attributesMutable[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attr = [attributesMutable copy];
  }
  textDrawingView = nil;
  textStackView = nil;
  %orig;
}
%end

%end

/* this is where things get messy. */

%group MusicColors

%hook MusicNowPlayingControlsViewController
- (void)viewDidLayoutSubviews {
  %orig;
  self.titleLabel.textColor = [UIColor whiteColor];
  self.subtitleButton.tintColor = [UIColor whiteColor];
  self.leftButton.imageView.tintColor = [UIColor whiteColor];
  self.playPauseStopButton.imageView.tintColor = [UIColor whiteColor];
  self.rightButton.imageView.tintColor = [UIColor whiteColor];
  if([self.accessibilityLyricsButton.tintColor isEqual:[UIColor systemPinkColor]])
  self.accessibilityLyricsButton.tintColor = [UIColor whiteColor];
  [self.view.subviews[4].subviews lastObject].tintColor = [UIColor whiteColor];
}
%end

%hook UILabel
- (void)setTextColor:(UIColor *)color {
  if ([[self parentViewController] isKindOfClass:%c(MusicNowPlayingControlsViewController)] || [[self parentViewController] isKindOfClass:NSClassFromString(@"MusicApplication.NowPlayingQueueViewController")])
    if ([color isEqual:[UIColor systemPinkColor]] || [color isEqual:[UIColor labelColor]] || [color isEqual:[UIColor tertiaryLabelColor]] || [self.textColor isEqual:[UIColor secondaryLabelColor]])
      color = [UIColor whiteColor];
  %orig;
}
- (void)layoutSubviews {
  %orig;
  if ([[self parentViewController] isKindOfClass:%c(MusicNowPlayingControlsViewController)] || [[self parentViewController] isKindOfClass:NSClassFromString(@"MusicApplication.NowPlayingQueueViewController")])
    if([self.textColor isEqual:[UIColor systemPinkColor]] || [self.textColor isEqual:[UIColor labelColor]] || [self.textColor isEqual:[UIColor tertiaryLabelColor]] || [self.textColor isEqual:[UIColor secondaryLabelColor]])
      self.textColor = [UIColor whiteColor];
}
- (void)setFrame:(CGRect)frame {
  %orig;
  [self layoutSubviews];
}
%end

%hook UIImageView
- (void)setTintColor:(UIColor *)color {
  if ([[self parentViewController] isKindOfClass:%c(MusicNowPlayingControlsViewController)] && ![self.image.imageAsset.assetName isEqualToString:@"quote.bubble"]) {
    if (![self.superview isKindOfClass:NSClassFromString(@"_TtCC16MusicApplication32NowPlayingControlsViewController12VolumeSlider")])
      color = [UIColor whiteColor];
    if ([self.superview isKindOfClass:%c(MPRouteButton)])
      if ([color isEqual:[UIColor systemPinkColor]])
        color = [UIColor whiteColor];
  }
  if ([self.superview isKindOfClass:%c(MPVolumeSlider)])
    if ([self.image.imageAsset.assetName containsString:@"speaker"])
      color = [UIColor colorWithRed:0.922 green:0.922 blue:0.961 alpha:0.18];
  %orig;
}
- (void)setBackgroundColor:(UIColor *)color {
  if ([[self parentViewController] isKindOfClass:%c(MusicNowPlayingControlsViewController)])
    if ([self.image.imageAsset.assetName isEqualToString:@"repeat"] || [self.image.imageAsset.assetName isEqualToString:@"shuffle"] || [self.image.imageAsset.assetName isEqualToString:@"repeat.1"])
      if ([[color valueForKey:@"alphaComponent"] isEqual:@(0.2)])
      color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
  %orig;
}
- (void)layoutSubviews {
  %orig;
  if ([[self parentViewController] isKindOfClass:%c(MusicNowPlayingControlsViewController)]) {
    if ([self.image.imageAsset.assetName isEqualToString:@"shuffle"] || [self.image.imageAsset.assetName isEqualToString:@"repeat"] || [self.image.imageAsset.assetName isEqualToString:@"repeat.1"]) {
      self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
      self.tintColor = [UIColor whiteColor];
    }
    if ([self.image.imageAsset.assetName isEqualToString:@"ellipsis"])
      self.tintColor = [UIColor whiteColor];
    if ([self.superview isKindOfClass:%c(MPRouteButton)])
      if ([self.tintColor isEqual:[UIColor systemPinkColor]])
        self.tintColor = [UIColor whiteColor];
  }
  if([self.superview isKindOfClass:%c(MPVolumeSlider)])
    if([self.image.imageAsset.assetName containsString:@"speaker"])
      self.tintColor = [UIColor colorWithRed:0.922 green:0.922 blue:0.961 alpha:0.18];
}
- (void)setImage:(UIImage *)image {
  if ([[self parentViewController] isKindOfClass:%c(MusicNowPlayingControlsViewController)]) {
    if ([image.imageAsset.assetName isEqualToString:@"shuffle"] || [image.imageAsset.assetName isEqualToString:@"repeat"] || [image.imageAsset.assetName isEqualToString:@"repeat.1"]) {
      self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
      self.tintColor = [UIColor whiteColor];
    }
    if ([image.imageAsset.assetName isEqualToString:@"NowPlayingQueueOn"]) {
      image = [[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] _flatImageWithColor:[UIColor whiteColor]];
      UIImage *bullet = [[[UIImage systemImageNamed:@"list.bullet"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] _flatImageWithColor:[UIColor whiteColor]];
      UIGraphicsBeginImageContextWithOptions(CGSizeMake(28, 28), NO, [UIScreen mainScreen].scale);
      CGContextRef context = UIGraphicsGetCurrentContext();
      CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
      CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
      CGContextFillRect(context, CGRectMake(0, 0, 28, 28));
      CGContextDrawImage(context, CGRectMake((self.frame.size.width-bullet.size.width)/2, (self.frame.size.height-bullet.size.height)/2, bullet.size.width, bullet.size.height), [bullet CGImage]);
      bullet = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      image = [image maskWithImage:bullet];
    }
  }
  %orig;
}
%end

%hook MPVolumeSlider
- (void)setMinimumTrackTintColor:(UIColor *)color {
  if ([color isEqual:[UIColor tertiaryLabelColor]])
    color = [UIColor whiteColor];
  %orig;
}
- (void)setMaximumTrackTintColor:(UIColor *)color {
  if ([color isEqual:[UIColor quaternaryLabelColor]])
    color = [UIColor colorWithRed:0.922 green:0.922 blue:0.961 alpha:0.18];
  %orig;
}
%end

%hook ContextualActionsButton
- (void)setTintColor:(UIColor *)color {
  if ([[self parentViewController] isKindOfClass:%c(MusicNowPlayingControlsViewController)])
    color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
  %orig;
}
%end

%hook MPButton
- (void)setTintColor:(UIColor *)color {
  if ([[self parentViewController] isKindOfClass:%c(MusicNowPlayingControlsViewController)] && ([color isEqual:[UIColor systemPinkColor]] || [self.imageView.image.imageAsset.assetName isEqualToString:@"list.bullet"]))
    color = [UIColor whiteColor];
  %orig;
}
- (void)layoutSubviews {
  %orig;
  if ([[self parentViewController] isKindOfClass:%c(MusicNowPlayingControlsViewController)]) {
    if ([self.tintColor isEqual:[UIColor systemPinkColor]] || [self.imageView.image.imageAsset.assetName isEqualToString:@"list.bullet"] || !self.currentImage)
      self.tintColor = [UIColor whiteColor];
  }
}
%end

%hook MPRouteButton
- (void)layoutSubviews {
  %orig;
  UIImageView *imageView = MSHookIvar<UIImageView *>(self, "_accessoryImageView");
  if ([[self parentViewController] isKindOfClass:%c(MusicNowPlayingControlsViewController)])
    if ([imageView.tintColor isEqual:[UIColor systemPinkColor]])
      imageView.tintColor = [UIColor whiteColor];
}
%end

%hook UIView
- (void)setBackgroundColor:(UIColor *)color {
  if (![NSStringFromClass([self class]) containsString:@"Header"]){
    if ([[self parentViewController] isKindOfClass:%c(MusicNowPlayingControlsViewController)] || [[self parentViewController] isKindOfClass:NSClassFromString(@"MusicApplication.NowPlayingQueueViewController")]) {
      if ([self.superview isKindOfClass:NSClassFromString(@"MusicApplication.ContextualActionsButton")]) {
        if ([color isEqual:[[%c(UIDynamicModifiedColor) alloc] initWithBaseColor:[UIColor systemPinkColor] alphaComponent:0.2 contrast:-1]])
          color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
      }
      else if ([self.superview isKindOfClass:NSClassFromString(@"MusicApplication.PlayerTimeControl")] && [self isEqual:self.superview.subviews[0]]) {
        if ([color isEqual:[UIColor tertiaryLabelColor]] || [color isEqual:[UIColor systemBackgroundColor]])
          color = [UIColor whiteColor];
      }
      else if (![self isKindOfClass:NSClassFromString(@"MusicApplication.NowPlayingShuffleButton")] && ![self isKindOfClass:NSClassFromString(@"MusicApplication.NowPlayingRepeatButton")] && ![self isKindOfClass:[UIImageView class]] && ![self.superview isKindOfClass:NSClassFromString(@"MusicApplication.PlayerTimeControl")] && ![self.superview isKindOfClass:%c(UITableViewCollectionCell)] && ![self isKindOfClass:%c(_UIGrabber)]) {
        color = [UIColor clearColor];
      }
    }
  }
  %orig;
}
%end

%hook CALayer
- (void)setBackgroundColor:(CGColorRef)color {
  if ([[self.delegate performSelector:@selector(parentViewController)] isKindOfClass:%c(MusicNowPlayingControlsViewController)])
    if (((UIViewController *)[self.delegate performSelector:@selector(parentViewController)]).view.subviews.count > 3)
      if ([self.delegate isEqual:((UIViewController *)[self.delegate performSelector:@selector(parentViewController)]).view.subviews[3]])
        color = [UIColor clearColor].CGColor;
  %orig;
}
%end

%hook PlayerTimeControl
- (void)layoutSubviews {
  %orig;
  #define self ((UIView *)self)
  if ([self.subviews[0].backgroundColor isEqual:[UIColor tertiaryLabelColor]])
    self.subviews[0].backgroundColor = [UIColor whiteColor];
  if ([self.subviews[4].backgroundColor isEqual:[UIColor systemBackgroundColor]])
    self.subviews[4].backgroundColor = [UIColor whiteColor];
  #undef self
}
%end

%hook NowPlayingRepeatButton
- (void)setBackgroundColor:(UIColor *)color {
  if ([color isEqual:[UIColor systemPinkColor]])
    color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
  %orig;
}
- (void)setTintColor:(UIColor *)color {
  if ([color isEqual:[UIColor systemPinkColor]])
    color = [UIColor whiteColor];
  %orig;
}
%end

%hook NowPlayingShuffleButton
- (void)setBackgroundColor:(UIColor *)color {
  if ([color isEqual:[UIColor systemPinkColor]])
    color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
  %orig;
}
- (void)setTintColor:(UIColor *)color {
  if ([color isEqual:[UIColor systemPinkColor]])
    color = [UIColor whiteColor];
  %orig;
}
%end

%hook UIDeviceRGBColor
%new
- (UIColor *)_resolvedColorWithTraitCollection:(UITraitCollection *)collection {
  return self;
}
%end

%end

void InitMusic() {
  %init(Music, QueueGradientView = NSClassFromString(@"MusicApplication.QueueGradientView"), NowPlayingQueueHeaderView = NSClassFromString(@"MusicApplication.NowPlayingQueueHeaderView"), NowPlayingHistoryHeaderView = NSClassFromString(@"MusicApplication.NowPlayingHistoryHeaderView"), TintColorObservingView = NSClassFromString(@"MusicApplication.TintColorObservingView"));
  %init(MusicColors, ContextualActionsButton = NSClassFromString(@"MusicApplication.ContextualActionsButton"), PlayerTimeControl = NSClassFromString(@"MusicApplication.PlayerTimeControl"), NowPlayingRepeatButton = NSClassFromString(@"MusicApplication.NowPlayingRepeatButton"), NowPlayingShuffleButton = NSClassFromString(@"MusicApplication.NowPlayingShuffleButton"));
}