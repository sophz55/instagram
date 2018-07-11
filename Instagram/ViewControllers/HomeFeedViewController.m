//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by Sophia Zheng on 7/9/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import "HomeFeedViewController.h"
#import <Parse/Parse.h>
#import "PostTableViewCell.h"
#import "Post.h"

@interface HomeFeedViewController () <UITabBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.feedTableView.dataSource = self;
    self.feedTableView.delegate = self;
    
    self.feedTableView.rowHeight = UITableViewAutomaticDimension;
    self.feedTableView.estimatedRowHeight = 570;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self fetchPosts];
}

- (void)fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.feedTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    Post *post = (Post *)self.posts[indexPath.row];
    
    [cell configureCellWithPost:post];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapLogout:(id)sender {
    [self logoutUser];
}

- (void)logoutUser {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {}];
    [self performSegueWithIdentifier:@"logoutSegue" sender:nil];
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
