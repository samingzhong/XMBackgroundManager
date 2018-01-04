    //
    //  Create by samingzhong on 2018/1/3.
    //

#import "XMBackgroundManager.h"
#import "XMBackgroundViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define XMBGWindowHideTime  0.35
#define XMBGWindowShowTime  0.3

@interface XMBackgroundManager ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) XMBackgroundViewController *viewController;
@property (nonatomic, strong) NSMutableDictionary *vc_imageDict;
@property (nonatomic, strong) UIViewController *topViewController;
@property (nonatomic, strong) UIImage *imageWillBeShow;

@property (nonatomic, strong) LAContext *laContext;
@property (nonatomic, assign) BOOL localAuthenticationSuccess;
@end

@implementation XMBackgroundManager

+ (XMBackgroundManager *)sharedInstance {
    static XMBackgroundManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XMBackgroundManager alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(applicationWillEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    });
    
    return sharedInstance;
}

- (XMBackgroundManager *)init {
    if (self = [super init]) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _window = [[UIWindow alloc] initWithFrame:frame];
        _viewController = [[XMBackgroundViewController alloc] init];
        _vc_imageDict = [NSMutableDictionary new];
    }
    
    return self;
}

#pragma mark - public methods

+ (void)setBackgroundImagesforViewControllerClasses:(NSDictionary *)vc_imageDict {
        //sharedInstance keep the image
    [[self sharedInstance].vc_imageDict addEntriesFromDictionary:vc_imageDict];
}

+ (void)setBackgroundImage:(UIImage *)image {
    [self sharedInstance].backgroundImage = image?:[self getAppIcon];
}

#pragma mark - ApplicationStatus Notificatioin
- (void)applicationWillResignActive:(NSNotification *)notification {
    if ([self shouldShowBGWindow]) {
        [self showBGWindow];
    }
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    if ([self shouldHideBGWindow]) {
        [self hideBGWindow];
    }
}

#pragma mark - Private methods

+ (UIImage *)getAppIcon {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage* image = [UIImage imageNamed:icon];
    return image;
}

#pragma mark getTopVC
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#pragma  mark show background window

- (BOOL)shouldShowBGWindow {
        //1. backgrondImage was set?
        //2. top VC has been set?
    self.topViewController = [self topViewController];
    
    BOOL yesOrNo = NO;
    if (_backgroundImage) {
        yesOrNo = YES;
    }
    
    id imageInfo = [self.vc_imageDict objectForKey:NSStringFromClass(self.topViewController.class)];
    if ([imageInfo isKindOfClass:NSString.class]) {
        _imageWillBeShow = [UIImage imageNamed:imageInfo];
        yesOrNo = YES;
    } else if ([imageInfo isKindOfClass:UIImage.class]) {
        _imageWillBeShow = imageInfo;
        yesOrNo = YES;
    }
    
    return yesOrNo;
}

- (void)showBGWindow {
    _window.windowLevel = UIWindowLevelAlert+1;
    _window.rootViewController = _viewController;
    _viewController.backgroundImage = _imageWillBeShow?:_backgroundImage;
    _window.hidden = NO;
    _window.alpha = 0;
    [UIView animateWithDuration:XMBGWindowShowTime animations:^{
        _window.alpha = 1;
    }];
}


#pragma  mark hide background window
- (BOOL)shouldHideBGWindow {
    return YES;
}

- (void)hideBGWindow {
    _window.alpha = 1;
    [UIView animateWithDuration:XMBGWindowHideTime animations:^{
        _window.alpha = 0;
    } completion:^(BOOL finished) {
        _window.hidden = YES;
        _imageWillBeShow = nil;
    }];
}



#pragma mark - dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
