//
//  picChapterController.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYReadModel.h"
@protocol LSYCatalogViewControllerDelegate;

@interface picChapterController : UIViewController
@property (nonatomic,strong) LSYReadModel *readModel;
@property (nonatomic,weak) id<LSYCatalogViewControllerDelegate>delegate;
@end
