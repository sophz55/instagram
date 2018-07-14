//
//  SignUpViewController.m
//  Instagram
//
//  Created by Sophia Zheng on 7/11/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.signUpButton.layer.cornerRadius = self.signUpButton.frame.size.height * .1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTapAway:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
}

- (void)registerUser {
    // initialize user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser.email = self.emailField.text;
    newUser[@"name"] = self.nameField.text;
    newUser[@"bio"] = @"";
    newUser[@"profilePicture"] = [self getPFFileFromImage:[UIImage imageNamed:@"image_placeholder"]];
    
    newUser[@"postsCount"] = @0;
    newUser[@"followersCount"] = @0;
    newUser[@"followingCount"] = @0;
    
    if (![newUser.email isEqual:@""] && ![newUser[@"name"] isEqual:@""] && ![newUser.username isEqual:@""] && ![newUser.password isEqual:@""]) {
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self callAlertWithTitle:@"Error" alertMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            } else {
                NSLog(@"User registered successfully");
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    } else {
        [self callAlertWithTitle:@"Cannot Sign Up" alertMessage:@"No fields can be blank"];
        NSLog(@"Did not register user");
    }
}

- (void)callAlertWithTitle:(NSString *)title alertMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

- (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
