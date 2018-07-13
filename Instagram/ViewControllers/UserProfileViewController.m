//
//  UserProfileViewController.m
//  Instagram
//
//  Created by Sophia Zheng on 7/12/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *postsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bio;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureViewWithUser:[PFUser currentUser]];
}

- (void)configureViewWithUser:(PFUser *)user {
    self.user = user;
    
    // put username label in navigation bar
    UILabel *usernameLabel = [[UILabel alloc] init];
    usernameLabel.text = self.user.username;
    self.navigationItem.titleView = usernameLabel;
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    
    // adding button borders
    self.editProfileButton.layer.borderWidth = 0.5;
    self.editProfileButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.editProfileButton.layer.cornerRadius = self.editProfileButton.frame.size.height * .1;
    
    self.settingsView.layer.borderWidth = 0.5;
    self.settingsView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.settingsView.layer.cornerRadius = self.editProfileButton.frame.size.height * .1;
    
    // setting other quantities
    self.postsCountLabel.text = [NSString stringWithFormat: @"%@", user[@"postsCount"]];
    self.followersCountLabel.text = [NSString stringWithFormat: @"%@", user[@"followersCount"]];
    self.followingCountLabel.text = [NSString stringWithFormat: @"%@", user[@"followingCount"]];
    self.name.text = user[@"name"];
    self.bio.text = user[@"bio"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
