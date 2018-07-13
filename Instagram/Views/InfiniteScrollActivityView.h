//
//  InfiniteScrollActivityView.h
//  Instagram
//
//  Created by Sophia Zheng on 7/13/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfiniteScrollActivityView : UIView

@property (class, nonatomic, readonly) CGFloat defaultHeight;

- (void)startAnimating;
- (void)stopAnimating;

@end
