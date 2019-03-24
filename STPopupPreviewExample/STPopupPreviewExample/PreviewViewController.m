//
//  PreviewViewController.m
//  STPopupPreviewExample
//
//  Created by Kevin Lin on 22/5/16.
//  Copyright © 2016 Sth4Me. All rights reserved.
//

#import "PreviewViewController.h"
#import "ImageLoader.h"
#import <STPopup/STPopup.h>

@interface PreviewViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *captionLabel;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *headerViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *footerViewHeightConstraint;

@end

@implementation PreviewViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        // Default content size
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 300);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Resize content size based on image dimensions
    CGFloat imageWidth = [self.data[@"dimensions"][@"width"] doubleValue];
    CGFloat imageHeight = [self.data[@"dimensions"][@"height"] doubleValue];
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat contentHeight = contentWidth * imageHeight / imageWidth + _headerViewHeightConstraint.constant + _footerViewHeightConstraint.constant;
    self.contentSizeInPopup = CGSizeMake(contentWidth, contentHeight);
    
    self.avatarImageView.layer.cornerRadius = 16;
    NSURL *avatarImageURL = [NSURL URLWithString:@"https://instagram.flhr2-1.fna.fbcdn.net/vp/ff1bd2dbfbcef9536b84b1623b43312c/5D1BC2EA/t51.2885-19/s320x320/53241807_254795148730661_6781962409327198208_n.jpg?_nc_ht=instagram.flhr2-1.fna.fbcdn.net"];
    if ([ImageLoader cachedImageForURL:avatarImageURL]) {
        self.avatarImageView.image = [ImageLoader cachedImageForURL:avatarImageURL];
    }
    else {
        [ImageLoader loadImageForURL:avatarImageURL completion:^(UIImage *image) {
            self.avatarImageView.image = image;
        }];
    }
    
    self.imageView.image = self.placeholderImage;
    [ImageLoader loadImageForURL:[NSURL URLWithString:self.data[@"display_url"]] completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    self.captionLabel.text = @"Instagram Photo";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.popupController.navigationBarHidden = YES;
}

@end
