//
//  ViewController.m
//  ApplicationShortCutDemo
//
//  Created by 张好志 on 15/10/22.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "FirstViewController.h"

@interface ViewController ()<UIViewControllerPreviewingDelegate>

@property (strong, nonatomic) IBOutlet UIButton *ui_nextBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //注册3DTouch
    [self registerForPreviewingWithDelegate:self sourceView:self.view];
    
}

//peek动作 力道等级较小时
- (UIViewController *) previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //高斯模糊下高亮清晰显示的部分
    previewingContext.sourceRect = self.ui_nextBtn.frame;
    
    //返回3Dtouch的目标viewController
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController * tmpVc = [storyBoard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    tmpVc.webUrl = @"http://www.baidu.com.cn";
    tmpVc.preferredContentSize = CGSizeMake(414, 736);
    
    return tmpVc;
}


//pop动作 力道等级较大时
- (void) previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    FirstViewController *vc = [[FirstViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) ceshi
{
    NSLog(@"LLLLLLLLLLLLLLLLLLLLLLL");
}

- (IBAction) nextAction:(id)sender
{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController * tmpVc = [storyBoard instantiateViewControllerWithIdentifier:@"DetailViewController"];
//    DetailViewController *tmpVc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self.navigationController pushViewController:tmpVc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
