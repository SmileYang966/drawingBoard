//
//  SCStrokeLine.h
//  test
//
//  Created by Evan Yang on 2019/12/28.
//  Copyright © 2019 Evan Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCStrokeLine : NSObject

@property(nonatomic,strong) UIBezierPath  *strokePath;
@property(nonatomic,assign) CGColorRef  strokeColor;
@property(nonatomic,assign) CGFloat lineWidth;
@property(nonatomic,assign) CGBlendMode BlendMode;

@end

NS_ASSUME_NONNULL_END
