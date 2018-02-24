//
//  keyBoardView.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/11/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import "keyBoardView.h"
#import "MyTool.h"

#define BgColor [UIColor colorWithRed:245/255. green:240/255. blue:235/255. alpha:.8]
#define DefaultHeight 44.0f
#define MaxHeight 200.0f
#define ImageHeight 75.0f

@interface keyBoardView()<UITextViewDelegate>
{
    CGFloat _keyboardY;
    UIView* _coverView;
}

@property (nonatomic, strong)UILabel*       placeholderLabel;
@property (nonatomic, strong)UIImageView*   selectedImage;
@property (nonatomic, strong)UIView*        selectedBg;
@property (nonatomic, strong)UIView*        textBgView;

@property (nonatomic, strong)UIButton*      postBtn;

@end

@implementation keyBoardView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = BgColor;
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOpacity = 0.5;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    CGRect frame = self.frame;
    
    _postBtn = [MyTool createButtonWithFrame:CGRectMake(frame.size.width - 58, 0, 58, frame.size.height) WithTitle:@"发送" WithTitleColor:[UIColor colorWithRed:162/255. green:158/255. blue:153/255. alpha:1.] WithIsRound:NO];
    [_postBtn addTarget:self action:@selector(postBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_postBtn];
    _postBtn.enabled = NO;
    _postBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    _textBgView = [[UIView alloc]initWithFrame:CGRectMake(20, 6, frame.size.width-10 - _postBtn.frame.size.width,frame.size.height - 6*2)];
    _textBgView.backgroundColor = [UIColor whiteColor];
    _textBgView.layer.cornerRadius = 5;
    [self addSubview:_textBgView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, _textBgView.frame.size.width - 10, _textBgView.frame.size.height)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.tintColor = [UIColor lightGrayColor];
    _textView.font = [UIFont systemFontOfSize:14.f];
    _textView.delegate = self;
    _textView.editable = YES;
    [_textBgView addSubview:_textView];
    
    CGRect rect = [_textView caretRectForPosition:_textView.endOfDocument];
    _placeholder = @"写评论...";
    _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rect), 0, _textView.frame.size.width, _textView.frame.size.height)];
    [_textView addSubview:_placeholderLabel];
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.font = _textView.font;
    _placeholderLabel.text = _placeholder;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_textBgView addGestureRecognizer:tap];
}

#pragma mark -- 属性
-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
}

-(void)tapClick:(UITapGestureRecognizer*)sender
{
    [self changeInputViewWith:nil];
}

-(void)changeInputViewWith:(UIView*)inputView{
    
    [UIView animateWithDuration:0.1 animations:^{
        
        if ([_textView isFirstResponder]) {
            
            [_textView resignFirstResponder];
        }
        [_textView resignFirstResponder];
        _textView.inputView = inputView;
        [_textView becomeFirstResponder];
        [_textView.inputView reloadInputViews];
    }];
}

-(void)postBtnClick:(UIButton *)btn{
    
    [self removeSelectedBg];
    [_textView resignFirstResponder];
//  [self adjustKeyboardFrame:_textView];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onCommentInKeyBoard:)]) {
        [_delegate onCommentInKeyBoard:self];
    }
}

-(void)adjustKeyboardFrame:(UITextView*)textView
{
    //获取内容大小
    CGSize contentSize = textView.contentSize;
    
    //获取textView的frame
    CGRect textFrame=textView.frame;
    UIView* superView = [textView superview];
    CGRect superFrame = superView.frame;
    CGRect selfFrame = self.frame;
    
    //如果内容超过textView
    if(contentSize.height > textFrame.size.height && selfFrame.size.height < MaxHeight)
    {
        CGFloat difference =  contentSize.height - textFrame.size.height;
        if ((selfFrame.size.height + difference) > MaxHeight)
        {
            difference = MaxHeight - selfFrame.size.height;
            
            selfFrame.size.height = MaxHeight;
            selfFrame.origin.y    -= difference;
            
            self.frame = selfFrame;
            textFrame.size.height += difference;
            superFrame.size.height += difference;

            textView.frame = textFrame;
            superView.frame = superFrame;
            return;
        }
        
        //增加textView的height
        textFrame.size.height += difference;
        superFrame.size.height += difference;
        
        selfFrame.size.height += difference;
        selfFrame.origin.y    -= difference;
        
        textView.frame = textFrame;
        superView.frame = superFrame;
        
        self.frame = selfFrame;
    }
    else if(contentSize.height < textFrame.size.height && selfFrame.size.height > DefaultHeight)//44键盘初始化高度
    {
        CGFloat difference =  textFrame.size.height - contentSize.height;
        
        //减小textView的height
        selfFrame.size.height -= difference;
        if (selfFrame.size.height <= DefaultHeight)
        {
            difference = DefaultHeight - selfFrame.size.height;
            selfFrame.size.height = DefaultHeight;
            selfFrame.origin.y -= difference;
            self.frame = selfFrame;
            
            textFrame.size.height += difference;
            superFrame.size.height += difference;
            
            textView.frame = textFrame;
            superView.frame = superFrame;
            
            return;
        }
        
        textFrame.size.height -= difference;
        superFrame.size.height -= difference;
        selfFrame.origin.y += difference;
        textView.frame = textFrame;
        superView.frame = superFrame;
        self.frame = selfFrame;
    }
}

-(void)removeSelectedBg
{
    _selectedImage.image = nil;
    if (_textView.text.length == 0)
    {
        _postBtn.enabled = NO;
    }
    if (![_selectedBg isDescendantOfView:self])
    {
        return;
    }
    [_selectedBg removeFromSuperview];
    
    CGRect textBgFrame   = _textBgView.frame;
    CGRect textViewFrame = _textView.frame;
    CGRect selfFrame     = self.frame;
    
    textBgFrame.size.height -= ImageHeight;
    textViewFrame.origin.y  -= ImageHeight;
    selfFrame.origin.y      += ImageHeight;
    selfFrame.size.height   -= ImageHeight;
    
    _textBgView.frame = textBgFrame;
    _textView.frame   = textViewFrame;
    self.frame        = selfFrame;
}

#pragma mark -- textView 代理事件
-(void)textViewDidChange:(UITextView *)textView{
    
    [self adjustPlaceholderLabelHidden:textView];
    if (textView.text.length == 0 && !_selectedImage.image){
        _postBtn.enabled = NO;
        
        [self adjustKeyboardFrame:textView];
    }else{
        
        [_postBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _postBtn.enabled = YES;
    }
}

-(void)adjustPlaceholderLabelHidden:(UITextView*)textView{
    
    if (textView.text.length > 0){
        
        _placeholderLabel.hidden = YES;
    }else{
        
        _placeholderLabel.hidden = NO;
    }
}

-(void)keyBoardFrame:(UITextView*)textView{
    
    CGFloat margin;
    CGSize contentSize = textView.contentSize;
    CGRect textFrame = textView.frame;
    CGRect selfFrame = self.frame;
    
    if (contentSize.height >textFrame.size.height && selfFrame.size.height <200) {
        
        margin = contentSize.height - textFrame.size.height;
        if ((selfFrame.size.height +margin) >200) {
            
            margin = 200 - selfFrame.size.height;
            selfFrame.size.height = MaxHeight;
            selfFrame.origin.y    -= margin;
            self.frame = selfFrame;
            textFrame.size.height += margin;
            textView.frame = textFrame;
            return;
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    
    return YES;
}

@end
