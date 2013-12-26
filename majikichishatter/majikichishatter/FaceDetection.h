//
//  FaceDetection.h
//  majikichishatter
//
//  Created by Kazuki Taniguchi on 2013/12/26.
//  Copyright (c) 2013年 Kazuki Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

@interface FaceDetection : NSObject

- (NSInteger)getFacesNumber:(UIImage*)image;
- (IplImage*)IplImageFromUIImage:(UIImage*)image;
- (UIImage*)UIImageFromIplImage:(IplImage*)image;

@end
