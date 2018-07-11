//
//  PostDetailViewController.m
//  Instagram
//
//  Created by Sophia Zheng on 7/11/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import "PostDetailViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface PostDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCellWithPost:self.post];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCellWithPost:(Post *)post {
    self.post = post;
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.height/2;
    //    self.usernameLabel;
    //    self.locationLabel;
    self.createdAtLabel.text = [post formatDateString];
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
    self.postCaptionLabel.text = post.caption;
    [self.likeButton setSelected:self.post.liked];
    self.likesCountLabel.text = [NSString stringWithFormat:@"%@ Likes",self.post.likeCount];
}

- (IBAction)didTapLikeButton:(id)sender {
    [self.post toggleLike];
    [self.likeButton setSelected:!self.likeButton.selected];
    self.likesCountLabel.text = [NSString stringWithFormat:@"%@ Likes",self.post.likeCount];
    
}

- (IBAction)didTapCommentButton:(id)sender {
}

- (IBAction)didTapShareButton:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
*/

@end
