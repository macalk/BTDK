//
//  BTDKMarketCell.h
//  BTDK
//
//  Created by xiaoning on 2018/12/6.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTDKMarketModel : NSObject

Strong NSString *logo;
Strong NSString *name;
Strong NSString *url;
Strong NSString *sign;
Assign NSInteger status;

@end

@interface BTDKMarketCell : UICollectionViewCell

Strong BTDKMarketModel *model;

@end


