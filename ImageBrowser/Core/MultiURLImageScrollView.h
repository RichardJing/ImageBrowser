//
//  MultiURLImageScrollView.h
//  ImageBrowser
//
//  Created by Richard on 14/10/28.
//  Copyright (c) 2014年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiURLImageScrollView : UIView
@property (nonatomic) NSUInteger currentPage;
- (instancetype) initWithImages:(NSArray *)imageURLs;
@end
