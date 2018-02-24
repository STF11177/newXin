//
//  eBookController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/12/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "eBookController.h"
#import "LSYReadPageViewController.h"
#import "eBookCell.h"
#import "ePictureController.h"
#import "eBookModel.h"
#import "loginMessageController.h"

@interface eBookController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}

@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSString *createDate;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIActivityIndicatorView *activity;


@end

@implementation eBookController
static NSString *userId;
static NSString *tokenStr;
static NSString *bookId;

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"电子书";
    lable.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    lable.textColor = [UIColor blackColor];
    self.navigationItem.titleView = lable;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[eBookCell class] forCellWithReuseIdentifier:@"eBookCell"];
    
    [self createHttpRequest];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    tokenStr = [userDefaults1 objectForKey:@"tokenName"];
    
    NSDictionary *param = @{@"type":@"0",@"CreateDate":@"",@"token":tokenStr,@"userId":userId};
    [self loadEbookDataWithParam:param];
    
    _activity.hidesWhenStopped = YES;
}

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = (SCREEN_WIDTH - 88*3)/3;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark -- 电子书
-(void)loadEbookDataWithParam:(NSDictionary*)param{
    
    __weak typeof(self) weakSelf = self;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:eBookURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        int tokenStuts = [dict[@"tokenStatus"]intValue];
        NSArray *menuListArray = dict[@"menuList"];
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            for ( NSDictionary *appDict in menuListArray) {
                
                eBookModel *model = [[eBookModel alloc]init];
                
                [model yy_modelSetWithDictionary:appDict];
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (tokenStuts == 2) {
                    
                    loginMessageController *login = [[loginMessageController alloc]init];
                    login.loginStatus = @"1";
                    login.hidesBottomBarWhenPushed = YES;
                    [weakSelf presentViewController:login animated:NO completion:^{
                        
                    }];
                    weakSelf.hidesBottomBarWhenPushed = NO;//最后一句话，可以保证在back回到A时
                }
            
                [weakSelf.collectionView reloadData];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    eBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"eBookCell" forIndexPath:indexPath];
    
    eBookModel *mdoel = self.dataArray[indexPath.item];
    cell.model = mdoel;
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(88, 125);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
// 在这里进行点击cell后的操作
    
    [_activity startAnimating];
    
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
          
            dispatch_async(dispatch_get_main_queue(), ^{

                [_activity stopAnimating];
                eBookModel *model = self.dataArray[indexPath.item];
                bookId = [NSString stringWithFormat:@"%@",model.bookId];
                ePictureController *detail = [[ePictureController alloc]init];
                detail.bookIdStr = bookId;
                [self.navigationController presentViewController:detail animated:YES completion:nil];
            });
        });
}

@end
