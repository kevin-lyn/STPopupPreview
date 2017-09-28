//
// Created by ghost on 7/18/17.
//

#import "STPopupController+STPopupPreview.h"
#import <objc/runtime.h>


@implementation STPopupController (STPopupPreview)

- (void) setPopupPreviewInteractionEnabled: (BOOL) enabled {
    objc_setAssociatedObject(self, @selector(popupPreviewInteractionEnabled), @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL) popupPreviewInteractionEnabled {
    NSNumber *truth =  objc_getAssociatedObject(self, @selector(popupPreviewInteractionEnabled));
    return truth ? [truth boolValue] : NO;
}
@end