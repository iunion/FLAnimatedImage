/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+WebCache.h"
#import "SDWebImageManager.h"
#import "NSData+GIF.h"
#import "UIImage+GIF.h"
#import "NSObject+Category.h"
#import "UIColor+Category.h"
#import "UIView+Positioning.h"


@implementation UIButton (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    [self setImageWithURL:url forState:state placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager cancelForDelegate:self];
    
    //modify by sxf
    UIActivityIndicatorView *activity = nil;
    if (!(options & SDWebImagePlaceholderImageDelay))
    {
        [self setImage:placeholder forState:state];
    }
    else if (options & SDWebImagePlaceholderImageDelay)
    {
        activity = SDWIReturnAutoreleased([[UIActivityIndicatorView alloc] initWithFrame:self.bounds]);
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:activity];
        activity.userInteractionEnabled = NO;
        activity.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
        [activity centerInSuperView];
        [activity startAnimating];
    }
    
    if (url)
    {
        if (activity)
        {            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:activity,placeholder,[NSNumber numberWithInt:state], nil] forKeys:[NSArray arrayWithObjects:@"activityKey", @"placeholderImage", @"UIControlState", nil]];
            [manager downloadWithURL:url delegate:self options:options userInfo:userInfo];
        }
        else
        {
            [manager downloadWithURL:url delegate:self options:options];
        }
    }
    else if (activity)
    {
        [activity stopAnimating];
        [activity removeFromSuperview];
        [self setImage:placeholder forState:state];
    }
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    [self setImage:placeholder forState:UIControlStateNormal];
    [self setImage:placeholder forState:UIControlStateSelected];
    [self setImage:placeholder forState:UIControlStateHighlighted];


    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageProgressBlock)progress success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    [self setImage:placeholder forState:UIControlStateNormal];
    [self setImage:placeholder forState:UIControlStateSelected];
    [self setImage:placeholder forState:UIControlStateHighlighted];

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options progress:progress success:success failure:failure];
    }
}
#endif

- (void)setBackgroundImageWithURL:(NSURL *)url
{
    [self setBackgroundImageWithURL:url placeholderImage:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setBackgroundImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    [self setBackgroundImage:placeholder forState:UIControlStateNormal];
    [self setBackgroundImage:placeholder forState:UIControlStateSelected];
    [self setBackgroundImage:placeholder forState:UIControlStateHighlighted];

    if (url)
    {
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"background" forKey:@"type"];
        [manager downloadWithURL:url delegate:self options:options userInfo:info];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setBackgroundImageWithURL:(NSURL *)url success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setBackgroundImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setBackgroundImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setBackgroundImageWithURL:url placeholderImage:placeholder options:options progress:nil success:success failure:failure];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageProgressBlock)progress success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    [self setBackgroundImage:placeholder forState:UIControlStateNormal];
    [self setBackgroundImage:placeholder forState:UIControlStateSelected];
    [self setBackgroundImage:placeholder forState:UIControlStateHighlighted];

    if (url)
    {
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"background" forKey:@"type"];
        [manager downloadWithURL:url delegate:self options:options userInfo:info progress:progress success:success failure:failure];
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

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    NSString *type = [info valueForKey:@"type"];
    if (type/* && [type isEqualToString:@"background"]*/)
    {
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setBackgroundImage:image forState:UIControlStateSelected];
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    else
    {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateSelected];
        [self setImage:image forState:UIControlStateHighlighted];
    }
}

// SDImageCache中有数据
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    NSString *type = [info valueForKey:@"type"];
    if (type/* && [type isEqualToString:@"background"]*/)
    {
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setBackgroundImage:image forState:UIControlStateSelected];
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    else
    {
        if ([info isNotEmpty])
        {
            [self removeAvtivityViewWithImage:image UserInfo:info];
        }
        else
        {
            [self setImage:image forState:UIControlStateNormal];
            [self setImage:image forState:UIControlStateSelected];
            [self setImage:image forState:UIControlStateHighlighted];
        }
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url userInfo:(NSDictionary *)info;
{
    [self removeAvtivityViewWithImage:nil UserInfo:info];
}

- (void)removeAvtivityViewWithImage:(UIImage *)image UserInfo:(NSDictionary *)info
{
    if ([info isNotEmpty])
    {
        UIView *activityIndicatorView = [info objectForKey:@"activityKey"];
        UIImage *placeImage = [info objectForKey:@"placeholderImage"];
        NSInteger state = [[info objectForKey:@"UIControlState"] integerValue];
        
        if (activityIndicatorView != nil)
        {
            if ([activityIndicatorView isKindOfClass:[UIActivityIndicatorView class]])
            {
                UIActivityIndicatorView *activity = (UIActivityIndicatorView *)activityIndicatorView;
                [activity stopAnimating];
            }
            [activityIndicatorView removeFromSuperview];
        }

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
        
        if (image)
        {
            [self setImage:image forState:state];
        }
        else if (placeImage && [placeImage isKindOfClass:[UIImage class]])
        {
            [self setImage:placeImage forState:state];
        }
    }
}

@end
