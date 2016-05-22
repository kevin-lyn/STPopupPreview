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

+ (instancetype)actionWithTitle:(NSString *)title style:(STPopupPreviewActionStyle)style handler:(void (^)(STPopupPreviewAction *action))handler;

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, assign, readonly) STPopupPreviewActionStyle style;

@end

@class STPopupPreviewRecognizer;

@protocol STPopupPreviewRecognizerDelegate <NSObject>

- (STPopupController *)popupControllerForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer;
- (UIViewController *)presentingViewControllerForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer;
- (NSArray<STPopupPreviewAction *> *)actionsForPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer;

@end

typedef NS_ENUM(NSUInteger, STPopupPreviewRecognizerState) {
    STPopupPreviewRecognizerStateNone,
    STPopupPreviewRecognizerStatePreviewing,
    STPopupPreviewRecognizerStateShowingActions
};

@interface STPopupPreviewRecognizer : NSObject

@property (nonatomic, weak, readonly) UIView *view;
@property (nonatomic, assign, readonly) STPopupPreviewRecognizerState state;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDelegate:(id<STPopupPreviewRecognizerDelegate>)deleagte NS_DESIGNATED_INITIALIZER;

@end
