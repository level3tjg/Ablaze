#include "SpringBoard.h"

extern MRYIPCCenter *center;

// AblazeUIService gets killed if drawn on lockscreen. unless...
%hook CSLockScreenSettings
- (BOOL)killsInsecureDrawingApps {
  return false;
}
%end

// "uicache -p" does not update entitlements :/
%hook FBSApplicationInfo
- (BOOL)hasViewServicesEntitlement {
  return [self.bundleIdentifier isEqualToString:@"com.level3tjg.AblazeUIService"] ? true : %orig;
}
%end

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object,  CFDictionaryRef userInfo) {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:NO];
}

%ctor {
  if (IN_SPRINGBOARD) {
    %init(_ungrouped);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    [center addTarget:^NSNumber *(id _) {
      return @([[UITraitCollection currentTraitCollection] userInterfaceStyle]);
    } forSelector:@selector(userInterfaceStyle)];
  }
}