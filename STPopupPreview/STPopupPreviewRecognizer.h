//
//  STPopupPreviewRecognizer.h
//  STPopupPreview
//
//  Created by Kevin Lin on 22/5/16.
//  Copyright © 2016 Sth4Me. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, STPopupPreviewActionStyle) {
    /**
     Default action in global tint color.
     */
    STPopupPreviewActionStyleDefault,
    /**
     Cancel action will be put at the bottom with bold font.
     */
    STPopupPreviewActionStyleCancel,
    /**
     Destructive action in destructive red tint color.
     */
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
- (nullable UIViewController *)previewViewControllerForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer;

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
    /**
     Before preview view controller is presented or after preview view controller is dismissed.
     */
    STPopupPreviewRecognizerStateNone,
    /**
     Preview view controller is presented but no preview actions are showed.
     */
    STPopupPreviewRecognizerStatePreviewing,
    /**
     Preview actions are showed(either part of or whole of the action sheet). 
     */
    STPopupPreviewRecognizerStateShowingActions
};

@interface STPopupPreviewRecognizer : NSObject

/**
 The view the preview recognizer is attached to.
 */
@property (nullable, nonatomic, weak, readonly) __kindof UIView *view;

/**
 The current state of preview recognizer.
 */
@property (nonatomic, assign, readonly) STPopupPreviewRecognizerState state;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDelegate:(id<STPopupPreviewRecognizerDelegate>)deleagte NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
