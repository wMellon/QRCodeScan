//
//  ScanCodeViewController.m
//  ShortCakeSFPatient
//
//  Created by xxb on 15/10/19.
//  Copyright (c) 2015年 zysoft. All rights reserved.
//

@import AVFoundation;
@import AssetsLibrary;
#import "QRCodeScanViewController.h"
#import "QRCodeScanView.h"

#define RGB(r,g,b) RGBA(r,g,b,1.0f)

@interface QRCodeScanViewController ()

@property (strong, nonatomic) QRCodeScanView *scanCodeView;

@end

@implementation QRCodeScanViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self permissionIdentify];
    [self setupContentView];
    [self.scanCodeView animationStart];
}

-(void)setupContentView{
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = self.scanCodeView.readerView;
    }
    CGRect scanCrop = [self getScanCrop:[self.scanCodeView scanRect] readerViewBounds:self.scanCodeView.readerView.bounds];
    self.scanCodeView.readerView.scanCrop = scanCrop;
    self.scanCodeView.readerView.readerDelegate = self;
    self.view = self.scanCodeView;
    
    [self.scanCodeView.readerView start];
}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image{
    NSString *str;
    for (ZBarSymbol *symbol in symbols) {
        str=symbol.data;
        break;
    }
    [self.scanCodeView.readerView stop];
    [self.scanCodeView animationEnd];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"结果" message:@"扫描完成" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.scanCodeView.readerView start];
        [self.scanCodeView animationStart];
    }];
    [vc addAction:ok];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - action

-(void)permissionIdentify{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
    }else {
        // iOS 8 后，全部都要授权
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined:{
                // 许可对话没有出现，发起授权许可
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        //第一次用户接受
                    }else{
                        NSLog(@"没有相机权限或设备相机无法访问");
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized:{
                // 已经开启授权，可继续
                break;
            }
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                // 用户明确地拒绝授权，或者相机设备无法访问
                NSLog(@"没有相机权限或设备相机无法访问");
                break;
            default:
                break;
        }
        
    }
}

- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)rvBounds{
    CGFloat x,y,width,height;
    x = rect.origin.y / rvBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / rvBounds.size.width;
    width = (rect.origin.y + rect.size.height) / rvBounds.size.height;
    height = 1 - rect.origin.x / rvBounds.size.width;
    return CGRectMake(x, y, width, height);
}

#pragma mark - properties

-(QRCodeScanView *)scanCodeView{
    if(!_scanCodeView){
        _scanCodeView = [[QRCodeScanView alloc] init];
    }
    return _scanCodeView;
}

@end
