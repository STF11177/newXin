//
//  FilePathUtil.m
//  Anjuke
//
//  Created by omiyang on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilePathUtil.h"
@implementation FilePathUtil

+ (NSString *)getPathFromAnyWhere:(NSString *)fileName {
    
    NSString *path = [self getPathFromDocument:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return path;
    }
    else {
        return [self getPathFromDefault:fileName];
    }
}

+ (NSString *)getPathFromDocument:(NSString *)fileName {
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
            stringByAppendingPathComponent:fileName];
}

+(NSString *)getPathFromLibraryCache:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    if ([ETRegularUtil isEmptyString:fileName]) {
        return documentpath;
    }
    return [documentpath stringByAppendingPathComponent:fileName];
}

+ (NSString *)getPathFromDefault:(NSString *)fileName {
    
    if ([fileName rangeOfString:@"."].location != NSNotFound) {
        return [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
    }
    else {
        return @"";
    }
    
}


+ (NSString*)logsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *rootDirectory = [[paths objectAtIndex:0]
                               stringByAppendingPathComponent:@"bike"];
    
    NSString* cachesDirectory = [rootDirectory stringByAppendingPathComponent:@"caches"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:cachesDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:cachesDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    return cachesDirectory;
}

@end
