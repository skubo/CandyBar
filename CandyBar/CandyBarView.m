//
//  CandyBarView.m
//  CandyBar
//
//  Created by skubo on 02.07.15.
//  Copyright (c) 2015 ga.rbers.net. All rights reserved.
//

#import "CandyBarView.h"
#import <CoreText/CoreText.h>

@implementation CandyBarView

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Dynamically load bundled custom fonts
        
        [self loadFont];
    });
}

+ (void)loadFont
{
    NSBundle* bundle = [NSBundle bundleForClass:[CandyBarView class]];
    
    NSString *fontPath = [bundle pathForResource:@"SNICN___" ofType:@"TTF"];
    NSData *fontData = [NSData dataWithContentsOfFile:fontPath];
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
    
    if (provider)
    {
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        
        if (font)
        {
            CFErrorRef error = NULL;
            if (CTFontManagerRegisterGraphicsFont(font, &error) == NO)
            {
                CFStringRef errorDescription = CFErrorCopyDescription(error);
                NSLog(@"Failed to load font: %@", errorDescription);
                CFRelease(errorDescription);
            }
            
            CFRelease(font);
        }
        
        CFRelease(provider);
    }
}

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView* barImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        barImageView.image = [UIImage imageNamed:@"frame" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        [self addSubview:barImageView];
        self.backgroundColor = [UIColor clearColor];
        
        _barTitle = [[UILabel alloc] initWithFrame:self.bounds];
        _barTitle.textColor = [UIColor blackColor];
        _barTitle.text = @"CandyMan";
        _barTitle.textAlignment = NSTextAlignmentCenter;
        
        _barTitle.font = [UIFont fontWithName:@"SnickersNormal" size:[self calculateFontSize]];
        [self addSubview:_barTitle];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame andTitle:(NSString*) title {
    if ([self initWithFrame:frame]) {
        _barTitle.text = title;
    }
    return self;
}

-(float)calculateFontSize {
    // TODO
    return 50.0f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setValue:(float)value lowValue:(float) low highValue:(float) high {
    
}
@end
