//
//  QMView.m
//  QMView
//
//  Created by mac on 17/3/31.
//  Copyright © 2017年 Qinmin. All rights reserved.
//

#import "QMView.h"
#import <GLKit/GLKit.h>

#define kDistanceZ  1000

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

GLKMatrix4 matrixFrom3DTransform(CATransform3D transform)
{
    GLKMatrix4 matrix = GLKMatrix4Make(transform.m11, transform.m12, transform.m13, transform.m14,
                                       transform.m21, transform.m22, transform.m23, transform.m24,
                                       transform.m31, transform.m32, transform.m33, transform.m34,
                                       transform.m41, transform.m42, transform.m43, transform.m44);
    
    return matrix;
}

GLKVector4 transform3DMultiplyVector4(CATransform3D transform, GLKVector4 vec4)
{
    GLKMatrix4 matrix = GLKMatrix4Make(transform.m11, transform.m12, transform.m13, transform.m14,
                                       transform.m21, transform.m22, transform.m23, transform.m24,
                                       transform.m31, transform.m32, transform.m33, transform.m34,
                                       transform.m41, transform.m42, transform.m43, transform.m44);

    GLKVector4 transVec4 = GLKMatrix4MultiplyVector4(matrix, vec4);
    return transVec4;
}

@interface QMView ()
{
    CGFloat _delta;
}
@property (nonatomic, assign) CGRect originFrame;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *bottomView;
@end

@implementation QMView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // [self setBackgroundColor:[UIColor greenColor]];
        _originFrame = frame;
        
        // 上部试图
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/2)];
        _topView.layer.anchorPoint = CGPointMake(0.5, 0.0);
        _topView.layer.position = CGPointMake(frame.size.width/2, 0);
        _topView.backgroundColor = [UIColor orangeColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        label.text = @"CALayer默认使用正交投影，因此没有远小近大效果，而且没有明确的API可以使用透视投影矩阵，但是我们可以通过矩阵连乘自己构造透视投影矩阵。CATransform3D的透视效果通过一个矩阵中一个很简单的元素来控制";
        label.numberOfLines = 0;
        [_topView addSubview:label];
    
        // 底部视图
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/2)];
        _bottomView.layer.anchorPoint = CGPointMake(0.5, 1.0);
        _bottomView.layer.position = CGPointMake(frame.size.width/2, frame.size.height);
        _bottomView.backgroundColor = [UIColor blueColor];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        label1.text = @"CALayer默认使用正交投影，因此没有远小近大效果，而且没有明确的API可以使用透视投影矩阵，但是我们可以通过矩阵连乘自己构造透视投影矩阵。CATransform3D的透视效果通过一个矩阵中一个很简单的元素来控制";
        label1.numberOfLines = 0;
        [_bottomView addSubview:label1];
        
        [self addSubview:_bottomView];
        [self addSubview:_topView];
    }
    
    return self;
}

//// 可行的代码
//- (void)setOffset:(CGFloat)offset
//{
//    if (offset < 0 || offset > _originFrame.size.height/2) {
//        return;
//    }
//
//    _offset = offset;
//    CGFloat thelta = M_PI/2*(_offset/(_originFrame.size.height/2));
//    CATransform3D transform = CATransform3DMakeRotation(-thelta, 1, 0, 0);
//    CATransform3D transform1 = CATransform3DMakeRotation(thelta, 1, 0, 0);
//
//    _topView.layer.transform = CATransform3DPerspect(transform, CGPointZero, kDistanceZ);
//    _bottomView.layer.transform = CATransform3DPerspect(transform1, CGPointZero, kDistanceZ);
//
//    //position.x = frame.origin.x + anchorPoint.x * bounds.size.width；
//    //position.y = frame.origin.y + anchorPoint.y * bounds.size.height；
//    CGFloat position = _topView.layer.frame.size.height + 1.0 * _bottomView.layer.frame.size.height;
//    _bottomView.layer.position = CGPointMake(_originFrame.size.width/2, position);
//
//    CGRect rect = self.frame;
//    rect.size.height = _topView.layer.frame.size.height + _bottomView.layer.frame.size.height;
//    self.frame = rect;
//}

//// 以修正frame的方式变换
//- (void)setOffset:(CGFloat)offset
//{
//    if (offset < 0 || offset > _originFrame.size.height/2) {
//        return;
//    }
//    
//    _offset = offset;
//    CGFloat thelta = M_PI/2*(_offset/(_originFrame.size.height/2));
//    CATransform3D transform = CATransform3DMakeRotation(-thelta, 1, 0, 0);
//    CATransform3D transform1 = CATransform3DMakeRotation(thelta, 1, 0, 0);
//    
//    _bottomView.frame = CGRectMake(0, 200, 300, 200);
//    
//    _topView.layer.transform = CATransform3DPerspect(transform, CGPointZero, kDistanceZ);
//    _bottomView.layer.transform = CATransform3DPerspect(transform1, CGPointZero, kDistanceZ);
//    
//    
//    CGRect rect = _bottomView.frame;
//    rect.origin.y = _topView.frame.size.height;
//    _bottomView.frame = rect;
//}

// GLKit变换
- (void)setOffset:(CGFloat)offset
{
    if (offset < 0 || offset > _originFrame.size.height/2) {
        return;
    }
   
    _offset = offset;
    CGFloat thelta = M_PI/2*(_offset/(_originFrame.size.height/2));
    CATransform3D transform = CATransform3DMakeRotation(-thelta, 1, 0, 0);
    CATransform3D transform1 = CATransform3DMakeRotation(thelta, 1, 0, 0);
    
    // 初始化高度 - 矩阵变换后的高度
    GLKVector4 top1 = transform3DMultiplyVector4(transform, GLKVector4Make(_originFrame.size.width/2, 0, 0, 1));
    GLKVector4 top2 =transform3DMultiplyVector4(transform, GLKVector4Make(_originFrame.size.width/2, _originFrame.size.height/2, 0, 1));
    
    GLKVector4 bottom1 = transform3DMultiplyVector4(transform1, GLKVector4Make(_originFrame.size.width/2, _originFrame.size.height/2, 0, 1));
    GLKVector4 bottom2 =transform3DMultiplyVector4(transform1, GLKVector4Make(_originFrame.size.width/2, _originFrame.size.height, 0, 1));
    
    _topView.layer.transform = CATransform3DPerspect(transform, CGPointZero, kDistanceZ);
    _bottomView.layer.transform = CATransform3DPerspect(transform1, CGPointZero, kDistanceZ);
    
    NSLog(@"1> %f %f", top2.y - top1.y, top1.y);
    NSLog(@"2> %f", _topView.layer.frame.size.height);
    NSLog(@"3> %f", bottom2.y - bottom1.y);
    
    //position.y = frame.origin.y + anchorPoint.y * bounds.size.height；
    CGFloat position = (top2.y - top1.y) + 1.0 * (bottom2.y - bottom1.y);
    _bottomView.layer.position = CGPointMake(_originFrame.size.width/2, position);
}


@end
