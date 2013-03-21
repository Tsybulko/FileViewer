//
//  MusicPlayerViewController.h
//  FileViewer
//
//  Created by Александр on 20.03.13.
//  Copyright (c) 2013 Alexandr Tsybulko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicPlayerViewController : UIViewController
<AVAudioPlayerDelegate>
{
    
    NSURL *url;
}
@property(nonatomic,strong) AVAudioPlayer *audioPlayer;

-(id)initWithUrl:(NSURL*)url_;

@end
