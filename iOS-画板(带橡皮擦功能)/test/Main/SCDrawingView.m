//
//  SCImageView.m
//  test
//
//  Created by Evan Yang on 2019/12/27.
//  Copyright © 2019 Evan Yang. All rights reserved.
//

#import "SCDrawingView.h"
#import "SCStrokeLine.h"

@interface SCDrawingView()

@property(nonatomic,strong) UIBezierPath *bezierPath;
@property(nonatomic,strong) NSMutableArray *lines;
@property(nonatomic,assign) BOOL isInEraseMode;
@property(nonatomic,strong) UIImageView *eraseView;

@end


@implementation SCDrawingView

- (UIImageView *)eraseView{
    if (_eraseView == nil) {
        _eraseView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,48,48)];
        _eraseView.image = [UIImage imageNamed:@"erase2.png"];
        [self addSubview:_eraseView];
    }
    return _eraseView;
}

- (NSMutableArray *)lines{
    if (_lines == nil) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (SCStrokeLine *line in self.lines) {
        CGContextSetLineWidth(ctx,line.lineWidth);
        CGContextSetStrokeColorWithColor(ctx,line.strokeColor);
        CGContextSetBlendMode(ctx,line.BlendMode);
        CGContextAddPath(ctx, line.strokePath.CGPath);
        CGContextStrokePath(ctx);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint startPoint = [touch locationInView:self];
    NSLog(@"touchesBegan--x=%lf,y=%lf",startPoint.x,startPoint.y);
    self.bezierPath = [UIBezierPath bezierPath];
    
    if (self.isInEraseMode) {
        self.eraseView.center = startPoint;
        self.eraseView.hidden = false;
    }
    
    //数组里包含了现有的path了
    [self.bezierPath moveToPoint:startPoint];
    
    SCStrokeLine *line = [[SCStrokeLine alloc]init];
    line.strokePath = self.bezierPath;
    line.lineWidth = self.isInEraseMode ? 20.0f : 5.0f ;
    line.strokeColor = self.isInEraseMode ? UIColor.clearColor.CGColor : UIColor.redColor.CGColor;
    line.BlendMode = self.isInEraseMode ? kCGBlendModeClear : kCGBlendModeNormal;
    [self.lines addObject:line];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint movedPoint = [touch locationInView:self];
    NSLog(@"touchesMoved--x=%lf,y=%lf",movedPoint.x,movedPoint.y);
    [self.bezierPath addLineToPoint:movedPoint];
    
    if (self.isInEraseMode) {
        self.eraseView.center = movedPoint;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint endPoint = [[touches anyObject] locationInView:self];
    NSLog(@"touchesEnded--x=%lf,y=%lf",endPoint.x,endPoint.y);
    
    if (self.isInEraseMode) {
        self.eraseView.hidden = true;
    }
}

-(void)clearOperation{
    self.lines = [NSMutableArray array];
    [self setNeedsDisplay];
}

-(void)undoOperation{
    [self.lines removeLastObject];
    [self setNeedsDisplay];
}

-(void)eraseOperationWithButton:(UIButton *)button{
    self.isInEraseMode = !self.isInEraseMode;
}

@end
