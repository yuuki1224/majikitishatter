//
//  FaceDetection.m
//  majikichishatter
//
//  Created by Kazuki Taniguchi on 2013/12/26.
//  Copyright (c) 2013年 Kazuki Taniguchi. All rights reserved.
//

#import "FaceDetection.h"

@implementation FaceDetection

// 撮影中の画像から顔の数を計算して返す
- (NSInteger)getFacesNumber:(UIImage*)image {

    NSLog(@"hoge");
    NSInteger numFaces = 0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_default" ofType:@"xml"];
    CvHaarClassifierCascade* cascade = (CvHaarClassifierCascade*)cvLoad([path cStringUsingEncoding:NSASCIIStringEncoding], 0, 0, 0);
    
    // グレースケール変換
    IplImage* iplImage = [self IplImageFromUIImage:image];
    
    CvSize smallSize = cvSize(image.size.width, image.size.height);
    
    CvMemStorage *storage = 0;
    IplImage *gray_image = cvCreateImage( smallSize, IPL_DEPTH_8U, 1 );
    
    storage = cvCreateMemStorage(0);
    cvClearMemStorage(storage);
    cvCvtColor(iplImage, gray_image, CV_BGR2GRAY);
    cvEqualizeHist(gray_image, gray_image);
    
    // 顔認識
    CvSeq *faces = cvHaarDetectObjects(gray_image, cascade, storage, 1.11, 4, 0, cvSize (40, 40));
    
    // 顔の数を取得
    if(faces != NULL && faces->total > 0) {
        numFaces = faces->total;
    }
    
    return numFaces;
}

// UIImage -> IplImage変換
- (IplImage*)IplImageFromUIImage:(UIImage*)image {
    
    CGImageRef imageRef = image.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    IplImage *iplimage = cvCreateImage(cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4 );
    
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage->imageData,
                                                    iplimage->width,
                                                    iplimage->height,
                                                    iplimage->depth,
                                                    iplimage->widthStep,
                                                    colorSpace,
                                                    kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef,
                       CGRectMake(0, 0, image.size.width, image.size.height),
                       imageRef);
    
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    cvReleaseImage(&iplimage);
    
    return ret;
}

// IplImage -> UIImage変換
- (UIImage*)UIImageFromIplImage:(IplImage*)image {
    
    CGColorSpaceRef colorSpace;
    if (image->nChannels == 1)
    {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        //BGRになっているのでRGBに変換
        cvCvtColor(image, image, CV_BGR2RGB);
    }
    NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(image->width,
                                        image->height,
                                        image->depth,
                                        image->depth * image->nChannels,
                                        image->widthStep,
                                        colorSpace,
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider,
                                        NULL,
                                        false,
                                        kCGRenderingIntentDefault
                                        );
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return ret;
}

@end
