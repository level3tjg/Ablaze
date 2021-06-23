#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
  @autoreleasepool {
    [[NSBundle bundleWithPath:@"/Library/Frameworks/MusicApplication.framework"] load];
    return UIApplicationMain(argc, argv, nil, nil);
  }
}