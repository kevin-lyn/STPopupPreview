//
//  ViewController.m
//  STPopupPreviewExample
//
//  Created by Kevin Lin on 22/5/16.
//  Copyright © 2016 Sth4Me. All rights reserved.
//

#import "ViewController.h"
#import "PreviewViewController.h"
#import <STPopupPreview/STPopupPreview.h>
#import <STPopup/STPopup.h>

@interface ViewController () <STPopupPreviewRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIView *targetView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.targetView.popupPreviewRecognizer = [[STPopupPreviewRecognizer alloc] initWithDelegate:self];
}

#pragma mark - STPopupPreviewRecognizerDelegate

- (UIViewController *)previewViewControllerForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    PreviewViewController *previewViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PreviewViewController class])];
    return previewViewController;
}

- (UIViewController *)presentingViewControllerForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    return self;
}

- (NSArray<STPopupPreviewAction *> *)previewActionsForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    return @[ [STPopupPreviewAction actionWithTitle:@"Like" style:STPopupPreviewActionStyleDefault handler:nil],
              [STPopupPreviewAction actionWithTitle:@"Delete" style:STPopupPreviewActionStyleDestructive handler:nil],
              [STPopupPreviewAction actionWithTitle:@"Cancel" style:STPopupPreviewActionStyleCancel handler:nil] ];
}

@end
