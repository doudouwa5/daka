//
//  ViewController.m
//  daka
//
//  Created by 韩豆豆 on 2018/10/13.
//  Copyright © 2017年 韩豆豆. All rights reserved.
//

#import "ViewController.h"
#import "HDDTextFiled.h"
#import <SDWebImage/SDWebImage.h>
#import "HDDNetworkClient.h"

@interface ViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)HDDTextFiled *textF;
@property(nonatomic,strong)UILabel *label1;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    // Do any additional setup after loading the view, typically from a nib.
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 120)];
    label.text = @"重启会失效，有些操作也可能导致位置还原，具体操作现在还不清楚，一般不出意外能坚持两天以上吧。\n\n失效后只能在xcode上重新编译";
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    
    _textF = [[HDDTextFiled alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(label.frame)+50, [UIScreen mainScreen].bounds.size.width -80, 50)];
    _textF.delegate = self;
    _textF.placeholder = @"下班滚犊子";
    _textF.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:_textF];
    
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(40, CGRectGetMaxY(_textF.frame)+50, [UIScreen mainScreen].bounds.size.width -80, 50);
    [bt addTarget:self action:@selector(GoToBeMerchant) forControlEvents:UIControlEventTouchUpInside];
    [bt setBackgroundColor:[UIColor redColor]];
    [bt setTitle:@"返回BBL" forState:UIControlStateNormal];
    [self.view addSubview:bt];
    
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, CGRectGetMaxY(bt.frame)+50+120, 100, 30)];
    _label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label1];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, CGRectGetMaxY(bt.frame)+50, 100, 100)];
    image.backgroundColor = [UIColor yellowColor];
    [image sd_setImageWithURL:[NSURL URLWithString:@"https://imgbemerng.bangkokbank.com/cdn2local/op_upload/127/146785959971.jpg"] placeholderImage:nil options:SDWebImageRetryFailed context:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        NSLog(@"receivedSize:%ld  expectedSize:%ld",(long)receivedSize,(long)expectedSize);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // UI更新代码
            self->_label1.text = [NSString stringWithFormat:@"%f", ((CGFloat)receivedSize / expectedSize)];
        }];
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];

    [self.view addSubview:image];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfoFromBeMerchant:) name:@"getInfoFromBeMerchant" object:nil];
    
    
    HDDNetworkClient *client = [HDDNetworkClient HTTPSessionManagerWithAPIType:HDDSERVICE_DEFAULT];
    [client GET:@"test.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
    
    

    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing-Vc");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textF resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textF resignFirstResponder];

    return YES;
}

-(void)getInfoFromBeMerchant:(NSNotification *)notif{
    NSLog(@"%@",notif.object);
    _textF.text = [NSString stringWithFormat:@"%@",notif.object];
}

-(void) GoToBeMerchant{
#warning 跳转BBL
    NSURL *url  = [NSURL URLWithString:@"BeMerchantFromMBanking://partner.BeMerchantAuthen?status=success"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {

    }];
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
