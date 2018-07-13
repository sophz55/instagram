//
//  UserProfileViewController.m
//  Instagram
//
//  Created by Sophia Zheng on 7/12/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import "UserProfileViewController.h"
#import "PostCollectionViewCell.h"
#import "Post.h"
#import "PostDetailViewController.h"

@interface UserProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *postsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet UICollectionView *userPhotosCollectionView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureViewWithUser:[PFUser currentUser]];
    
    [self configureCollectionView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.postsCountLabel.text = [NSString stringWithFormat: @"%@", self.user[@"postsCount"]];
    self.followersCountLabel.text = [NSString stringWithFormat: @"%@", self.user[@"followersCount"]];
    self.followingCountLabel.text = [NSString stringWithFormat: @"%@", self.user[@"followingCount"]];

    [self fetchUserPosts];
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

- (void)configureCollectionView {
    self.userPhotosCollectionView.dataSource = self;
    self.userPhotosCollectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.userPhotosCollectionView.collectionViewLayout;
    
    CGFloat frameWidth = self.userPhotosCollectionView.frame.size.width;
    
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    CGFloat cellsPerLine;
    if (frameWidth > 400) {
        cellsPerLine = 4;
    } else {
        cellsPerLine = 3;
    }
    CGFloat itemWidth = (self.userPhotosCollectionView.frame.size.width - layout.minimumInteritemSpacing * (cellsPerLine + 1)) / cellsPerLine;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
}

- (void)fetchUserPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:self.user];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.userPhotosCollectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.posts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.item];
    
    if (post){
        [post.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            cell.postImageView.image = [UIImage imageNamed:@"image_placeholder"];
            cell.postImageView.image = [UIImage imageWithData:data];
        }];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        PostCollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.userPhotosCollectionView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        PostDetailViewController *detailViewController = [segue destinationViewController];
        [self.userPhotosCollectionView deselectItemAtIndexPath:indexPath animated:YES];
        detailViewController.post = post;
    }
}

@end
