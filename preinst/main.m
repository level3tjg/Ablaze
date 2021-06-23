#include <AFNetworking/AFNetworking.h>
#include <MobileGestalt/MobileGestalt.h>
#include <SSZipArchive/SSZipArchive.h>
#include <stdio.h>

#define kMobileGestaltSystemImageIDKey CFSTR("4qfpxrvLtWillIHpIsVgMA")
#define kMobileGestaltBuildIDKey CFSTR("qwXfFvH5jPXPxrny0XuGtQ")

int main(int argc, char *argv[], char *envp[]) {
  if (strcmp(argv[1], "install") != 0 &&
      [[NSFileManager defaultManager]
          fileExistsAtPath:@"/Library/Frameworks/MusicApplication.framework"])
    return 0;
  dispatch_group_t group = dispatch_group_create();
  dispatch_queue_t queue = dispatch_queue_create("com.level3tjg.ablaze", DISPATCH_QUEUE_CONCURRENT);
  AFHTTPSessionManager *rawManager = [AFHTTPSessionManager manager];
  rawManager.responseSerializer = [AFHTTPResponseSerializer serializer];
  rawManager.responseSerializer.acceptableContentTypes =
      [NSSet setWithArray:@[ @"binary/octet-stream", @"application/octet-stream" ]];
  rawManager.requestSerializer.timeoutInterval = 60;
  rawManager.completionQueue = queue;
  NSString *buildId = @"F054EA8A-E6F9-11EA-A328-211E709B550E";
  // #if __arm64e__
  // NSString *systemImageId = @"03951F47-359D-4F5D-8316-3B116C13BB7F";
  // #else
  NSString *systemImageId = @"2754B362-A2F1-4106-AAB3-DE926DFC187A";
  // #endif
  NSString *xml = [NSString
      stringWithFormat:@"https://mesu.apple.com/systemassets/%@/%@/com_apple_MobileAsset_SystemApp/"
                       @"com_apple_MobileAsset_SystemApp.xml",
                       buildId, systemImageId];
  NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:xml]];
  NSDictionary *assets = plist[@"Assets"];
  NSDictionary *musicAsset;
  for (NSDictionary *asset in assets) {
    if ([asset[@"AppBundleID"] isEqualToString:@"com.apple.Music"]) {
      musicAsset = asset;
    }
  }
  if (musicAsset) {
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
      [rawManager GET:[NSString stringWithFormat:@"%@%@", musicAsset[@"__BaseURL"],
                                                 musicAsset[@"__RelativePath"]]
          parameters:nil
          headers:@{
            @"Range" :
                [NSString stringWithFormat:@"bytes=%@-%@", musicAsset[@"_StartOfDataRange"],
                                           @([musicAsset[@"_StartOfDataRange"] integerValue] +
                                             [musicAsset[@"_LengthOfDataRange"] integerValue])]
          }
          progress:nil
          success:^(NSURLSessionDataTask *task, NSData *data) {
            [data writeToFile:@"/tmp/MusicAsset.zip" atomically:YES];
            [SSZipArchive
                  unzipFileAtPath:@"/tmp/MusicAsset.zip"
                    toDestination:@"/tmp/MusicAsset"
                  progressHandler:nil
                completionHandler:^(NSString *path, BOOL success, NSError *error) {
                  if (error || !success) {
                    if (error)
                      printf("\n%s\n\n",
                             [NSString stringWithFormat:@"Error unzipping MobileAsset: %@",
                                                        error.localizedDescription]
                                 .UTF8String);
                    dispatch_group_leave(group);
                  }
                  if (success) {
                    NSFileManager *fm = [NSFileManager defaultManager];
                    [fm removeItemAtPath:@"/Library/Frameworks/MusicApplication.framework"
                                   error:nil];
                    [fm moveItemAtPath:@"/tmp/MusicAsset/AssetData/Music.app/Frameworks/"
                                       @"MusicApplication.framework"
                                toPath:@"/Library/Frameworks/"
                                       @"MusicApplication.framework"
                                 error:&error];
                    if (error) {
                      printf(
                          "\n%s\n\n",
                          [NSString stringWithFormat:@"Error moving MusicApplication.framework: %@",
                                                     error.localizedDescription]
                              .UTF8String);
                      dispatch_group_leave(group);
                    } else {
                      [fm removeItemAtPath:@"/tmp/MusicAsset" error:nil];
                      [fm removeItemAtPath:@"/tmp/MusicAsset.zip" error:nil];
                      dispatch_group_leave(group);
                    }
                  }
                }];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
            printf("\n%s\n\n", [NSString stringWithFormat:@"Error downloading MobileAsset: %@",
                                                          error.localizedDescription]
                                   .UTF8String);
            dispatch_group_leave(group);
          }];
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
  }
  if (![[NSFileManager defaultManager]
          fileExistsAtPath:@"/Library/Frameworks/MusicApplication.framework"])
    return 1;
  return 0;
}
