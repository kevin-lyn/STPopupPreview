//
//  STPopupPreviewRecognizer.m
//  STPopupPreview
//
//  Created by Kevin Lin on 22/5/16.
//  Copyright © 2016 Sth4Me. All rights reserved.
//

#import "STPopupPreviewRecognizer.h"

CGFloat const STPopupPreviewActionSheetButtonHeight = 44;
CGFloat const STPopupPreviewActionSheetSpacing = 10;
CGFloat const STPopupPreviewShouldViewActionsOffset = 30;

@interface STPopupPreviewAction ()

@property (nonatomic, copy, readonly) void (^handler)(STPopupPreviewAction *);

- (instancetype)initWithTitle:(NSString *)title style:(STPopupPreviewActionStyle)style handler:(void (^)(STPopupPreviewAction *))handler;

@end

@implementation STPopupPreviewAction

- (instancetype)initWithTitle:(NSString *)title style:(STPopupPreviewActionStyle)style handler:(void (^)(STPopupPreviewAction *))handler
{
    if (self = [super init]) {
        _title = title;
        _style = style;
        _handler = [handler copy];
    }
    return self;
}

+ (instancetype)actionWithTitle:(NSString *)title style:(STPopupPreviewActionStyle)style handler:(void (^)(STPopupPreviewAction *))handler
{
    return [[STPopupPreviewAction alloc] initWithTitle:title style:style handler:handler];
}

@end


@interface STPopupPreviewActionSheet : UIView

@property (nonatomic, strong, readonly) NSArray<STPopupPreviewAction *> *actions;

- (instancetype)initWithActions:(NSArray<STPopupPreviewAction *> *)actions;

@end

@implementation STPopupPreviewActionSheet
{
    UIView *_topContainerView;
    UIView *_bottomContainerView;
}

- (instancetype)initWithActions:(NSArray<STPopupPreviewAction *> *)actions
{
    if (self = [super init]) {
        _actions = actions;
        NSMutableArray<STPopupPreviewAction *> *topActions = [NSMutableArray new];
        NSMutableArray<STPopupPreviewAction *> *bottomActions = [NSMutableArray new];
        for (STPopupPreviewAction *action in actions) {
            switch (action.style) {
                case STPopupPreviewActionStyleDefault:
                case STPopupPreviewActionStyleDestructive:
                    [topActions addObject:action];
                    break;
                case STPopupPreviewActionStyleCancel:
                    [bottomActions addObject:action];
                    break;
                default:
                    break;
            }
        }
        
        if (topActions.count) {
            _topContainerView = [UIView new];
            _topContainerView.layer.cornerRadius = 12;
            _topContainerView.clipsToBounds = YES;
            _topContainerView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_topContainerView];
            for (STPopupPreviewAction *action in topActions) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                [button setTitle:action.title forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:20];
                if (action.style == STPopupPreviewActionStyleDestructive) {
                    [button setTitleColor:[UIColor colorWithRed:1 green:0.23 blue:0.19 alpha:1] forState:UIControlStateNormal];
                }
                [_topContainerView addSubview:button];
            }
        }
        if (bottomActions.count) {
            _bottomContainerView = [UIView new];
            _bottomContainerView.layer.cornerRadius = 12;
            _bottomContainerView.clipsToBounds = YES;
            _bottomContainerView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_bottomContainerView];
            for (STPopupPreviewAction *action in bottomActions) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                [button setTitle:action.title forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
                [_bottomContainerView addSubview:button];
            }
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat spacing = STPopupPreviewActionSheetSpacing;
    CGFloat buttonHeight = STPopupPreviewActionSheetButtonHeight;
    _topContainerView.frame = CGRectMake(spacing, spacing, self.superview.bounds.size.width - spacing * 2, _topContainerView.subviews.count * buttonHeight);
    _bottomContainerView.frame = CGRectMake(spacing, _topContainerView.frame.origin.y + _topContainerView.frame.size.height + spacing, self.superview.bounds.size.width - spacing * 2, _bottomContainerView.subviews.count * buttonHeight);
    [self layoutContainerView:_topContainerView];
    [self layoutContainerView:_bottomContainerView];
}

- (void)layoutContainerView:(UIView *)containerView
{
    for (UIView *subview in containerView.subviews) {
        subview.frame = CGRectMake(0, STPopupPreviewActionSheetButtonHeight * [containerView.subviews indexOfObject:subview], containerView.frame.size.width, STPopupPreviewActionSheetButtonHeight);
    }
}

- (void)sizeToFit
{
    NSAssert(self.superview, @"%@ of %@ can only be called after it's added to a superview", NSStringFromSelector(_cmd), NSStringFromClass(self.class));
    
    CGRect frame = self.frame;
    frame.size.width = self.superview.frame.size.width;
    self.frame = frame;
    [self layoutIfNeeded];
    
    if (_bottomContainerView) {
        frame.size.height = _bottomContainerView.frame.origin.y + _bottomContainerView.frame.size.height + STPopupPreviewActionSheetSpacing;
    }
    else {
        frame.size.height = _topContainerView.frame.origin.y + _topContainerView.frame.size.height + STPopupPreviewActionSheetSpacing;
    }
    frame.origin = CGPointMake(0, self.superview.frame.size.height - frame.size.height);
    self.frame = frame;
}

