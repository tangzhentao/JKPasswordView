//
//  PasswordVC.m
//  JKPasswordView
//
//  Created by void on 2020/4/14.
//  Copyright © 2020 learn. All rights reserved.
//

#import "PasswordVC.h"
#import "JKPasswordView.h"

@interface PasswordVC ()

@property (strong, nonatomic) JKPasswordView *pwdView1;
@property (strong, nonatomic) JKPasswordView *pwdView2;

@end

@implementation PasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createAndAddUI];
    [self constraintUI];
}

- (void)createAndAddUI {
    _pwdView1 = [JKPasswordView new];
    _pwdView2 = [JKPasswordView new];
    
    [self.view addSubview:_pwdView1];
    [self.view addSubview:_pwdView2];

    
    [_pwdView1 becomeFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    _pwdView1.pwdDidChangeHandler = ^(BOOL complete, NSString * _Nonnull password) {
        NSLog(@"输入密码：%@ %@", password, complete ? @"-- 完成" : @"");
        if (complete) {
            [weakSelf.pwdView2 becomeFirstResponder];
        }
    };
    
    _pwdView2.pwdDidChangeHandler = ^(BOOL complete, NSString * _Nonnull password) {
        NSLog(@"确认密码：%@ %@", password, complete ? @"-- 完成" : @"");
    };
    _pwdView2.emptyDeleteHandler = ^(JKPasswordView * _Nonnull pwdView) {
        [weakSelf.pwdView1 becomeFirstResponder];
    };
}
- (void)constraintUI {
    
    _pwdView1.translatesAutoresizingMaskIntoConstraints = NO;
    _pwdView2.translatesAutoresizingMaskIntoConstraints = NO;

    
    NSLayoutConstraint *left1 = [NSLayoutConstraint constraintWithItem:_pwdView1 attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeLeft) multiplier:1 constant:20];
    NSLayoutConstraint *right1 = [NSLayoutConstraint constraintWithItem:_pwdView1 attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeRight) multiplier:1 constant:-20];
    
    NSLayoutConstraint *centY = [NSLayoutConstraint constraintWithItem:_pwdView1 attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeCenterY) multiplier:1 constant:-100];
    
    NSLayoutConstraint *height1 = [NSLayoutConstraint constraintWithItem:_pwdView1 attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:60];
    
    [self.view addConstraints:@[left1, right1, centY, height1]];
    
    NSLayoutConstraint *left2 = [NSLayoutConstraint constraintWithItem:_pwdView2 attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeLeft) multiplier:1 constant:20];
    NSLayoutConstraint *right2 = [NSLayoutConstraint constraintWithItem:_pwdView2 attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeRight) multiplier:1 constant:-20];
    
    NSLayoutConstraint *top2 = [NSLayoutConstraint constraintWithItem:_pwdView2 attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:_pwdView1 attribute:(NSLayoutAttributeBottom) multiplier:1 constant:40];
    
    NSLayoutConstraint *height2 = [NSLayoutConstraint constraintWithItem:_pwdView2 attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:60];
    
    [self.view addConstraints:@[left2, right2, centY, height2, top2]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark - PasswordViewDelegate
//-(void)passWordDidChange:(PasswordView *)password {
//    if (password == _pwdView1) {
//        NSLog(@"密码1：%@", password.textStore);
//    } else {
//        NSLog(@"密码2：%@", password.textStore);
//    }
//
//}
//
//-(void)passWordCompleteInput:(PasswordView *)password{
//    if (password == _pwdView1) {
//        [_pwdView2 becomeFirstResponder];
//        NSLog(@"密码1：%@", password.textStore);
//    } else {
//        NSLog(@"密码2：%@", password.textStore);
//    }
//}
//
//-(void)passWordBeginInput:(PasswordView *)password {
//
//}
//
//-(void)deleteWhenEmpty:(PasswordView *)password {
//    if (password == _pwdView2) {
//        NSLog(@"密码2清空后，仍然删除");
//        [_pwdView1 becomeFirstResponder];
//    } else {
//        NSLog(@"密码1清空后，仍然删除");
//    }
//}

@end
