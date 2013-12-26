//
//  SettingViewController.m
//  majikichishatter
//
//  Created by 浅野 友希 on 2013/12/26.
//  Copyright (c) 2013年 Kazuki Taniguchi. All rights reserved.
//
#define SCREEN_BOUNDS   ([UIScreen mainScreen].bounds)

#import "SettingViewController.h"
#import "CameraViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0.600 green:0.157 blue:0.224 alpha:1.0];
        // Custom initialization
        UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15.0f];
        UIFont *centerFont = [UIFont fontWithName:@"HiraKakuProN-W3" size:24.0f];
        
        //上の文字
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor whiteColor];
        label.font = font;
        label.text = @"撮りたい人数を設定してください。";
        [label sizeToFit];
        label.frame = CGRectMake((SCREEN_BOUNDS.size.width-label.frame.size.width)/2, 56, label.frame.size.width, label.frame.size.height);
        [self.view addSubview: label];
        
        //三角
        UIImage *triangle = [UIImage imageNamed:@"point"];
        UIImageView *triangleImageView = [[UIImageView alloc]initWithImage: triangle];
        triangleImageView.frame = CGRectMake((SCREEN_BOUNDS.size.width - 25)/2, 85, 25, 21);
        [self.view addSubview: triangleImageView];
        
        //ルーレット
        UIImage *roulette = [UIImage imageNamed:@"roulette"];
        UIImageView *rouletteImageView = [[UIImageView alloc]initWithImage: roulette];
        rouletteImageView.frame = CGRectMake((SCREEN_BOUNDS.size.width - 250)/2, 117, 250, 250);
        [self.view addSubview: rouletteImageView];
        //rouletteImageView.layer.transform = CGAffineTransformMakeRotation(1.5);
        
        //真ん中のラベル
        UILabel *centerLabel = [[UILabel alloc]init];
        centerLabel.textColor = [UIColor whiteColor];
        centerLabel.font = centerFont;
        centerLabel.text = @"1";
        [centerLabel sizeToFit];
        centerLabel.frame = CGRectMake((SCREEN_BOUNDS.size.width- centerLabel.frame.size.width)/2, 230, centerLabel.frame.size.width, centerLabel.frame.size.height);
        [self.view addSubview: centerLabel];

        UIImageView *button = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button"]];
        button.frame = CGRectMake((SCREEN_BOUNDS.size.width - 90)/2, 450, 90, 38);
        [self.view addSubview: button];
        button.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [button addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapped:(UITapGestureRecognizer *)sender {
    CameraViewController *cs = [[CameraViewController alloc]init];
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    rootViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:cs animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
