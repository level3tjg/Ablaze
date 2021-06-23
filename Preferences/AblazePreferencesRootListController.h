#import <NSTask.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface AblazePreferencesRootListController : PSListController {
  NSMutableDictionary *_prefs;
}
- (void)kill:(NSString *)process;
@end
