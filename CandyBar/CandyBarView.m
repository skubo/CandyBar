//
//  CandyBarView.m
//  CandyBar
//
//  Created by skubo on 02.07.15.
//  Copyright (c) 2015 ga.rbers.net. All rights reserved.
//

#import "CandyBarView.h"
#import <CoreText/CoreText.h>
#import "SKUBezierPath+SVG.h"
#import "UIColor+HexColors.h"

@interface CandyBarView() {
    UIBezierPath* path1;
    UIBezierPath* path2;
    UIBezierPath* path3;
    UIBezierPath* path4;
    UIBezierPath* progressPath;
    float scaleX;
    float scaleY;
    UIColor* color1;
    UIColor* color2;
    UIColor* color3;
    UIColor* color4;
}

@end

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

-(void)setCurrent:(float)current {
    _current = current;
    [self computeProgressPath];
    [self setNeedsDisplay];
}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if(self != nil) {
//        self.current = 0.5;
//        self.maximum = 1;
//        self.minimum = 0;
//        self.progressColor = [UIColor colorWithHexString:@"#FEDCBA"];
//        self.withR = YES;
//        
//        color1 = [UIColor blackColor];
//        color2 = [UIColor colorWithHexString:@"#211e1e"];
//        color3 = [UIColor colorWithHexString:@"#eb1928"];
//        color4 = [UIColor whiteColor];
//        
//        path1 = [UIBezierPath bezierPathWithSVGString:@"M 1186.0449,44.83399 C 1186.0449,50.38087 1182.0947,54.11134 1177.4365,54.11134 L 1177.4365,54.08204 C 1172.6562,54.11134 1168.7988,50.38087 1168.7988,44.83399 C 1168.7988,39.292 1172.6562,35.59083 1177.4365,35.59083 C 1182.0947,35.59083 1186.0449,39.292 1186.0449,44.83399 M 1189.5215,44.83399 C 1189.5215,37.2168 1183.8086,32.78322 1177.4365,32.78322 C 1171.0254,32.78322 1165.3223,37.2168 1165.3223,44.83399 C 1165.3223,52.45607 1171.0254,56.88478 1177.4365,56.88478 C 1183.8086,56.88478 1189.5215,52.45607 1189.5215,44.83399 M 1175.4297,45.84962 L 1176.7334,45.84962 L 1179.7314,51.3086 L 1183.0176,51.3086 L 1179.7021,45.63478 C 1181.4209,45.50294 1182.8223,44.64357 1182.8223,42.25099 C 1182.8223,39.292 1180.8496,38.33009 1177.5,38.33009 L 1172.6562,38.33009 L 1172.6562,51.3086 L 1175.4297,51.3086 L 1175.4297,45.84962 z M 1175.4297,43.65235 L 1175.4297,40.52735 L 1177.3682,40.52735 C 1178.4277,40.52735 1179.8584,40.625 1179.8584,41.9629 C 1179.8584,43.39844 1179.1211,43.65235 1177.8809,43.65235 L 1175.4297,43.65235 z"];
//        path2 = [UIBezierPath bezierPathWithSVGString:@"M 998.65234,288.31544 L 0,288.31544 L 11.20117,258.59375 C 22.27539,229.20899 81.68457,71.74805 87.31445,58.96974 C 93.93555,43.11037 104.80957,26.98732 118.35449,17.17287 C 136.76269,4.38478 157.06054,-0.17577 177.93945,0.01954 L 180.63477,0 L 1175.3906,0 L 1164.0332,29.79982 C 1143.208,84.4336 1092.4121,217.6172 1087.1045,230.82033 C 1079.0186,251.40138 1067.1191,263.59375 1053.8379,272.74903 C 1042.0068,280.67384 1024.6728,288.31544 998.65234,288.31544"];
//        path3 = [UIBezierPath bezierPathWithSVGString:@"M 1159.5508,10.91798 L 1153.8379,25.91309 C 1133.0322,80.49805 1082.2754,213.59375 1076.9678,226.792 C 1069.7998,245.0293 1059.5019,255.58594 1047.7051,263.72072 C 1037.4805,270.5713 1022.2949,277.40724 998.65234,277.40724 L 15.7666,277.40724 L 21.40625,262.4463 C 32.45117,233.13478 91.67969,76.1084 97.29004,63.36427 C 103.41797,48.63282 113.19824,34.375 124.6582,26.06934 C 140.81543,14.85353 158.70605,10.7422 177.86133,10.92774 L 180.65918,10.91798 L 1159.5508,10.91798 z"];
//        path4 = [UIBezierPath bezierPathWithSVGString:@"M 1107.0996,24.4336 C 1086.8848,80.7129 1040.7861,209.07228 1035.8838,222.00684 C 1030.1562,237.5 1022.3145,245.98634 1013.0566,252.76368 C 1005.4443,258.16895 993.91113,263.88673 974.76563,263.88673 L 68.15918,263.88673 C 80.83496,228.16895 133.19824,80.8252 138.2959,68.51563 C 143.53028,55.07325 151.47949,43.20313 159.70703,36.875 C 172.07032,27.75392 185.78125,24.28712 201.57227,24.44825 L 204.3457,24.4336 L 1107.0996,24.4336 z"];
//
//        _barTitle = [[UILabel alloc] init];
//        _barTitle.textColor = [UIColor blackColor];
//        _barTitle.text = @"CandybaR";
//        _barTitle.textAlignment = NSTextAlignmentCenter;
//        _barTitle.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//        _barTitle.adjustsFontSizeToFitWidth = YES;
//        _barTitle.minimumScaleFactor = 0.1;
//        _barTitle.textColor = [UIColor colorWithHexString:@"#234aa3"];
//        _barTitle.font = [UIFont fontWithName:@"SnickersNormal" size:100];
//        [self addSubview:_barTitle];
//       
//    }
//    return self;
//}

//-(void)layoutSubviews {
//    self.backgroundColor = [UIColor clearColor];
//    
//    scaleX = self.frame.size.width / 1207;
//    scaleY = self.frame.size.height / 306;
//    [path1 applyTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
//    [path2 applyTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
//    [path3 applyTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
//    [path4 applyTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
//    _barTitle.frame = CGRectMake(self.frame.size.width*0.1, 0, self.frame.size.width*0.77, self.frame.size.height*0.95);
//    _barTitle.font = [UIFont fontWithName:@"SnickersNormal" size:self.frame.size.height];
//    
//}

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        path1 = [UIBezierPath bezierPathWithSVGString:@"M 1186.0449,44.83399 C 1186.0449,50.38087 1182.0947,54.11134 1177.4365,54.11134 L 1177.4365,54.08204 C 1172.6562,54.11134 1168.7988,50.38087 1168.7988,44.83399 C 1168.7988,39.292 1172.6562,35.59083 1177.4365,35.59083 C 1182.0947,35.59083 1186.0449,39.292 1186.0449,44.83399 M 1189.5215,44.83399 C 1189.5215,37.2168 1183.8086,32.78322 1177.4365,32.78322 C 1171.0254,32.78322 1165.3223,37.2168 1165.3223,44.83399 C 1165.3223,52.45607 1171.0254,56.88478 1177.4365,56.88478 C 1183.8086,56.88478 1189.5215,52.45607 1189.5215,44.83399 M 1175.4297,45.84962 L 1176.7334,45.84962 L 1179.7314,51.3086 L 1183.0176,51.3086 L 1179.7021,45.63478 C 1181.4209,45.50294 1182.8223,44.64357 1182.8223,42.25099 C 1182.8223,39.292 1180.8496,38.33009 1177.5,38.33009 L 1172.6562,38.33009 L 1172.6562,51.3086 L 1175.4297,51.3086 L 1175.4297,45.84962 z M 1175.4297,43.65235 L 1175.4297,40.52735 L 1177.3682,40.52735 C 1178.4277,40.52735 1179.8584,40.625 1179.8584,41.9629 C 1179.8584,43.39844 1179.1211,43.65235 1177.8809,43.65235 L 1175.4297,43.65235 z"];
        path2 = [UIBezierPath bezierPathWithSVGString:@"M 998.65234,288.31544 L 0,288.31544 L 11.20117,258.59375 C 22.27539,229.20899 81.68457,71.74805 87.31445,58.96974 C 93.93555,43.11037 104.80957,26.98732 118.35449,17.17287 C 136.76269,4.38478 157.06054,-0.17577 177.93945,0.01954 L 180.63477,0 L 1175.3906,0 L 1164.0332,29.79982 C 1143.208,84.4336 1092.4121,217.6172 1087.1045,230.82033 C 1079.0186,251.40138 1067.1191,263.59375 1053.8379,272.74903 C 1042.0068,280.67384 1024.6728,288.31544 998.65234,288.31544"];
        path3 = [UIBezierPath bezierPathWithSVGString:@"M 1159.5508,10.91798 L 1153.8379,25.91309 C 1133.0322,80.49805 1082.2754,213.59375 1076.9678,226.792 C 1069.7998,245.0293 1059.5019,255.58594 1047.7051,263.72072 C 1037.4805,270.5713 1022.2949,277.40724 998.65234,277.40724 L 15.7666,277.40724 L 21.40625,262.4463 C 32.45117,233.13478 91.67969,76.1084 97.29004,63.36427 C 103.41797,48.63282 113.19824,34.375 124.6582,26.06934 C 140.81543,14.85353 158.70605,10.7422 177.86133,10.92774 L 180.65918,10.91798 L 1159.5508,10.91798 z"];
        path4 = [UIBezierPath bezierPathWithSVGString:@"M 1107.0996,24.4336 C 1086.8848,80.7129 1040.7861,209.07228 1035.8838,222.00684 C 1030.1562,237.5 1022.3145,245.98634 1013.0566,252.76368 C 1005.4443,258.16895 993.91113,263.88673 974.76563,263.88673 L 68.15918,263.88673 C 80.83496,228.16895 133.19824,80.8252 138.2959,68.51563 C 143.53028,55.07325 151.47949,43.20313 159.70703,36.875 C 172.07032,27.75392 185.78125,24.28712 201.57227,24.44825 L 204.3457,24.4336 L 1107.0996,24.4336 z"];

        self.minimum = 0;
        self.maximum = 1.0;
        self.current = 0.5;

        scaleX = frame.size.width / 1207;
        scaleY = frame.size.height / 306;
        [path1 applyTransform:CGAffineTransformMakeScale(scaleX, scaleX)];
        [path2 applyTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
        [path3 applyTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
        [path4 applyTransform:CGAffineTransformMakeScale(scaleX, scaleY)];

        [self computeProgressPath];
        
        color1 = [UIColor blackColor];
        color2 = [UIColor colorWithHexString:@"#211e1e"];
        color3 = [UIColor colorWithHexString:@"#eb1928"];
        color4 = [UIColor whiteColor];
        
        self.progressColor = [UIColor colorWithHexString:@"#FEDCBA"];
        
        self.backgroundColor = [UIColor clearColor];

        _barTitle = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width*0.1, 0, frame.size.width*0.77, frame.size.height*0.95)];
        _barTitle.textColor = [UIColor blackColor];
        _barTitle.text = @"CandybaR";
        _barTitle.textAlignment = NSTextAlignmentCenter;
        _barTitle.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _barTitle.adjustsFontSizeToFitWidth = YES;
        _barTitle.minimumScaleFactor = 0.1;
        _barTitle.textColor = [UIColor colorWithHexString:@"#234aa3"];
        _barTitle.font = [UIFont fontWithName:@"SnickersNormal" size:frame.size.height];
        [self addSubview:_barTitle];
    }
    
    return self;
}

