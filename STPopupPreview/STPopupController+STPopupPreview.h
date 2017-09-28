//
// Created by ghost on 7/18/17.
//

#import <Foundation/Foundation.h>
#import <STPopup/STPopup.h>

@interface STPopupController (STPopupPreview)

@property(nonatomic, assign, getter=popupPreviewInteractionEnabled, setter=setPopupPreviewInteractionEnabled:) BOOL popupPreviewInteractionEnabled;
- (void) setPopupPreviewInteractionEnabled: (BOOL) enabled NS_SWIFT_NAME(set(popupPreviewInteractionEnabled:));
- (BOOL) popupPreviewInteractionEnabled NS_SWIFT_NAME(popupPreviewInteractionEnabled);

@end