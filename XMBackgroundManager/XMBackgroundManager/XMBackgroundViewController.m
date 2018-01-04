    //
    //  Create by samingzhong on 2018/1/3.
    //

#import "XMBackgroundViewController.h"

@interface XMBackgroundViewController ()
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation XMBackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bgImageView = [UIImageView new];
    [self.view addSubview:_bgImageView];
    [self refreshBackgroundView];
}

- (void)refreshBackgroundView {
    _bgImageView.frame = CGRectMake(0, 0, _backgroundImage.size.width, _backgroundImage.size.height);
    _bgImageView.image = _backgroundImage;
    _bgImageView.center = self.view.center;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    
    [self refreshBackgroundView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
