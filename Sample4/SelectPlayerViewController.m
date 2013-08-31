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
#import "thumbView.h"

@interface SelectPlayerViewController ()

@end

@implementation SelectPlayerViewController

@synthesize scrollView = _scrollView;
@synthesize chosenImages = _chosenImages;

#define THUMB_WIDTH 100		//	サムネイルビューの幅
#define THUMB_HEIGHT 100	//	〃　高さ
#define MARGIN 10			//	サムネイルビュー間のすきま

static UIScrollView* createThumbScrollView(CGRect inFrame)
{
	UIScrollView* thumbScrollView = [[UIScrollView alloc] initWithFrame:inFrame];
	[thumbScrollView setCanCancelContentTouches:NO];
	[thumbScrollView setClipsToBounds:NO];
	return thumbScrollView;
}

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
	//	スクロールビュー作成
	float scrollViewHeight = MARGIN + THUMB_HEIGHT + MARGIN;
	float scrollViewWidth  = [[self view] bounds].size.width;
	thumbScrollView = createThumbScrollView(CGRectMake(0, 0, scrollViewWidth, scrollViewHeight));

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

    [self xxx:(info)];
    return;
    
    /// この下のロジックはいまのところ不要だが、ひとまず残しておく。
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];

    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150*[info count], 80)];

    int i = 0;
    
    CGRect viewFrame = CGRectMake(5,5, 120, 70);
	for(NSDictionary *dict in info) {
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        
        [images addObject:image];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        
        iv.frame = CGRectMake(150 * i++, 0, 150, 80);

		thumbView *view = [[thumbView alloc] initWithFrame:viewFrame];
        [view addSubview:iv];
        
        NSLog(@"Rect->%@", NSStringFromCGRect(view.frame));
        [containView addSubview:view];
    }
    
    _scrollView.contentSize = containView.frame.size;
    [_scrollView addSubview:containView];
	[_scrollView setPagingEnabled:YES];
}

- (void)xxx:(NSArray *)info
{
    
	//	スクロールビューにサムネイルビューを埋め込む
    //	THUMB_WIDTH x THUMB_HEIGHT をサムネイルビューとする
	CGRect frame = CGRectMake(MARGIN, MARGIN, THUMB_WIDTH, THUMB_HEIGHT);
	for(NSDictionary *dict in info) {
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        [iv setFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
		
        thumbView *view = [[thumbView alloc] initWithFrame:frame];
        [view addSubview:iv];

		[thumbScrollView addSubview:view];
		frame.origin.x += (frame.size.width + MARGIN);			//	横にずらす
	}
	[thumbScrollView setContentSize:CGSizeMake(frame.origin.x, [[self view] bounds].size.width)];
    
	//	スクロールビューを埋め込む入れ物を作成
	CGRect bounds = [[self view] bounds];
	frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds) - [thumbScrollView frame].size.height, bounds.size.width, [thumbScrollView frame].size.height);
	slideUpView = [[UIView alloc] initWithFrame:frame];
	//	暗い半透明の黒の背景とする
	[slideUpView setBackgroundColor:[UIColor orangeColor]];
	[slideUpView setOpaque:NO];
	[slideUpView setAlpha:0.75];
	[[self view] addSubview:slideUpView];
	//	スクロールビュー埋めこみ
	[slideUpView addSubview:thumbScrollView];

}


- (void)elcImagePickerControllerDidCancel:(SelectPlayerViewController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
