//
//  FilesTableViewController.h
//  FileViewer
//
//  Created by Александр on 19.03.13.
//  Copyright (c) 2013 Alexandr Tsybulko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPlayerViewController.h" 


typedef enum _TabType{
  kMusic,
  kImage,
  kOther
} TabTypes;

@interface FilesTableViewController : UIViewController
                    <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>{
    TabTypes tabTypes;
}

@property(nonatomic,strong) UITableView *filesTable;
@property(nonatomic,strong) NSMutableArray *filesList;
@property(nonatomic,strong) NSString* filesType;
@property(nonatomic,strong) UIAlertView* alert;
@property(nonatomic,strong) NSPredicate *filter;
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) UILabel *numberFiles;
@property(nonatomic,strong) MusicPlayerViewController* musicPlayer;

-(id)initForImageFiles;
-(id)initForMusicFiles;
-(id)initForOtherFiles;

@end
