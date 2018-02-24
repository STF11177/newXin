//
//  bugCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "bugCell.h"
#import "bugCommentModel.h"
#import "bugReplyCell.h"

@interface bugCell ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) bugReplyCell *detailCell;
@property (nonatomic,strong) NSMutableArray *sectioNArray;
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation bugCell
static NSString *bugId;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        [self layOutUI];
        
        [self.tableView registerClass:[bugReplyCell class] forCellReuseIdentifier:@"detailTextCell"];
    }
    return self;
}

-(void)createView{

    self.sectioNArray = [[NSMutableArray alloc]init];
    self.titleLb = [[copyLable alloc]init];
    self.titleLb.text = @"";
    self.titleLb.numberOfLines = 0;
    self.titleLb.font = [UIFont systemFontOfSize:16];
    self.titleLb.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
    [self.contentView addSubview:self.titleLb];
    
    self.statusBtn = [[UIButton alloc]init];
    [self.statusBtn setTitle:@"待处理" forState:UIControlStateNormal];
    self.statusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.statusBtn.layer.borderWidth = 1;
    self.statusBtn.layer.cornerRadius = 3;
    self.statusBtn.layer.borderColor = [UIColor colorWithHexString:@"#d02c30"].CGColor;
    [self.statusBtn setTitleColor:[UIColor colorWithHexString:@"#d02c30"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.statusBtn];

    self.timeLb = [[UILabel alloc]init];
    self.timeLb.text = @"";
    self.timeLb.font = [UIFont systemFontOfSize:15];
    self.timeLb.textColor = [UIColor colorWithHexString:@"#898989"];
    [self.contentView addSubview:self.timeLb];
    
    self.deleteBtn = [[UIButton alloc]init];
    [self.deleteBtn setTitleColor:[UIColor colorWithHexString:@"#1b82d2"] forState:UIControlStateNormal];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.deleteBtn];
    
    self.bugImgView = [[bugPhotoView alloc] initWithWidth:32];
    [self.contentView addSubview:self.bugImgView];
    
    self.imgCountLb = [[UILabel alloc]init];
    self.imgCountLb.font = [UIFont systemFontOfSize:15];
    self.imgCountLb.textColor = [UIColor colorWithHexString:@"#898989"];
    [self.contentView addSubview:self.imgCountLb];
    
    self.sepView = [[UIView alloc]init];
    self.sepView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.contentView addSubview:self.sepView];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
}

-(void)layOutUI{

    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.bugImgView.mas_left).offset(-10);
    }];

    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLb.mas_left);
        make.top.equalTo(self.titleLb.mas_bottom).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.statusBtn.mas_right).offset(15);
        make.top.equalTo(self.statusBtn.mas_top);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.statusBtn.mas_top).offset(-5);
        make.left.equalTo(self.timeLb.mas_right).offset(15);
    }];
   
    [self.bugImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    [self.bugImgView setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisVertical];
    [self.bugImgView setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];

    [self.imgCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bugImgView.mas_bottom).offset(5);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.statusBtn.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH -15);
        make.height.mas_equalTo(1);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.sepView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

-(void)deleteBtnClick{

    if (_delegate && [_delegate respondsToSelector:@selector(onDeleteInCell:)]) {
        [_delegate onDeleteInCell:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(onCommentInCell:)]) {
        [_delegate onCommentInCell:self];
    }
}

#pragma mark --tableView
-(void)createBugListModel{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSDictionary *appDict in self.dataArray) {
            
            bugCommentModel *model = [[bugCommentModel alloc]init];
            [model yy_modelSetWithDictionary:appDict];
            [self.sectioNArray addObject:model];
        }
        [self.tableView reloadData];
    });
}