@end

@interface STPopupPreviewRecognizer ()

@property (nonatomic, weak) UIView *view;

@end

@implementation STPopupPreviewRecognizer
{
    __weak id<STPopupPreviewRecognizerDelegate> _delegate;
    UILongPressGestureRecognizer *_longPressGesture;
    UIPanGestureRecognizer *_panGesture;
    STPopupController *_popupController;
    CGFloat _startPointY;
    STPopupPreviewActionSheet *_actionSheet;
}

- (instancetype)initWithDelegate:(id<STPopupPreviewRecognizerDelegate>)deleagte
{
    if (self = [super init]) {
        _delegate = deleagte;
    }
    return self;
}

- (void)setView:(UIView *)view
{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
        _longPressGesture.minimumPressDuration = 0.3;
    }
    [_view removeGestureRecognizer:_longPressGesture];
    _view = view;
    [_view addGestureRecognizer:_longPressGesture];
}

#pragma mark - Gestures

- (void)gestureAction:(UIGestureRecognizer *)gesture
{
    NSAssert(gesture == _longPressGesture || _panGesture == _panGesture, @"Gesture is not expected");
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (gesture == _panGesture) {
                _startPointY = [gesture locationInView:_popupController.backgroundView].y - _popupController.containerView.transform.ty;
                break;
            }
            _popupController = [_delegate popupControllerForPopupPreviewRecognizer:self];
            _popupController.transitionStyle = STPopupTransitionStyleFade;
            
            UIViewController *presentingViewController = [_delegate presentingViewControllerForPopupPreviewRecognizer:self];
            [_popupController presentInViewController:presentingViewController completion:^{
                _popupController.containerView.userInteractionEnabled = NO;
                _state = STPopupPreviewRecognizerStatePreviewing;
                _startPointY = [gesture locationInView:_popupController.backgroundView].y;
                NSArray<STPopupPreviewAction *> *actions = [_delegate actionsForPopupPreviewRecognizer:self];
                if (actions.count) {
                    _actionSheet = [[STPopupPreviewActionSheet alloc] initWithActions:actions];
                    [_popupController.backgroundView addSubview:_actionSheet];
                    [_actionSheet sizeToFit];
                    _actionSheet.transform = CGAffineTransformMakeTranslation(0, _actionSheet.frame.size.height);
                }
                
                _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
                [_popupController.backgroundView addGestureRecognizer:_panGesture];
            }];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if ((_state != STPopupPreviewRecognizerStatePreviewing && _state != STPopupPreviewRecognizerStateViewingActions) ||
                !_actionSheet) {
                break;
            }
            
            CGPoint currentPoint = [gesture locationInView:_popupController.backgroundView];
            CGFloat translationY = currentPoint.y - _startPointY;
            _popupController.containerView.transform = CGAffineTransformMakeTranslation(0, translationY);
            
            if (-translationY >= STPopupPreviewShouldViewActionsOffset) {
                CGFloat availableHeight = _popupController.backgroundView.frame.size.height - _popupController.containerView.frame.origin.y - _popupController.containerView.frame.size.height;
                if (_state != STPopupPreviewRecognizerStateViewingActions) {
                    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        if (availableHeight >= _actionSheet.frame.size.height) {
                            _actionSheet.transform = CGAffineTransformIdentity;
                        }
                        else {
                            _actionSheet.transform = CGAffineTransformMakeTranslation(0, _actionSheet.frame.size.height - availableHeight);
                        }
                    } completion:nil];
                }
                else {
                    if (availableHeight >= _actionSheet.frame.size.height) {
                        _actionSheet.transform = CGAffineTransformIdentity;
                    }
                    else {
                        _actionSheet.transform = CGAffineTransformMakeTranslation(0, _actionSheet.frame.size.height - availableHeight);
                    }
                }
                _state = STPopupPreviewRecognizerStateViewingActions;
            }
            else {
                [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _actionSheet.transform = CGAffineTransformMakeTranslation(0, _actionSheet.frame.size.height);
                } completion:nil];
                _state = STPopupPreviewRecognizerStatePreviewing;
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded: {
            if (_state == STPopupPreviewRecognizerStateViewingActions) {
                CGFloat availableHeight = _popupController.backgroundView.frame.size.height - _actionSheet.frame.size.height;
                CGFloat translationY = availableHeight - _popupController.containerView.frame.size.height - (_popupController.backgroundView.frame.size.height - _popupController.containerView.frame.size.height) / 2;
                [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    if (translationY < 0) {
                        _popupController.containerView.transform = CGAffineTransformMakeTranslation(0, translationY);
                    }
                    else {
                        _popupController.containerView.transform = CGAffineTransformIdentity;
                    }
                    _actionSheet.transform = CGAffineTransformIdentity;
                } completion:nil];
            }
            else {
                _state = STPopupPreviewRecognizerStateNone;
                [_popupController.backgroundView removeGestureRecognizer:_panGesture];
                [_popupController dismissWithCompletion:^{
                    [_actionSheet removeFromSuperview];
                    _actionSheet = nil;
                    _panGesture = nil;
                    _popupController = nil;
                }];
            }
        }
            break;
        default:
            break;
    }
}

@end
