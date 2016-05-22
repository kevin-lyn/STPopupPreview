//
//  STPopupPreviewRecognizer.h
//  STPopupPreview
//
//  Created by Kevin Lin on 22/5/16.
//  Copyright © 2016 Sth4Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STPopup/STPopup.h>

typedef NS_ENUM(NSInteger, STPopupPreviewActionStyle) {
    STPopupPreviewActionStyleDefault,
    STPopupPreviewActionStyleCancel,
    STPopupPreviewActionStyleDestructive
};

@interface STPopupPreviewAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title style:(STPopupPreviewActionStyle)style handler:(void (^)(STPopupPreviewAction *action, UIViewController *previewViewController))handler;

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, assign, readonly) STPopupPreviewActionStyle style;

@end

@class STPopupPreviewRecognizer;

@protocol STPopupPreviewRecognizerDelegate <NSObject>

/**
 A view controller for previewing.
 It should be configured as a popup view controller. (either "contentSizeInPopup" or "landscapeContentSizeInPopup" should be set)
 @see UIViewController+STPopup
 */
- (UIViewController *)previewViewControllerForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer;

/**
 The view controller for presenting the popup.
 */
- (UIViewController *)presentingViewControllerForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer;

/**
 An array of STPopupPreviewAction.
 It could be empty if no actions are available for previewing.
 */
- (NSArray<STPopupPreviewAction *> *)previewActionsForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer;

@end

typedef NS_ENUM(NSUInteger, STPopupPreviewRecognizerState) {
    STPopupPreviewRecognizerStateNone,
    STPopupPreviewRecognizerStatePreviewing,
    STPopupPreviewRecognizerStateShowingActions
};

@interface STPopupPreviewRecognizer : NSObject

/**
 The view the preview recognizer is attached to.
 */
@property (nonatomic, weak, readonly) __kindof UIView *view;

/**
 The current state of preview recognizer.
 */
@property (nonatomic, assign, readonly) STPopupPreviewRecognizerState state;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDelegate:(id<STPopupPreviewRecognizerDelegate>)deleagte NS_DESIGNATED_INITIALIZER;

@end
