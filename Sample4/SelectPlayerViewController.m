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

static TestUIScrollView* createThumbScrollView(CGRect inFrame)
{
	TestUIScrollView* thumbScrollView = [[TestUIScrollView alloc] initWithFrame:inFrame];
	[thumbScrollView setCanCancelContentTouches:NO];
	[thumbScrollView setClipsToBounds:NO];
    [thumbScrollView setShowsVerticalScrollIndicator:FALSE];
    [thumbScrollView setAlwaysBounceHorizontal:YES];
    [thumbScrollView setAlwaysBounceVertical:NO];
    [thumbScrollView setPagingEnabled:YES];
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
    
    // イメージセット
    UIImage *image = nil;
    if (self.boardType == SOCCER) {
        image = [UIImage imageNamed:@"サッカー.png"];
    } else if (self.boardType == BASEBALL) {
        image = [UIImage imageNamed:@"野球.png"];
    } else if (self.boardType == BASKETBALL) {
        image = [UIImage imageNamed:@"バスケット.png"];
    }
    [self.boadImage setImage:image];

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
    
    NSLog(@"=======きた！　%@",thumbView);
    
    CGFloat thumbY = thumbView.frame.origin.y;
    if (thumbY < 0) {
        // 座標yがマイナスになった場合は、スクロールビューから外れたとみなす。

        // y 座標の算出
        // -20 は微調整。
        CGFloat y = self.view.frame.size.height - THUMB_WIDTH - 20 + thumbY;
        
//        NSLog(@"self.view.frame->%f", self.view.frame.size.width);
//        NSLog(@"now->%f, home->%f", thumbView.frame.origin.x, thumbView.home.origin.x);
        
        // x 座標の算出
        float xxx = floorf(thumbView.home.origin.x / self.view.frame.size.width);

        CGFloat xx = thumbView.home.origin.x - (self.view.frame.size.width * xxx);
        CGFloat x = xx + (thumbView.frame.origin.x - thumbView.home.origin.x);

//        NSLog(@"xxx->%f, xx->%f, x->%f", xxx, xx, x);

        thumbView.frame = CGRectMake(x, y, thumbView.frame.size.width, thumbView.frame.size.height);
        [self.view addSubview:thumbView];
    } else if (thumbY > thumbScrollView.frame.origin.y) {
        thumbView.frame =  CGRectMake(MARGIN, MARGIN, THUMB_WIDTH, THUMB_HEIGHT);
        [thumbScrollView addSubview:thumbView];
    }
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

    // スクロールビューにページを差し込む
    
    // １ページ毎のサムビュー数
    const int thumbs = 3;
    
    UIView* slide = nil;
	CGRect thumbFrame;
    CGRect slideFrame;
    int count = 0;
    int slideCount = 0;
	for(NSDictionary *dict in info) {
        if (count % thumbs == 0) {
            slideFrame = CGRectMake(0.0 + (self.view.frame.size.width * slideCount),
                                    0.0,
                                    self.view.frame.size.width,
                                    thumbScrollView.frame.size.height);
            slide = [[UIView alloc] initWithFrame:slideFrame];
            slideCount++;
            [thumbScrollView addSubview:slide];
            thumbFrame = CGRectMake(MARGIN, MARGIN, THUMB_WIDTH, THUMB_HEIGHT);
        }
        count++;
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        [iv setFrame:CGRectMake(0.0, 0.0, thumbFrame.size.width, thumbFrame.size.height)];
		
        ThumbView *view = [[ThumbView alloc] initWithFrame:thumbFrame];
        [view addSubview:iv];

		[slide addSubview:view];
		thumbFrame.origin.x += (thumbFrame.size.width + MARGIN);			//	横にずらす
	}
    // XXX 立て幅 80 だけどここは流動にしたい。とりえあえず 80に。
    CGSize thumbScrollViewSize = CGSizeMake(slideFrame.origin.x + self.view.frame.size.width, THUMB_HEIGHT);

    [thumbScrollView setContentSize:thumbScrollViewSize];
    
	//	スクロールビューを埋め込む入れ物を作成
	CGRect bounds = [[self view] bounds];
	thumbScrollView.frame = CGRectMake(CGRectGetMinX(bounds),
                                       CGRectGetMaxY(bounds) - [thumbScrollView frame].size.height,
                                       bounds.size.width,
                                       [thumbScrollView frame].size.height);

    
	[[self view] addSubview:thumbScrollView];

}


- (void)elcImagePickerControllerDidCancel:(SelectPlayerViewController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    NSLog(@"touchesBegan");
    CGPoint point = [[touches anyObject] locationInView:self.view];
    NSLog(@"controller_began x->%f, y->%f", point.x, point.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    NSLog(@"controller_end x->%f, y->%f", point.x, point.y);

}


@end
