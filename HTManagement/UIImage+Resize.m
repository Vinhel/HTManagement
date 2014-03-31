//
//  UIImage+Resize.m
//  HTManagement
//
//  Created by lyn on 14-3-28.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
	// Create a graphics image context
	UIGraphicsBeginImageContext(newSize);
	
	// Tell the old image to draw in this new context, with the desired
	// new size
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	
	// Get the new image from the context
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the context
	UIGraphicsEndImageContext();
	
	// Return the new image.
	return newImage;
}


@end
