#include "AblazePreferencesRootListController.h"

@implementation AblazePreferencesRootListController

- (NSArray *)specifiers {
  if (!_specifiers) {
    _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
  }

  return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
  id value = _prefs[specifier.properties[@"key"]];
  return value ? value : specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
  NSString *key = specifier.properties[@"key"];
  if ([key isEqualToString:@"enableMusic"] || ![key hasPrefix:@"enable"]) {
    [self kill:@"Music"];
    [self kill:@"AblazeUIService"];
  }
  if ([key isEqualToString:@"enableSpotify"] || ![key hasPrefix:@"enable"]) {
    [self kill:@"Spotify"];
  }
  if ([key isEqualToString:@"enableTidal"] || ![key hasPrefix:@"enable"]) {
    [self kill:@"TIDAL"];
  }
  _prefs[key] = value;
  [_prefs writeToFile:@"/var/mobile/Library/Preferences/com.level3tjg.ablaze14.plist"
           atomically:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _prefs = [NSMutableDictionary
      dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.level3tjg.ablaze14.plist"];
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"Respring"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(respring)];
}

- (void)kill:(NSString *)process {
  [NSTask launchedTaskWithLaunchPath:@"/usr/bin/killall"
                           arguments:@[
                             @"-9",
                             process,
                           ]];
}

- (void)respring {
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                       CFSTR("respring"), NULL, NULL, false);
}

@end
