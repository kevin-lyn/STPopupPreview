//
//  ImageLoader.m
//  STPopupPreviewExample
//
//  Created by Kevin Lin on 23/5/16.
//  Copyright © 2016 Sth4Me. All rights reserved.
//

#import "ImageLoader.h"

static NSMutableDictionary<NSURL *, UIImage *> *_cachedImages;

@implementation ImageLoader

+ (void)load
{
    _cachedImages = [NSMutableDictionary new];
}

+ (UIImage *)cachedImageForURL:(NSURL *)url
{
    return _cachedImages[url];
}

+ (void)loadImageForURL:(NSURL *)url completion:(void (^)(UIImage *))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            _cachedImages[url] = image;
            if (completion) {
                completion(image);
            }
        });
    });
}

@end
