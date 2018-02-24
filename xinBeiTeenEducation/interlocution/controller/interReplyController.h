//
//  interReplyController.h
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^inputFinished)(id content,NSArray *imageArr);
typedef NSArray *(^uploadCompelte)(void);

typedef NS_ENUM(NSUInteger,RichTextType) {
    RichTextType_PlainString=0,
    RichTextType_AttributedString,
    RichTextType_HtmlString,
};

@interface interReplyController : UIViewController

@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *taskStr;

//提示字
@property (nonatomic,copy) IBInspectable NSString * placeholderText;
//文本类型
@property (nonatomic,assign) RichTextType textType;
//完成
@property (nonatomic,copy) inputFinished finished;
//编辑富文本，设置内容
@property (nonatomic,strong) id content;

@property (nonatomic,strong) NSString *from_uid;//被评论者

@end


