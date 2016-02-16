//
//  ViewController.m
//  AnimationExpediaDemo
//
//  Created by liujianzhong on 16/2/16.
//  Copyright © 2016年 liujianzhong. All rights reserved.
//

#import "ViewController.h"
#import "GGImageBrowserView.h"
#import "UIView+CTExtensions.h"

typedef NS_ENUM(NSInteger, VIEWSTYLE) {
    VIEWSTYLEUP = 1,
    VIEWSTYLEDown = 2
};

#define originImageHeight SCREENWIDTH * 2/3

@interface ViewController () <GGImageBrowserViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isStopScroll;
@property (nonatomic, assign) VIEWSTYLE viewStyle;

@property (nonatomic, strong) UIView *viewContent;
@property (nonatomic, strong) GGImageBrowserView *viewImage;
@property (nonatomic, strong) UILabel *labelContent;//内容
@end

@implementation ViewController
#pragma mark - lifeCycleMethods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initData];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initData {
    self.isStopScroll = NO;
    self.viewStyle = VIEWSTYLEUP;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"酒店详情"];

    self.view.backgroundColor = DSBackColor;
    
    self.viewImage.frame  = CGRectMake(0, 0, SCREENWIDTH, originImageHeight);
    [self.scrollView addSubview:self.viewImage];
    
    self.scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view addSubview:self.scrollView];
    //    [self.scrollView addSubview:self.imageView];
    self.labelContent.frame = CGRectMake(0, 0, SCREENWIDTH, 500);

    self.viewContent.frame = CGRectMake(0, self.viewImage.ctBottom, SCREENWIDTH, self.labelContent.ctHeight);
    self.scrollView.contentSize = CGSizeMake(SCREENWIDTH , self.viewContent.ctBottom);

    [self.scrollView addSubview:self.viewContent];
    [self.viewContent addSubview:self.labelContent];
    [self reloadImages];
}

- (void)reloadImages {
    
    NSMutableArray *imageArr = [NSMutableArray array];
    NSMutableArray *picUrlArr = [NSMutableArray array];
    NSInteger imageCount = 4;//your image count
    for(int i = 0 ; i < imageCount ; i++)//
    {
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(i * 60, i * 60, 60, 60);
        //        [self.view addSubview:image];
        [image setImage:[UIImage imageNamed:@"icon_default_building_detail"]];
        image.userInteractionEnabled = YES;
        //imageView 放入数组
        [imageArr addObject:image];
        //imageView的网络图片地址
        [picUrlArr addObject:@"your image url"];
        
        //添加点击操作
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//        [tap addTarget:self action:@selector(tapImage:)];
//        [image addGestureRecognizer:tap];
        
    }
    if (picUrlArr.count == 0 && imageArr.count == 0) {
        [picUrlArr addObject:@""];
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(0, 0, 60, 60);
        //        [self.view addSubview:image];
        [image setImage:[UIImage imageNamed:@"icon_default_building_detail"]];
        image.userInteractionEnabled = YES;
        //imageView 放入数组
        [imageArr addObject:image];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//        [tap addTarget:self action:@selector(tapImage:)];
//        [image addGestureRecognizer:tap];
    }
    [self.viewImage showImageWith:picUrlArr image:imageArr];
}


- (void)didTapImage {
    if (self.viewStyle == VIEWSTYLEUP) {
        [self didAnimationDownStatus];
    } else {
        [self didAnimationUpStatus];
    }
}

/**设置成小图模式*/
- (void)didAnimationUpStatus {
    self.viewStyle = VIEWSTYLEUP;
    [UIView animateWithDuration:0.4 animations:^{
        self.navigationController.navigationBarHidden = NO;
        self.viewImage.frame = CGRectMake(0, 0, SCREENWIDTH, originImageHeight);
        
        self.viewContent.frame = CGRectMake(0, self.viewImage.ctBottom, SCREENWIDTH, self.viewContent.ctHeight);
        self.scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, self.viewContent.ctBottom );
        self.scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.viewContent.ctBottom);
        [self.viewImage didFrameChanged];
    } completion:^(BOOL finished) {
        self.scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.viewContent.ctBottom);
        self.isStopScroll = NO;
        [self.viewImage setImageDescriptionShow:NO];
    }];
}

