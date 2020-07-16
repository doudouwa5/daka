//
//  HDDNetworkClient.m
//  daka
//
//  Created by HanDD on 2020/6/29.
//  Copyright © 2020 杨林贵. All rights reserved.
//

#import "HDDNetworkClient.h"

@implementation HDDNetworkClient


+ (instancetype)HTTPSessionManagerWithAPIType:(HDDSERVICETYPE)APIType {
    NSString *strBaseURL = @"";
    switch (APIType) {
        case HDDSERVICE_DEFAULT:
            strBaseURL = @"http://127.0.0.1/";
            break;
            
        default:
            strBaseURL = @"http://127.0.0.1/";
            break;
    }
    HDDNetworkClient *client = [[HDDNetworkClient alloc] initWithBaseURL:[NSURL URLWithString:strBaseURL]];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    client.requestSerializer.timeoutInterval = 60.0;
    client.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    if (0) {
        //https证书验证
        AFSecurityPolicy *securityPolicy = [client createSecurityPolicy];
        [client setSecurityPolicy:securityPolicy];
    }else{
        
        AFSecurityPolicy *securityPolicy;
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = NO;
        securityPolicy.validatesDomainName = YES;
        [client setSecurityPolicy:securityPolicy];
    }
    client.requestSerializer = [AFJSONRequestSerializer serializer];

    return client;
}


/**
 *  HTTPS证书认证
 */
-(AFSecurityPolicy *)createSecurityPolicy
{
    //先导入证书，找到证书的路径
    NSString *cerStr = @"uat.test.bbl";
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:cerStr ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];

    //AFSSLPinningModeCertificate AFSSLPinningModePublicKey - 证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:set];

    [securityPolicy setPinnedCertificates:set];
    [securityPolicy setValidatesDomainName:YES];
    [securityPolicy setAllowInvalidCertificates:NO];

    
//    //验证自建证书(无效证书)设置为YES
//    securityPolicy.allowInvalidCertificates = NO;
//
//    //validatesDomainName 验证域名，默认为YES；如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = YES;
//    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}


@end
