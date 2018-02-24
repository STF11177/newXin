//
//  FilePathUtil.h
//  Anjuke
//
//  Created by omiyang on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilePathUtil : NSObject

+ (NSString *)getPathFromAnyWhere:(NSString *)fileName;
+ (NSString *)getPathFromDocument:(NSString *)fileName;
+ (NSString *)getPathFromDefault:(NSString *)fileName;
+ (NSString *)getPathFromLibraryCache:(NSString *)fileName;

//缓存目录
+ (NSString*)logsDirectory;
@end
