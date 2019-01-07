//
//  QuickTools.m
//  Shopping
//
//  Created by 党玉华 on 2018/7/11.
//  Copyright © 2018年 党玉华. All rights reserved.
//

#import "QuickTools.h"
#import "FPSLabel.h"

@interface QuickTools()

@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, assign)NSInteger second;

@end

@implementation QuickTools

+(SDWebImageManager *)shareManager{
    static SDWebImageManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken, ^{
        if (manager == nil) {
            manager = [SDWebImageManager sharedManager];
        }
    });
    return manager;
}
//UIButton
+(UIButton *)UIButtonWithFrame:(CGRect )frame backgroundColor:(UIColor *)backgroundColor title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage font:(CGFloat)font textColor:(UIColor *)textColor selectTextColor:(UIColor *)selectTextColor edgeInsets:(UIEdgeInsets )edgeInsets tag:(NSInteger)tag target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = backgroundColor;
    button.frame = frame;
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:textColor forState:UIControlStateNormal];
        [button setTitleColor:selectTextColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:font];
        button.titleEdgeInsets = edgeInsets;
    }else{
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
        button.imageEdgeInsets = edgeInsets;
    }
    button.tag = tag;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//导航栏返回按钮
+(UIBarButtonItem *)UIBarButtonItemNavBackBarButtonItemWithTarget:(id)target action:(SEL)action{
    UIButton *button = [self UIButtonWithFrame:CGRectMake(0, 0, 28, 32) backgroundColor:clearColor title:nil image:@"general_back" selectImage:nil font:0 textColor:clearColor selectTextColor:clearColor edgeInsets:Edge(0, 0, 0, 8) tag:0 target:target action:action];
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithCustomView:button];
    return backBar;
}

//导航栏按钮
+(UIBarButtonItem *)UIBarButtonItemBarButtonWithTarget:(id)target action:(SEL)action frame:(CGRect )frame title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage font:(CGFloat)font textColor:(UIColor *)textColor edgeInsets:(UIEdgeInsets)edgeInsets{
    UIButton *button = [self UIButtonWithFrame:frame backgroundColor:clearColor title:title image:image selectImage:selectImage font:font textColor:textColor selectTextColor:textColor edgeInsets:Edge(0, 0, 0, 0) tag:0 target:target action:action];
    if (title != nil) {
        button.titleEdgeInsets = edgeInsets;
    }else{
        button.imageEdgeInsets = edgeInsets;
    }
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    return barButton;
}

