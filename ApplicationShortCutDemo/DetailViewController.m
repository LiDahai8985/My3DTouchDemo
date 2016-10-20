//
//  DetailViewController.m
//  ApplicationShortCutDemo
//
//  Created by LDhai on 15/11/24.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewController.h"

@interface DetailViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) NSArray *actionArray;

@property (strong, nonatomic) IBOutlet UIImageView *detailImgView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (strong, nonatomic) IBOutlet UIWebView   *web;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    
}

//3DTouch peek动作时会自动调用
- (NSArray <id <UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"111" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        [self.navigationController pushViewController:previewViewController animated:YES];
         NSLog(@"-----------11111------------");
        
    }];
    UIPreviewAction *action2 =  [UIPreviewAction actionWithTitle:@"222" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
         NSLog(@"-------------2222----------");
    }];
    UIPreviewAction *action3 =  [UIPreviewAction actionWithTitle:@"333" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
         NSLog(@"------------3333-----------");
    }];
    
    return @[action1, action2, action3];
}

- (void) test
{
    NSLog(@"-----------------------");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setWebUrl:(NSString *)webUrl
{
    _webUrl = webUrl;
    
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self.loadingView startAnimating];
    self.loadingView.hidden = NO;
    return YES;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
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
