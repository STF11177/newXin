//
//  RTString.h
//  Anjuke
//
//  Created by Wang Qiansheng on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (ETString)

- (NSString *)stringByDeletingInlegalCharacters;
- (NSUInteger)ASCIILength;
- (BOOL)isEmpty;

- (CGSize)safelySizeWithFont:(UIFont *)font;
- (CGSize)safelySizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)safelySizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size options:(NSStringDrawingOptions )options;

- (NSString *)ucfirst;
- (NSString *) md5;

+ (NSString *)stringWithBool:(BOOL)boolean;

//正则表达式过滤
- (BOOL)isValidNumber;

- (BOOL)isValidEmail;

- (BOOL)isValidPhone;

- (BOOL)isValidPassword;

- (BOOL)isValidRecommend;

- (BOOL)isValidCode;

+ (NSString *)hexStringFromString:(NSString *)string;
@end
