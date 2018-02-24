//
//  interReplyController.m
//  xinBeiTeenEducation
//
//  Created by user on 2018/1/2.
//  Copyright © 2018年 user. All rights reserved.
//

#import "interReplyController.h"
#import "interReplyView.h"
#import "interKeyBoardView.h"
#import "CommonSheet.h"
#import "AlbumController.h"
#import "ImageTextAttachment.h"
#import "utility.h"

//Image default max size，图片显示的最大宽度
#define IMAGE_MAX_SIZE (100)

#define DefaultFont (16)
#define MaxLength (2000)

#define userDefault [NSUserDefaults standardUserDefaults]
@interface interReplyController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,interKeyBoardViewDelegate,CommonSheetDelegate,UITextViewDelegate,AlbumControllerDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    BOOL _isHide;
    
}
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UITextView *contentView;
@property (nonatomic,strong) interReplyView *replyView;
@property (nonatomic,strong) interKeyBoardView *keyBoardView;
@property (nonatomic,strong) UILabel *placeholderLabel;

@property (nonatomic,strong) NSMutableDictionary *mutImgDict;
@property (nonatomic,strong) NSMutableArray *seletImgArray;
@property (nonatomic,strong) NSMutableArray *mutImgArray;
@property (nonatomic,strong) NSMutableArray *htmlImgArray;//最终确定照片URl数组 html
@property (nonatomic,strong) NSMutableArray *imgArray;
@property (nonatomic,assign) BOOL isDelete;        //是否是回删
@property (nonatomic,assign) NSRange newRange;     //记录最新内容的range
@property (nonatomic,strong) NSString * newstr;    //记录最新内容的字符串

//纪录变化时的内容，即是
@property (nonatomic,strong) NSMutableAttributedString * locationStr;

@end

@implementation interReplyController
static NSString *bottomSignStr;
static NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createHttp];
    [self createNav];
    
    userId = [userDefault objectForKey:@"userName"];
    DDLog(@"%@",self.titleStr);
    
    self.replyView.titleLable.text = self.titleStr;
    CGFloat replyFloat = [self.replyView cellHeightWithString:self.replyView.titleLable.text
                          ];
    self.replyView.frame = CGRectMake(0, 64, ScreenWidth, replyFloat +30);
    [self.view addSubview:self.replyView];
    
    _titleLable.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.replyView];
    [self.view addSubview:self.contentView];

    self.keyBoardView.frame = CGRectMake( 0, ScreenHeight, ScreenWidth, 44);
    [[UIApplication sharedApplication].keyWindow addSubview:self.keyBoardView];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHiden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.keyBoardView becomeFirstResponder];
    [self.contentView becomeFirstResponder];
}

#pragma mark --电池的颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    
    return UIStatusBarStyleDefault;
}

-(void)createHttp{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)createNav{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"填写回答";
    lable.font = [UIFont systemFontOfSize:20];
    lable.textColor = [UIColor blackColor];
    self.navigationItem.titleView = lable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 10, 60, 50, 50)];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
}

-(interReplyView *)replyView{
    
    if (!_replyView) {
        
        _replyView = [[interReplyView alloc]init];
    }
    return _replyView;
}

-(UITextView *)contentView{
    
    if (!_contentView) {
        
        _contentView = [[UITextView alloc]initWithFrame:CGRectMake(0,70 +self.replyView.height, ScreenWidth, ScreenHeight -70 - self.replyView.height)];
        _contentView.font = [UIFont systemFontOfSize:17];
        _contentView.delegate = self;
    }
    return  _contentView;
}

-(UILabel *)placeholderLabel{
    
    if (!_placeholderLabel) {
        
        _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH -5, 34)];
        _placeholderLabel.text = @"撰写回答";
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:17];
    }
    return _placeholderLabel;
}

-(NSMutableDictionary *)mutImgDict{
    
    if (!_mutImgDict) {
        
        _mutImgDict = [[NSMutableDictionary alloc]init];
    }
    return _mutImgDict;
}

-(NSMutableArray *)mutImgArray{
    
    if (!_mutImgArray) {
        
        _mutImgArray = [[NSMutableArray alloc]init];
    }
    return _mutImgArray;
}

-(NSMutableArray *)seletImgArray{
    
    if (!_seletImgArray) {
        
        _seletImgArray = [[NSMutableArray alloc]init];
    }
    return _seletImgArray;
}

-(NSMutableArray *)htmlImgArray{
    
    if (!_htmlImgArray) {
        
        _htmlImgArray = [[NSMutableArray alloc]init];
    }
    return _htmlImgArray;
}

-(NSMutableArray *)imgArray{
    
    if (!_imgArray) {
        
        _imgArray = [[NSMutableArray alloc]init];
    }
    return _imgArray;
}

