#import <UIKit/UIKit.h>

%hook SpotifyAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"[Spotweak] Animated Lockscreen hook engine successfully initialized.");
    return %orig;
}
%end
