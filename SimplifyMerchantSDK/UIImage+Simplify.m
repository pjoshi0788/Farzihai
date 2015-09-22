#import "UIImage+Simplify.h"
#import "NSBundle+Simplify.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Simplify)

+(UIImage*)imageNamedFromFramework:(NSString*)name {
    NSString *fileName = [[NSBundle frameworkBundle] pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:fileName];
}

+(UIImageView *)blurImage:(CALayer *)layer {

    CGRect rect = layer.frame;
    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();
    [layer renderInContext:context];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *blurredImage = [UIImage boxblurImage:image withBlur:1.0];
    return [[UIImageView alloc] initWithImage:blurredImage];
    
}

+(UIImage *)boxblurImage:(UIImage *)originalImage withBlur:(CGFloat)blur {

    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 50);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef imagePreProcess = originalImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(imagePreProcess);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(imagePreProcess);
    inBuffer.height = CGImageGetHeight(imagePreProcess);
    inBuffer.rowBytes = CGImageGetBytesPerRow(imagePreProcess);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(imagePreProcess) * CGImageGetHeight(imagePreProcess));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(imagePreProcess);
    outBuffer.height = CGImageGetHeight(imagePreProcess);
    outBuffer.rowBytes = CGImageGetBytesPerRow(imagePreProcess);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8,
                                             outBuffer.rowBytes, colorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}


@end