//上拉下拉tableview
+(UITableView *)UITableViewMJRefreshWithBackgroundColor:(UIColor *)color frame:(CGRect )frame separatorStyle:(UITableViewCellSeparatorStyle )separatorStyle style:(UITableViewStyle)style contentInset:(UIEdgeInsets )contentInset footIsNeedDrag:(BOOL)footIsNeedDrag mjheadBlock:(void (^)(void))mjheadBlock mjfootBlock:(void (^)(void))mjfootBlock{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:style];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    //非常重要关闭预估高度，避免新系统UI刷新错位
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.separatorStyle = separatorStyle;
    tableView.backgroundColor = color;
    tableView.contentInset = contentInset;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        mjheadBlock();
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    tableView.mj_header = header;
    if (footIsNeedDrag) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            mjfootBlock();
        }];
        footer.labelLeftInset = 0;
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
        [footer setTitle:@"" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        tableView.mj_footer = footer;
    }else{
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            mjfootBlock();
        }];
        footer.labelLeftInset = 0;
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
        [footer setTitle:@"" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        tableView.mj_footer = footer;
    }
    return tableView;
}
//
+(UITableView *)UITableViewWithBackgroundColor:(UIColor *)color frame:(CGRect )frame separatorStyle:(UITableViewCellSeparatorStyle )separatorStyle style:(UITableViewStyle)style contentInset:(UIEdgeInsets )contentInset{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:style];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    //非常重要关闭预估高度，避免新系统UI刷新错位
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.separatorStyle = separatorStyle;
    tableView.backgroundColor = color;
    tableView.contentInset = contentInset;
    return tableView;
}
//通过data获取image,可获取image大小
+(UIImage *)UIImageWithimageURL:(NSString *)imageURL{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    return image;
}
//UICollectionView
+(UICollectionView *)UICollectionViewWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection )scrollDirection itemSize:(CGSize )itemSize minimumLineSpacing:(CGFloat )minimumLineSpacing minimumInteritemSpacing:(CGFloat )minimumInteritemSpacing backgroundColor:(UIColor *)backgroundColor scrollEnabled:(BOOL )scrollEnabled pagingEnabled:(BOOL )pagingEnabled showsScrollIndicator:(BOOL )showsScrollIndicator contentInset:(UIEdgeInsets )contentInset{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = scrollDirection;
    
    flowLayout.itemSize = itemSize;
    
    flowLayout.minimumLineSpacing = minimumLineSpacing;
    
    flowLayout.minimumInteritemSpacing = minimumInteritemSpacing;
    
    UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    
    if (@available(iOS 11.0, *)) {
        collectionview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    collectionview.backgroundColor = backgroundColor;
    
    collectionview.scrollEnabled = scrollEnabled;
    
    collectionview.pagingEnabled = pagingEnabled;
    
    if (scrollDirection == UICollectionViewScrollDirectionVertical) {
        collectionview.showsVerticalScrollIndicator = showsScrollIndicator;
    }else{
        collectionview.showsHorizontalScrollIndicator = showsScrollIndicator;
    }
    collectionview.contentInset = contentInset;
    
    return collectionview;
}

//UICollectionView
+(UICollectionView *)UICollectionViewMJRefreshWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection )scrollDirection itemSize:(CGSize )itemSize minimumLineSpacing:(CGFloat )minimumLineSpacing minimumInteritemSpacing:(CGFloat )minimumInteritemSpacing backgroundColor:(UIColor *)backgroundColor scrollEnabled:(BOOL )scrollEnabled pagingEnabled:(BOOL )pagingEnabled showsScrollIndicator:(BOOL )showsScrollIndicator contentInset:(UIEdgeInsets )contentInset footerLabelLeftInset:(CGFloat)inset mjfootBlock:(void (^)(void))mjfootBlock{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = scrollDirection;
    
    flowLayout.itemSize = itemSize;
    
    flowLayout.minimumLineSpacing = minimumLineSpacing;
    
    flowLayout.minimumInteritemSpacing = minimumInteritemSpacing;
    
    UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    
    if (@available(iOS 11.0, *)) {
        collectionview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    collectionview.backgroundColor = backgroundColor;
    
    collectionview.scrollEnabled = scrollEnabled;
    
    collectionview.pagingEnabled = pagingEnabled;
    
    if (scrollDirection == UICollectionViewScrollDirectionVertical) {
        collectionview.showsVerticalScrollIndicator = showsScrollIndicator;
    }else{
        collectionview.showsHorizontalScrollIndicator = showsScrollIndicator;
    }
    collectionview.contentInset = contentInset;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        mjfootBlock();
    }];
    footer.labelLeftInset = inset;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    collectionview.mj_footer = footer;
    
    return collectionview;
}
//解决含有UICollectionView的vc手势返回冲突
+(UICollectionView *)UICollectionViewConflictWithVCBack:(UICollectionView *)collectionview vc:(UIViewController *)vc{
    NSArray *gestureArray = vc.navigationController.view.gestureRecognizers;
    for (UIGestureRecognizer *gestureRecognizer in gestureArray) {
        if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [collectionview.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        }
    }
    return collectionview;
}

//UIScrollView
+ (UIScrollView *)UIScrollViewWithFrame:(CGRect )frame backgroundColor:(UIColor *)bgcolor size:(CGSize )size isPagingEnable:(BOOL )isPage isBounces:(BOOL )isBounces scrollEnabled:(BOOL )scrollEnabled isShowVerticalIndicator:(BOOL )isShowVIndicator isShowsHorizontalScrollIndicator:(BOOL )isShowHIndicator{
    
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:frame];
    scrollview.backgroundColor = bgcolor;
    scrollview.contentSize = size;
    scrollview.pagingEnabled = isPage;
    scrollview.bounces = isBounces;
    scrollview.scrollEnabled = scrollEnabled;
    scrollview.showsVerticalScrollIndicator = isShowVIndicator;
    scrollview.showsHorizontalScrollIndicator = isShowHIndicator;
    return scrollview;
}
//解决含有scrollview的vc手势返回冲突
+(UIScrollView *)UIScrollViewConflictWithVCBack:(UIScrollView *)scrollview vc:(UIViewController *)vc{
    NSArray *gestureArray = vc.navigationController.view.gestureRecognizers;
    for (UIGestureRecognizer *gestureRecognizer in gestureArray) {
        if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [scrollview.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        }
    }
    return scrollview;
}
//
+(UILabel *)UILabelWithFrame:(CGRect )frame backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor text:(NSString *)text numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment )textAlignment font:(CGFloat)fontSize{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = backgroundColor;
    label.text = text;
    label.frame = frame;
    label.textColor = textColor;
    label.numberOfLines = numberOfLines;
    label.textAlignment = textAlignment;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}
