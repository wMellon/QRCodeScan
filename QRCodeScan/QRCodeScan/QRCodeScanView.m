//
//  ScanCodeView.m
//  HealthyCity
//
//  Created by zoenet on 2017/3/7.
//  Copyright © 2017年 智业互联网络科技有限公司 艾嘉健康. All rights reserved.
//

#import "QRCodeScanView.h"
#import "ZBarReaderView.h"
#import "UIView+Convenience.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height//获取屏幕高度，兼容性测试
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度，兼容性测试

@interface QRCodeScanView()

@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL end;//动画是否结束

@end

@implementation QRCodeScanView

-(id)init{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if(self){
        [self addSubview:self.readerView];
        [self addSubview:self.bgView];
        [self addSubview:self.lineView];
        [self addSubview:self.label];
    }
    return self;
}

-(UIImageView *)bgView{
    if(!_bgView){
        _bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *bgImage = [[UIImage imageNamed:@"Scan_Background"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        UIImage *border = [UIImage imageNamed:@"Scan_Border"];
        //中间塞东西
        UIGraphicsBeginImageContext(self.bounds.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [bgImage drawInRect:self.bounds];
        CGContextClearRect(context, [self scanRect]);
        [border drawInRect:[self scanRect]];
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _bgView.image = theImage;
    }
    return _bgView;
}

-(UIImageView*)lineView{
    if(!_lineView){
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake([self scanRect].origin.x, [self scanRect].origin.y, [self scanRect].size.width, LineViewHeight)];
        _lineView.image = [[UIImage imageNamed:@"Scan_Line"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    }
    return _lineView;
}

-(UILabel*)label{
    if(!_label){
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([self scanRect]) + 20, self.frameWidth, 14)];
        _label.font = [UIFont systemFontOfSize:14];
        _label.text = @"将二维码放入扫描框内，即可自动扫描";
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

-(ZBarReaderView*)readerView{
    if(!_readerView){
        _readerView = [[ZBarReaderView alloc] init];
        _readerView.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
        _readerView.layer.cornerRadius = 8.0f;
        _readerView.layer.borderWidth= 1.0f;
        _readerView.layer.borderColor = [[UIColor blueColor] CGColor];

        //关闭闪光灯
        _readerView.torchMode = 0;
        
        _readerView.allowsPinchZoom=NO;
    }
    return _readerView;
}

-(CGRect)scanRect{
    CGFloat width = self.frameWidth * 0.67;
    return CGRectMake((self.frameWidth - width) / 2, 0.16 * self.frameHeight, width, width);
}

-(void)animationStart{
    self.lineView.frameY = [self scanRect].origin.y;
    [UIView animateWithDuration:2.0 animations:^{
        self.lineView.frameY = CGRectGetMaxY([self scanRect]) - LineViewHeight;
    } completion:^(BOOL finished) {
        if(!self.end){
            [self animationStart];
        }
    }];
}

-(void)animationEnd{
    self.end = YES;
}
@end
