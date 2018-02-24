//
//  UIViewController+mainAction.m
//  Bike
//
//  Created by Enjoytouch on 16/4/21.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

@implementation UIViewController (mainAction)

//提示框
- (void)showAlertWithMessage:(NSString *)message{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
    
}



//有确定和取消按钮
- (void)showAlertWithMessage:(NSString *)message tag:(NSInteger)tag{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alert.tag = tag;
    [alert show];

}

//有确定和取消按钮------有输入框
- (void)showInputAlertWithMessage:(NSString *)message title:(NSString *)title tag:(NSInteger)tag{
    
//    MemberData * member = [AppDataCenter getLoginMember];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = tag;
    
    if (tag==666666) {
        //修改昵称
        UITextField *textField = [alert textFieldAtIndex:0];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        textField.text = member.nickName;
        
    }else if(tag==10013||tag==10014){
        //其他
        UITextField *textField = [alert textFieldAtIndex:0];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;

    }else{
        //其他
        UITextField *textField = [alert textFieldAtIndex:0];
        textField.placeholder = message;
    }
    
    [alert show];
    
}


//有确定和取消按钮------有输入框
- (void)showInputAlertWithMessage:(NSString *)message tag:(NSInteger)tag{
    
//    MemberData * member = [AppDataCenter getLoginMember];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = tag;
    
    if (tag==666666) {
        //修改昵称
        UITextField *textField = [alert textFieldAtIndex:0];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
//        textField.text = member.nickName;
       
    }else{
        //其他
        UITextField *textField = [alert textFieldAtIndex:0];
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.placeholder = message;
    }

    [alert show];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            [textField resignFirstResponder];
            
        }
        [self performCancelActionWithTag:alertView.tag];
        
    }
    
    
    if (buttonIndex == 1) {
        if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            [textField resignFirstResponder];
            [self performInputAlertViewWitnSureAction:textField.text tag:alertView.tag];
            
        }else{
            
            [self performSureActionWithTag:alertView.tag];
            
        }
        
    }
    
}

- (void)showAlert:(NSString *)message withBtnTitles:(NSArray *)titles{
    
    CommonAlert *alert = [[CommonAlert alloc]initWithMessage:message withBtnTitles:titles];
    if (titles) {
        alert.delegate = self;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:alert];//edit by fang
}

- (void)showAlert:(NSString *)message withBtnTitles:(NSArray *)titles tag:(NSInteger)tag{
    
    CommonAlert *alert = [[CommonAlert alloc]initWithMessage:message withBtnTitles:titles];
    if (titles) {
        alert.delegate = self;
    }
    alert.tag = tag;
    [[UIApplication sharedApplication].keyWindow addSubview:alert];//edit by fang
}

- (void)showAlertWithBtnTitles:(NSArray *)titles{

    CommonAlert *alert = [[CommonAlert alloc]initWithModifiedInforWithBtnTitles:titles andWithmessage:nil];
    [alert.textField becomeFirstResponder];
//    MemberData *member = [AppDataCenter getLoginMember];
//    alert.textField.text = member.nickName;
    if (titles) {
        alert.delegate = self;
    }
   [[UIApplication sharedApplication].keyWindow addSubview:alert];
}

- (void)showAlertSendMessage:(NSString *)message Titles:(NSArray *)titles{
    
    CommonAlert *alert = [[CommonAlert alloc]initWithSendMessage:message Titles:titles];
    [alert.textField becomeFirstResponder];
    if (titles) {
        alert.delegate = self;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
}

- (void)itemCancel:(CommonAlert *)alert{}

- (void)itemCertain:(CommonAlert *)alert{}


- (void)performCancelActionWithTag:(NSInteger )tag{}
- (void)performSureActionWithTag:(NSInteger )tag{}
- (void)performInputAlertViewWitnSureAction:(NSString *)text tag:(NSInteger)tag{};
@end