//
+(UIControl *)UIControlFrame:(CGRect )frame backgroundColor:(UIColor *)backgroundColor tag:(int)tag target:(id)target action:(SEL)action{
    UIControl *control = [[UIControl alloc]initWithFrame:frame];
    control.backgroundColor = backgroundColor;
    control.tag = tag;
    [control addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return control;
}
//
+(UIView *)UIViewWithFrame:(CGRect )frame backgroundColor:(UIColor *)backgroundColor{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = backgroundColor;
    view.frame = frame;
    return view;
}
//
+(UITextView *)UITextViewithFrame:(CGRect )frame backgroundColor:(UIColor *)backgroundColor content:(NSString *)content font:(CGFloat)fontSize textColor:(UIColor *)textColor{
    UITextView *textview = [[UITextView alloc]init];
    textview.backgroundColor = backgroundColor;
    textview.frame = frame;
    textview.scrollEnabled = NO;
    textview.showsVerticalScrollIndicator = NO;
    textview.showsHorizontalScrollIndicator = NO;
    textview.text = content;
    textview.font = [UIFont systemFontOfSize:fontSize];
    textview.textColor = textColor;
    textview.editable = NO;
    textview.userInteractionEnabled = NO;
    return textview;
}

+(UIImageView *)UIImageViewWithFrame:(CGRect )frame image:(id)image{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = frame;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    if ([image isKindOfClass:[NSString class]]) {
        imageView.image = [UIImage imageNamed:image];
    }else if ([image isKindOfClass:[UIImage class]]) {
        imageView.image = image;
    }
    return imageView;
}

+(UITextField *)UITextFieldWithFrame:(CGRect )frame cornerRadius:(CGFloat )r font:(CGFloat)font borderStyle:(UITextBorderStyle )borderStyle backgroundColor:(UIColor *)bgcolor placeholder:(NSString *)placeholder attributes:(NSDictionary<NSAttributedStringKey, id> *)attrs returnKeyType:(UIReturnKeyType)returnKeyType leftview:(UIView *)leftview rightView:(UIView *)rightView clearButtonMode:(UITextFieldViewMode )clearButtonMode keyboardType:(UIKeyboardType )keyboardType{
    UITextField *tf = [[UITextField alloc]initWithFrame:frame];
    tf.layer.cornerRadius = r;
    tf.font = [UIFont systemFontOfSize:font];
    tf.backgroundColor = bgcolor;
    tf.placeholder = placeholder;
    tf.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeholder attributes:attrs];
    tf.borderStyle = borderStyle;
    leftview.layer.cornerRadius = r;
    tf.leftView = leftview;
    rightView.layer.cornerRadius = r;
    tf.rightView = rightView;
    tf.returnKeyType = returnKeyType;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.rightViewMode = UITextFieldViewModeAlways;
    tf.clearButtonMode = clearButtonMode;
    tf.keyboardType = keyboardType;
    return tf;
}

