//
//  noAttentionController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/30.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "personController.h"

@interface AttentionDetailController : UIViewController

@property (nonatomic,strong) NSString *typeId;
@property (nonatomic,strong) NSMutableArray *noAttenArray;
@property (nonatomic,strong) UITableView *noAttenTableView;

@end
