//
//  FaceDetection.h
//  majikichishatter
//
//  Created by Kazuki Taniguchi on 2013/12/26.
//  Copyright (c) 2013年 Kazuki Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceDetection : NSObject

- (cv::Mat)cvMatFromUIImage:(UIImage *)image;

@end
