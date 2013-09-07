//
//  ViewController.m
//  Sample4
//
//  Created by 中村 祥二 on 13/08/04.
//  Copyright (c) 2013年 中村 祥二. All rights reserved.
//

#import "ViewController.h"
#import "BoardTypeEnum.h"
#import "SelectPlayerViewController.h"
#import "BoardTypeEnum.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BoardTypeEnum type = 0;
    
    if ([segue.identifier isEqualToString:@"SOCCER"]) {
        type = SOCCER;
    } else if ([segue.identifier isEqualToString:@"BASEBALL"])  {
        type = BASEBALL;
    } else if ([segue.identifier isEqualToString:@"BASKETBALL"])  {
        type = BASKETBALL;
    }

    SelectPlayerViewController* ctrl =
        (SelectPlayerViewController*)[segue destinationViewController];
    [ctrl setBoardType:type];

}

@end
