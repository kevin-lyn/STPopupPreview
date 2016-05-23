# STPopupPreview ![CI Status](https://travis-ci.org/kevin0571/STPopupPreview.svg?branch=master) ![Version](http://img.shields.io/cocoapods/v/STPopupPreview.svg?style=flag) ![License](https://img.shields.io/cocoapods/l/STPopupPreview.svg?style=flag)
**STPopupPreview** uses long press gesture to enable quick preview of a page on non 3D Touch devices. Preview actions are also supported. This idea is inspired by Instagram. 

It is built on top of of [STPopup](http://github.com/kevin0571/STPopup)(a library provides STPopupController, which works just like UINavigationController in popup style). Both STPopup and STPopupPreview support iOS 7+.

## Demo
A simple demo shows images from my [Instagram](https://www.instagram.com/kevin0571/)

![STPopupPreviewDemo](https://cloud.githubusercontent.com/assets/1491282/15470641/4cf17556-2124-11e6-885b-d2242de06974.gif)

## Features
* Long press to preview, release to dismiss.
* Slide up to show preview actions.
* Easy integration.

## Get Started
**CocoaPods**
```ruby
platform: ios, '7.0'
pod 'STPopupPreview'
```
**Carthage**
```ruby
github "kevin0571/STPopupPreview"
```
*Don't forget to drag both STPopupPreview.framework and STPopup.framework into linked frameworks.
## Usage

### Import header file
```objc
#import <STPopupPreview/STPopupPreview.h>
```

### Attach popup preview recognizer to view
```objc
CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];
if (!cell.popupPreviewRecognizer) {
    cell.popupPreviewRecognizer = [[STPopupPreviewRecognizer alloc] initWithDelegate:self];
}
```

### Implement STPopupPreviewRecognizerDelegate

Return the preview view controller. The preview view controller should have "contentSizeInPopup" set before its "viewDidLoad" called. More about this please read the document of [STPopup](http://github.com/kevin0571/STPopup).

```objc
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
```

Return a view controller to present the preview view controller. Most of the time it will be the current view controller.

```objc
- (UIViewController *)presentingViewControllerForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    return self;
}
```

Return the preview actions you want to show when slides up. It can be nil if you don't have any preview actions.

```objc
- (NSArray<STPopupPreviewAction *> *)previewActionsForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    return @[ [STPopupPreviewAction actionWithTitle:@"Like" style:STPopupPreviewActionStyleDefault handler:^(STPopupPreviewAction *action, UIViewController *previewViewController) {
        // Action handler
    }] ];
}
```

### Enable STPopupPreview only if 3D Touch is not available
```objc
BOOL isForceTouchAvailable = [self respondsToSelector:@selector(traitCollection)] &&
    [self.traitCollection respondsToSelector:@selector(forceTouchCapability)] &&
    self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
if (!isForceTouchAvailable) {
    if (!cell.popupPreviewRecognizer) {
        cell.popupPreviewRecognizer = [[STPopupPreviewRecognizer alloc] initWithDelegate:self];
    }
}
```

## Issues & Contact
* If you have any question regarding the usage, please refer to the example project for more details.
* If you find any bug, please submit an **issue**.
