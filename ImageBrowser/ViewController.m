//
//  ViewController.m
//  ImageBrowser
//
//  Created by Richard on 14/10/28.
//  Copyright (c) 2014年 Richard. All rights reserved.
//

#import "ViewController.h"
#import "MultiURLImageScrollView.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *imageURLs;
@property (nonatomic, strong) MultiURLImageScrollView *imageScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions
- (IBAction)buttonDown:(UIButton *)sender {
    self.imageScrollView.currentPage = sender.tag;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window.rootViewController.view addSubview:self.imageScrollView];
}
#pragma mark - Properties
-(NSMutableArray *)imageURLs
{
    if (!_imageURLs) {
        _imageURLs = [[NSMutableArray alloc] init];
        [_imageURLs addObject:@"http://ww3.sinaimg.cn/mw690/6541fc9djw1elu73h0x0fj21kw16oh07.jpg"];
        [_imageURLs addObject:@"http://ww1.sinaimg.cn/mw690/6541fc9djw1elu73ehbguj21kw23uh0a.jpg"];
        [_imageURLs addObject:@"http://ww2.sinaimg.cn/mw690/6541fc9djw1elu73clahsj21kw16otjt.jpg"];
        [_imageURLs addObject:@"http://ww1.sinaimg.cn/mw690/6541fc9djw1elu73a85gvj21kw23uatk.jpg"];
    }
    return _imageURLs;
}
- (MultiURLImageScrollView *)imageScrollView
{
    if (!_imageScrollView) {
        _imageScrollView = [[MultiURLImageScrollView alloc] initWithImages:self.imageURLs];
    }
    return _imageScrollView;
}
@end
