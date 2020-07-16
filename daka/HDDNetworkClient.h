//
//  HDDNetworkClient.h
//  daka
//
//  Created by HanDD on 2020/6/29.
//  Copyright © 2020 杨林贵. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,HDDSERVICETYPE) {
    HDDSERVICE_DEFAULT,
};

@interface HDDNetworkClient : AFHTTPSessionManager

+ (instancetype)HTTPSessionManagerWithAPIType:(HDDSERVICETYPE )APIType;

@end

NS_ASSUME_NONNULL_END