/**设置成大图模式*/
- (void)didAnimationDownStatus {
    self.viewStyle = VIEWSTYLEDown;
    [UIView animateWithDuration:0.4 animations:^{
        self.navigationController.navigationBarHidden = YES;
        self.viewImage.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.viewContent.frame = CGRectMake(0, self.viewImage.ctBottom, SCREENWIDTH, self.viewContent.ctHeight);
        self.scrollView.frame = CGRectMake(0, -20, SCREENWIDTH, self.viewContent.ctBottom + 20);
        self.scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.viewContent.ctBottom + 1);
        [self.viewImage didFrameChanged];
    } completion:^(BOOL finished) {
        self.isStopScroll = NO;
        [self.viewImage setImageDescriptionShow:YES];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isStopScroll) {
        return;
    }
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    CGFloat currentOffset = offset.y + bounds.size.height;
    CGFloat maximumOffset = size.height;
    //    NSLog(@"scrollViewDidScroll*****************%f", maximumOffset);
    //    NSLog(@"scrollViewDidScroll*****************%f", maximumOffset - currentOffset);
    NSLog(@"scrollView.bounds.origin.y*****************%f", scrollView.bounds.origin.y);
    if (self.viewStyle == VIEWSTYLEUP && scrollView.bounds.origin.y <= -64) {//上视图向下
        [self.viewImage removeFromSuperview];
        self.viewImage.frame = CGRectMake(0, 64 + scrollView.bounds.origin.y, SCREENWIDTH, originImageHeight - scrollView.bounds.origin.y - 64);
        [self.viewImage didFrameChanged];
        self.viewContent.ctTop = self.viewImage.ctBottom;
        [self.scrollView addSubview:self.viewImage];
        NSLog(@"scrollViewDidScroll%@", self.viewImage);
    } else if (self.viewStyle == VIEWSTYLEUP && scrollView.bounds.origin.y > -64) {//
        
    }else if (self.viewStyle == VIEWSTYLEDown && scrollView.bounds.origin.y >= -40) {
        NSLog(@"warning*****************%f", scrollView.bounds.origin.y);
        
        [self.viewImage removeFromSuperview];
        CGFloat imageHeight = SCREENHEIGHT - scrollView.bounds.origin.y+1;
        self.viewImage.frame = CGRectMake(0, scrollView.bounds.origin.y, SCREENWIDTH, imageHeight);
        [self.viewImage didFrameChanged];
        [self.scrollView addSubview:self.viewImage];
        //        NSLog(@"scrollViewDidScroll%@", self.viewImage);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    CGFloat currentOffset = offset.y + bounds.size.height;
    CGFloat maximumOffset = size.height;
    NSLog(@"maximumOffset*****************%f", offset.y);
    NSLog(@"currentOffset*****************%f", currentOffset);
    NSLog(@"maximumOffset - currentOffset*****************%f", maximumOffset - currentOffset);
    if (self.viewStyle == VIEWSTYLEUP && offset.y < - 64 - 50) {//手指向下滑动50的距离
        self.viewStyle = VIEWSTYLEDown;
        [UIView animateWithDuration:0.4 animations:^{
            self.isStopScroll = YES;
            self.navigationController.navigationBarHidden = YES;
            self.viewImage.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT );
            self.viewContent.frame = CGRectMake(0, self.viewImage.ctBottom, SCREENWIDTH, self.viewContent.ctHeight);
            self.scrollView.frame = CGRectMake(0, -20, SCREENWIDTH, self.viewContent.ctBottom + 20);
            self.scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.viewContent.ctBottom + 1);
            [self.viewImage didFrameChanged];
        } completion:^(BOOL finished) {
            self.isStopScroll = NO;
            [self.viewImage setImageDescriptionShow:YES];
        }];
        return;
    }
    
    if (self.viewStyle == VIEWSTYLEDown && offset.y > - 20 + 50) {//向上
        self.viewStyle = VIEWSTYLEUP;
        [UIView animateWithDuration:0.4 animations:^{
            self.navigationController.navigationBarHidden = NO;
            self.viewImage.frame = CGRectMake(0, 0, SCREENWIDTH, originImageHeight);
            
            self.viewContent.frame = CGRectMake(0, self.viewImage.ctBottom, SCREENWIDTH, self.viewContent.ctHeight);
            self.scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, self.viewContent.ctBottom );
            self.scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.viewContent.ctBottom - 100);
            [self.viewImage didFrameChanged];
        } completion:^(BOOL finished) {
            self.scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
            self.scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.viewContent.ctBottom);
            [self.viewImage setImageDescriptionShow:NO];
        }];
        return;
    }
}

- (GGImageBrowserView *)viewImage {
    if (_viewImage == nil) {
        _viewImage = [[GGImageBrowserView alloc] init];
        _viewImage.tag = 1009;
        _viewImage.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage)];
        _viewImage.delegate = self;
        [_viewImage addGestureRecognizer:tap];
    }
    return _viewImage;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = DSBackColor;
        _scrollView.pagingEnabled = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    }
    return _scrollView;
}

- (UIView *)viewContent {
    if (_viewContent == nil) {
        _viewContent = [[UIView alloc] init];
        _viewContent.backgroundColor = DSLineSepratorColor;
    }
    return _viewContent;
}

- (UILabel *)labelContent {
    if (_labelContent == nil) {
        _labelContent = [[UILabel alloc] init];
        _labelContent.numberOfLines = 0;
        _labelContent.lineBreakMode = NSLineBreakByCharWrapping;
        _labelContent.textAlignment = NSTextAlignmentCenter;
        _labelContent.textColor = DSBlackColor;
        _labelContent.font = [UIFont systemFontOfSize:14];
        _labelContent.text = @"这里是内容区";
    }
    return _labelContent;
}

@end
