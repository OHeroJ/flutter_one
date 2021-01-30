//
//  ViewController.m
//  Runner
//
//  Created by imac on 2021/1/18.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 300, 100)];
    [btn setTitle:@"wait 10s, then click!" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)back:(id)sender {
    [UIApplication sharedApplication].keyWindow.rootViewController = self.rootVc;
}

@end
