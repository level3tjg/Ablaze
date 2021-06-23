#import <Foundation/Foundation.h>
#import "Ablaze.h"

@interface LSApplicationProxy : NSObject
+ (instancetype)applicationProxyForIdentifier:(NSString *)bundleIdentifier;
@end

@interface FBSApplicationInfo : NSObject
@property NSString *bundleIdentifier;
@property NSDictionary *entitlements;
- (instancetype)initWithApplicationProxy:(LSApplicationProxy *)proxy;
@end

@interface FBSystemService
+ (instancetype)sharedInstance;
- (void)exitAndRelaunch:(BOOL)relaunch;
@end