-(void)setModel:(bugCommentModel *)model{
    
    self.detailCell = [[bugReplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailTextCell"];
    
    if ([model.status isEqualToString:@"2"]) {
        
        self.detailCell.contentLb.text = [NSString stringWithFormat:@"管理员回复: %@",model.content];
      
        self.detailCell.contentLb.textColor = [UIColor colorWithHexString:@"#3e3e3e"];
        NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.detailCell.contentLb.text];
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 5)];
        self.detailCell.contentLb.attributedText = centStr;
        self.sepView.hidden = NO;
    
    }else{
        
        self.detailCell.contentLb.text = [NSString stringWithFormat:@"我回复管理员 %@",model.content];
        NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.detailCell.contentLb.text];
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5184BC"] range:NSMakeRange(0, 1)];
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5184BC"] range:NSMakeRange(3, 3)];
        self.detailCell.contentLb.attributedText = centStr;
        self.sepView.hidden = NO;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.sectioNArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.detailCell = [tableView dequeueReusableCellWithIdentifier:@"detailTextCell"];
    if (!self.detailCell) {
        self.detailCell = [[bugReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailTextCell"];
    }
    
    if (self.sectioNArray.count !=0) {
        
        bugCommentModel *comment = self.sectioNArray[indexPath.row];
        self.model = comment;
        self.detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self.detailCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if ([self.delegate respondsToSelector:@selector(onCommentInCell:indexPath:)]) {
//        [self.delegate onCommentInCell:self indexPath:indexPath];
//    }
//
//    bugCommentModel *comment = self.sectioNArray[indexPath.row];
//    self.model = comment;
//    if (self.delegate) {
//
//        [self.delegate selectBugId:comment.parent_cid selectBugStatus:comment.status];
//    }
}

- (CGFloat)bugCommentHeight{
    
    bugCommentModel *model = self.sectioNArray[self.indexpath.row];
    self.model = model;
    CGSize maxSize1 = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    // 计算内容label的高度
    NSDictionary *dict1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
    CGRect contenRect1 = [self.detailCell.contentLb.text boundingRectWithSize:maxSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil];
    _bugCommentHeight = contenRect1.size.height;
    
    return _bugCommentHeight;
}

-(void)configCellWithModel:(bugListModel *)model indexPath:(NSIndexPath *)indexPath{

    [self.sectioNArray removeAllObjects];
    self.indexpath = indexPath;
    self.titleLb.text = model.content;
    
    NSString *tiemStr = [self formateDate:[NSString stringWithFormat:@"%@",model.createDate]];
    self.timeLb.text = tiemStr;
    
    if ([model.status isEqualToString:@"2"]) {

        [self.statusBtn setTitle:@"已处理" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:[UIColor colorWithHexString:@"#8fc31f"] forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = [UIColor colorWithHexString:@"#8fc31f"].CGColor;
        self.sepView.hidden = NO;
    }else{
        
        [self.statusBtn setTitle:@"待处理" forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = [UIColor colorWithHexString:@"#d02c30"].CGColor;
        [self.statusBtn setTitleColor:[UIColor colorWithHexString:@"#d02c30"] forState:UIControlStateNormal];

        self.sepView.hidden = YES;
    }
    
    NSArray *picViews =[model.Iconimgs componentsSeparatedByString:@"|"];
    NSMutableArray *oriPArr = [NSMutableArray new];
    for (NSString *pName in picViews) {
        [oriPArr addObject:[NSURL URLWithString:pName]];
    }
    self.dataArray = model.imgs;
    self.commentView.dataArray = model.imgs;
    self.bugImgView.picUrlArray = picViews;
    
//  CGFloat tableViewHeight = 0;
    CGSize maxSize1;
    if ([ETRegularUtil isEmptyString:model.Iconimgs]) {
        
        [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        maxSize1 = CGSizeMake(SCREEN_WIDTH - 15 -15, CGFLOAT_MAX);
        self.imgCountLb.hidden = YES;
    }else{
        
        [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.bugImgView.mas_left).offset(-10);
        }];
        
        maxSize1 = CGSizeMake(SCREEN_WIDTH - 15 -15 - 40 - 10, CGFLOAT_MAX);
        self.imgCountLb.text = [NSString stringWithFormat:@"%@ 张",model.sumCount];
        self.imgCountLb.hidden = NO;
    }
    
    for (NSDictionary *appDict in self.dataArray) {
        
        bugCommentModel *model = [[bugCommentModel alloc]init];
        [model yy_modelSetWithDictionary:appDict];
        [self.sectioNArray addObject:model];
    }

    CGFloat cellHeight = 0;
    if (self.dataArray.count !=0) {
    for (NSDictionary *dict in self.dataArray) {
        
        bugCommentModel *commentModel = [[bugCommentModel alloc]init];
        [commentModel yy_modelSetWithDictionary:dict];
        CGSize maxSize1 = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
 
        // 计算内容label的高度
        NSDictionary *dict1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
        CGRect contenRect1 = [commentModel.content boundingRectWithSize:maxSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil];
        
        cellHeight = cellHeight + contenRect1.size.height + 15 +5;
        }
    }
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(cellHeight);
        make.top.equalTo(self.sepView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

-(CGFloat)cellHeight:(bugListModel *)model indexPath:(NSIndexPath *)indexPath{
    
    self.indexpath = indexPath;
    
    NSArray *picViews =[model.Iconimgs componentsSeparatedByString:@"|"];
    NSMutableArray *oriPArr = [NSMutableArray new];
    for (NSString *pName in picViews) {
        [oriPArr addObject:[NSURL URLWithString:pName]];
    }
    
    self.dataArray = model.imgs;
    self.commentView.dataArray = model.imgs;
    self.bugImgView.picUrlArray = picViews;
    
    CGFloat tableViewHeight = 0;
    CGSize maxSize1;
    if ([ETRegularUtil isEmptyString:model.Iconimgs]) {
        
        maxSize1 = CGSizeMake(SCREEN_WIDTH - 15 -15, CGFLOAT_MAX);
    }else{
    
        maxSize1 = CGSizeMake(SCREEN_WIDTH - 15 -15 - 40 - 10, CGFLOAT_MAX);
    }

    // 计算内容label的高度
    NSDictionary *dict1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
    CGRect contenRect1 = [model.content boundingRectWithSize:maxSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil];
    tableViewHeight += contenRect1.size.height +15 +15 +30;
    
    if (self.dataArray.count !=0) {
        for (NSDictionary *dict in self.dataArray) {
            
            bugCommentModel *commentModel = [[bugCommentModel alloc]init];
            [commentModel yy_modelSetWithDictionary:dict];
            
            CGSize maxSize1 = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
            
            // 计算内容label的高度
            NSDictionary *dict1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
            CGRect contenRect1 = [commentModel.content boundingRectWithSize:maxSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil];
            
            tableViewHeight += contenRect1.size.height +15 +5;
        }
    }       return tableViewHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [self bugCommentHeight];
}

#pragma mark--时间转化的方法
- (NSString *)formateDate:(NSString *)dateString
{
    @try {
        // ------实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里的格式必须和DateString格式一致
        NSDate * nowDate = [NSDate date];
        // ------将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        // ------取当前时间和转换时间两个日期对象的时间间隔
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        // ------再然后，把间隔的秒数折算成天数和小时数：
        NSString *dateStr = [[NSString alloc] init];
        if (time<=60) {  //1分钟以内的
            
            dateStr = @"刚刚";
        }else if(time<=60*60){  //一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
        }else if(time<=60*60*24){  //在两天内的
            
            int hours = time/3600;
            dateStr = [NSString stringWithFormat:@"%d小时前",hours];
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                //在同一年
                [dateFormatter setDateFormat:@"MM-dd HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

@end
