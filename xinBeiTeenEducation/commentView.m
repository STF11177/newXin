//
//  commentView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "commentView.h"
#import "bugCommentModel.h"
#import "bugListModel.h"
#import "ETRegularUtil.h"

@interface commentView ()
{
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic,strong) NSMutableArray *sectioNArray;
@property (nonatomic,strong) UITableViewCell *tableViewCell;

@end

@implementation commentView
static NSString *contentStr;
//static CGFloat tableViewHeight;

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
    
        self.sectioNArray = [[NSMutableArray alloc]init];
        self.tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.tableFooterView = [[UIView alloc]init];
        [self createBugListModel];
        
        [self addSubview:self.tableView];
        
    }
    return self;
}

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
    
    self.tableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if ([model.status isEqualToString:@"2"]) {
    
        self.tableViewCell.textLabel.text = [NSString stringWithFormat:@"管理员回复我 %@",model.content];
        NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.tableViewCell.textLabel.text];
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5184BC"] range:NSMakeRange(0, 3)];
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5184BC"] range:NSMakeRange(5, 1)];
        self.tableViewCell.textLabel.attributedText = centStr;

    }else{
    
        self.tableViewCell.textLabel.text = [NSString stringWithFormat:@"我回复管理员 %@",model.content];
        NSMutableAttributedString *centStr = [[NSMutableAttributedString alloc]initWithString:self.tableViewCell.textLabel.text];
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5184BC"] range:NSMakeRange(0, 1)];
        [centStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5184BC"] range:NSMakeRange(3, 3)];
        self.tableViewCell.textLabel.attributedText = centStr;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return self.sectioNArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!self.tableViewCell) {
        self.tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
  }

    if (self.sectioNArray.count !=0) {

        bugCommentModel *comment = self.sectioNArray[indexPath.row];
        self.model = comment;
        self.tableViewCell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.tableViewCell.textLabel.numberOfLines = 0;
    }
    
    return self.tableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentLabelTapped:)];
    self.tableViewCell.textLabel.userInteractionEnabled = YES;
    [self.tableViewCell.textLabel addGestureRecognizer:tap];
}

- (void)commentLabelTapped:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(onTapCommentCell)]) {
        [_delegate onTapCommentCell];
    }
}

- (CGFloat)cellHeight{
    
    CGSize maxSize1 = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
    
    // 计算内容label的高度
    NSDictionary *dict1 = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0]};
    CGRect contenRect1 = [self.tableViewCell.textLabel.text boundingRectWithSize:maxSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil];
    _cellHeight = contenRect1.size.height + 15 + 15;
    return _cellHeight;
}

-(void)configCellWithModel{

    CGFloat tableViewHeight = 0;
    for (NSDictionary *dict in self.dataArray) {
        
        bugCommentModel *model = [[bugCommentModel alloc]init];
        [model yy_modelSetWithDictionary:dict];
        CGSize maxSize1 = CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX);
        
        // 计算内容label的高度
        NSDictionary *dict1 = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0]};
        CGRect contenRect1 = [self.tableViewCell.textLabel.text boundingRectWithSize:maxSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil];
        tableViewHeight = contenRect1.size.height + 15 + 15;
        
        DDLog(@"xxxxxxx%lf",tableViewHeight);
        tableViewHeight += tableViewHeight;
        DDLog(@"tableViewHeight:%lf",tableViewHeight);
    }
    DDLog(@"%lf",tableViewHeight);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        [self configCellWithModel];
        return [self cellHeight];
}

@end
