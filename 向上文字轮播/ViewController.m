//
//  ViewController.m
//  向上文字轮播
//
//  Created by bug neo on 2018/8/9.
//  Copyright © 2018年 bug neo. All rights reserved.
//

#import "ViewController.h"

#import "LabelScrollView.h"

@interface ViewController ()
@property (nonatomic, strong) LabelScrollView *labelScroll;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelScroll = [[LabelScrollView alloc] initWithFrame:CGRectMake(10, 100, 200, 80)];
    [self.view addSubview:self.labelScroll];
    self.labelScroll.dataSource = [NSMutableArray arrayWithObjects:@"澳门", @"皇家",@"FBI",@"Warning",@"东京",@"热门",@"一拳超人", nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.labelScroll showNext];
}


@end
