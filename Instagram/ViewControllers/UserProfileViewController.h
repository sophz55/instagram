//
//  UserProfileViewController.h
//  Instagram
//
//  Created by Sophia Zheng on 7/12/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserProfileViewController : UIViewController

@property (strong, nonatomic) PFUser *user;

@end
