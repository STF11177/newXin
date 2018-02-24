#import <Foundation/Foundation.h>


@interface NSMutableArray (ETMutableArray)

- (void)addInteger:(NSInteger)integer;
- (id)safelyObjectAtIndex:(NSUInteger)index;
- (void)safelyAddObject:(id)object;
- (void)safelyAddObjectsFromArray:(NSArray *)array;
- (void)safelyRemoveAtIndex:(NSUInteger)index;
@end
