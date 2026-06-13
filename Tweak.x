#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// Hook into Spotify's Canvas video rendering engine
%hook SPTCanvasVideoPlayerViewController

- (void)viewDidLoad {
    %orig;
    
    // Listen for when a video loop starts playing inside Spotify
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleCanvasVideoChange:) 
                                                 name:@"SPTCanvasVideoPlayerItemChangedNotification" 
                                               object:nil];
}

%new
- (void)handleCanvasVideoChange:(NSNotification *)notification {
    // Extract the raw video asset currently running inside the player
    AVPlayerItem *currentItem = [notification object];
    if (currentItem) {
        // Forward this active video stream directly to the iOS Lock Screen system player
        Class mpControlCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
        if (mpControlCenter) {
            id center = [mpControlCenter defaultCenter];
            
            // Access Apple's official API for third-party animated lockscreens
            NSMutableDictionary *nowPlayingInfo = [[center nowPlayingInfo] mutableCopy] ?: [NSMutableDictionary dictionary];
            
            // Inject the video item as the animated background artwork context
            if (@available(iOS 16.0, *)) {
                // Instantiates the animated artwork object using the background video loop
                id animatedArtwork = [[NSClassFromString(@"MPMediaItemAnimatedArtwork") alloc] initWithVideoPlayerItem:currentItem];
                [nowPlayingInfo setObject:animatedArtwork forKey:@"nowPlayingAnimatedArtwork"];
                [center setNowPlayingInfo:nowPlayingInfo];
            }
        }
    }
}

%end
