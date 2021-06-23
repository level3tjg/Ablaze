#import <Foundation/Foundation.h>
#include <NSTask.h>
#include <stdio.h>

NSString *absolutePath(NSString *command) {
  NSString *absolutePath;
  for (NSString *path in
       [NSProcessInfo.processInfo.environment[@"PATH"] componentsSeparatedByString:@":"]) {
    NSString *possiblePath = [path stringByAppendingPathComponent:command];
    if ([NSFileManager.defaultManager fileExistsAtPath:possiblePath]) {
      absolutePath = possiblePath;
      break;
    }
  }
  if (!absolutePath)
    [NSException raise:@"Command not found" format:@"%@ was not found in PATH", command];
  return absolutePath;
}

int main(int argc, char *argv[], char *envp[]) {
  @autoreleasepool {
    if (!NSClassFromString(@"MPVideoView"))
      [NSTask
          launchedTaskWithLaunchPath:absolutePath(@"sed")
                           arguments:@[
                             @"-i",
                             @"s/\\/System\\/Library\\/Frameworks\\/MediaPlayer.framework\\/MediaPlayer/\\/\\/\\/\\/\\/\\/\\/\\/Library\\/Frameworks\\/MediaPlayer.framework\\/MediaPlayer/g",
                             @"/Library/Frameworks/MusicApplication.framework/MusicApplication"
                           ]];
    [NSTask launchedTaskWithLaunchPath:absolutePath(@"uicache")
                             arguments:@[ @"-p", @"/Applications/AblazeUIService.app" ]];
    return 0;
  }
}
