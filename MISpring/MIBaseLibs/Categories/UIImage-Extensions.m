	//
	//  UIImage-Extensions.m
	//
	//  Created by Hardy Macia on 7/1/09.
	//  Copyright 2009 Catamount Software. All rights reserved.
	//

#import "UIImage-Extensions.h"

static inline CGFloat degreesToRadians(CGFloat degrees)
{
    return M_PI * (degrees / 180.0);
}

static CGFloat DegreesToRadians(CGFloat degrees) { return degrees * M_PI / 180; };


static inline CGSize swapWidthAndHeight(CGSize size)
{
    CGFloat  swap = size.width;
	
    size.width  = size.height;
    size.height = swap;
	
    return size;
}

@implementation UIImage (WBImage)

	// rotate an image to any 90-degree orientation, with or without mirroring.
	// original code by kevin lohman, heavily modified by yours truly.
	// http://blog.logichigh.com/2008/06/05/uiimage-fix/

-(UIImage*)rotate:(UIImageOrientation)orient
{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
	
    bnds.size = self.size;
    rect.size = self.size;
	
    switch (orient)
  {
	  case UIImageOrientationUp:
        return self;
		
	  case UIImageOrientationUpMirrored:
        tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
        tran = CGAffineTransformScale(tran, -1.0, 1.0);
        break;
		
	  case UIImageOrientationDown:
        tran = CGAffineTransformMakeTranslation(rect.size.width,
												rect.size.height);
        tran = CGAffineTransformRotate(tran, degreesToRadians(180.0));
        break;
		
	  case UIImageOrientationDownMirrored:
        tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
        tran = CGAffineTransformScale(tran, 1.0, -1.0);
        break;
		
	  case UIImageOrientationLeft:
        bnds.size = swapWidthAndHeight(bnds.size);
        tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
        tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
        break;
		
	  case UIImageOrientationLeftMirrored:
        bnds.size = swapWidthAndHeight(bnds.size);
        tran = CGAffineTransformMakeTranslation(rect.size.height,
												rect.size.width);
        tran = CGAffineTransformScale(tran, -1.0, 1.0);
        tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
        break;
		
	  case UIImageOrientationRight:
        bnds.size = swapWidthAndHeight(bnds.size);
        tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
        tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
        break;
		
	  case UIImageOrientationRightMirrored:
        bnds.size = swapWidthAndHeight(bnds.size);
        tran = CGAffineTransformMakeScale(-1.0, 1.0);
        tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
        break;
		
	  default:
			// orientation value supplied is invalid
        assert(false);
        return nil;
  }
	
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
	
    switch (orient)
  {
	  case UIImageOrientationLeft:
	  case UIImageOrientationLeftMirrored:
	  case UIImageOrientationRight:
	  case UIImageOrientationRightMirrored:
        CGContextScaleCTM(ctxt, -1.0, 1.0);
        CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
        break;
		
	  default:
        CGContextScaleCTM(ctxt, 1.0, -1.0);
        CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
        break;
  }
	
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(ctxt, rect, self.CGImage);
	
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return copy;
}

/*
 * 旋转视图，陈毅 add
 */
- (UIImage *)imageRotated:(UIImage*)img andByDegrees:(CGFloat)degrees
{  
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,img.size.width, img.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-img.size.width / 2, 
                                          -img.size.height / 2, 
                                          img.size.width, 
                                          img.size.height), 
                       [img CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*)rotateAndScaleFromCameraWithMaxSize:(CGFloat)maxSize
{
    UIImage*  imag = self;
	
    imag = [imag rotate:imag.imageOrientation];
    imag = [imag scaleWithMaxSize:maxSize];
	
    return imag;
}

-(UIImage*)scaleWithMaxSize:(CGFloat)maxSize
{
    return [self scaleWithMaxSize:maxSize quality:kCGInterpolationHigh];
}

-(UIImage*)scaleWithMaxSize:(CGFloat)maxSize
					quality:(CGInterpolationQuality)quality
{
    CGRect        bnds = CGRectZero;
    UIImage*      copy = nil;
    CGContextRef  ctxt = nil;
    CGRect        orig = CGRectZero;
    CGFloat       rtio = 0.0;
    CGFloat       scal = 1.0;
	
    bnds.size = self.size;
    orig.size = self.size;
    rtio = orig.size.width / orig.size.height;
	
    if ((orig.size.width <= maxSize) && (orig.size.height <= maxSize))
	  {
        return self;
	  }
	
    if (rtio > 1.0)
	  {
        bnds.size.width  = maxSize;
        bnds.size.height = maxSize / rtio;
	  }
    else
	  {
        bnds.size.width  = maxSize * rtio;
        bnds.size.height = maxSize;
	  }
	
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
	
    scal = bnds.size.width / orig.size.width;
    CGContextSetInterpolationQuality(ctxt, quality);
    CGContextScaleCTM(ctxt, scal, -scal);
    CGContextTranslateCTM(ctxt, 0.0, -orig.size.height);
    CGContextDrawImage(ctxt, orig, self.CGImage);
	
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return copy;
}

@end