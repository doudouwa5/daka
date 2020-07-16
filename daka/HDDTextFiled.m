//
//  HDDTextFiled.m
//  daka
//
//  Created by 韩豆豆 on 2018/10/13.
//  Copyright © 2017年 韩豆豆. All rights reserved.
//

#import "HDDTextFiled.h"

@interface  HDDTextFiled()<UITextFieldDelegate>

@end
@implementation HDDTextFiled
-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.delegate =self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];

    }
    
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)textFieldTextDidBeginEditing:(NSNotification *)notifi{
    NSLog(@"UITextFieldTextDidBeginEditingNotification");
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing-View");

}
@end
