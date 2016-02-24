//
//  CandyBarView.h
//  CandyBar
//
//  Created by skubo on 02.07.15.
//  Copyright (c) 2015 ga.rbers.net. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CandyBarView : UIView

-(id)initWithFrame:(CGRect)frame andTitle:(NSString*) title;

@property (nonatomic, strong) IBInspectable UILabel* barTitle;
@property (nonatomic, strong) IBInspectable UIColor* progressColor;
@property (nonatomic, assign) IBInspectable float current;
@property (nonatomic, assign) IBInspectable float minimum;
@property (nonatomic, assign) IBInspectable float maximum;
@property (nonatomic, assign) IBInspectable BOOL withR;


@end
