//
//  chanelController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/19.
//  Copyright © 2017年 user. All rights reserved.
//

#import "chanelController.h"
#import "hotAticleController.h"
#import "ChannelCollectionViewCell.h"
#import "ChannelCollectionReusableView.h"

#define itemSize_Height 30
#define itemSize_Width 80
#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)

#define padding 10
#define  navigation_height 44
#define statuBar_height 20

static NSString *channelID=@"ChannelCollectionViewCell";
static NSString *reusableViewID=@"ChannelCollectionReusableView";

//定义 cell是否是编辑状态的枚举
typedef NS_ENUM(NSInteger,cellStatus)//(枚举类型，枚举名称)
{
    cellStatuEdite=0,//编辑状态
    cellStatuFinish  //完成状态
    
};
@interface chanelController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{

    UICollectionView*_collection;
    UICollectionViewFlowLayout*_layout;
    NSMutableArray*_channelArray;//装载我的频道的数据
    NSMutableArray *_tuijianArray;//装载推荐频道的数据
    
    cellStatus cellEditeStatu;//记录编辑状态

}

//添加抖动动画
@property(nonatomic,strong)CAKeyframeAnimation*caKeyframeAnimation;
@end

@implementation chanelController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //默认设置初始cell的编辑状态为 未编辑即完成状态
    cellEditeStatu=cellStatuFinish;
    
    [self createNav];
    [self loadData];
    [self creatCollection];
}

-(void)createNav{
    
    UIButton *leftBtn = [[UIButton alloc]init];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item2;

    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 , 10, 40, 40)];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

-(void)loadData{
    
    NSArray*array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*path=[array[0] stringByAppendingPathComponent:@"channel.plist"];
    _channelArray=[NSMutableArray arrayWithContentsOfFile:path];
    
    NSString*tuijianPath=[array[0] stringByAppendingPathComponent:@"tuijian.plist"];
    _tuijianArray=[NSMutableArray arrayWithContentsOfFile:tuijianPath];
    if (_tuijianArray.count==0||_tuijianArray==nil)
    {
        
        _tuijianArray=[NSMutableArray arrayWithArray:@[]];
        [_tuijianArray writeToFile:tuijianPath atomically:YES];
    }
}

-(CAKeyframeAnimation*)caKeyframeAnimation
{
    if (!_caKeyframeAnimation)
    {
        //设置核心动画
        _caKeyframeAnimation=[CAKeyframeAnimation animation];
        //设置动画属性
        _caKeyframeAnimation.keyPath=@"transform.rotation";
        
        //设置动画的values
        _caKeyframeAnimation.values=@[@(Angle2Radian(-5)),@(Angle2Radian(5)),@(Angle2Radian(-5))];
        //设置动画执行时长
        _caKeyframeAnimation.duration=0.25;
        
        //设置动画执行次数
        _caKeyframeAnimation.repeatCount=MAXFLOAT;
        
        //设置是否保持动画完成时的状态
        _caKeyframeAnimation.removedOnCompletion=NO;
        _caKeyframeAnimation.fillMode=kCAFillModeForwards;
        
    }
    return _caKeyframeAnimation;
    
}

