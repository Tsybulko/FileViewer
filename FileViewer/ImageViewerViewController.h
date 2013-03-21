//
//  ImageViewerViewController.h
//  FileViewer
//
//  Created by Александр on 19.03.13.
//  Copyright (c) 2013 Alexandr Tsybulko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewerViewController : UIViewController

-(id)initWithPathToImage:(NSString*)pathToImage;

@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) UIImageView* imageView;

@end
