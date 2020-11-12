#import "Shared.h"

%group SpringBoard

%hook MPCPlaybackEngine
- (id)initWithPlayerID:(NSString *)id {
  return nil;
}
%end

%hook CSNotificationAdjunctListViewController
%property (nonatomic, retain) MusicLyricsBackgroundView *lyricsBackgroundView;
- (void)_insertItem:(CSAdjunctListItem *)item animated:(BOOL)animated {
  %orig;
  if([item.identifier isEqualToString:@"SBDashBoardNowPlayingAssertionIdentifier"])
    if(self.lyricsBackgroundView)
      [UIView animateWithDuration:1 animations:^(void){
        self.lyricsBackgroundView.alpha = 0.99999;
      }];
}
- (void)_removeItem:(CSAdjunctListItem *)item animated:(BOOL)animated {
  %orig;
  if([item.identifier isEqualToString:@"SBDashBoardNowPlayingAssertionIdentifier"])
    if(self.lyricsBackgroundView)
      [UIView animateWithDuration:1 animations:^(void){
        self.lyricsBackgroundView.alpha = 0;
      }];
}
%new
- (CSAdjunctListItem *)nowPlayingItem {
  return self.identifiersToItems[@"SBDashBoardNowPlayingAssertionIdentifier"];
}
%end

%end

%group LockScreenBG

%hook CSNotificationAdjunctListViewController
- (void)viewWillAppear:(BOOL)animated {
  %orig;
  if ([self nowPlayingItem]) {
    if (![self nowPlayingItem].platterView.hidden) {
      if (!self.lyricsBackgroundView) {
        self.lyricsBackgroundView = [[AblazeManager sharedInstance] globalBackgroundView];
        MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 0;
      }
      UIViewController *lastParent = self;
      while (lastParent.parentViewController)
        lastParent = lastParent.parentViewController;
      lastParent = lastParent.childViewControllers[0];
      self.lyricsBackgroundView.frame = [UIScreen mainScreen].bounds;
      [self.lyricsBackgroundView trackDidChange:nil];
      [lastParent.view insertSubview:self.lyricsBackgroundView atIndex:0];
      self.lyricsBackgroundView.alpha = 1;
    }
  }
}

- (void)viewDidAppear:(BOOL)animated {
  %orig;
  [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:NO block:^(NSTimer * _Nonnull timer){
    if(self.lyricsBackgroundView)
      MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 2;
  }];
}

- (void)viewDidDisappear:(BOOL)animated {
  %orig;
  if (self.lyricsBackgroundView) {
    MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 0;
    [self.lyricsBackgroundView removeFromSuperview];
  }
}
%end

%end

%group LockScreenPlayer

%hook CSNotificationAdjunctListViewController
%new
- (CSAdjunctListItem *)nowPlayingItem {
  return self.identifiersToItems[@"SBDashBoardNowPlayingAssertionIdentifier"];
}

- (void)viewWillAppear:(BOOL)animated {
  %orig;
  CSAdjunctListItem *nowPlayingItem = [self nowPlayingItem];
  if (nowPlayingItem) {
    MTMaterialView *materialView = nowPlayingItem.platterView.platterView.backgroundMaterialView;
    if (!self.lyricsBackgroundView) {
      self.lyricsBackgroundView = [[AblazeManager sharedInstance] globalBackgroundView];
      MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 0;
    }
    self.lyricsBackgroundView.frame = materialView.frame;
    self.lyricsBackgroundView.layer.masksToBounds = true;
    self.lyricsBackgroundView.layer.cornerRadius = materialView.layer.cornerRadius;
    [self.lyricsBackgroundView trackDidChange:nil];
    if (self.lyricsBackgroundView) {
      self.lyricsBackgroundView.alpha = 0.99;
    }
    [materialView insertSubview:self.lyricsBackgroundView atIndex:0];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  %orig;
  if (self.lyricsBackgroundView) {
    self.lyricsBackgroundView.metalView.paused = false;
    [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:NO block:^(NSTimer * _Nonnull timer){
      MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 1;
    }];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  %orig;
  if (self.lyricsBackgroundView) {
    self.lyricsBackgroundView.metalView.paused = true;
    MSHookIvar<float>(self.lyricsBackgroundView.renderer, "crossfadeDuration") = 0;
    [self.lyricsBackgroundView removeFromSuperview];
  }
}
%end

%hook CSAdjunctItemView
%new
- (PLPlatterView *)platterView {
  for(PLPlatterView *subview in self.subviews)
    if([subview isKindOfClass:%c(PLPlatterView)])
      return subview;
  return nil;
}
%end

%end

void InitSpringBoard() {
  %init(SpringBoard);
}

void InitLockScreenBG() {
  %init(LockScreenBG);
}

void InitLockScreenPlayer() {
  %init(LockScreenPlayer);
}