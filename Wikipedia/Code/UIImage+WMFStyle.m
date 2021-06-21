#import <WMF/UIImage+WMFStyle.h>

void yoo5() {}

@implementation UIImage (WMFStyle)

+ (instancetype)wmf_imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)wmf_imageFlippedForRTLLayoutDirectionNamed:(NSString *)name {
    return [[UIImage imageNamed:name] imageFlippedForRightToLeftLayoutDirection];
}

@end
