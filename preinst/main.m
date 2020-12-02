#include <AFNetworking/AFNetworking.h>
#include <SSZipArchive/SSZipArchive.h>
#include <stdio.h>

int main(int argc, char *argv[], char *envp[]) {
  dispatch_group_t group = dispatch_group_create();
  dispatch_queue_t queue = dispatch_queue_create("com.level3tjg.ablaze", DISPATCH_QUEUE_CONCURRENT);
  AFHTTPSessionManager *rawManager = [AFHTTPSessionManager manager];
  rawManager.responseSerializer = [AFHTTPResponseSerializer serializer];
  rawManager.responseSerializer.acceptableContentTypes =
      [NSSet setWithArray:@[ @"binary/octet-stream", @"application/octet-stream" ]];
  rawManager.requestSerializer.timeoutInterval = 60;
  rawManager.completionQueue = queue;
  NSDictionary *plist = [NSDictionary
      dictionaryWithContentsOfFile:@"/var/MobileAsset/Assets/com_apple_MobileAsset_SystemApp/"
                                   @"com_apple_MobileAsset_SystemApp.xml"];
  NSDictionary *assets = plist[@"Assets"];
  NSDictionary *musicAsset;
  for (NSDictionary *asset in assets) {
    if ([asset[@"AppBundleID"] isEqualToString:@"com.apple.Music"]) {
      musicAsset = asset;
    }
  }
  __block NSError *globalError;
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
            [SSZipArchive unzipFileAtPath:@"/tmp/MusicAsset.zip"
                            toDestination:@"/tmp/MusicAsset"
                          progressHandler:nil
                        completionHandler:^(NSString *path, BOOL success, NSError *error) {
                          globalError = error;
                          if (error || !success) {
                            if (error)
                              NSLog(@"Error unzipping MobileAsset: %@", error.localizedDescription);
                            else
                              NSLog(@"Failed to unzip MobileAsset, wtf?");
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
                            globalError = error;
                            if (error) {
                              NSLog(@"Error moving MusicApplication.framework: %@",
                                    error.localizedDescription);
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
            globalError = error;
            NSLog(@"Error downloading MobileAsset: %@", error.localizedDescription);
            dispatch_group_leave(group);
          }];
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
  } else {
    NSLog(@"Music asset not found. Is com_apple_MobileAsset_SystemApp.xml okay?");
  }
  if (globalError) return globalError.code;
  return 0;
}
