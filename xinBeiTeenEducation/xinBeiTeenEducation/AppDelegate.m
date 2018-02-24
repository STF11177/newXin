//
//  AppDelegate.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "AppDelegate.h"
#import "ETTabBarController.h"
#import "BaseInfoModel.h"
#import "loginMessageController.h"
#import <UserNotifications/UserNotifications.h>
#import <UMSocialCore/UMSocialCore.h>
#import "XMNetWorkHelpManager.h"
#import "WXApi.h"
#import <sys/utsname.h>
#import "UIViewController+mainAction.h"
#import "registerController.h"


#define EaseMobAppKey @"1103170228115680#xinbeieducation"
@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate>
{
    
    AFHTTPRequestOperationManager *_manager;
    
}

@end

@implementation AppDelegate
static NSString *userId;
static NSString *tokenStr;
static NSString *messageStr;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //运营商，电池变为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self createHttpRequest];
    [self loadCurrentVersion];
    [XMNetWorkHelpManager sharedManager];
    
    /* 打开日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    // 打开图片水印
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58d1ecafc895761a54002594"];
    
    //微信注册appId
    [WXApi registerApp:@"wxd7cf604bab22c904"];
    
    [self configUSharePlatforms];
    [self confitUShareSettings];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults objectForKey:@"userName"];
    
    if (userId) {
        
      ETTabBarController *tab = [[ETTabBarController alloc]init];
        
      self.window.rootViewController = tab;
    }else{

            loginMessageController *login = [[loginMessageController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
         
            self.window.rootViewController = nav;
        }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    
    return UIStatusBarStyleLightContent;
}

-(void)createHttpRequest{
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

//获取当前的版本号
-(void)loadCurrentVersion{

    NSDictionary *param = @{};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    NSData *baseData = [jsonData base64EncodedDataWithOptions:0];
    NSString *jsonString = [[NSString alloc]initWithData:baseData encoding:NSUTF8StringEncoding];
    
    DDLog(@"%@",jsonString);
    [_manager POST:currentVersionURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DDLog(@"下载成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DDLog(@"dict:%@",dict);
        
        NSDictionary *result = dict[@"results"];
        int status = [dict[@"status"]intValue];
        if (status == 0) {
            
            NSString *str = result[@"versionName"];
            messageStr = result[@"msg"];
            DDLog(@"%@",str);
            
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            //当前版本号
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            DDLog(@"xxxxxxxxxx%@",currentVersion);

            NSString *outString = [NSString stringWithFormat:@"%@",result[@"out"]];
            NSString *versionBuild = [NSString stringWithFormat:@"%@",result[@"versionNum"]];
            
            NSArray *array = [currentVersion componentsSeparatedByString:@"."];
            float str1 = [array[0] floatValue];
            float str2 = [array[1] floatValue];
            float str3 = [array[2] floatValue];
            float currentFloat = str1 + str2 + str3;
            
            NSArray *array1 = [versionBuild componentsSeparatedByString:@"."];
            float str4 = [array1[0] floatValue];
            float str5 = [array1[1] floatValue];
            float str6 = [array1[2] floatValue];
            float versionFloat = str4 + str5 + str6;
            
            DDLog(@"currentFloatxxxxxxxx%lf",currentFloat);
            DDLog(@"versionFloatyyyyyyy%lf",versionFloat);
            
            if (currentFloat < versionFloat) {
                
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"有新的版本"message:messageStr preferredStyle:UIAlertControllerStyleAlert];
        
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    //跳转到AppStore，该App下载界面
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1239366047"]];
                }];
                
                [alertControl addAction:action1];
                
                [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertControl animated:YES completion:nil];
                
            }else{
            
                //改变versionName可以知道提示更新和强制更新，versionName是指最新的版本
                if ([outString isEqualToString:@"0"]) {
                    if(![currentVersion isEqualToString:str])
                    {
                        
                        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"有新的版本"message:messageStr preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            //跳转到AppStore，该App下载界面
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1239366047"]];
                        }];
                        
                        [alertControl addAction:action];
                        [alertControl addAction:action1];
                        
                        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertControl animated:YES completion:nil];
                    }else{
                        
                        DDLog(@"检测到不需要更新");
                    }
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
//    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
//    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)onResp:(BaseResp *)resp
{
    //支付返回结果，实际支付结果需要去微信服务器端查询
    NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
    switch (resp.errCode) {
        case WXSuccess:
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            
            break;
        default:
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            break;
    }
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxd7cf604bab22c904" appSecret:@"953b71a97b02be19cc8308d40a51c8b9" redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106358422"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}

//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
         [WXApi handleOpenURL:url delegate:self];
        
    }
    return result;
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
         [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        return [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}

-(void)applicationWillEnterForeground:(UIApplication *)application {
      //该方法中我们经常用来取消在程序进入后台的时候执行的操作。

    [self loadCurrentVersion];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}


- (ETTabBarController *)tabBarController {
    if (_tabBarController == nil){
        _tabBarController = [[ETTabBarController alloc] init];
        
    }
    return _tabBarController;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController {
    
   [XMNetWorkHelpManager sharedManager];
    
    return YES;
}

@end
