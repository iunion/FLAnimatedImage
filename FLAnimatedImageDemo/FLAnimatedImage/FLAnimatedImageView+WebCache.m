//
//  FLAnimatedImageView+WebCache.m
//  FLAnimatedImageDemo
//
//  Created by mac on 14-6-4.
//  Copyright (c) 2014年 Flipboard. All rights reserved.
//

#import "FLAnimatedImageView+WebCache.h"

#import <ImageIO/ImageIO.h>
#import "UIImage+GIF.h"
#import "NSObject+Category.h"


#define TAG_ACTIVITY_INDICATOR 149462

@implementation FLAnimatedImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self viewWithTag:TAG_ACTIVITY_INDICATOR];

        if (activityIndicator == nil)
        {
            activityIndicator = SDWIReturnAutoreleased([[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityStyle]);

            //calculate the correct position
            float width = activityIndicator.frame.size.width;
            float height = activityIndicator.frame.size.height;
            float x = (self.frame.size.width / 2.0) - width/2;
            float y = (self.frame.size.height / 2.0) - height/2;
            activityIndicator.frame = CGRectMake(x, y, width, height);

            activityIndicator.userInteractionEnabled = NO;
            activityIndicator.hidesWhenStopped = YES;
            activityIndicator.tag = TAG_ACTIVITY_INDICATOR;
            [self addSubview:activityIndicator];
        }

        [activityIndicator startAnimating];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:activityIndicator forKey:@"activityKey"];
        [manager downloadWithURL:url delegate:self options:options userInfo:userInfo];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url animatedsuccess:(SDWebAnimatedImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:nil animatedsuccess:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animatedsuccess:(SDWebAnimatedImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 animatedsuccess:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options animatedsuccess:(SDWebAnimatedImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil animatedsuccess:success failure:failure];
}

// add by DJ
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageProgressBlock)progress animatedsuccess:(SDWebAnimatedImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:(options | SDWebImageFLAnimatedImage) progress:progress animatedsuccess:success failure:failure];
    }
}
#endif

- (void)cancelCurrentImageLoad
{
    @synchronized(self)
    {
        [[SDWebImageManager sharedManager] cancelForDelegate:self];
    }
}


#pragma mark -
#pragma mark SDWebImageManagerDelegate

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    self.image = image;
    [self setNeedsLayout];
}

//- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
//{
//    self.image = image;
//    [self setNeedsLayout];
//}


- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    self.image = image;

    [self removeAvtivityViewWithUserInfo:info];

    [self setNeedsLayout];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithFLAnimatedImage:(FLAnimatedImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    self.animatedImage = image;

    [self removeAvtivityViewWithUserInfo:info];

    [self setNeedsLayout];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url userInfo:(NSDictionary *)info;
{
    [self removeAvtivityViewWithUserInfo:info];
}

- (void)removeAvtivityViewWithUserInfo:(NSDictionary *)info
{
    if ([info isNotEmpty])
    {
        UIView *activityIndicatorView = [info objectForKey:@"activityKey"];

        if (activityIndicatorView != nil)
        {
            if ([activityIndicatorView isKindOfClass:[UIActivityIndicatorView class]])
            {
                UIActivityIndicatorView *activity = (UIActivityIndicatorView *)activityIndicatorView;
                [activity stopAnimating];
            }
            [activityIndicatorView removeFromSuperview];
        }
        else
        {
            NSArray *array = [self subviews];
            for (UIView *view in array)
            {
                if ([view isKindOfClass:[UIActivityIndicatorView class]])
                {
                    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)view;
                    [activity stopAnimating];

                    [view removeFromSuperview];
                }
            }
        }
    }
}

@end