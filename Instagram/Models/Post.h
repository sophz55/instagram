//
//  Post.h
//  Instagram
//
//  Created by Sophia Zheng on 7/10/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Post : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *postID;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) PFUser *author;

@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) PFFile *image;
@property (strong, nonatomic) NSNumber *likeCount;
@property (nonatomic) BOOL liked;
@property (strong, nonatomic) NSNumber *commentCount;
@property (strong, nonatomic) NSString *location;


+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withLocation: ( NSString * _Nullable )location withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (PFFile *)getPFFileFromImage: ( UIImage * _Nullable )image;

- (void)toggleLike;

- (NSString *)formatDateString;

@end
