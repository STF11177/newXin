//
//  interDIscussHeadView.h
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/18.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "interPhotoView.h"
#import "interlocutionModel.h"

@class interDIscussHeadView;
@protocol discussHeadCellDelegate <NSObject>

- (void)exprandInView:(interDIscussHeadView *)View;

@end

@interface interDIscussHeadView : UIView

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *contentLb;
@property (nonatomic,strong) UIButton *expressBtn;
@property (nonatomic,strong) interPhotoView *photoContainer;
@property (nonatomic,strong) interlocutionModel *model;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic,weak) id<discussHeadCellDelegate> delegate;

-(CGFloat)cellHeightWith:(NSString*)imgStr isOpen:(BOOL)isOpen;

@end