#pragma mark+++ 创建并初始化collectionView +++++
-(void)creatCollection
{
    _layout=[[UICollectionViewFlowLayout alloc]init];
    _layout.itemSize=CGSizeMake(itemSize_Width, itemSize_Height);
    _layout.minimumLineSpacing=10;
    _layout.minimumInteritemSpacing=10;
    _layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT) collectionViewLayout:_layout];
    _collection.delegate=self;
    _collection.dataSource=self;
    _collection.backgroundColor=[UIColor lightGrayColor];
    
    [_collection registerNib:[UINib nibWithNibName:@"ChannelCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:channelID];
    
    [_collection registerNib:[UINib nibWithNibName:@"ChannelCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableViewID];
    [_layout setHeaderReferenceSize:CGSizeMake(SCREEN_WIDTH, 50)];
    [self.view addSubview:_collection];
}

#pragma mark+++设置collectionView 的区块数++++++
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
#pragma mark++++  设置每个区块的单元格的个数 ++++++++
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0)
    {
        return _channelArray.count;
    }
    else
    {
        return _tuijianArray.count;
    }
}

#pragma mark++ 设置单元格 +++
-( __kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChannelCollectionViewCell *channelCell=[collectionView dequeueReusableCellWithReuseIdentifier:channelID forIndexPath:indexPath];
    
    channelCell.layer.cornerRadius=itemSize_Height/6;
    channelCell.clipsToBounds=YES;
    
    if (cellEditeStatu==cellStatuFinish)//未编辑状态
    {
        channelCell.cannelImage.hidden=YES;// 隐藏编辑符号
        if (indexPath.section==0)//第一个区块
        {
            channelCell.textLb.text=_channelArray[indexPath.item];
//            [channelCell.layer removeAnimationForKey:@"shanking"];
        }
        else//第二个区块
        {
            channelCell.textLb.text=_tuijianArray[indexPath.item];
        }
    }
    else  if (cellEditeStatu==cellStatuEdite)//编辑状态
    {
        if (indexPath.section==0)//第一个区块
        {
            if (indexPath.item >0) {
                
//                [channelCell.layer addAnimation:self.caKeyframeAnimation forKey:@"shanking"];
                channelCell.textLb.text=_channelArray[indexPath.item];
                channelCell.cannelImage.hidden=NO;//不隐藏编辑符号
            }else{
            
            channelCell.textLb.text=_channelArray[indexPath.item];
            }
            
        }
        else  //第二个区块
        {
            channelCell.textLb.text=_tuijianArray[indexPath.item];
            channelCell.cannelImage.hidden=YES;
            
        }
        
    }
    return channelCell;
}
#pragma mark++  设置单元格的点击事件 +++
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChannelCollectionViewCell*channelCell=(ChannelCollectionViewCell*)[_collection cellForItemAtIndexPath:indexPath];
    
    if (cellEditeStatu==cellStatuEdite)//编辑状态
    {
        if (indexPath.section==0)//第一个区块
        {
            if (indexPath.item >0) {
              
                //获取当前选择的单元格的内容
                NSString*cellText=channelCell.textLb.text;
                //在第一个区块删除当前所选择的单元格
                [_channelArray removeObject:cellText];
                //在第二个区块插入当前所删除的单元格
                [_tuijianArray insertObject:cellText atIndex:0];
                //将更改的数据保存到沙河中
                [self saveDataForEdited];
                //刷新数据
                [_collection reloadData];
            }
        }
        else //第二个区块
        {
            NSString*cellText=channelCell.textLb.text;
            [_tuijianArray removeObject:cellText];
            [_channelArray addObject:cellText];
            [self saveDataForEdited];
            [_collection reloadData];
            
        }
    }
    else //非编辑状态
    {
        if (indexPath.section==0)//第一个区块
        {
//            [_delegate setChannelText:channelCell.textLb.text andIndex:indexPath.item];
            
//            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        else //第二个区块
        {
            NSString*cellText=channelCell.textLb.text;
            [_tuijianArray removeObject:cellText];
            [_channelArray addObject:cellText];
            [self saveDataForEdited];
            [_collection reloadData];
        }
    }
}

#pragma mark++保存更改的数据到沙河+++
-(void)saveDataForEdited
{
    NSArray*array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*channelPlistPath=[array[0] stringByAppendingPathComponent:@"channel.plist"];
    NSString*tuijianPlistPath=[array[0] stringByAppendingPathComponent:@"tuijian.plist"];
    
    [_tuijianArray writeToFile:tuijianPlistPath atomically:YES];
    [_channelArray writeToFile:channelPlistPath atomically:YES];
    
}
#pragma mark +++ 设置collectionView的表头 +++++
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //判断是表头还是表尾
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        ChannelCollectionReusableView*headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableViewID forIndexPath:indexPath];

        //分区
        if (indexPath.section==0)
        {
            headerView.editeBtn.hidden=NO;
            [headerView.editeBtn addTarget:self action:@selector(editeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            headerView.textLb.text=@"我的频道";
        }
        else
        {
            headerView.textLb.text=@"推荐频道";
            headerView.editeBtn.hidden=YES;
        }
        
        return headerView;
    }
    return nil;
}
#pragma mark+++ 设置编辑按钮的点击事件 +++
-(void)editeBtnAction:(UIButton *)sender
{
    //根据枚举值 做相应的更改
    if (cellEditeStatu==cellStatuFinish)//未编辑状态
    {
        cellEditeStatu= cellStatuEdite;//更改当前编辑状态
        [sender setTitle:@"编辑" forState:UIControlStateNormal];//更改编辑按钮显示的标题
        [_collection reloadSections:[NSIndexSet indexSetWithIndex:0]];//刷新数据
    }
    else if(cellEditeStatu==cellStatuEdite)
    {
        cellEditeStatu=cellStatuFinish;
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [_collection reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
}

-(void)rightBtn{
    
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end














//
//  hotCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 user. All rights reserved.
//

//#import "hotCell.h"
//
//@implementation hotCell
//
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//        [self createView];
//        [self layoutUI];
//    }
//    return self;
//}
//
//-(void)createView{
//    
//    _contentLb = [[UILabel alloc]init];
//    _contentLb.numberOfLines = 0;
//    _contentLb.font = [UIFont systemFontOfSize:18];
//    [self.contentView addSubview:_contentLb];
//    
//    _nameLb = [[UILabel alloc]init];
//    _nameLb.font = [UIFont systemFontOfSize:12];
//    _nameLb.textColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:_nameLb];
//    
//    _commentLb = [[UILabel alloc]init];
//    _commentLb.font = [UIFont systemFontOfSize:12];
//    _commentLb.textColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:_commentLb];
//    
//    _timeLb = [[UILabel alloc]init];
//    _timeLb.font = [UIFont systemFontOfSize:12];
//    _timeLb.textColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:_timeLb];
//    
//    _headImgView = [[UIImageView alloc]init];
//    _headImgView.clipsToBounds = YES;
//    _headImgView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.contentView addSubview:_headImgView];
//}
//
//-(void)layoutUI{
//    __weak typeof(self) weakSelf = self;
//    [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.mas_top).offset(15);
//        make.right.equalTo(weakSelf.headImgView.mas_left).offset(-15);
//        make.left.equalTo(weakSelf.contentView).offset(15);
//        
//    }];
//    
//    // 不然在6/6plus上就不准确了
//    self.contentLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 -15 - 70 -15;
//    [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.contentLb.mas_bottom).offset(4);
//        make.left.equalTo(weakSelf.contentView).offset(15);
//        make.height.mas_equalTo(20);
//        
//    }];
//    
//    [_commentLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.nameLb.mas_top);
//        make.left.equalTo(weakSelf.nameLb.mas_right).offset(10);
//        make.height.mas_equalTo(20);
//        
//    }];
//    
//    [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.nameLb.mas_top);
//        make.left.equalTo(weakSelf.commentLb.mas_right).offset(10);
//        make.height.mas_equalTo(20);
//        
//    }];
//    
//    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
//        make.right.equalTo(weakSelf.contentView).offset(-15);
//        make.width.height.mas_equalTo(70);
//        
//    }];
//}
//
//-(void)setHotModel:(hotArticleModel *)hotModel{
//    
//    _hotModel = hotModel;
//    _contentLb.text =_hotModel.title;
//    _contentLb.numberOfLines = 0;
//    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 15 - 15 - 70 - 15, CGFLOAT_MAX);
//    //  计算内容label的高度
//    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
//    CGRect contenRect = [self.contentLb.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
//    
//    if (contenRect.size.height < 21) {
//        
//        [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(26);
//            make.right.equalTo(self.headImgView.mas_left).offset(-15);
//            make.left.equalTo(self.contentView).offset(15);
//            make.height.mas_equalTo(21);
//            
//        }];
//        
//        // 不然在6/6plus上就不准确了
//        self.contentLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 -15 - 70 -15;
//        [_headImgView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView.mas_top).offset(15);
//            
//        }];
//    }
//    else if(contenRect.size.height > 21 && contenRect.size.height <41){
//        
//        [_headImgView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView.mas_top).offset(15);
//            
//        }];
//        
//        [_contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(18);
//            make.right.equalTo(self.headImgView.mas_left).offset(-15);
//            make.left.equalTo(self.contentView).offset(15);
//            
//        }];
//        
//        // 不然在6/6plus上就不准确了
//        self.contentLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 15 -15 - 70 -15;
//    }else{
//        
//        [_contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_top).offset(15);
//            make.right.equalTo(self.headImgView.mas_left).offset(-15);
//            make.left.equalTo(self.contentView).offset(15);
//            
//        }];
//    }
//    
//    _nameLb.text = _hotModel.source;
//    NSString *tiemStr = [self formateDate:[NSString stringWithFormat:@"%@",_hotModel.createDate]];
//    _timeLb.text = tiemStr;
//    _commentLb.text = [NSString stringWithFormat:@"评论%@",_hotModel.comment_count];
//    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_hotModel.imgs] placeholderImage:[UIImage imageNamed:@"nsme_ke"]];
//}
//
//- (CGFloat)cellHeight{
//    
//    // 文字的最大尺寸(设置内容label的最大size，这样才可以计算label的实际高度，需要设置最大宽度，但是最大高度不需要设置，只需要设置为最大浮点值即可)，53为内容label到cell左边的距离
//    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 15 -15 - 70 - 15, CGFLOAT_MAX);
//    
//    //  计算内容label的高度
//    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0]};
//    CGRect contenRect = [self.contentLb.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
//    
//    DDLog(@"%@",_contentLb.text);
//    
//    if (contenRect.size.height < 41) {
//        
//        _cellHeight = 41 + 20 + 15 + 15 + 5 + 5;
//    }else{
//        
//        _cellHeight = contenRect.size.height + 20 + 15 + 15 + 5;
//    }
//    
//    return _cellHeight;
//}
//
//#pragma mark--时间转化的方法
//- (NSString *)formateDate:(NSString *)dateString
//{
//    @try {
//        // ------实例化一个NSDateFormatter对象
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里的格式必须和DateString格式一致
//        NSDate * nowDate = [NSDate date];
//        // ------将需要转换的时间转换成 NSDate 对象
//        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
//        // ------取当前时间和转换时间两个日期对象的时间间隔
//        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
//        // ------再然后，把间隔的秒数折算成天数和小时数：
//        NSString *dateStr = [[NSString alloc] init];
//        if (time<=60) {  //1分钟以内的
//            
//            dateStr = @"刚刚";
//        }else if(time<=60*60){  //一个小时以内的
//            
//            int mins = time/60;
//            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
//        }else if(time<=60*60*24){  //在两天内的
//            
//            int hours = time/3600;
//            dateStr = [NSString stringWithFormat:@"%d小时前",hours];
//        }else {
//            
//            [dateFormatter setDateFormat:@"yyyy"];
//            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
//            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
//            
//            if ([yearStr isEqualToString:nowYear]) {
//                //在同一年
//                [dateFormatter setDateFormat:@"MM-dd HH:mm"];
//                dateStr = [dateFormatter stringFromDate:needFormatDate];
//            }else{
//                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//                dateStr = [dateFormatter stringFromDate:needFormatDate];
//            }
//        }
//        return dateStr;
//    }
//    @catch (NSException *exception) {
//        return @"";
//    }
//}
//
//@end







