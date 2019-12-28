//
//  SCImageView.h
//  test
//
//  Created by Evan Yang on 2019/12/27.
//  Copyright © 2019 Evan Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCDrawingView : UIView

-(void)clearOperation;
-(void)undoOperation;
-(void)eraseOperationWithButton:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
