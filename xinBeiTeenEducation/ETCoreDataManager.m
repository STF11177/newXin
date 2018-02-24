//
//  CoreDataManager.m
//  AnjukeBroker
//
//  Created by zheng yan on 12-5-31.
//  Copyright (c) 2012年 anjuke. All rights reserved.
//

#import "ETCoreDataManager.h"

@implementation ETCoreDataManager
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize modelName = _modelName;

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static ETCoreDataManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[ETCoreDataManager alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelName withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
    
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSString *modelSqlite = [NSString stringWithFormat:@"%@.sqlite", self.modelName];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:modelSqlite];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - self search

- (NSObject *)getOneWithEntity:(NSString *)entityName
                     predicate:(NSString *)predicateName
                          sort:(NSString *)sortName
                     ascending:(BOOL)ascending {
    NSArray *result = [self fetchObjectsWithEntity:entityName predicate:predicateName sort:sortName ascending:ascending];
    if ([result count]>0) {
        return [result objectAtIndex:0];
    }

    return nil;
}

- (NSArray *) fetchObjectsWithEntity:(NSString *)entityName
                           predicate:(NSString *)predicateName
                                sort:(NSString *)sortName
                           ascending:(BOOL)ascending
                               limit:(NSNumber *)limit
                               group:(NSArray *)group {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = nil;
    NSSortDescriptor *sortDescriptor = nil;
    NSPredicate *predicate = nil;
    
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //Order By
    if (sortName != nil) {
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortName ascending:ascending];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    //查询条件
    if (predicateName != nil) {
        predicate = [NSPredicate predicateWithFormat:predicateName, nil];
        [fetchRequest setPredicate:predicate];
    }
    
    //Group By
    if (group != nil) {
        
        NSExpression *keyPathExpression = [NSExpression expressionForKeyPath: @"json"]; // Does not really matter
        NSExpression *countExpression = [NSExpression expressionForFunction: @"lowercase:"
                                                                  arguments: [NSArray arrayWithObject:keyPathExpression]];
        NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
        [expressionDescription setName: @"json"];
        [expressionDescription setExpression: countExpression];
        [expressionDescription setExpressionResultType: NSStringAttributeType];

        NSMutableArray *fetchArray = [NSMutableArray array];
        [fetchArray addObject:expressionDescription];
        
        NSMutableArray *groupArray = [NSMutableArray array];

        for (NSString *column in group) {
            NSAttributeDescription* desc = [entity.attributesByName objectForKey:column];
            //        NSAttributeDescription* json = [entity.attributesByName objectForKey:@"json"];
            [fetchArray addObject:desc];
            [groupArray addObject:desc];
        }
        [fetchRequest setPropertiesToFetch:fetchArray];
        [fetchRequest setPropertiesToGroupBy:groupArray];
        [fetchRequest setResultType:NSDictionaryResultType];
    }
    
    [fetchRequest setIncludesPendingChanges:YES];
    
    if (limit!=nil && limit.intValue>0) {
        [fetchRequest setFetchLimit:[limit intValue]];
    }
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // Handle the error
    }
    
    return fetchedObjects;
}

- (NSArray *) fetchObjectsWithEntity:(NSString *)entityName 
                           predicate:(NSString *)predicateName 
                                sort:(NSString *)sortName 
                           ascending:(BOOL)ascending; 
{
    return [self fetchObjectsWithEntity:entityName predicate:predicateName sort:sortName ascending:ascending limit:nil group:nil];
}

- (NSArray *) fetchObjectsWithEntity:(NSString *)entityName
                           predicate:(NSString *)predicateName
                                sort:(NSString *)sortName
                           ascending:(BOOL)ascending
                               limit:(NSNumber *)limit;
{
    return [self fetchObjectsWithEntity:entityName predicate:predicateName sort:sortName ascending:ascending limit:limit group:nil];
}

- (NSArray *)fetchObjectsWithEntity:(NSString *)entityName 
                          predicate:(NSString *)predicateName 
                            sortArr:(NSArray *)sortNameArr 
                       ascendingArr:(NSArray *)ascendingArr{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = nil;
    NSPredicate *predicate = nil;
    
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    if ([sortNameArr count]>0) {
        NSMutableArray *sortDescriptors = [NSMutableArray array];
        for (int i = 0; i<[sortNameArr count]; i++) {
            
            NSSortDescriptor *temp = [NSSortDescriptor sortDescriptorWithKey:[sortNameArr objectAtIndex:i] ascending:[[sortNameArr objectAtIndex:i] boolValue]];
            [sortDescriptors addObject:temp];
            
        }
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    if (predicateName != nil) {
        predicate = [NSPredicate predicateWithFormat:predicateName, nil];
        [fetchRequest setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // Handle the error
    }
    
    return fetchedObjects;
    
}


- (void)deleteManagedObject:(NSManagedObject *)object
{
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:object];
}

- (NSManagedObject *)createObjectWithEntityName:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}

@end
