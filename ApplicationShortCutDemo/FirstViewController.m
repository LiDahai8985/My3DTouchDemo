//
//  FirstViewController.m
//  ApplicationShortCutDemo
//
//  Created by LiDaHai on 16/6/3.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import "FirstViewController.h"
#import "DetailViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation FirstViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //注册3DTouch
    [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
}

//peek动作 力道等级较小时
- (UIViewController *) previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //高斯模糊下高亮清晰显示的部分
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath.row == 2) {
        return nil;
    }
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    previewingContext.sourceRect = cell.frame;
    
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
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondVCCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