-(interKeyBoardView *)keyBoardView{
    
    if (!_keyBoardView) {
        
        _keyBoardView = [[interKeyBoardView alloc]init];
        _keyBoardView.delegate = self;
        _keyBoardView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    }
    return _keyBoardView;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (self.contentView.attributedText.length>0) {
        
        self.placeholderLabel.hidden=YES;
    }else{
        
        self.placeholderLabel.hidden=NO;
    }
}

#pragma  mark - **************AlbumControllerDelegate************
- (void)selectedImagesFinished:(NSMutableArray *)images{
    
    [self.seletImgArray safelyAddObjectsFromArray:images];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    if (self.contentView.textStorage.length>0) {
       
//        [self appenReturn];
    }
    
    //    上传照片
    NSMutableArray *images = [NSMutableArray arrayWithObject:@[image,@"jpeg"]];
 
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
    
    NSString *iconString;
    NSMutableArray *uploadDatas = [NSMutableArray array];
    for (NSArray *item in images) {
        NSData *data;
        id meta = [item firstObject];
        NSString *type = [item lastObject];
        
        if ([meta isKindOfClass:[NSData class]]) {
            [uploadDatas safelyAddObject:@[meta,type]];
            continue;
        }
        
        UIImage *image =meta;
        CGSize imgSize = image.size;
        
        if ([@"png" isEqualToString:[item lastObject]]) {
            data = [self imageWithImage:image scaledToSize:imgSize toCompression:1.0 isPngType:YES];
            if (data.length>300000) {
                data = [self getJpegTypeScaleImageWithImage:data toMaxFileSize:300000];
            }
        }else{
            data = [self imageWithImage:image scaledToSize:imgSize toCompression:1.0 isPngType:NO];
            if (data.length>300000) {
                data = [self getJpegTypeScaleImageWithImage:data toMaxFileSize:300000];
            }
        }
        
        iconString = [data base64EncodedStringWithOptions:0];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *param = @{@"userId":userId,@"iconString":iconString,@"imageType":@""};
        [self createPictureWithParam:param];
        //图片添加后 自动换行
        [self setImageText:image withRange:self.contentView.selectedRange appenReturn:YES];
        
        self.contentView.font = [UIFont systemFontOfSize:17];
        [self.content becomeFirstResponder];
    });
    });
}


//设置图片
-(void)setImageText:(UIImage *)img withRange:(NSRange)range appenReturn:(BOOL)appen
{
    
    UIImage * image=img;
    
    if (image == nil){
        
        return;
    }
    
    if (![image isKindOfClass:[UIImage class]])           // UIImage资源
    {
        
        return;
    }
    

    CGFloat ImgeHeight=((self.view.frame.size.width - 10)/ img.size.width) * img.size.height;
    
    
    ImageTextAttachment *imageTextAttachment = [ImageTextAttachment new];
    
    //Set tag and image
    imageTextAttachment.imageTag = RICHTEXT_IMAGE;
    imageTextAttachment.image =image;
    
    //Set image sizexaaaaaaaa
    imageTextAttachment.imageSize = CGSizeMake(SCREEN_WIDTH - 10, ImgeHeight);
    
    
    if (appen) {
    //Insert image image
    [_contentView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]
                                              atIndex:range.location];
    }else{
        
    if (_contentView.textStorage.length>0) {
        
    [_contentView.textStorage replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]];
        }
    }
    _contentView.selectedRange = NSMakeRange(range.location + 1, range.length);
    if(appen){
        
//   [self appenReturn];
    }
}

-(void)appenReturn
{
    NSAttributedString * returnStr=[[NSAttributedString alloc]initWithString:@"\n"];
    NSMutableAttributedString * att=[[NSMutableAttributedString alloc]initWithAttributedString:_contentView.attributedText];
    [att appendAttributedString:returnStr];
    
    _contentView.attributedText=att;
}

//上传照片
- (void)uploadPicture:(UIImage *)image
{
    //此处是上传单张图片   ------ 等上传成功后按照下面去存储数据
    /*
     NSDictionary *rawDic = (NSDictionary *)responseObject;
     NSDictionary *infoDic = [rawDic objectForKey:@"info"];
     
     NSString *url = [infoDic valueForKey:@"url"];
     [self.mutImgDict setValue:image forKey:url];
     [self.textView becomeFirstResponder];
     */
}

//根据屏幕宽度适配高度
- (CGFloat)getImgHeightWithImg:(UIImage *)img{
    
    CGFloat height = ((self.view.frame.size.width - 10)/ img.size.width) * img.size.height;
    return height;
}

