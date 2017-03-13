//
//  ScanCodeView.h
//  HealthyCity
//
//  Created by zoenet on 2017/3/7.
//  Copyright © 2017年 智业互联网络科技有限公司 艾嘉健康. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LineViewHeight 40

@class ZBarReaderView;

@interface QRCodeScanView : UIView

@property (nonatomic, strong) ZBarReaderView *readerView;

-(CGRect)scanRect;

/**
 开始动画
 */
-(void)animationStart;

/**
 结束动画
 */
-(void)animationEnd;
@end
