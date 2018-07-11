//
//  ComposePostViewController.m
//  Instagram
//
//  Created by Sophia Zheng on 7/10/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import "ComposePostViewController.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface ComposePostViewController ()  <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UITextView *postCaptionTextView;

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self presentCamera];
}

- (void)presentCamera {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.postImageView.image = editedImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"composeToFeedSegue" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapShare:(id)sender {
    
//    PFObject *post = [[PFObject alloc] initWithClassName:@"Post"];
//    post[@"postID"] = @"PostID";
//    post[@"userID"] = @"userID";
//    PFFile *imageFile = [PFFile fileWithName:@"photo.png" data:UIImagePNGRepresentation(self.postImageView.image)];
//    post[@"image"] = imageFile;
//    post[@"caption"] = self.postCaptionTextView.text;
//
//    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            // The object has been saved.
//        }
//        else {
//            NSLog(@"save in background %@", error.localizedDescription);
//        }
//    }];
    
    [Post postUserImage:self.postImageView.image withCaption:self.postCaptionTextView.text withCompletion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"saved post");
            [self dismissViewControllerAnimated:YES completion:nil];
            [self performSegueWithIdentifier:@"composeToFeedSegue" sender:nil];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
            [self callAlertWithTitle:@"Error saving post" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        }
    }];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"composeToFeedSegue" sender:nil];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
