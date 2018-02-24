/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "InvitationManager.h"


@interface InvitationManager (){
    NSUserDefaults *_defaults;
}

@end

static InvitationManager *sharedInstance = nil;
@implementation InvitationManager


+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    if (self = [super init]) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

-(void)addInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username{
    NSData *defalutData = [_defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
    [appleys addObject:applyEntity];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
    [_defaults setObject:data forKey:username];
}

-(void)removeInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username{
    NSData *defalutData = [_defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
    ApplyEntity *needDelete;
    for (ApplyEntity *entity in appleys) {
        if ([entity.applicantUsername isEqualToString:applyEntity.applicantUsername]&&[entity.receiverUsername isEqualToString:applyEntity.receiverUsername]) {
            needDelete = entity;
            break;
        }
    }
    [appleys removeObject:needDelete];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
    [_defaults setObject:data forKey:username];
}

-(NSArray *)applyEmtitiesWithloginUser:(NSString *)username{
    NSData *defalutData = [_defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    return ary;
}

- (void)applyEmtitiesReadStatusWithloginUser:(NSString *)username{
    if (username&&![ETRegularUtil isEmptyString:username]) {
        NSData *defalutData = [_defaults objectForKey:username];
        NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
        for (ApplyEntity *entity in ary) {
            entity.readStatus = @"1";
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ary];
        [_defaults setObject:data forKey:username];
    }
}

@end


@interface ApplyEntity ()<NSCoding>

@end

@implementation ApplyEntity

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_applicantUsername forKey:@"applicantUsername"];
    [aCoder encodeObject:_applicantNick forKey:@"applicantNick"];
    [aCoder encodeObject:_reason forKey:@"reason"];
    [aCoder encodeObject:_readStatus forKey:@"readStatus"];
    [aCoder encodeObject:_receiverUsername forKey:@"receiverUsername"];
    [aCoder encodeObject:_applicantSanp forKey:@"applicantSanp"];
    [aCoder encodeObject:_style forKey:@"style"];
    [aCoder encodeObject:_entityId forKey:@"entityId"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        _applicantUsername = [aDecoder decodeObjectForKey:@"applicantUsername"];
        _applicantNick = [aDecoder decodeObjectForKey:@"applicantNick"];
        _applicantSanp = [aDecoder decodeObjectForKey:@"applicantSanp"];
        _reason = [aDecoder decodeObjectForKey:@"reason"];
        _receiverUsername = [aDecoder decodeObjectForKey:@"receiverUsername"];
        _readStatus = [aDecoder decodeObjectForKey:@"readStatus"];
        _style = [aDecoder decodeObjectForKey:@"style"];
        _entityId = [aDecoder decodeObjectForKey:@"entityId"];
    }
    
    return self;
}

@end

