//
//  PaymaxWx.h
//  PaymaxWx
//
//  Created by William on 16/8/11.
//  Copyright © 2016年 SWWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "PaymaxSDK.h"

@interface PaymaxWx : NSObject<WXApiDelegate>

@property (copy) void(^completionBlock)(PaymaxResult *result);

@end
