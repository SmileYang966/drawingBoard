//
//  ViewController.m
//  test
//
//  Created by Evan Yang on 2019/12/27.
//  Copyright © 2019 Evan Yang. All rights reserved.
//

#import "ViewController.h"
#import "SCDrawingView.h"

@interface ViewController (){
    BOOL isEraseEnabled;
}
@property(nonatomic,strong) UIImageView *myImageView;
@property(nonatomic,strong) SCDrawingView *drawingView;
@property(nonatomic,strong) UIView *myTitleView;

@end

@implementation ViewController

- (UIImageView *)myImageView{
    if (_myImageView == nil) {
        _myImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _myImageView.image = [UIImage imageNamed:@"climb.jpg"];
        _myImageView.userInteractionEnabled = YES;
        [self.view addSubview:_myImageView];
    }
    return _myImageView;
}

- (SCDrawingView *)drawingView{
    if (_drawingView == nil) {
        _drawingView = [[SCDrawingView alloc]initWithFrame:self.view.bounds];
        _drawingView.backgroundColor = UIColor.clearColor;
        [self.myImageView addSubview:_drawingView];
    }
    return _drawingView;
}

- (UIView *)myTitleView{
    if (_myTitleView == nil) {
        _myTitleView = [[UIView alloc]initWithFrame:CGRectMake(0,0,250, 30)];
        
        CGFloat marginX = 5.0f;
        CGFloat hegith = 30.0f;
        
        UIButton *clearButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,hegith)];
        [clearButton setBackgroundColor:UIColor.brownColor];
        [clearButton setTitle:@"清除" forState:UIControlStateNormal];
        [clearButton setTitleColor:UIColor.yellowColor forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clearButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_myTitleView addSubview:clearButton];
        
        UIButton *undoButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(clearButton.frame)+marginX,0,50,hegith)];
        [undoButton setBackgroundColor:UIColor.brownColor];
        [undoButton setTitleColor:UIColor.yellowColor forState:UIControlStateNormal];
        [undoButton setTitle:@"撤销" forState:UIControlStateNormal];
        [undoButton addTarget:self action:@selector(undoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_myTitleView addSubview:undoButton];
        
        UIButton *eraseButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(undoButton.frame)+marginX,0,100,hegith)];
        [eraseButton setBackgroundColor:UIColor.brownColor];
        [eraseButton setTitleColor:UIColor.yellowColor forState:UIControlStateNormal];
        [eraseButton setTitle:@"使用橡皮擦" forState:UIControlStateNormal];
        [eraseButton addTarget:self action:@selector(eraseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_myTitleView addSubview:eraseButton];
        
        UIButton *saveImageButton1 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(eraseButton.frame)+marginX,0,40,hegith)];
        [saveImageButton1 setBackgroundColor:UIColor.brownColor];
        [saveImageButton1 setTitleColor:UIColor.yellowColor forState:UIControlStateNormal];
        [saveImageButton1 setTitle:@"Save" forState:UIControlStateNormal];
        [saveImageButton1 addTarget:self action:@selector(saveToLocal) forControlEvents:UIControlEventTouchUpInside];
        [_myTitleView addSubview:saveImageButton1];
    }
    return _myTitleView;
}

-(void)clearButtonClicked{
    [self.drawingView clearOperation];
}

-(void)undoButtonClicked{
    [self.drawingView undoOperation];
}

-(void)eraseButtonClicked:(UIButton *)button{
    isEraseEnabled = !isEraseEnabled;
    
    if (isEraseEnabled) {
        [button setTitle:@"停止橡皮擦" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.brownColor forState:UIControlStateNormal];
        [button setBackgroundColor:UIColor.yellowColor];
    }else{
        [button setTitle:@"使用橡皮擦" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.yellowColor forState:UIControlStateNormal];
        [button setBackgroundColor:UIColor.brownColor];
    }
    
    [self.drawingView eraseOperationWithButton:button];
}

-(void)saveToLocal{
    UIGraphicsBeginImageContextWithOptions(self.myImageView.bounds.size, NO, 0);
    [self.myImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imgData = UIImagePNGRepresentation(img);
    //拼接存储路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString *newImageName = [docPath stringByAppendingPathComponent:@"abc.png"];
    if([imgData writeToFile:newImageName atomically:YES])
    {
        NSLog(@"图片已缓存到Document目录下");
    }
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawingView];
    self.navigationItem.titleView = self.myTitleView;
}


@end
