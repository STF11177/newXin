//
//  DetailCell.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/5/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.array = [[NSMutableArray alloc]init];
        self.btnArray = [[NSMutableArray alloc]init];
        [self createBtn];
        
    }
    return self;
}

-(void)createBtn{

    self.categoryLb = [[UILabel alloc]initWithFrame:CGRectMake( 10, 10, SCREEN_WIDTH, 30)];
    self.categoryLb.text = @"类别";
    [self addSubview:self.categoryLb];
    
    self.sepeView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
    self.sepeView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self addSubview:self.sepeView];
    
    CGFloat olderWith = 0;//保存前一个button的宽及前一个button距离屏幕边缘的距离
    CGFloat height = 71;//用来控制button的距离父视图的高
    for (int i = 0; i< self.btnArray.count; i++) {
        
        self.categoryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.categoryBtn.tag = 101 +i;
        self.categoryBtn.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
//        [self.categoryBtn addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.categoryBtn setTitle:self.btnArray[i] forState:UIControlStateNormal];
       //计算文字的大小
       NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
       CGFloat length = [self.btnArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size.width;
        
        self.categoryBtn.frame = CGRectMake(10 + olderWith, height, length + 30, 30);
        //当button的位置超出屏幕边缘时换行，SCREEN_WIDTH只是button所在父视图的宽度
        if ( 10 + olderWith +length +30 >SCREEN_WIDTH) {
            olderWith = 0;//换行时将olderWith置为0
            height = height +self.categoryBtn.frame.size.height +10;
            self.categoryBtn.frame = CGRectMake( 10 +olderWith, height, length +20, 30);//重设button的frame
        }
        
        olderWith = self.categoryBtn.frame.size.width + self.categoryBtn.frame.origin.x;
        [self addSubview:self.categoryBtn];
    }
}

-(void)categoryClick:(UIButton *)btn{
    
    if (!btn.selected) {
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#f2f2f2"]];
        [self.array addObject:[NSNumber numberWithInteger:btn.tag - 100]];
        
    }else{
        [btn setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        if ([self.array containsObject:[NSNumber numberWithInteger:btn.tag - 100]]) {
            [self.array removeObject:[NSNumber numberWithInteger:btn.tag - 100]];
        }
    }
    
    btn.selected = !btn.selected;
//    DDLog(@"%@", self.array.description);
//    DDLog(@"%ld",btn.tag-100);
}

-(void)blockReturnSelectedBtn:(blockReturnSelectedBtn)block{

    _block = block;
}

@end
