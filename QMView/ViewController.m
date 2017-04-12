//
//  ViewController.m
//  QMView
//
//  Created by mac on 17/3/31.
//  Copyright © 2017年 Qinmin. All rights reserved.
//

#import "ViewController.h"
#import "QMView.h"
#import "NSTimer+QM.h"

@interface ViewController () <NSURLConnectionDelegate>
@property (nonatomic, assign) CGFloat startY;
@property (nonatomic, weak) QMView *qmView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QMView *view = [[QMView alloc] initWithFrame:CGRectMake(50, 100, 300, 400)];
    [self.view addSubview:view];
    _qmView = view;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _startY = [[touches anyObject] locationInView:self.view].y;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGFloat y = [[touches anyObject] locationInView:self.view].y;
    CGFloat delta = _startY - y;
    
    [_qmView setOffset:delta];
}

@end
