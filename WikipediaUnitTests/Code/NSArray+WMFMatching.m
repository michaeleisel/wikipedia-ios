#import "NSArray+WMFMatching.h"
void yoo14() {}
@implementation NSArray (WMFMatching)

- (BOOL)wmf_containsObjectsInAnyOrder:(NSArray *)objects {
    NSSet *selfSet = [NSSet setWithArray:self];
    NSSet *objectsSet = [NSSet setWithArray:objects];
    return [objectsSet isSubsetOfSet:selfSet];
}

@end
