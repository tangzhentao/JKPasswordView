//
//  JKPasswordView.h
//  JKPasswordView
//
//  Created by void on 2020/4/14.
//  Copyright © 2020 learn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JKPasswordView;

typedef void(^PasswordDidChangeHandler)(BOOL complete, NSString *password);
typedef void(^EmptyDeleteHandler)(JKPasswordView *pwdView); // 密码为空时，点击删除键

@interface JKPasswordView : UIView<UIKeyInput>

@property (strong, nonatomic) PasswordDidChangeHandler pwdDidChangeHandler;
@property (strong, nonatomic) EmptyDeleteHandler emptyDeleteHandler;

@property (nonatomic) NSUInteger passwordLength; // 密码长度，默认是6位
@property (nonatomic) UIColor *lineColor; // 边框颜色

@property (nonatomic) CGFloat passwordPointRadius; // 密码点半径，默认是6
@property (nonatomic) UIColor *passwordPointColor; // 密码点颜色，默认是黑色

@property (assign, nonatomic) BOOL highlight; // 是否高亮当前输入框, 默认是Yes
@property (nonatomic) UIColor *highlightColor; // 高亮颜色，默认是绿色

@end

NS_ASSUME_NONNULL_END
