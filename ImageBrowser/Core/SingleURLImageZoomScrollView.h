//
//  SingleURLImageZoomScrollView.h
//  ImageBrowser
//
//  Created by Richard on 14/10/30.
//  Copyright (c) 2014年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SingleURLImageZoomScrollViewDelegate<NSObject>
- (void) browseEnd;
@end
@interface SingleURLImageZoomScrollView : UIScrollView
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) id<SingleURLImageZoomScrollViewDelegate> sigleImageDelegate;
- (void) zoomBack;
@end
