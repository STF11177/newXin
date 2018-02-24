//
//  newfriendCell.h
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFIndexedCollectionView : UICollectionView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface newfriendCell : UITableViewCell

@property (nonatomic, strong) AFIndexedCollectionView *collectionView;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end
