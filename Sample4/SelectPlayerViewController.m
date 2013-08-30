//
//  SelectPlayer.m
//  Sample4
//
//  Created by 中村 祥二 on 13/08/05.
//  Copyright (c) 2013年 中村 祥二. All rights reserved.
//

#import "SelectPlayerViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "AppDelegate.h"

@interface SelectPlayerViewController ()

@end

@implementation SelectPlayerViewController

@synthesize scrollView = _scrollView;
@synthesize chosenImages = _chosenImages;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (IBAction)launch:(id)sender {
    NSLog(@"message1");
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName: nil bundle: nil];
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    
    [albumController setParent:elcPicker];
	[elcPicker setDelegate:self];
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}


- (void)elcImagePickerController:(SelectPlayerViewController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
	
    for (UIView *v in [_scrollView subviews]) {
        [v removeFromSuperview];
    }

    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];

    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150*[info count], 80)];

    int i = 0;
	for(NSDictionary *dict in info) {
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [images addObject:image];
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        iv.frame = CGRectMake(150 * i++, 0, 150, 80);
        NSLog(@"Rect->%@", NSStringFromCGRect(iv.frame));
        [containView addSubview:iv];
    }
    
    _scrollView.contentSize = containView.frame.size;
    [_scrollView addSubview:containView];
	[_scrollView setPagingEnabled:YES];
}


- (void)elcImagePickerControllerDidCancel:(SelectPlayerViewController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}




@end
