//
//  FilesTableViewController.m
//  FileViewer
//
//  Created by Александр on 19.03.13.
//  Copyright (c) 2013 Alexandr Tsybulko. All rights reserved.
//

#import "FilesTableViewController.h"
#import "ImageViewerViewController.h"
#import "MusicPlayerViewController.h"

#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]


@interface FilesTableViewController ()

@end

@implementation FilesTableViewController

@synthesize filesList = _filesList;
@synthesize filesTable = _filesTable;
@synthesize filesType = _filesType;
@synthesize filter = _filter;
@synthesize alert = _alert;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize textField = _textField;
@synthesize musicPlayer = _musicPlayer;
@synthesize numberFiles = _numberFiles;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _filesList = [[NSMutableArray alloc] init];

        _alert = [[UIAlertView alloc] initWithTitle:@"File Viewer" message:@"Please enter new name\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        _numberFiles = [[UILabel alloc] init];
        [self.view addSubview:_numberFiles];
        _textField = [[UITextField alloc] init];
        [_textField setBackgroundColor:[UIColor whiteColor]];
        _textField.delegate = self;
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.frame = CGRectMake(15, 75, 255, 30);
        _textField.font = [UIFont fontWithName:@"ArialMT" size:20];
        _textField.placeholder = @"Preset Name";
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.keyboardAppearance = UIKeyboardAppearanceAlert;
        [_textField becomeFirstResponder];
        [_alert addSubview:_textField];
    }
    return self;
}

-(id)initForImageFiles{
    self = [self initWithNibName:nil bundle:nil];
    self.title = NSLocalizedString(@"Images", @"Images");
    tabTypes = kImage;
    self.filter = [NSPredicate predicateWithFormat:@"(self ENDSWITH '.jpg')OR(self ENDSWITH'.jpeg')OR(self ENDSWITH'.png')OR(self ENDSWITH'.bmp')"];
    [self updateFilesList];
    [self createTableForFiles];
    return self;
}

-(id)initForMusicFiles{
    self = [self initWithNibName:nil bundle:nil];
    self.title = NSLocalizedString(@"Music", @"Music");
    self.filter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.mp3'"];
    tabTypes = kMusic;
    [self updateFilesList];
    [self createTableForFiles];
    return self;
}


-(id)initForOtherFiles{
    self = [self initWithNibName:nil bundle:nil];
    self.title = NSLocalizedString(@"Other files", @"Other files");
    tabTypes = kOther;
    self.filter = [NSPredicate predicateWithFormat:@"NOT(self ENDSWITH '.mp3')AND NOT(self ENDSWITH '.jpg')AND NOT(self ENDSWITH'.jpeg')AND NOT(self ENDSWITH'.png')AND NOT(self ENDSWITH'.bmp')"];
    [self updateFilesList];
    [self createTableForFiles];
    return self;
}

