#include "LockScreen.h"
#include "UIView+Recursion.h"

%hook CSCoverSheetViewController
- (void)viewWillAppear:(BOOL)animated {
  %orig;
  [self.ablazeProxy performSelector:@selector(setCrossfadeDuration:) withObject:@0];
  [self performSelector:@selector(nowPlayingInfoDidChange)];
  if (self.showingMediaControls) {
    [self.view insertSubview:self.ablazeView atIndex:0];
  }
}
%end

void initLSBackground() {
  %init(_ungrouped);
}