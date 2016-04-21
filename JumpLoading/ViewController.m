//
//  ViewController.m
//  JumpLoading
//
//  Created by Realank on 16/4/20.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "ViewController.h"
#import "JumpLoadingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    JumpLoadingView* view = [[JumpLoadingView alloc] initWithFrame:CGRectMake(40, 50, 300, 100)];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