+(UISearchController *)UISearchControllerWithSearchResultsController:(UIViewController *)searchResultsController frame:(CGRect )frame{
    UISearchController *searchController = [[UISearchController alloc]initWithSearchResultsController:searchResultsController];
    searchController.searchBar.frame = frame;
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    if (@available(iOS 9.1, *)) {
        searchController.obscuresBackgroundDuringPresentation = NO;
    } else {
        // Fallback on earlier versions
    }
    //隐藏导航栏
    searchController.hidesNavigationBarDuringPresentation = YES;
    
    return searchController;
}
//WKWebView
+(WKWebView *)WKWebViewWithFrame:(CGRect )frame url:(NSString *)url{
    WKWebView *webView = [[WKWebView alloc] initWithFrame:frame];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0]];
    return webView;
}
//UIActivityIndicatorView
+(UIActivityIndicatorView *)UIActivityIndicatorViewWithFrame:(CGRect )frame activityIndicatorViewStyle:(UIActivityIndicatorViewStyle) activityIndicatorViewStyle{
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:frame];
    indicatorView.activityIndicatorViewStyle = activityIndicatorViewStyle;
    return indicatorView;
}
+(NSAttributedString *)NSAttributedStringWithIndex1:(NSInteger )index1 index2:(NSInteger )index2 string:(NSString *)string color:(UIColor *)color font:(CGFloat)font{
    NSString *str1 = string;
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString: str1];
    [str2 addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(index1,index2)];
    [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(index1,index2)];
    return str2;
}
//尚未确定
+(UIControl *)TopImageBottomStringWithFrame:(CGRect)frame image:(NSString *)image imageurl:(NSString *)imageurl placeholderImage:(NSString *)placeholderImage name:(NSString *)name font:(CGFloat)font textColor:(UIColor *)textColor tag:(NSInteger)tag target:(id)target action:(SEL)action{
    UIControl *control = [[UIControl alloc]init];
    control.backgroundColor = clearColor;
    UIImageView *imageview = [self UIImageViewWithFrame:Frame(0, frame.size.height/10, frame.size.width, frame.size.width) image:image];
    if (image == nil) {
        imageview = [self SDWebImageSetImage:imageview url:imageurl placeholderImage:placeholderImage];
    }
    [control addSubview:imageview];
    UILabel *label = [self UILabelWithFrame:Frame(0, frame.size.width+frame.size.height/10, frame.size.width, 15) backgroundColor: clearColor textColor:blackColor text:name numberOfLines:0 textAlignment:NSTextAlignmentCenter font:font];
    [control addSubview:label];
    control.tag = tag;
    [control addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return control;
}
//数字字符串转成时间字符串
+(NSString *)NumberTimeChangeString:(NSString *)time{
    
    NSInteger num = [time integerValue];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate * confromTime = [NSDate dateWithTimeIntervalSince1970:num];
    NSString * comfromTimeStr = [formatter stringFromDate:confromTime];
    return comfromTimeStr;
}
//获得目前时间
+(NSString *)getCurrentDateFormatter:(NSString *)dateFormat{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = dateFormat;//@"yyyy-MM-dd HH:mm:ss"
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
}
//获取某个时间与现在时间差
+(NSInteger)getTimeDifferenceWithNowTime:(NSString*)nowTime endTime:(NSString*)endTime {
    
    NSInteger timeDifference = 0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowTime];
    NSDate *deadline = [formatter dateFromString:endTime];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];
    NSTimeInterval newTime = [deadline timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}
//string时间转数字时间戳
+(NSString *)StringDateToNSIntergeTime:(NSString*)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:time];
    NSInteger numtime = nowDate.timeIntervalSince1970;
    NSString *numtimestr = [NSString stringWithFormat:@"%ld",(long)numtime];
    return numtimestr;
}
//下载图片
+(UIImageView *)SDWebImageSetImage:(UIImageView *)imageview url:(NSString *)imageURL placeholderImage:(NSString *)placeholderImage{
    
    [imageview sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:placeholderImage]];
    return imageview;
}
//图片渐显
+(UIImageView *)SDWebImageFadeInImageView:(UIImageView *)imageview url:(NSString *)url placeholderImage:(NSString *)placeholderImage{
    //从缓存中取图片
    //UIImage *image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:url];
    //把图片存到缓存中
    //[[SDImageCache sharedImageCache]storeImage:image forKey:url];
    NSURL *imageURL = [NSURL URLWithString:url];
    SDWebImageManager *manager = [self shareManager];
    imageview.image = [UIImage imageNamed:placeholderImage];
    [imageview sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:placeholderImage] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if ([manager diskImageExistsForURL:imageURL]) {
            return;//缓存中有，就不再渐显
        }else {
            imageview.alpha = 0.0;
            [UIView transitionWithView:imageview duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                imageview.alpha = 1.0;
            }completion:NULL];
        }
    }];
    return imageview;
}
//下载图片(需要获取frame的)
+(UIImageView *)SDWebImageNeedFrame:(UIImageView *)imageview url:(NSString *)imageURL placeholderImage:(NSString *)placeholderImage{
    [imageview sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:placeholderImage] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGSize size = image.size;
        CGFloat w = size.width;
        CGFloat h = size.height;
        imageview.frame = CGRectMake(0, 0, w, h);
    }];
    return imageview;
}
//截取字符串
+(NSString *)cutoutNSString:(NSString *)str range:(NSInteger )index{
    str = [str substringToIndex:index];
    return str;
}

