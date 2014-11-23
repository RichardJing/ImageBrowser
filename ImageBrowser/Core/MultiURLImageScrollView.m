//
//  MultiImageViewController.m
//  ImageBrowser
//
//  Created by Richard on 14/10/28.
//  Copyright (c) 2014年 Richard. All rights reserved.
//

#import "MultiURLImageScrollView.h"
#import "SingleURLImageZoomScrollView.h"

@interface MultiURLImageScrollView ()<UIScrollViewDelegate,SingleURLImageZoomScrollViewDelegate>
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *zoomViews;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation MultiURLImageScrollView

#pragma mark - Private Methods
- (void) initImages
{
    // scroll view contentSize
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(pageWidth * self.imageURLs.count, pageHeight);
    
    //imageViews
    for (int i = 0; i < self.imageURLs.count; i++) {
        SingleURLImageZoomScrollView *zoomView = [[SingleURLImageZoomScrollView alloc] initWithFrame:CGRectMake(i * pageWidth , 0, pageWidth, pageHeight)];
        NSLog(@"offeset :%0.0f", i * pageWidth);
        zoomView.sigleImageDelegate = self;
        [self.zoomViews addObject:zoomView];
        [self.scrollView addSubview:zoomView];
    }
}
#pragma mark - Properties
- (void) setCurrentPage:(NSUInteger)currentPage
{
    _currentPage = currentPage;
    
    //加载第一张图片
    SingleURLImageZoomScrollView *zoomView = [self.zoomViews objectAtIndex:currentPage];
    zoomView.imageURL = [self.imageURLs objectAtIndex:currentPage];
    CGFloat pageWidth = CGRectGetWidth(self.frame);
    [self.scrollView setContentOffset:CGPointMake(self.currentPage * pageWidth, 0) animated:NO];
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}
-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 10 - 10, self.frame.size.width, 10)];
        _pageControl.numberOfPages = self.imageURLs.count;
        _pageControl.currentPage = self.currentPage;
    }
    return _pageControl;
}

- (NSMutableArray *)zoomViews
{
    if (!_zoomViews) {
        _zoomViews = [[NSMutableArray alloc] init];
    }
    return _zoomViews;
}

#pragma mark - Public Methods
- (instancetype) initWithImages:(NSArray *)imageURLs
{
    self = [super init];
    if (self) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.imageURLs = imageURLs;
        [self initImages];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for (SingleURLImageZoomScrollView *zoomView in self.zoomViews) { //翻页时，图片间有分隔
        zoomView.contentInset =  UIEdgeInsetsMake(0, 10, 0, 10);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.frame);
    NSUInteger currentPage = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = currentPage;
    
    SingleURLImageZoomScrollView *zoomView = [self.zoomViews objectAtIndex:currentPage];
    zoomView.imageURL = [self.imageURLs objectAtIndex:currentPage];//翻到时再加载
    
    //前后两张图片缩放效果重置
    if (currentPage - 1.0 >= 0) {
        [[self.zoomViews objectAtIndex:(currentPage - 1)] zoomBack];
    }
    if (currentPage + 1 < self.zoomViews.count) {
        [[self.zoomViews objectAtIndex:(currentPage + 1)] zoomBack];
    }
    for (SingleURLImageZoomScrollView *zoomView in self.zoomViews) {
        zoomView .contentInset =  UIEdgeInsetsZero;
    }
}

#pragma mark - ZoomingViewDelegate
- (void) browseEnd
{
    [self removeFromSuperview];
}
@end
