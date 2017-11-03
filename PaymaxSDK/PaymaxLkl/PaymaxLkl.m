//
//  PaymaxLkl.m
//  PaymaxLkl
//
//  Created by William on 16/8/11.
//  Copyright © 2016年 SWWX. All rights reserved.
//

#import "PaymaxLkl.h"

@implementation PaymaxLkl

static NSString *SUCCESS = @"1";
static NSString *FAILURE = @"0";
static NSString *CANCEL =  @"2";

- (void)lklpay:(NSDictionary *)payData completion:(void (^)(PaymaxResult *result))completionBlock {
    PaymaxSDK *_paymax = [PaymaxSDK new];
    _paymax->_result = [PaymaxResult new];
    
    NSDictionary *_charge = [payData objectForKey:@"charge"];
    UIViewController *_vc = [payData objectForKey:@"viewController"];
    NSDictionary *_credential = [_charge objectForKey:@"credential"];
    if (!_credential || _credential == (id)kCFNull) {
        _paymax->_result.type = PAYMAX_CODE_ERROR_CHARGE_PARAMETER;
        _paymax->_result.channelBackCode = @"nil";
        _paymax->_result.backStr = @"credential为空";
        _paymax->_result.channel = @"LKL";
        completionBlock(_paymax->_result);
        return;
    }
    NSDictionary *_lakala_app = [_credential objectForKey:@"lakala_app"];
    if (!_lakala_app || _lakala_app == (id)kCFNull) {
        _paymax->_result.type = PAYMAX_CODE_ERROR_CHARGE_PARAMETER;
        _paymax->_result.channelBackCode = @"nil";
        _paymax->_result.backStr = @"lakala_app为空";
        _paymax->_result.channel = @"LKL";
        completionBlock(_paymax->_result);
        return;
    }
    NSString *merchantId = [_lakala_app objectForKey:@"merchantId"];
    NSString *merchantName = [_lakala_app objectForKey:@"merchantName"];
    NSString *merchantOrderNo = [_lakala_app objectForKey:@"merchantOrderNo"];
    NSString *merchantUserNo = [_lakala_app objectForKey:@"merchantUserNo"];
    NSString *orderTime = [_lakala_app objectForKey:@"orderTime"];
    NSString *token = [_lakala_app objectForKey:@"token"];
    NSString *totalAmount = [_lakala_app objectForKey:@"totalAmount"];
    if (!merchantId || merchantId == (id)kCFNull ||
        !merchantName || merchantName == (id)kCFNull ||
        !merchantOrderNo || merchantOrderNo == (id)kCFNull||
        !merchantUserNo || merchantUserNo == (id)kCFNull||
        !orderTime || orderTime == (id)kCFNull||
        !token || token == (id)kCFNull||
        !totalAmount || totalAmount == (id)kCFNull) {
        
        _paymax->_result.type = PAYMAX_CODE_ERROR_CHARGE_PARAMETER;
        _paymax->_result.channelBackCode = @"nil";
        _paymax->_result.backStr = @"lakala_app里缺失参数";
        _paymax->_result.channel = @"LKL";
        completionBlock(_paymax->_result);
        return;
    }
    NSDictionary *lklorderDic = @{@"merchantId":merchantId,
                                  @"merchantName":merchantName,
                                  @"orderTime":orderTime,
                                  @"totalAmount":totalAmount,
                                  @"token":token,
                                  @"mercOrdNo":merchantOrderNo,
                                  @"mercUserNo":merchantUserNo};
    [LKLPaySDK sendPayMessageOfApp:lklorderDic andTarget:_vc withPayResultBlock:^(id result) {
        
        _paymax->_result.channel = @"LKL";
        if([result isEqualToString:SUCCESS])
        {
            _paymax->_result.type = PAYMAX_CODE_SUCCESS;
            _paymax->_result.backStr = @"支付成功";
            completionBlock(_paymax->_result);
        }else if([result isEqualToString:FAILURE])
        {
            _paymax->_result.type = PAYMAX_CODE_FAILURE;
            _paymax->_result.backStr = @"支付失败";
            completionBlock(_paymax->_result);
        }else if([result isEqualToString:CANCEL])
        {
            _paymax->_result.type = PAYMAX_CODE_FAIL_CANCEL;
            _paymax->_result.backStr = @"支付取消";
            completionBlock(_paymax->_result);
        }
    }];
}

@end
