#include <stdio.h>

@interface LSApplicationProxy : NSObject
@property (nonatomic, assign) NSURL *bundleURL;
+ (LSApplicationProxy *)applicationProxyForIdentifier:(NSString *)bundleIdentifier;
@end

int main(int argc, char *argv[], char *envp[]) {
	@autoreleasepool {
		NSFileManager *fm = [NSFileManager defaultManager];
		NSString *target = @"/Library/Frameworks/MusicApplication.framework";
		NSURL *bundleURL = [LSApplicationProxy applicationProxyForIdentifier:@"com.apple.Music"].bundleURL;
		if (bundleURL) {
			printf("Found Music.app\n");
			NSString *framework = [bundleURL.path stringByAppendingPathComponent:@"Frameworks/MusicApplication.framework"];
			if (![fm fileExistsAtPath:target] || ![fm contentsEqualAtPath:framework andPath:target]) {
				printf("Copying MusicApplication.framework\n");
				NSError *error;
				[fm copyItemAtPath:framework toPath:target error:&error];
				if (error) {
					printf("Error: %s\n", [error.description UTF8String]);
					return 1;
				}
				return 0;
			}
		}
		else {
			printf("\n");
			for(int i = 0; i < 3; i++)
				printf("*** Install the Apple Music app before installing Ablaze ***\n");
			printf("\n");
			return 1;
		}
		return 0;
	}
}
