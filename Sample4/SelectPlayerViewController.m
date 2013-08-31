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
#import "ThumbView.h"

@interface SelectPlayerViewController ()

@end

@implementation SelectPlayerViewController

#define THUMB_WIDTH 80		//	サムネイルビューの幅
#define THUMB_HEIGHT 80	//	〃　高さ
#define MARGIN 10			//	サムネイルビュー間のすきま

static UIScrollView* createThumbScrollView(CGRect inFrame)
{
	UIScrollView* thumbScrollView = [[UIScrollView alloc] initWithFrame:inFrame];
	[thumbScrollView setCanCancelContentTouches:NO];
	[thumbScrollView setClipsToBounds:NO];
    [thumbScrollView setShowsVerticalScrollIndicator:FALSE];
    [thumbScrollView setAlwaysBounceHorizontal:YES];
    [thumbScrollView setAlwaysBounceVertical:NO];
    
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(thumb:) name:@"thumbNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)thumb:(NSNotification *)notification {
    
    ThumbView *thumbView = (ThumbView *)notification.object;
    
    NSLog(@"きた！　%@",thumbView);
    
    thumbView.frame = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:thumbView];
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
	
    for (UIView *v in [thumbScrollView subviews]) {
        [v removeFromSuperview];
    }

    [self createThumbNail:(info)];
    return;

}

- (void)createThumbNail:(NSArray *)info
{
    
	//	スクロールビューにサムネイルビューを埋め込む
    //	THUMB_WIDTH x THUMB_HEIGHT をサムネイルビューとする
	CGRect frame = CGRectMake(MARGIN, MARGIN, THUMB_WIDTH, THUMB_HEIGHT);
	for(NSDictionary *dict in info) {
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        [iv setFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
		
        ThumbView *view = [[ThumbView alloc] initWithFrame:frame];
		view.backgroundColor = [UIColor greenColor];
        [view addSubview:iv];

		[thumbScrollView addSubview:view];
		frame.origin.x += (frame.size.width + MARGIN);			//	横にずらす
	}
    // XXX 立て幅 80 だけどここは流動にしたい。とりえあえず 80に。
    CGSize thumbScrollViewSize = CGSizeMake(frame.origin.x, 80);

    [thumbScrollView setContentSize:thumbScrollViewSize];
    
	//	スクロールビューを埋め込む入れ物を作成
	CGRect bounds = [[self view] bounds];
	frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds) - [thumbScrollView frame].size.height, bounds.size.width, [thumbScrollView frame].size.height);

    thumbScrollView.frame = frame;
	[thumbScrollView setBackgroundColor:[UIColor orangeColor]];
    
	[[self view] addSubview:thumbScrollView];

}


- (void)elcImagePickerControllerDidCancel:(SelectPlayerViewController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
