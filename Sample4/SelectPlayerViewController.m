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

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>


@interface SelectPlayerViewController ()

@end

@implementation SelectPlayerViewController

#define THUMB_WIDTH 65		//	サムネイルビューの幅
#define THUMB_HEIGHT 65	//	〃　高さ
#define MARGIN 12			//	サムネイルビュー間のすきま

static TestUIScrollView* createThumbScrollView(CGRect inFrame)
{
	TestUIScrollView* thumbScrollView = [[TestUIScrollView alloc] initWithFrame:inFrame];
	[thumbScrollView setCanCancelContentTouches:NO];
	[thumbScrollView setClipsToBounds:NO];
    [thumbScrollView setShowsVerticalScrollIndicator:FALSE];
    [thumbScrollView setAlwaysBounceHorizontal:YES];
    [thumbScrollView setAlwaysBounceVertical:NO];
    [thumbScrollView setPagingEnabled:YES];
    [thumbScrollView setUserInteractionEnabled:YES];
//    [thumbScrollView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.1f]];
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
        image = [UIImage imageNamed:@"バスケット.jpg"];
    }
    [self.boadImage setImage:image];
    [self.boadImage setUserInteractionEnabled:YES];

	//	スクロールビュー作成
	float scrollViewHeight = MARGIN + THUMB_HEIGHT + MARGIN;
	float scrollViewWidth  = [[self view] bounds].size.width;
	thumbScrollView = createThumbScrollView(CGRectMake(0, 0, scrollViewWidth, scrollViewHeight));

    // バーボタン
    UIBarButtonItem* right1 = [[UIBarButtonItem alloc]
                               initWithTitle:@"選択"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(launch:)];
    
    UIBarButtonItem* right2 = [[UIBarButtonItem alloc]
                               initWithTitle:@"保存"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(printing:)];
    self.navigationItem.rightBarButtonItems = @[right1, right2];
    
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
    
    CGFloat thumbY = thumbView.frame.origin.y;
    if (thumbY < 0) {
        // 座標yがマイナスになった場合は、スクロールビューから外れたとみなす。

        // y 座標の算出
        // -20 は微調整。
        CGFloat y = self.view.frame.size.height - THUMB_WIDTH - 20 + thumbY;
        
        thumbView.frame = CGRectMake(thumbView.frame.origin.x, y
                                     , thumbView.frame.size.width, thumbView.frame.size.height);
        [self.boadImage addSubview:thumbView];

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

// SHOT ボタン押下
- (void)printing:(id)sender {
    // See http://iphone-dev.g.hatena.ne.jp/saika_makoto/20081117
    
    //アラートビューの生成と設定
    // 改行はオプションキーを押しながら ¥ ボタン押下
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"スクリーンショットの保存"
                          message:@"フォトアルバムに保存します。\nよろしいですか?"
                          delegate:self
                          cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    [alert show];

}

// アラートからのデリゲート
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"push ->%d", buttonIndex);
    if (buttonIndex != 1) {
        return;
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    // 画像切り取り。下の空白部分を除外。155 は微調整
    screenRect.size.height -= 155;
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [self.view.layer renderInContext:ctx];
    
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(screenImage, nil, nil, nil);
    UIGraphicsEndImageContext();
    
    
    //アラートビューの生成と設定
    UIAlertView *alertFin = [[UIAlertView alloc]
                             initWithTitle:@"スクリーンショットの保存"
                             message:@"保存しました。"
                             delegate:nil
                             cancelButtonTitle:@"閉じる" otherButtonTitles:nil];
    [alertFin show];
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
    //	THUMB_WIDTH x THUMB_HrEIGHT をサムネイルビューとする

    // スクロールビューにページを差し込む
    
    // １ページ毎のサムビュー数
    const int thumbs = 4;
    
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

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    //    NSLog(@"touchesBegan");
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//    NSLog(@"controller_began x->%f, y->%f", point.x, point.y);
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//    NSLog(@"controller_end x->%f, y->%f", point.x, point.y);
//
//}


@end
