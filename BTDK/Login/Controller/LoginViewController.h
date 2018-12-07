//
//  LoginViewController.h
//  KaiXinQianDai
//
//  Created by xiaoning on 2018/11/27.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import "BaseViewController.h"



@interface LoginViewController : BaseViewController

typedef void (^LoginSuccessBlock) (void);

- (instancetype)initWithSuccessBlock:(LoginSuccessBlock)successBlock;

@end


