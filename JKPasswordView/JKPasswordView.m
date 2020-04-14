//
//  JKPasswordView.m
//  JKPasswordView
//
//  Created by void on 2020/4/14.
//  Copyright © 2020 learn. All rights reserved.
//

#import "JKPasswordView.h"

@interface JKPasswordView ()

@property (nonatomic) CGFloat cellWidth; // 单元格的宽度
@property (nonatomic) CGFloat cellHeight; // 单元格的高度

@property (nonatomic,strong) NSMutableString *password;

@end

@implementation JKPasswordView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _password = [NSMutableString string];
        [self setDefaultValues];
    }
    
    return  self;
}

- (void)setDefaultValues {
    self.backgroundColor = [UIColor whiteColor];
    _passwordLength = 6;
    _lineColor = [UIColor lightGrayColor];
    _passwordPointRadius = 6;
    _passwordPointColor = [UIColor blackColor];
    _highlight = YES;
    _highlightColor = [UIColor greenColor];
}

/**
 * 设置键盘类型
 */

-(UIKeyboardType)keyboardType
{
    return UIKeyboardTypeNumberPad;
}

-(BOOL)becomeFirstResponder
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    
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
    return self.password.length > 0;
}

/**
 *插入文本
 */
static NSString  * const MONEYNUMBERS = @"0123456789";
-(void)insertText:(NSString *)text
{
    if (self.password.length < self.passwordLength) {
        
        //判断是否有数字
        NSCharacterSet *character = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBERS] invertedSet];
        
        NSString *filter = [[text componentsSeparatedByCharactersInSet:character] componentsJoinedByString:@""];

        BOOL basicTest = [text isEqualToString:filter];
        if (basicTest) {
            [self.password appendString:text];
            
            BOOL complete = (self.password.length == self.passwordLength);
            !_pwdDidChangeHandler ? : _pwdDidChangeHandler(complete, _password);
            
            [self setNeedsDisplay];
        }
        
    }
}

//删除文本
-(void)deleteBackward
{
    if (_password.length > 0) {
        [_password deleteCharactersInRange:NSMakeRange(_password.length - 1, 1)];
        !_pwdDidChangeHandler ? : _pwdDidChangeHandler(NO, _password);
    } else {
        !_emptyDeleteHandler ? : _emptyDeleteHandler(self);
    }
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    _cellWidth = rect.size.width / _passwordLength;
    _cellHeight = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    //画外框
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    //画竖条
    for (int i = 1; i < _passwordLength; i ++) {
        CGContextMoveToPoint(context, x + _cellWidth * i, y);
        CGContextAddLineToPoint(context, x + _cellWidth * i, y + _cellHeight);
        CGContextClosePath(context);
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    CGContextSetFillColorWithColor(context, _passwordPointColor.CGColor);
    
    //画黑点
    for (int i = 1; i <= _password.length; i++) {
        CGContextAddArc(context, x + _cellWidth * i - _cellWidth/2.0, y + _cellHeight/2.0, _passwordPointRadius, 0, M_PI * 2, YES);
        CGContextDrawPath(context, kCGPathFill);
    }
    
    // 画高亮焦点
    if (!self.isFirstResponder || _highlight == NO) {
        return;
    }
    
    NSUInteger num = _password.length;
    if (num >= _passwordLength) {
        return;
    }
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGRect hightlightRect = CGRectMake(num * _cellWidth + x + 0.5, y + 0.5, _cellWidth - 1, _cellHeight - 1);
    CGContextAddRect(context, hightlightRect);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
