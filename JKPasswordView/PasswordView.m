//
//  PasswordView.m
//  JKPasswordView
//
//  Created by itang on 2020/4/4.
//  Copyright © 2020 learn. All rights reserved.
//

#import "PasswordView.h"

#define Color_RGB(a,b,c,d) [UIColor colorWithRed:(a)/255.0 green:(b)/255.0 blue:(c)/255.0 alpha:(d)]
#define LineGrayColor  Color_RGB(210,210,210,1)//分割线 灰
#define BlackColor [UIColor blackColor]

@interface PasswordView ()

@property (nonatomic) CGFloat squareWidth;//密码框的大小
@property (nonatomic) CGFloat squareHeight;//密码框的大小

@property (nonatomic,strong) NSMutableString *textStore;

@end

@implementation PasswordView

static NSString  * const MONEYNUMBERS = @"0123456789";



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.passWordNum = 6;
        self.pointRadius = 6;
        self.textStore = [NSMutableString string];
        self.rectColor = LineGrayColor;
        self.pointColor = BlackColor;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return  self;
}


/**
 * 设置密码框边长
 */
-(void)setSquareWidth:(CGFloat)squareWidth
{
    _squareWidth = squareWidth;
    [self setNeedsDisplay];
}

/**
 * 设置键盘类型
 */

-(UIKeyboardType)keyboardType
{
    return UIKeyboardTypeNumberPad;
}

/**
 *  设置密码位数
 *
 */

-(void)setPassWordNum:(NSInteger)passWordNum
{
    _passWordNum = passWordNum;
    [self setNeedsDisplay];
}

-(BOOL)becomeFirstResponder
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    if ([self.delegate respondsToSelector:@selector(passWordBeginInput:)]) {
        [self.delegate passWordBeginInput:self];
    }
    
    return [super becomeFirstResponder];
}

/**
 *  是否成为第一响应者
 *
 */
-(BOOL)canBecomeFirstResponder
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [self setNeedsDisplay];
    return YES;
}

- (BOOL)canResignFirstResponder {
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    return YES;
}
- (BOOL)resignFirstResponder {
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [super resignFirstResponder];
    [self setNeedsDisplay];

    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

#pragma mark - UIKeyInput
/**
 * 用于显示的文本对象是否有任何文本
 */
-(BOOL)hasText
{
    return self.textStore.length > 0;
}

/**
 *插入文本
 */
-(void)insertText:(NSString *)text
{
    if (self.textStore.length < self.passWordNum) {
        
        //判断是否有数字
        NSCharacterSet *character = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBERS] invertedSet];
        
        NSString *filter = [[text componentsSeparatedByCharactersInSet:character] componentsJoinedByString:@""];

        BOOL basicTest = [text isEqualToString:filter];
        if (basicTest) {
            [self.textStore appendString:text];
            if ([self.delegate respondsToSelector:@selector(passWordDidChange:)]) {
                [self.delegate passWordDidChange:self];
            }
            
            if (self.textStore.length == self.passWordNum) {
                if ([self.delegate respondsToSelector:@selector(passWordCompleteInput:)]) {
                    [self.delegate passWordCompleteInput:self];
                }
            }
            [self setNeedsDisplay];
            
        }
        
    }
}

//删除文本
-(void)deleteBackward
{
    if (self.textStore.length > 0) {
        [self.textStore deleteCharactersInRange:NSMakeRange(self.textStore.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(passWordDidChange:)]) {
            [self.delegate passWordDidChange:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(deleteWhenEmpty:)]) {
            [self.delegate deleteWhenEmpty:self];
        }
    }
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    self.squareWidth = rect.size.width/6.0;
    self.squareHeight = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    //画外框
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, self.rectColor.CGColor);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, self.rectColor.CGColor);
    //画竖条
    for (int i = 1; i < self.passWordNum; i ++) {
        CGContextMoveToPoint(context, x + self.squareWidth * i, y);
        CGContextAddLineToPoint(context, x + self.squareWidth * i, y + self.squareWidth);
        CGContextClosePath(context);
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    CGContextSetFillColorWithColor(context, self.pointColor.CGColor);
    
    //画黑点
    for (int i = 1; i <= self.textStore.length; i++) {
        CGContextAddArc(context, x + self.squareWidth * i - self.squareWidth/2.0, y + self.squareWidth/2.0, self.pointRadius, 0, M_PI * 2, YES);
        CGContextDrawPath(context, kCGPathFill);
    }
    
    // 画高亮焦点
    if (!self.isFirstResponder) {
        return;
    }
    
    NSUInteger num = self.textStore.length;
    if (num >= self.passWordNum) {
        return;
    }
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGRect hightlightRect = CGRectMake(num * _squareWidth + x + 0.5, y + 0.5, _squareWidth - 1, _squareHeight - 1);
    CGContextAddRect(context, hightlightRect);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
