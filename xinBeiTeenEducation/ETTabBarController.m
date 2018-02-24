//
//  ETTabBarController.m
//  xinBeiTeenEducation
//
//  Created by user on 2017/3/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ETTabBarController.h"
#import "parentsCircleController.h"
#import "textualResearchController.h"
#import "hotAticleController.h"
#import "parentOffspingController.h"
#import "mineViewController.h"
#import "newController.h"
#import "XMNetWorkHelpManager.h"
#import "UITabBar+badge.h"
#import "eBookController.h"
#import "interlocutionController.h"

@interface ETTabBarController ()<UITabBarDelegate>

//@property(nonatomic,strong) UITabBar *tabBar;

@end

@implementation ETTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createViewControllers];
    [XMNetWorkHelpManager sharedManager];
}

-(void)createViewControllers{

    NSArray *imagesNames =@[@"index",@"textual",@"text",@"education",@"me"];
    NSArray *viewControllers =@[@"new",@"interlocution",@"hotAticle",@"eBook",@"mineView"];
    NSArray *titles =@[@"家长圈",@"考证",@"热文",@"图书",@"我"];
    
    NSMutableArray *arry =[[NSMutableArray alloc]init];
    for (int i = 0; i<imagesNames.count; i++) {
        
        NSString *className = [viewControllers[i] stringByAppendingString:@"Controller"];
        Class vcClass = NSClassFromString(className);
        
        UIViewController *viewController =[[vcClass alloc]init];
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:viewController];
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#006fcd"]];
        nav.tabBarItem.image = [[UIImage imageNamed:imagesNames[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:[imagesNames[i] stringByAppendingString:@"2"]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.title =titles[i];
        nav.tabBarItem.tag = i;
        self.tabBar.backgroundColor = [UIColor colorWithHexString:@"#f5f5f7"];
        self.tabBar.tintColor =[UIColor colorWithHexString:@"#29a1f7"];
        [arry addObject:nav];
        [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    }

    self.viewControllers = arry;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{

    if (item.tag == 0) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"parentRefresh" object:nil userInfo:nil];
    }else if (item.tag == 2){
    
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hotRefresh" object:nil userInfo:nil];
    }else if (item.tag == 1){
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"testRefresh" object:nil userInfo:nil];
    }else{
    
    }
}

//禁止tab多次点击
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UIViewController *tbselect=tabBarController.selectedViewController;
    if([tbselect isEqual:viewController]){
        return NO;
    }
    return YES;
}

+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

@end
