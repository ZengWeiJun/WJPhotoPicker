//
//  WJPhotoDisplayController.m
//  Example
//
//  Created by 森巴iOS开发部 on 16/6/21.
//  Copyright © 2016年 曾维俊. All rights reserved.
//

#import "WJPhotoDisplayController.h"
#import "WJPhotoGridController.h"
#import "WJPhotoDisplayCell.h"
#import "WJPhotoCommon.h"
#import "WJPhotoDisplayToolbar.h"
#import "MBProgressHUD.h"

@interface WJPhotoDisplayController ()<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
> {
    BOOL _unFirst;
    BOOL _barHidden;
}
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) WJPhotoDisplayToolbar *toolbar;
@property (nonatomic, weak) UIView *navigationBar;
@property (nonatomic, weak) UIButton *seletedBtn;

@property (nonatomic, weak) WJPhotoAsset *photoAsset;

@end

@implementation WJPhotoDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _unFirst = NO;
    _barHidden = NO;
    
    [self setupCollectionView];
    [self setupToolbar];
    [self setupNavigatoinBar];
}

- (void)setupCollectionView {
    CGFloat windowHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat windowWidth = [UIScreen mainScreen].bounds.size.width;
    
    // Setup collection view
    CGFloat space = 10;
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumInteritemSpacing = space;
    flow.itemSize = CGSizeMake(windowWidth, windowHeight);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, space);
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor blackColor];
    [collectionView registerClass:[WJPhotoDisplayCell class] forCellWithReuseIdentifier:@"WJPhotoDisplayCell"];
    [self.view addSubview:collectionView];
    
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-(-10)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:0 metrics:nil views:views]];
    self.collectionView = collectionView;
}

- (void)setupToolbar{
    WJPhotoDisplayToolbar *toolbar = [[WJPhotoDisplayToolbar alloc] initWithSeletedAssets:self.gridViewController.seletedAssets callback:NULL];
    [self.view addSubview:toolbar];
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(toolbar);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[toolbar]-0-|" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[toolbar(44)]-0-|" options:0 metrics:0 views:views]];
    self.toolbar = toolbar;
}

- (void)setupNavigatoinBar {
    UIView *navBar = [[UIView alloc] init];
    navBar.backgroundColor = self.toolbar.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:navBar];
    navBar.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(navBar);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[navBar]-0-|" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[navBar(64)]" options:0 metrics:0 views:views]];
    self.navigationBar = navBar;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.5;
    [navBar addSubview:lineView];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *lineViews = NSDictionaryOfVariableBindings(lineView);
    [navBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[lineView]-0-|" options:0 metrics:nil views:lineViews]];
    [navBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineView(0.5)]-0-|" options:0 metrics:nil views:lineViews]];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"barbuttonicon_back"] forState:UIControlStateNormal];
    [navBar addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    backBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *backBtnViews = NSDictionaryOfVariableBindings(backBtn);
    [navBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backBtn(80)]" options:0 metrics:0 views:backBtnViews]];
    [navBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[backBtn(44)]" options:0 metrics:0 views:backBtnViews]];
    
    
    UIButton *seletedBtn = [[UIButton alloc] init];
    [seletedBtn setImage:[UIImage imageNamed:@"ImageSelectedOff"] forState:UIControlStateNormal];
    [seletedBtn setImage:[UIImage imageNamed:@"ImageSelectedOn"] forState:UIControlStateSelected];
    [navBar addSubview:seletedBtn];
    [seletedBtn addTarget:self action:@selector(seletedBtnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    seletedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    seletedBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *seletedBtnViews = NSDictionaryOfVariableBindings(seletedBtn);
    [navBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[seletedBtn(80)]-0-|" options:0 metrics:0 views:seletedBtnViews]];
    [navBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[seletedBtn(44)]" options:0 metrics:0 views:seletedBtnViews]];
    self.seletedBtn = seletedBtn;
}

- (void)backBtnClicked {[self.navigationController popViewControllerAnimated:YES];}
- (void)seletedBtnBtnClicked:(UIButton *)btn {[self.gridViewController selectionButtonPressed:btn photoAsset:_photoAsset];}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.popCompleted) self.popCompleted();
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!_thumbs.count) return;
    if (!_unFirst) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        _unFirst = YES;
    }
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.thumbs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WJPhotoAsset *photoAsset = self.thumbs[indexPath.item];
    WJPhotoDisplayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WJPhotoDisplayCell" forIndexPath:indexPath];
    self.seletedBtn.selected = photoAsset.selected;
    self.photoAsset = photoAsset;
    
    __weak __typeof(&*cell) wcell = cell;
    [self.gridViewController.groupController asynchronousGetImage:photoAsset thumb:YES completeCb:^(UIImage *image) {
        __strong __typeof(&*wcell) scell = wcell;
        scell.photoDisplayView.imageView.image = image;
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    WJPhotoAsset *photoAsset = self.thumbs[indexPath.item];
    [self requestImage:photoAsset cell:(WJPhotoDisplayCell *)cell];
}

- (BOOL)isPhotoInLocalAblum:(PHAsset *)asset {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = NO;
    option.synchronous = YES;
    __block BOOL isInLocalAblum = YES;
    [self.gridViewController.groupController.cachingImageManager requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        isInLocalAblum = imageData ? YES : NO;
    }];
    return isInLocalAblum;
}

- (void)requestImage:(WJPhotoAsset *)photoAsset cell:(WJPhotoDisplayCell *)cell {
#if iOS8
    if ([self isPhotoInLocalAblum:photoAsset.asset]) {
        self.seletedBtn.enabled = YES;
        [MBProgressHUD hideHUDForView:cell.photoDisplayView animated:YES];
        __weak __typeof(&*cell) wcell = cell;
        [self.gridViewController.groupController asynchronousGetImage:photoAsset thumb:NO completeCb:^(UIImage *image) {
            __strong __typeof(&*wcell) scell = wcell;
            scell.photoDisplayView.imageView.image = image;
        }];
    } else {
        self.seletedBtn.enabled = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:cell.photoDisplayView animated:YES];
        hud.labelText = @"正在从iCloud同步图片";
        hud.detailsLabelText = @"0%";
        
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = NO;
        options.networkAccessAllowed = YES;
        
        __weak __typeof(&*hud) weakHud = hud;
        options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            __strong __typeof(&*weakHud) strongHud = weakHud;
            NSLog(@"progress:%f", progress);
            strongHud.detailsLabelText = [NSString stringWithFormat:@"%.f%%", progress * 100];
        };
        __weak __typeof(&*cell) wcell = cell;
        [self.gridViewController.groupController.cachingImageManager requestImageForAsset:photoAsset.asset targetSize:imageTargetSize() contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong __typeof(&*weakHud) strongHud = weakHud;
                __strong __typeof(&*wcell) scell = wcell;
                if (result) {
                    scell.photoDisplayView.imageView.image = result;
                    self.seletedBtn.enabled = YES;
                    [strongHud hide:YES afterDelay:0.5];
                } else {
                    strongHud.labelText = @"从iCloud同步图片失败";
                    strongHud.detailsLabelText = nil;
                    strongHud.mode = MBProgressHUDModeText;
                    self.seletedBtn.enabled = NO;
                    [strongHud hide:YES afterDelay:1.0];
                }
            });
        }];
    }
#else
    // 暂不支持iOS7
#endif
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self hideBar:_barHidden = !_barHidden];
}

- (void)hideBar:(BOOL)hidden {
    [self.toolbar setHidden:hidden];
    [self.navigationBar setHidden:hidden];
}





@end
