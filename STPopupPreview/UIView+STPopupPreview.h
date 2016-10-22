//
//  UIView+STPopupPreview.h
//  STPopupPreview
//
//  Created by Kevin Lin on 22/5/16.
//  Copyright © 2016 Sth4Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STPopupPreview/STPopupPreviewRecognizer.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (STPopupPreview)

/**
 The attached preview recognizer.
 */
@property (nullable, nonatomic, strong) STPopupPreviewRecognizer *popupPreviewRecognizer;

@end

NS_ASSUME_NONNULL_END
