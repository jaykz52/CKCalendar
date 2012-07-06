#import <Foundation/Foundation.h>

@class CALayer;
@class CAGradientLayer;


@interface GradientView : UIView

@property(nonatomic, strong, readonly) CAGradientLayer *gradientLayer;
- (void)setColors:(NSArray *)colors;

@end