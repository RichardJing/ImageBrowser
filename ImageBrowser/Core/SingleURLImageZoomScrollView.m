//
//  SingleURLImageZoomScrollView.m
//  ImageBrowser
//
//  Created by Richard on 14/10/30.
//  Copyright (c) 2014年 Richard. All rights reserved.
//

#import "SingleURLImageZoomScrollView.h"
#import "MBProgressHUD.h"

@interface SingleURLImageZoomScrollView()<UIScrollViewDelegate>
@property (nonatomic, strong) MBProgressHUD *progressHud; //加载URL时转圈
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation SingleURLImageZoomScrollView
#pragma mark - Init
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        self.backgroundColor = [UIColor blackColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        //双击放大，单击退出
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleDoubleTap:)];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleSingleTap:)];
        [singleTap requireGestureRecognizerToFail : doubleTap];
        [doubleTap setDelaysTouchesBegan : YES];
        [singleTap setDelaysTouchesBegan : YES];
        [doubleTap setNumberOfTapsRequired : 2];
        [singleTap setNumberOfTapsRequired : 1];
        [self addGestureRecognizer : doubleTap];
        [self addGestureRecognizer : singleTap];
        
        [self addSubview:self.progressHud];
        [self.progressHud show:YES];
    }
    return self;
}

#pragma mark - Properties
- (void) setImageURL:(NSString *)imageURL
{
    if (_imageURL) { //如果已经加载过，不再加载
        return;
    }
    _imageURL = imageURL;
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    [self.progressHud hide:YES];
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat fullWidth = self.frame.size.width;
    CGFloat fullHeight = self.frame.size.height;
    
    //适应屏幕大小
    CGFloat rWidth = fullWidth / imageWidth;
    CGFloat rHeight = fullHeight / imageHeight;
    CGFloat rate = MIN(rWidth, rHeight);
    CGFloat imageViewWidth = imageWidth * rate;
    CGFloat imageViewHeight = imageHeight * rate;
    
    //居中
    CGFloat imageViewX = (fullWidth - imageViewWidth) / 2;
    CGFloat imageViewY = (fullHeight - imageViewHeight) / 2;
    
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
    self.imageView.image = image;
    
    NSLog(@"x: %0.0f, y:%0.0f, width: %0.0f, height: %0.0f", imageViewX, imageViewY,imageViewWidth, imageViewHeight);
    
    CGFloat maxScale = 1 / rate;
    self.maximumZoomScale = maxScale > 1 ? maxScale : 1; //防止图片本身比屏幕小
}

-(MBProgressHUD *)progressHud
{
    if (!_progressHud) {
        _progressHud = [[MBProgressHUD alloc]initWithView:self];
        _progressHud.userInteractionEnabled = NO;
    }
    return _progressHud;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


#pragma mark - Public Methods
- (void) zoomBack
{
    if (self.zoomScale != self.minimumZoomScale) {
        self.zoomScale = self.minimumZoomScale;
    }
}

#pragma mark -  Private Methods

- (void) handleDoubleTap: (UITapGestureRecognizer *)sender
{
    if (self.zoomScale > self.minimumZoomScale) {
        self.zoomScale = self.minimumZoomScale;
    } else {
        CGFloat zoomScale = self.maximumZoomScale;
        CGPoint touchPoint = [sender locationInView: nil];
        NSLog(@"touchPoint x: %0.0f, y: %0.0f", touchPoint.x, touchPoint.y);
        CGFloat centerX = self.frame.size.width / 2;
        CGFloat centerY = self.frame.size.height / 2;
        NSLog(@"centerX: %0.0f, centerY: %0.0f", centerX,centerY);
        CGPoint contentOffeset = CGPointMake((touchPoint.x - centerX) * zoomScale , (touchPoint.y - centerY) * zoomScale);
        [self setContentOffset:contentOffeset animated:YES];
        
        [self setZoomScale:self.maximumZoomScale animated:NO];
    }
}

- (void) handleSingleTap: (UITapGestureRecognizer *)sender
{
    if (self.zoomScale > self.minimumZoomScale) {
        return;
    }
    if (self.sigleImageDelegate && [self.sigleImageDelegate respondsToSelector:@selector(browseEnd)]) {
        [self.sigleImageDelegate browseEnd];
    }
}
@end
