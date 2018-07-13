//
//  PostTableViewCell.m
//  Instagram
//
//  Created by Sophia Zheng on 7/10/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithPost:(Post *)post {
    self.post = post;
//    self.userProfileImageView.image = post.author.image;
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.height/2;;
    self.usernameLabel.text = post.author.username;
    self.createdAtLabel.text = [post formatDateString];
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
    self.locationLabel.text = post.location;

    if (![post.caption isEqualToString:@""]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[post.author.username stringByAppendingString: [@" " stringByAppendingString: post.caption]]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f weight:UIFontWeightBold] range:NSMakeRange(0, post.author.username.length)];
        self.postCaptionLabel.attributedText = attributedString;
    } else {
        self.postCaptionLabel.text = @"";
    }

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

@end
