//
//  ImageLoader.h
//  STPopupPreviewExample
//
//  Created by Kevin Lin on 23/5/16.
//  Copyright © 2016 Sth4Me. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageLoader : NSObject

+ (UIImage *)cachedImageForURL:(NSURL *)url;
+ (void)loadImageForURL:(NSURL *)url completion:(void(^)(UIImage *image))completion;

@end
