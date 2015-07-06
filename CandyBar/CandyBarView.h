//
//  CandyBarView.h
//  CandyBar
//
//  Created by skubo on 02.07.15.
//  Copyright (c) 2015 ga.rbers.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandyBarView : UIView

-(id)initWithFrame:(CGRect)frame andTitle:(NSString*) title;

-(void)setValue:(float)value lowValue:(float) low highValue:(float) high;

@property (nonatomic, strong) UILabel* barTitle;

@end
