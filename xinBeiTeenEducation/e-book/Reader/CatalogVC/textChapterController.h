//
//  textChapterController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYReadModel.h"
@protocol LSYCatalogViewControllerDelegate;
@interface textChapterController : UIViewController

@property (nonatomic,strong) LSYReadModel *readModel;
@property (nonatomic,weak) id<LSYCatalogViewControllerDelegate>delegate;

@end