-(void)presentVC{
    
    _isHide = YES;
    _keyBoardView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 44);
    [_contentView resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSString *)attriToStrWithAttri:(NSAttributedString *)attri{
    NSDictionary *tempDic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [attri dataFromRange:NSMakeRange(0, attri.length)
                         documentAttributes:tempDic
                                      error:nil];
    return [[NSString alloc] initWithData:htmlData
                                 encoding:NSUTF8StringEncoding];
}

-(void)sendMessage{
    
    NSString *str = [_contentView.attributedText getPlainString];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
   
    // *  获取带有图片标示的一个普通字符串
    NSArray *contentArray = [str1 componentsSeparatedByString:RICHTEXT_IMAGE];

    DDLog(@"%@",contentArray);
    
    NSString * newContent=@"";
    for (int i=0; i<contentArray.count; i++) {
        
        NSString * imgTag=@"";
        if (i<contentArray.count-1) {
            //这是用url 地址替换 图片标示 imgTag=urlarr[i];
            imgTag= self.htmlImgArray[i];
        }
        
        //因为cutstr 可能是null
        NSString *str = @"<p>";
        NSString * cutStr=[contentArray objectAtIndex:i];
        cutStr = [str stringByAppendingString:cutStr];
        cutStr = [cutStr stringByAppendingString:@"</p>"];
        newContent=[NSString stringWithFormat:@"%@%@%@",newContent,cutStr,imgTag];
        
    }
  
    NSString *imgStr ;
    if (self.imgArray.count ==0) {
        
        imgStr = @"";
    }else{
        
        imgStr = self.imgArray[0];
    }
    
    if ((self.contentView.text.length - self.htmlImgArray.count) == 0) {
        
        self.contentView.text = @"";
    }
    
    NSDictionary *param = @{@"userId":userId,@"from_userId":self.from_uid,@"taskId":self.taskStr,@"content":newContent,@"comment_id":@"",@"attachedContent":self.contentView.text,@"commentImg":imgStr};

    [self createMessageWithParam:param];
}

//把最新内容都赋给self.locationStr
-(void)setInitLocation{
    
    self.locationStr=nil;
    self.locationStr=[[NSMutableAttributedString alloc]initWithAttributedString:self.contentView.attributedText];
}

#pragma mark -- 发布消息
-(void)createMessageWithParam:(NSDictionary *)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    [_manager POST:interSendMessageURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:NO];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark -- 上传图片
-(void)createPictureWithParam:(NSDictionary*)param{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    [_manager POST:interUploadPictureURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        dispatch_async(dispatch_get_main_queue(), ^{
  
            NSString *imgStr = [NSString stringWithFormat:@"%@",dict[@"imgUrl"]];
            [self.imgArray addObject:imgStr];
            
            
            NSString *imageStr = [NSString stringWithFormat:@"<img src=\"%@\">",imgStr];
            [self.htmlImgArray addObject:imageStr];
            DDLog(@"%@",_htmlImgArray);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ETMessageView sharedInstance] showMessage:@"网络不佳，请稍后尝试" onView:self.view withDuration:1.0];
    }];
}

#pragma mark --键盘隐藏出现通知
-(void)keyBoardHiden:(NSNotification*)noti
{
    _isHide = YES;
    _keyBoardView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 44);
    self.contentView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)keyBoardShow:(NSNotification*)noti
{
    NSDictionary *dict = noti.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];

    CGRect textFieldRect = CGRectMake(0, rect.origin.y - 44, rect.size.width, 44);

    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }

    self.contentView.contentInset=UIEdgeInsetsMake(0, 0,rect.size.height +44, 0);
    [UIView animateWithDuration:0.25 animations:^{
        _keyBoardView.frame = textFieldRect;
    }];
    _isHide = NO;
}

-(void)backInView:(interKeyBoardView *)View {
    
    _isHide = YES;
    _keyBoardView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 44);
    [_contentView resignFirstResponder];
}

-(void)showPictureInView{
    
    /* 相册 */
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;

    //设置选择后的图片可被编辑
    [self presentViewController:picker animated:YES completion:nil];
}

//JPEG及其它类型的图片压缩
- (NSData *)getJpegTypeScaleImageWithImage:(NSData *)imageData toMaxFileSize:(NSInteger)maxFileSize{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    
    if ([imageData length] > maxFileSize){
        UIImage *imageTemp = [UIImage imageWithData:imageData];
        while ([imageData length] > maxFileSize && compression > maxCompression) {
            imageData = UIImageJPEGRepresentation(imageTemp, compression);
            compression -= 0.1;
        }
    }
    return imageData;
}

//图片大小压缩
- (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize toCompression:(CGFloat)compression isPngType:(BOOL)type;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (type)
        return UIImagePNGRepresentation(newImage);
    return UIImageJPEGRepresentation(newImage, compression);
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