-(void)computeProgressPath {
    
    float x_MaxDistance = 974.76563 - 204.3457;
    float percentage = self.current / (self.maximum - self.minimum);
    float x_PercentageDistance = x_MaxDistance * percentage;
    float x_Start = 201.57227;
    float x_End = x_Start + x_PercentageDistance;
    
    NSString* pathString;
    if (percentage <=0) {
        pathString = @"";
    } else if (percentage >=1) {
        pathString = @"M 1107.0996,24.4336 C 1086.8848,80.7129 1040.7861,209.07228 1035.8838,222.00684 C 1030.1562,237.5 1022.3145,245.98634 1013.0566,252.76368 C 1005.4443,258.16895 993.91113,263.88673 974.76563,263.88673 L 68.15918,263.88673 C 80.83496,228.16895 133.19824,80.8252 138.2959,68.51563 C 143.53028,55.07325 151.47949,43.20313 159.70703,36.875 C 172.07032,27.75392 185.78125,24.28712 201.57227,24.44825 L 204.3457,24.4336 L 1107.0996,24.4336 z";
    } else {
        pathString = [NSString stringWithFormat:@"M 68.15918,263.88673 C 80.83496,228.16895 133.19824,80.8252 138.2959,68.51563 C 143.53028,55.07325 151.47949,43.20313 159.70703,36.875 C 172.07032,27.75392 185.78125,24.28712 201.57227,24.44825 L %f,24.44825 L %f,263.88673 L 68.15918,263.88673 z", x_End, x_End];
        
    }
    
    progressPath = [UIBezierPath bezierPathWithSVGString:pathString];
    [progressPath applyTransform:CGAffineTransformMakeScale(scaleX, scaleY)];

}

-(id)initWithFrame:(CGRect)frame andTitle:(NSString*) title {
    if ([self initWithFrame:frame]) {
        _barTitle.text = title;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [color1 setFill];
    [path1 setLineWidth:0];
    if (self.withR) {
        [path1 fill];
    }
    [color2 setFill];
    [path2 setLineWidth:0];
    [path2 fill];
    [color3 setFill];
    [path3 setLineWidth:0];
    [path3 fill];
    [color4 setFill];
    [path4 setLineWidth:0];
    [path4 fill];

    [self.progressColor setFill];
    [progressPath setLineWidth:0];
    [progressPath fill];

}

@end
