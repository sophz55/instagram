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
#import "PostDetailViewController.h"
#import "Post.h"
#import "InfiniteScrollActivityView.h"

@interface HomeFeedViewController () <UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) InfiniteScrollActivityView *loadingMoreView;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up table view
    self.feedTableView.dataSource = self;
    self.feedTableView.delegate = self;
    self.feedTableView.rowHeight = UITableViewAutomaticDimension;
    self.feedTableView.estimatedRowHeight = 570;

    // Set up pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.feedTableView addSubview:self.refreshControl];
    
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.feedTableView.contentSize.height, self.feedTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.feedTableView addSubview:self.loadingMoreView];
    
    UIEdgeInsets insets = self.feedTableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.feedTableView.contentInset = insets;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self fetchPosts];
}

- (void)fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.feedTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [self.refreshControl endRefreshing];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.feedTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.feedTableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if (scrollView.contentOffset.y > scrollOffsetThreshold && self.feedTableView.isDragging) {
            self.isMoreDataLoading = YES;
            
            // Update position of self.loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.feedTableView.contentSize.height, self.feedTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            
            [self loadMoreData];
        }
    }
}

- (void)loadMoreData{
    NSLog(@"LOADING");
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.feedTableView reloadData];
            
            [self.loadingMoreView stopAnimating];
            
            self.isMoreDataLoading = NO;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        PostTableViewCell *cell = sender;
        PostDetailViewController *postDetailController = [segue destinationViewController];
        postDetailController.post = cell.post;
    }
}

@end
