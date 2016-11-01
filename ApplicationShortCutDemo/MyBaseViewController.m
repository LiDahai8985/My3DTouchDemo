//
//  MyBaseViewController.m
//  My3DTouchDemo
//
//  Created by LiDaHai on 16/11/1.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import "MyBaseViewController.h"

@interface MyBaseViewController ()

@end

@implementation MyBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSStringFromClass([self class]);
    
    //设置返回按钮
    [self setNavigationBarBackItem];
}


// 设置导航条返回按钮
- (void)setNavigationBarBackItem
{
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backItemClickHandler)];
    }
}

// pop出页面
- (void)backItemClickHandler
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark-
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
