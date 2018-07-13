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
@property (weak, nonatomic) IBOutlet UITextField *postLocationTextView;

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.postImageView.image == NULL){
        [self presentCamera];
    }
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
    self.postImageView.image = editedImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.tabBarController.selectedIndex = 0;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearPost {
    self.postImageView.image = NULL;
    self.postCaptionTextView.text = @"";
    self.postLocationTextView.text = @"";
}

- (IBAction)didTapShare:(id)sender {
    [Post postUserImage:self.postImageView.image withCaption:self.postCaptionTextView.text withLocation:self.postLocationTextView.text withCompletion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"saved post");
            [self clearPost];
            self.tabBarController.selectedIndex = 0;
        }
        else {
            NSLog(@"%@", error.localizedDescription);
            [self callAlertWithTitle:@"Error saving post" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        }
    }];
}

- (IBAction)didTapCancel:(id)sender {
    [self clearPost];
    self.tabBarController.selectedIndex = 0;
}

- (IBAction)onTapAway:(id)sender {
    [self.view endEditing:YES];
}

- (void)callAlertWithTitle:(NSString *)title alertMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
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
