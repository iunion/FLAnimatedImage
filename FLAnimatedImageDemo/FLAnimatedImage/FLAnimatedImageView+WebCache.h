//
//  FLAnimatedImageView+WebCache.h
//  FLAnimatedImageDemo
//
//  Created by mac on 14-6-4.
//  Copyright (c) 2014年 Flipboard. All rights reserved.
//

#import "FLAnimatedImageView.h"

#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"

/**
 * Integrates SDWebImage async downloading and caching of remote images with UIImageView.
 *
 * Usage with a UITableViewCell sub-class:
 *
 * 	#import <SDWebImage/UIImageView+WebCache.h>
 *
 * 	...
 *
 * 	- (UITableViewCell *)tableView:(UITableView *)tableView
 * 	         cellForRowAtIndexPath:(NSIndexPath *)indexPath
 * 	{
 * 	    static NSString *MyIdentifier = @"MyIdentifier";
 *
 * 	    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
 *
 * 	    if (cell == nil)
 * 	    {
 * 	        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
 * 	                                       reuseIdentifier:MyIdentifier] autorelease];
 * 	    }
 *
 * 	    // Here we use the provided setImageWithURL: method to load the web image
 * 	    // Ensure you use a placeholder image otherwise cells will be initialized with no image
 * 	    [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://example.com/image.jpg"]
 * 	                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
 *
 * 	    cell.textLabel.text = @"My Text";
 * 	    return cell;
 * 	}
 *
 */
@interface FLAnimatedImageView (WebCache) <SDWebImageManagerDelegate>

/**
 * Set the imageView `image` with an `url`.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 */
- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see setImageWithURL:placeholderImage:options:
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;

#if NS_BLOCKS_AVAILABLE
/**
 * Set the imageView `image` with an `url`.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param success A block to be executed when the image request succeed This block has no return value and takes the retrieved image as argument.
 * @param failure A block object to be executed when the image request failed. This block has no return value and takes the error object describing the network or parsing error that occurred (may be nil).
 */
- (void)setImageWithURL:(NSURL *)url animatedsuccess:(SDWebAnimatedImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;

/**
 * Set the imageView `image` with an `url`, placeholder.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param success A block to be executed when the image request succeed This block has no return value and takes the retrieved image as argument.
 * @param failure A block object to be executed when the image request failed. This block has no return value and takes the error object describing the network or parsing error that occurred (may be nil).
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animatedsuccess:(SDWebAnimatedImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param success A block to be executed when the image request succeed This block has no return value and takes the retrieved image as argument.
 * @param failure A block object to be executed when the image request failed. This block has no return value and takes the error object describing the network or parsing error that occurred (may be nil).
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options animatedsuccess:(SDWebAnimatedImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;


// add by DJ
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageProgressBlock)progress animatedsuccess:(SDWebAnimatedImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;

#endif

/**
 * Cancel the current download
 */
- (void)cancelCurrentImageLoad;

@end