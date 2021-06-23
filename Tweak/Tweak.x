#import <Foundation/Foundation.h>
#import "Ablaze.h"

MRYIPCCenter *center;
NSMutableDictionary *prefs;

%ctor {
  center = [MRYIPCCenter centerNamed:@"com.level3tjg.AblazeServer"];
  if (!IN_SPRINGBOARD && !IN_MUSIC)
    [[NSBundle bundleWithPath:@"/Library/Frameworks/MusicApplication.framework"] load];
  NSString *prefsPath = @"/var/mobile/Library/Preferences/com.level3tjg.ablaze14.plist";
  NSDictionary *defaults = @{
    @"enableMusic": @YES,
    @"enableSpotify": @YES,
    @"enableTidal": @YES,
    // @"enableMarvis": @YES,
    @"enableLSBackground": @NO,
    @"enableLSPlayer": @NO,
    @"userInterfaceStyle": @0,
    @"crossfadeDuration": @1,
    @"scale": @1,
    @"fps": @30
  };
  prefs = [NSMutableDictionary dictionaryWithContentsOfFile:prefsPath];
  if (!prefs) {
    [defaults writeToFile:prefsPath atomically:YES];
    prefs = [NSMutableDictionary dictionaryWithContentsOfFile:prefsPath]; 
  }
  for (NSString *key in defaults.allKeys)
    if (!prefs[key])
      prefs[key] = defaults[key];
}