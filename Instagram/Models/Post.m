//
//  Post.m
//  Instagram
//
//  Created by Sophia Zheng on 7/10/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic description;
@dynamic image;

// Conforming to Subclassing
+ (nonnull NSString *)parseClassName {
    return @"Post";
}

@end
