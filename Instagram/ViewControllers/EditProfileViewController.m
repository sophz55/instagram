//
//  EditProfileViewController.m
//  Instagram
//
//  Created by Sophia Zheng on 7/13/18.
//  Copyright © 2018 Sophia Zheng. All rights reserved.
//

#import "EditProfileViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *bioLabel;
@property (strong, nonatomic) PFUser *user;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.user = [PFUser currentUser];
    
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.height/2;
    if (self.user[@"profilePicture"]) {
        self.userProfileImageView.file = self.user[@"profilePicture"];
        [self.userProfileImageView loadInBackground];
    }
    
    self.nameLabel.text = self.user[@"name"];
    self.usernameLabel.text = self.user[@"username"];
    self.emailLabel.text = self.user[@"email"];
    self.bioLabel.text = self.user[@"bio"];
}

- (IBAction)didTapChangeProfilePicture:(id)sender {
    [self presentCamera];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSave:(id)sender {
    self.user[@"profilePicture"] = [self getPFFileFromImage:self.userProfileImageView.image];
    self.user[@"name"] = self.nameLabel.text;
    self.user[@"username"] = self.usernameLabel.text;
    self.user[@"email"] = self.emailLabel.text;
    self.user[@"bio"] = self.bioLabel.text;
    [self.user saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    CGSize size;
    size.width = 500;
    size.height = 500;
    UIImage *editedImage = [self resizeImage:info[UIImagePickerControllerEditedImage] withSize:size];
    self.userProfileImageView.image = editedImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
