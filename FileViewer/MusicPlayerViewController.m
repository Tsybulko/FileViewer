//
//  MusicPlayerViewController.m
//  FileViewer
//
//  Created by Александр on 20.03.13.
//  Copyright (c) 2013 Alexandr Tsybulko. All rights reserved.
//

#import "MusicPlayerViewController.h"

@interface MusicPlayerViewController ()

@end

@implementation MusicPlayerViewController
@synthesize audioPlayer;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        playButton.frame = CGRectMake(20, 20, 100, 44); // position in the parent view and set the size of the button
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:playButton];
       
        UIButton *pauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        pauseButton.frame = CGRectMake(150, 20, 100, 44); // position in the parent view and set the size of the button
        [pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [pauseButton addTarget:self action:@selector(stopAudio:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:pauseButton];
        
   
    }
    return self;
}

-(id)initWithUrl:(NSURL*)url_{
    self =  [self initWithNibName:nil bundle:nil];
    url = url_;
    
    
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:url_
                        error:&error];
    
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    }

    return self;
}



-(void)playAudio:(id)sender
{
    [audioPlayer play];
}
-(void)stopAudio:(id)sender
{
    [audioPlayer stop];
}


-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