-(void)updateFilesList{
    
    NSString *documentsDirectory = DOCUMENTS;
    NSArray *fileListAct = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
    if(tabTypes == kMusic){
        /* Сортировка по размеру файла. Для вкладки музыка*/
        fileListAct = [fileListAct sortedArrayUsingComparator:^(id obj1, id obj2) {
            NSError *attributesError = nil;
            int size1 =   [[[NSFileManager defaultManager] attributesOfItemAtPath:[DOCUMENTS stringByAppendingPathComponent:obj1] error:&attributesError] fileSize];
            int size2 =   [[[NSFileManager defaultManager] attributesOfItemAtPath:[DOCUMENTS stringByAppendingPathComponent:obj2] error:&attributesError] fileSize];
            if(size1 == size2){
                return 0;
            }else if(size1 > size2){
                return 1;
            }else {
                return -1;
            }
        }];
    }else{
        /* Сортировка по имени файла*/
        fileListAct = [fileListAct sortedArrayUsingComparator:^(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
    }
    self.filesList = (NSMutableArray*)[fileListAct filteredArrayUsingPredicate:_filter];
    _numberFiles.text = [NSString stringWithFormat:@"Number of files:%d",[_filesList count]];
}



-(void)createTableForFiles{

    self.filesTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300, 380) style:UITableViewStylePlain];
    self.filesTable.delegate = self;
    self.filesTable.dataSource = self;
    [self.view addSubview:_filesTable];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_filesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[_filesList objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndexPath = indexPath;
    if(tabTypes == kOther){
        [[[UIActionSheet alloc] initWithTitle:nil
                                     delegate:self
                            cancelButtonTitle:@"Close"
                       destructiveButtonTitle:nil
                            otherButtonTitles:@"Delete", nil]
         showFromTabBar:self.tabBarController.tabBar];
    }else{
        [[[UIActionSheet alloc] initWithTitle:nil
                                     delegate:self
                            cancelButtonTitle:@"Close"
                       destructiveButtonTitle:nil
                            otherButtonTitles:@"Open file", @"Rename", @"Delete", nil]
         showFromTabBar:self.tabBarController.tabBar];

    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (tabTypes) {
        case kMusic:
            switch (buttonIndex) {
                case 0:
                    [self openMusic]; break;
                case 1:
                    [self renameFile];break;
                case 2:
                    [self deleteFile]; break;
            }
            break;
        case kImage:
            switch (buttonIndex) {
                case 0:
                    [self openImage]; break;
                case 1:
                    [self renameFile];break;
                case 2:
                    [self deleteFile]; break;
            }
            break;
        case kOther:
            switch (buttonIndex) {
                case 0:
                    [self deleteFile]; break;
            }
            break;
        default:
            break;
    }
}

-(void)openImage{
    
    UITableViewCell *cell = [_filesTable cellForRowAtIndexPath:_selectedIndexPath];
    NSString *cellText = cell.textLabel.text;
    NSString *path = [DOCUMENTS stringByAppendingPathComponent:cellText];
    ImageViewerViewController *imageViewer = [[ImageViewerViewController alloc] initWithPathToImage:path];
    [[self navigationController] pushViewController:imageViewer animated:YES];
}

-(void)openMusic{
    UITableViewCell *cell = [_filesTable cellForRowAtIndexPath:_selectedIndexPath];
    NSString *cellText = cell.textLabel.text;
    NSString *path = [DOCUMENTS stringByAppendingPathComponent:cellText];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.musicPlayer = [[MusicPlayerViewController alloc] initWithUrl:url];
    [[self navigationController] pushViewController:_musicPlayer animated:YES];

}


-(void)renameFile{
    
    [_alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView.title isEqual:@"Error"]){
        //Ошибка переименования. Вызов сообщения для нового ввода данных
        [_alert show];
    }
    
    NSString* detailString = _textField.text;
    if ([_textField.text length] <= 0 || buttonIndex == 0){
        return; 
    }
    if (buttonIndex == 1) {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSError *error;
        UITableViewCell *cell = [_filesTable cellForRowAtIndexPath:_selectedIndexPath];
        NSString *cellText = cell.textLabel.text;
        NSString *path = [DOCUMENTS stringByAppendingPathComponent:cellText];
        NSString *path2 = [DOCUMENTS stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", detailString,[path pathExtension]]];
        if ([fileMgr moveItemAtPath:path toPath:path2 error:&error] != YES){
            UIAlertView *alertError = [[UIAlertView alloc]
                                  initWithTitle: @"Error"
                                  message: @"Rename failed"
                                  delegate: self
                                       cancelButtonTitle:nil
                                  otherButtonTitles:@"OK",nil];
        [alertError show];
        }
        [self updateFilesList];
        [self.filesTable reloadData];
        
    }
}

-(void)deleteFile{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error;
    UITableViewCell *cell = [_filesTable cellForRowAtIndexPath:_selectedIndexPath];
    NSString *cellText = cell.textLabel.text;
    NSString *path = [DOCUMENTS stringByAppendingPathComponent:cellText];
    if ([fileMgr removeItemAtPath:path error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);

    [self updateFilesList];
    [self.filesTable reloadData];
}



- (void)viewWillAppear:(BOOL)animated{
    [self updateFilesList];
    [self.filesTable reloadData];
    [self willAnimateRotationToInterfaceOrientation:[[UIDevice currentDevice] orientation] duration:0];

}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    int tabBarHeight = [[[super tabBarController] tabBar] frame].size.height;
    int navigationControllerHeight = [[[super navigationController] navigationBar] frame].size.height;
    CGRect  screenRect   = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth  = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
        if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
            
            _filesTable.frame = CGRectMake(0.0f, 0.0f, screenHeight, screenWidth-_numberFiles.frame.size.height - tabBarHeight - navigationControllerHeight - 40 );
            _numberFiles.frame = CGRectMake(0,screenWidth - tabBarHeight - navigationControllerHeight - 40 , 300, 20);
        }else{
            _filesTable.frame = CGRectMake(0.0f, 0.0f, screenWidth, screenHeight-_numberFiles.frame.size.height - tabBarHeight - navigationControllerHeight - 40);
            _numberFiles.frame = CGRectMake(0, screenHeight - tabBarHeight - navigationControllerHeight - 40 , 300, 20);
           
            
        }
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
