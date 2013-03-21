//
//  ImageViewerViewController.m
//  File Viewer
//
//  Created by Александр on 19.03.13.
//  Copyright (c) 2013 Alexandr Tsybulko. All rights reserved.
//

#import "ImageViewerViewController.h"

@interface ImageViewerViewController ()

@end

@implementation ImageViewerViewController
@synthesize image = _image;
@synthesize imageView = _imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithPathToImage:(NSString*)pathToImage{
    
    self = [self initWithNibName:nil bundle:nil];
    self.image = [UIImage imageWithContentsOfFile:pathToImage];
    self.imageView = [[UIImageView alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    return self;
}

-(void)compressImage{
    CGImageRef cg_image = [_image CGImage];
    
    CGFloat imageWidth   = CGImageGetWidth(cg_image);
    CGFloat imageHeight  = CGImageGetHeight(cg_image);
    CGRect  screenRect   = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth;
    CGFloat screenHeight;
    if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight){
        screenWidth  = screenRect.size.height;
        screenHeight = screenRect.size.width;
    }else{
        screenWidth  = screenRect.size.width;
        screenHeight = screenRect.size.height;
    }
    int navigationControllerHeight = [[[super navigationController] navigationBar] frame].size.height;
    screenHeight=screenHeight -20 - navigationControllerHeight;
    
    float scale;
    float scaleForWidth = imageWidth/screenWidth;
    float scaleForHeigth = imageHeight/screenHeight;
    
    if(scaleForHeigth > scaleForWidth){
        scale = scaleForHeigth;
    }else{
        scale = scaleForWidth;
    }
    
    if(cg_image != NULL)
    {
        self.imageView.image = nil;
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:cg_image scale:scale orientation:UIImageOrientationUp]];
        [_imageView setCenter:CGPointMake(screenWidth/2, screenHeight/2)];
        [self.view addSubview:_imageView];

    }
  
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(toInterfaceOrientation){
        [self compressImage];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self compressImage];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backToPreviousView:)];
    self.navigationItem.leftBarButtonItem = doneButton;
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self compressImage];

}
- (void)backToPreviousView:(id)sender{
  [[self navigationController] popViewControllerAnimated:YES];  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
