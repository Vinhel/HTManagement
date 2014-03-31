//
//  UIImage+Resize.h
//  HTManagement
//
//  Created by lyn on 14-3-28.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

+ (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
