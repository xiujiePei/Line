//
//  ViewController.m
//  Line
//
//  Created by hh on 16/6/23.
//  Copyright © 2016年 pxj. All rights reserved.
//

#import "ViewController.h"
#import "StockCodeLineView.h"
#import "Entity.h"
#import "JSONKit.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()
@property (strong, nonatomic)StockCodeLineView *SCLViewTest;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.SCLViewTest = [[StockCodeLineView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200)];
    [self.view addSubview:self.SCLViewTest];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"StockCodeLine" ofType:@"txt"];
    NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dic = [str objectFromJSONString];
    
    self.SCLViewTest.SCLData = [[StockCodeLineDatasEntity alloc] initWithInfos:dic];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
