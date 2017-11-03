//
//  PaymaxAli.m
//  PaymaxAli
//
//  Created by William on 16/8/11.
//  Copyright © 2016年 SWWX. All rights reserved.
//

#import "PaymaxAli.h"

@implementation PaymaxAli
- (void)alipay:(NSDictionary *)payData completion:(void (^)(PaymaxResult *result))completionBlock {
    PaymaxSDK *_paymax = [PaymaxSDK new];
    _paymax->_result = [PaymaxResult new];
   
    NSDictionary *_charge = [payData objectForKey:@"charge"];
    NSString *_schemeStr = [payData objectForKey:@"schemeStr"];
    NSDictionary *_credential = [_charge objectForKey:@"credential"];
    if (!_credential || _credential == (id)kCFNull) {
        _paymax->_result.type = PAYMAX_CODE_ERROR_CHARGE_PARAMETER;
        _paymax->_result.channelBackCode = @"nil";
        _paymax->_result.backStr = @"credential为空";
        _paymax->_result.channel = @"alipay";
        completionBlock(_paymax->_result);
        return;
    }
    NSDictionary *_alipay_app = [_credential objectForKey:@"alipay_app"];
    if (!_alipay_app || _alipay_app == (id)kCFNull) {
        _paymax->_result.type = PAYMAX_CODE_ERROR_CHARGE_PARAMETER;
        _paymax->_result.channelBackCode = @"nil";
        _paymax->_result.backStr = @"alipay_app为空";
        _paymax->_result.channel = @"alipay";
        completionBlock(_paymax->_result);
        return;
    }
    NSString *_orderString = [_alipay_app objectForKey:@"orderInfo"];
    if (!_orderString || _orderString == (id)kCFNull) {
        _paymax->_result.type = PAYMAX_CODE_ERROR_CHARGE_PARAMETER;
        _paymax->_result.channelBackCode = @"nil";
        _paymax->_result.backStr = @"orderInfo为空";
        _paymax->_result.channel = @"nil";
        completionBlock(_paymax->_result);
        return;
    }
    [[AlipaySDK defaultService] payOrder:_orderString fromScheme:_schemeStr callback:^(NSDictionary *resultDic) {
        
        NSString *_code = resultDic[@"resultStatus"];
        _paymax->_result.channelBackCode = resultDic[@"resultStatus"];
        _paymax->_result.channel = @"alipay";
        _paymax->_result.backStr = resultDic[@"memo"];
        
        switch ([_code integerValue]) {
            case 9000: {
                _paymax->_result.type = PAYMAX_CODE_SUCCESS;
            }
                break;
            case 8000: {
                _paymax->_result.type = PAYMAX_CODE_ERROR_DEAL;
            }
                break;
            case 4000: {
                _paymax->_result.type = PAYMAX_CODE_FAILURE;
            }
                break;
            case 6001: {
                _paymax->_result.type = PAYMAX_CODE_FAIL_CANCEL;
            }
                break;
            case 6002: {
                _paymax->_result.type = PAYMAX_CODE_ERROR_CONNECT;
            }
                break;
        }
        completionBlock(_paymax->_result);
    }];
}

- (void)alipayhandleOpenURL:(NSURL *)url completion:(void (^)(PaymaxResult *result))completionBlock {
    PaymaxSDK *_paymax = [PaymaxSDK new];
    _paymax->_result = [PaymaxResult new];

    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        NSString *_code = resultDic[@"resultStatus"];
        _paymax->_result.channelBackCode = resultDic[@"resultStatus"];
        _paymax->_result.channel = @"alipay";
        _paymax->_result.backStr = resultDic[@"memo"];

        switch ([_code integerValue]) {
            case 9000: {
                _paymax->_result.type = PAYMAX_CODE_SUCCESS;
            }
                break;
            case 8000: {
                _paymax->_result.type = PAYMAX_CODE_ERROR_DEAL;
            }
                break;
            case 4000: {
                _paymax->_result.type = PAYMAX_CODE_FAILURE;
            }
                break;
            case 6001: {
                _paymax->_result.type = PAYMAX_CODE_FAIL_CANCEL;
            }
                break;
            case 6002: {
                _paymax->_result.type = PAYMAX_CODE_ERROR_CONNECT;
            }
                break;
        }
        completionBlock(_paymax->_result);
    }];
}
@end
