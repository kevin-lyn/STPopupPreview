//
//  ViewController.m
//  STPopupPreviewExample
//
//  Created by Kevin Lin on 22/5/16.
//  Copyright © 2016 Sth4Me. All rights reserved.
//

#import "ViewController.h"
#import "PreviewViewController.h"
#import "ImageLoader.h"
#import <STPopupPreview/STPopupPreview.h>

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSDictionary *data;

@end

@implementation CollectionViewCell

@end

@interface ViewController () <STPopupPreviewRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController
{
    NSArray<NSDictionary *> *_exampleData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ExampleData" ofType:@"json"];
    _exampleData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:NULL];
}

- (BOOL)isForceTouchAvailable
{
    return [self respondsToSelector:@selector(traitCollection)] &&
            [self.traitCollection respondsToSelector:@selector(forceTouchCapability)] &&
            self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
}

#pragma mark - STPopupPreviewRecognizerDelegate

- (UIViewController *)previewViewControllerForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    if (![popupPreviewRecognizer.view isKindOfClass:[CollectionViewCell class]]) {
        return nil;
    }
    
    CollectionViewCell *cell = popupPreviewRecognizer.view;
    
    PreviewViewController *previewViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PreviewViewController class])];
    previewViewController.data = cell.data;
    previewViewController.placeholderImage = cell.imageView.image;
    return previewViewController;
}

- (UIViewController *)presentingViewControllerForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    return self;
}

- (NSArray<STPopupPreviewAction *> *)previewActionsForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    return @[ [STPopupPreviewAction actionWithTitle:@"Like" style:STPopupPreviewActionStyleDefault handler:^(STPopupPreviewAction *action, UIViewController *previewViewController) {
        [[[UIAlertView alloc] initWithTitle:@"Liked" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }], [STPopupPreviewAction actionWithTitle:@"Delete" style:STPopupPreviewActionStyleDestructive handler:^(STPopupPreviewAction *action, UIViewController *previewViewController) {
        [[[UIAlertView alloc] initWithTitle:@"Deleted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }], [STPopupPreviewAction actionWithTitle:@"Cancel" style:STPopupPreviewActionStyleCancel handler:^(STPopupPreviewAction *action, UIViewController *previewViewController) {
        [[[UIAlertView alloc] initWithTitle:@"Cancelled" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }] ];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _exampleData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];
    // You may want to enable popup preview recognizer only if force touch is not available by using "isForceTouchAvailable"
    if (!cell.popupPreviewRecognizer) {
        cell.popupPreviewRecognizer = [[STPopupPreviewRecognizer alloc] initWithDelegate:self];
    }
    
    NSDictionary *data = _exampleData[indexPath.item][@"node"];
    cell.data = data;
    
    NSURL *imageURL = [NSURL URLWithString:data[@"display_url"]];
    if ([ImageLoader cachedImageForURL:imageURL]) {
        cell.imageView.image = [ImageLoader cachedImageForURL:imageURL];
    }
    else {
        cell.imageView.image = nil;
        [ImageLoader loadImageForURL:imageURL completion:^(UIImage *image) {
            [collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
        }];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = (collectionView.frame.size.width - 2) / 3;
    return CGSizeMake(size, size);
}

@end
