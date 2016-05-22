//
//  UIView+STPopupPreview.m
//  STPopupPreview
//
//  Created by Kevin Lin on 22/5/16.
//  Copyright © 2016 Sth4Me. All rights reserved.
//

#import "UIView+STPopupPreview.h"
#import <objc/runtime.h>

@interface STPopupPreviewRecognizer (STPopupPreviewInternal)

@property (nonatomic, weak) UIView *view;

@end

@implementation UIView (STPopupPreview)

- (void)setPopupPreviewRecognizer:(STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    self.popupPreviewRecognizer.view = nil;
    popupPreviewRecognizer.view = self;
    objc_setAssociatedObject(self, @selector(popupPreviewRecognizer), popupPreviewRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (STPopupPreviewRecognizer *)popupPreviewRecognizer
{
    return objc_getAssociatedObject(self, @selector(popupPreviewRecognizer));
}

@end
