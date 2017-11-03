//
//  PaymaxWx.m
//  PaymaxWx
//
//  Created by William on 16/8/11.
//  Copyright © 2016年 SWWX. All rights reserved.
//

#import "PaymaxWx.h"

@implementation PaymaxWx

- (void)wxpay:(NSDictionary *)payData completion:(void (^)(PaymaxResult *result))completionBlock {
    PaymaxSDK *_paymax = [PaymaxSDK new];
    _paymax->_result = [PaymaxResult new];
    NSDictionary *_charge = [payData objectForKey:@"charge"];
    NSDictionary *_credential = [_charge objectForKey:@"credential"];
    if (!_credential || _credential == (id)kCFNull) {
        _paymax->_result.type = PAYMAX_CODE_ERROR_CHARGE_PARAMETER;
        _paymax->_result.channelBackCode = @"nil";
        _paymax->_result.backStr = @"credential为空";
        _paymax->_result.channel = @"wechat";
        completionBlock(_paymax->_result);
        return;
    }
    NSDictionary *_wechat_app = [_credential objectForKey:@"wechat_app"];
    if (!_wechat_app || _wechat_app == (id)kCFNull) {
        _paymax->_result.type = PAYMAX_CODE_ERROR_CHARGE_PARAMETER;
        _paymax->_result.channelBackCode = @"nil";
        _paymax->_result.backStr = @"wechat_app为空";
        _paymax->_result.channel = @"wechat";
        completionBlock(_paymax->_result);
        return;
    }
    NSMutableString *timestamp = [_wechat_app objectForKey:@"timestamp"];
    NSString *appId = [_wechat_app objectForKey:@"appid"];
    NSString *partnerid = [_wechat_app objectForKey:@"partnerid"];
    NSString *prepayid = [_wechat_app objectForKey:@"prepayid"];
    NSString *noncestr = [_wechat_app objectForKey:@"noncestr"];
    NSString *package = [_wechat_app objectForKey:@"package"];
    NSString *sign = [_wechat_app objectForKey:@"sign"];
    
    if (!timestamp || timestamp == (id)kCFNull ||
        !appId || appId == (id)kCFNull ||
        !partnerid || partnerid == (id)kCFNull||
        !prepayid || prepayid == (id)kCFNull||
        !noncestr || noncestr == (id)kCFNull||
        !package || package == (id)kCFNull||
        !sign || sign == (id)kCFNull) {
        
        _paymax->_result.type = PAYMAX_CODE_ERROR_CHARGE_PARAMETER;
        _paymax->_result.channelBackCode = @"nil";
        _paymax->_result.backStr = @"wechat_app里缺失参数";
        _paymax->_result.channel = @"wechat";
        completionBlock(_paymax->_result);
        return;
    }
    
    BOOL wxpay = [WXApi registerApp:appId];
    NSLog(@"registerApp %d",wxpay);
    if (![WXApi isWXAppInstalled]) {
        _paymax->_result.type = PAYMAX_CODE_ERROR_WX_NOT_INSTALL;
        _paymax->_result.channelBackCode = @"nil";
        _paymax->_result.backStr = @"未安装微信";
        _paymax->_result.channel = @"wechat";
        completionBlock(_paymax->_result);
        return;
    }
    if (![WXApi isWXAppSupportApi]) {
        _paymax->_result.type = PAYMAX_CODE_ERROR_WX_NOT_SUPPORT_PAY;
        _paymax->_result.channelBackCode = @"nil";
        _paymax->_result.backStr = @"微信版本不支持";
        _paymax->_result.channel = @"wechat";
        completionBlock(_paymax->_result);
        return;
    }
    PayReq* req   = [[PayReq alloc] init];
    req.partnerId = partnerid;
    req.prepayId  = prepayid;
    req.nonceStr  = noncestr;
    req.timeStamp = timestamp.intValue;
    req.package   = package;
    req.sign      = sign;
    [WXApi sendReq:req];
}

- (void)wxhandleOpenURL:(NSURL *)url completion:(void (^)(PaymaxResult *result))completionBlock {
    self.completionBlock = completionBlock;
    [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]) {
        PaymaxSDK *_paymax = [PaymaxSDK new];
        _paymax->_result = [PaymaxResult new];
        _paymax->_result.channel = @"wechat";
        _paymax->_result.channelBackCode = [NSString stringWithFormat:@"%d",resp.errCode];
        _paymax->_result.backStr = resp.errStr;
        
        switch (resp.errCode) {
            case WXSuccess:
                _paymax->_result.type = PAYMAX_CODE_SUCCESS;
                _paymax->_result.backStr = @"支付成功";
                break;
            case WXErrCodeCommon:
                _paymax->_result.type = PAYMAX_CODE_ERROR_WX_UNKNOW;
                _paymax->_result.backStr = @"微信普通错误类型";
                break;
            case WXErrCodeUserCancel:
                _paymax->_result.type = PAYMAX_CODE_FAIL_CANCEL;
                _paymax->_result.backStr = @"用户取消支付";
                break;
            case WXErrCodeSentFail:
                _paymax->_result.type = PAYMAX_CODE_ERROR_WX_UNKNOW;
                _paymax->_result.backStr = @"微信发送失败";
                break;
            case WXErrCodeAuthDeny:
                _paymax->_result.type = PAYMAX_CODE_ERROR_WX_UNKNOW;
                _paymax->_result.backStr = @"微信授权失败";
                break;
            case WXErrCodeUnsupport:
                _paymax->_result.type = PAYMAX_CODE_ERROR_WX_NOT_SUPPORT_PAY;
                _paymax->_result.backStr = @"微信不支持";
                break;
        }
        self.completionBlock(_paymax->_result);
    }
}

@end
