//
//  Create by samingzhong on 2018/1/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XMBackgroundManager : NSObject

@property (nonatomic, strong) UIImage* backgroundImage;

+ (void)setBackgroundImage:(UIImage *)image;

+ (void)setBackgroundImagesforViewControllerClasses:(NSDictionary *)vc_imageDict;

@end
