//
//  Post.m
//  Instagram
//
//  Created by Sophia Zheng on 7/10/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import "Post.h"
#import "NSDate+DateTools.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;
@dynamic liked;
@dynamic location;

// Conforming to Subclassing
+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withLocation: ( NSString * _Nullable )location withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.author[@"postsCount"] = @([newPost.author[@"postsCount"] intValue] + 1);
    newPost.caption = caption;
    newPost.location = location;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    NSLog (@"%@", newPost);
    [newPost saveInBackgroundWithBlock: completion];
}

- (NSString *)formatDateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *createdAtDate = self.createdAt;
    NSTimeInterval timeAgo = createdAtDate.timeIntervalSinceNow;
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:timeAgo];
    
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    // Convert Date to String
    int relativeTimeRange = 518400; // 6 days in seconds
    if (timeAgo < relativeTimeRange) {
        return timeAgoDate.shortTimeAgoSinceNow;
    }
    return [formatter stringFromDate:createdAtDate];
}

+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}

- (void)toggleLike {
    if (self.liked) {
        self.likeCount = [NSNumber numberWithInteger:[self.likeCount intValue] - 1];
    } else {
        self.likeCount = [NSNumber numberWithInteger:[self.likeCount intValue] + 1];
    }
    self.liked = !self.liked;
}

@end
