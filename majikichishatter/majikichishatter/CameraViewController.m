//
//  CameraViewController.m
//  majikichishatter
//
//  Created by 浅野 友希 on 2013/12/26.
//  Copyright (c) 2013年 Kazuki Taniguchi. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FaceDetection.h"

@interface CameraViewController ()

@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) UIView *previewView;

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // 撮影ボタンを配置したツールバーを生成
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    UIBarButtonItem *takePhotoButton = [[UIBarButtonItem alloc] initWithTitle:@"撮影"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(takePhoto:)];
    toolbar.items = @[takePhotoButton];
    [self.view addSubview:toolbar];
    NSLog(@"hoge");
    // プレビュー用のビューを生成
    self.previewView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                toolbar.frame.size.height,
                                                                self.view.bounds.size.width,
                                                                self.view.bounds.size.height - toolbar.frame.size.height)];
    [self.view addSubview:self.previewView];
    
    // 撮影開始
    [self setupAVCapture];
}

- (void)setupAVCapture
{
    NSError *error = nil;
    
    // 入力と出力からキャプチャーセッションを作成
    self.session = [[AVCaptureSession alloc] init];
    
    // 正面に配置されているカメラを取得
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // カメラからの入力を作成し、セッションに追加
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
    [self.session addInput:self.videoInput];
    
    // 画像への出力を作成し、セッションに追加
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.session addOutput:self.stillImageOutput];
    
    // キャプチャーセッションから入力のプレビュー表示を作成
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.frame = self.view.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // レイヤーをViewに設定
    CALayer *previewLayer = self.previewView.layer;
    previewLayer.masksToBounds = YES;
    [previewLayer addSublayer:captureVideoPreviewLayer];
    
    // セッション開始
    [self.session startRunning];
}

- (void)takePhoto:(id)sender
{
    __block NSInteger count = 0;
    int setting_count = 0;
    NSLog(@"takePhoto");
    // ビデオ入力のAVCaptureConnectionを取得
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (videoConnection == nil) {
        return;
    }
    
    // ビデオ入力から画像を非同期で取得。ブロックで定義されている処理が呼び出され、画像データを引数から取得する
    [self.stillImageOutput
     captureStillImageAsynchronouslyFromConnection:videoConnection
     completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         if (imageDataSampleBuffer == NULL) {
             return;
         }
         
         // 入力された画像データからJPEGフォーマットとしてデータを取得
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         
         // JPEGデータからUIImageを作成
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         //FaceDetectionにUIImageを送る
         //getFacesNumber関数に送る
         FaceDetection *fd = [[FaceDetection alloc] init];
         count = [fd getFacesNumber:image];
         NSLog(@"hoge");
         if (count == setting_count){
             //音声
             NSLog(@"onse");
             //画像取得
             
             // アルバムに画像を保存
             UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
         }
         // アルバムに画像を保存
         UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
         [NSThread sleepForTimeInterval:1.0f];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
