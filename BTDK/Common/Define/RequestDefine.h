//
//  RequestDefine.h
//  KaiXinQianDai
//
//  Created by xiaoning on 2018/11/27.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#ifndef RequestDefine_h
#define RequestDefine_h

#ifdef DEBUG

static NSString * const BaseRequestUrl = @"http://test.vip-black.com";

#else

static NSString * const BaseRequestUrl = @"http://api.vip-black.com";

#endif


static NSString * const products_list = @"http://interface.vip-black.com/products/list"; // 被拒产品接口，域名和其他接口不一样！

static NSString * const s1_apps_version_model = @"/s1/apps/version/model";
static NSString * const s1_sms_sendSms = @"/s1/sms/sendSms";
static NSString * const s1_sms_checkCode = @"/s1/sms/checkCode";
static NSString * const s1_clientUser_smsLogin_app = @"/s1/clientUser/smsLogin/app";
static NSString * const s1_clientUser_register_app = @"/s1/clientUser/register/app";
static NSString * const s1_clientUser_updatePassword = @"/s1/clientUser/updatePassword";

static NSString * const s1_clientUser_login = @"/s1/clientUser/login";
static NSString * const s1_order_submit = @"/s1/order/submit";
static NSString * const s1_idCard_save = @"/s1/idCard/save";
static NSString * const s1_contacts_save = @"/s1/contacts/save";
static NSString * const s1_action_save = @"/s1/action/save";
static NSString * const s1_order_list = @"/s1/order/list";
static NSString * const s1_order_query = @"/s1/order/query";
static NSString * const s1_credit_score_saveZhiMa = @"/s1/credit/score/saveZhiMa";


#endif /* RequestDefine_h */
