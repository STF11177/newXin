//
//  ETBaseData.m
//  iYepu
//
//  Created by Omiyang on 13-11-26.
//  Copyright (c) 2013年 Omiyang. All rights reserved.
//

#import "ETBaseData.h"
//#import "ETCore.h"


@implementation ETBaseData 


//- (ObjectMapping *)objectMapping{
//    ObjectMapping *mapping = [ObjectMapping mappingForClass:[self class]];
//    
//    for (NSDictionary *c in self.columns) {
//        [mapping converEntityFromJsonToEntity:[c objectForKey:@"key"] to:[c objectForKey:@"prop"] withClass: [c objectForKey:@"class"]];
//    }
//    return mapping;
//}

//- (NSString *)toString {
//    NSString *className = NSStringFromClass([self class]);
//    NSMutableString *content = [NSMutableString string];
//
//    for (NSDictionary *c in self.columns) {
//        SEL selector = NSSelectorFromString([c objectForKey:@"prop"]);
//        
//        id value;
//        SuppressPerformSelectorLeakWarning(
//           value = [self performSelector:selector];
//        );
//        [content appendFormat:@" <%@:%@>", [c objectForKey:@"prop"], value];
//    }
//    return [NSString stringWithFormat:@"[%@] %@", className, content];
//}
//
//- (NSString *)toJson {
//    return [[self toDictionary] JSONRepresentation];
//}
//
//- (NSMutableDictionary *)toDictionary {
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    
//    for (NSDictionary *c in self.columns) {
//        SEL selector = NSSelectorFromString([c objectForKey:@"prop"]);
//
//        id object;
//        SuppressPerformSelectorLeakWarning(
//           object = [self performSelector:selector];
//        );
//        if (object != nil) {
//            if ([object isKindOfClass:[NSArray class]]) {
//                object = [self toArray:object];
//            }
//            if ([object isKindOfClass:[ETBaseData class]]) {
//                object = [object toDictionary];
//            }
//            [dict setObject:object forKey:[c objectForKey:@"key"]];
//        }
//    }
//    return dict;
//}
//
//- (NSMutableArray *)toArray:(NSArray *)data {
//    NSMutableArray *result = [NSMutableArray array];
//    if (data.count>0) {
//        for (NSObject *item in data) {
//            if ([item isKindOfClass:[ETBaseData class]]) {
//                [result addObject:[(ETBaseData *)item toDictionary]];
//                continue;
//            }
//            if ([item isKindOfClass:[NSArray class]]) {
//                [result addObject:[self toArray:(NSArray *)item]];
//                continue;
//            }
//            [result addObject:item];
//        }
//    }
//    return result;
//}
@end