//计算字符串高度
+(CGFloat)calculatedStringHeight:(NSString *)string WithSize:(CGSize)size font:(CGFloat)fontSize{
    CGFloat h = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.height;
    return h;
}
//计算字符串宽度
+(CGFloat)calculatedStringWidth:(NSString *)string WithSize:(CGSize)size font:(CGFloat)fontSize{
    CGFloat h = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.width;
    return h;
}


// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)return CGSizeZero;// url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
//获取目前的VC
+ (UIViewController *)getCurrentVC{
    UITabBarController *tab = (UITabBarController *)WIN.rootViewController;
    UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
    return nav.topViewController;
}
//用途比如推送跳转
+ (UINavigationController *)getCurrentNav{
    UITabBarController *tab = (UITabBarController *)WIN.rootViewController;
    UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
    return nav;
}
//设置NSAttributedString颜色
+(NSMutableAttributedString *)NSMutableAttributedStringColorConfigText:(NSString *)text textColor:(UIColor *)textColor range:(NSRange)range{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
    [attr setAttributes:@{NSForegroundColorAttributeName : textColor} range:range];
    return attr;
}
//震动
+(void)playVibrate{
    AudioServicesPlaySystemSound(1007);  
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}
//image转data
+(NSData *)UIImageExchangeNSData:(UIImage *)image{
    NSData *data = UIImagePNGRepresentation(image);
    return data;
}
//data转image
+(UIImage *)NSDataExchangeUIImage:(NSData *)data{
    UIImage *image = [UIImage imageWithData: data];
    return image;
}
//相机相册调用
+(UIImagePickerController *)UIImagePickerControllerWithAllowsEditing:(BOOL)allowsEditing sourceType:(UIImagePickerControllerSourceType) sourceType{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = allowsEditing;
    imagePickerController.sourceType = sourceType;
    //Media types:在拍照时,用来指定是拍静态的图片还是录像.kUTTypeImage 表示静态图片, kUTTypeMovie表示录像.
    imagePickerController.mediaTypes =[NSArray arrayWithObjects: (NSString *)kUTTypeMovie, nil];
    //imagePickerController.videoQuality = UIImagePickerControllerQualityType640x480;
    imagePickerController.videoQuality=UIImagePickerControllerQualityTypeMedium;
    imagePickerController.navigationBar.translucent = NO;//去除毛玻璃效果
    return imagePickerController;
}
//点按
+(UITapGestureRecognizer *)UITapGestureRecognizerWithTarget:(id)target action:(SEL)action{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    return tap;
}
//长按
+(UILongPressGestureRecognizer *)UILongPressGestureRecognizerWithTarget:(id)target action:(SEL)action{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    return longPress;
}
//轻扫
+(UISwipeGestureRecognizer *)UISwipeGestureRecognizerWithTarget:(id)target action:(SEL)action direction:(UISwipeGestureRecognizerDirection)direction{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    swipe.direction = direction;
    return swipe;
}
//旋转
+(UIRotationGestureRecognizer *)UIRotationGestureRecognizerWithTarget:(id)target action:(SEL)action{
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:target action:action];
    return rotation;
}
//捏合
+(UIPinchGestureRecognizer *)UIPinchGestureRecognizerWithTarget:(id)target action:(SEL)action{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:target action:action];
    return pinch;
}
//拖拽
+(UIPanGestureRecognizer *)UIPanGestureRecognizerWithTarget:(id)target action:(SEL)action{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    return pan;
}
//FPS检测 //流畅度
+(void)FPSLabel{
    FPSLabel *fpsLabel = [[FPSLabel alloc]initWithFrame:Frame(ScreenW-100, kTopBarHeight+20, 80, 30)];
    [WIN addSubview:fpsLabel];
}

// 返回虚线image的方法
+(UIImage *)drawLineByImageView:(UIImageView *)imageView lineColor:(UIColor *)color{
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    CGFloat lengths[] = {5,1.0};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, color.CGColor);
    CGContextSetLineDash(line, 0, lengths, 0.5); //画虚线
    CGContextMoveToPoint(line, 0.0, 1.0); //开始画线
    CGContextAddLineToPoint(line, ScreenW - 10, 1.0);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}
//获取启动图
+(UIImage *)getLaunchImage{
    UIImage *lauchImage  = nil;
    NSString *viewOrientation = nil;
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        viewOrientation = @"Landscape";
    }else{
        viewOrientation = @"Portrait";
    }
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    return lauchImage;
}

@end





