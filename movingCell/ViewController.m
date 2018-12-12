//
//  ViewController.m
//  movingCell
//
//  Created by Apple on 2018/12/11.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "ViewController.h"
#import "moving/movingSearchViewCtr.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)btnClick:(id)sender {
    movingSearchViewCtr *searchVC = [[movingSearchViewCtr alloc] init];
    [self presentViewController:searchVC animated:YES completion:nil];
}


@end
