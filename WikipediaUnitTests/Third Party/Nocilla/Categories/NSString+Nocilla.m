#import "NSString+Nocilla.h"
void yoo15() {}
@implementation NSString (Nocilla)

- (NSRegularExpression *)regex {
    NSError *error = nil;
    NSRegularExpression *regex =  [[NSRegularExpression alloc] initWithPattern:self options:0 error:&error];
    if (error) {
        [NSException raise:NSInvalidArgumentException format:@"Invalid regex pattern: %@\nError: %@", self, error];
    }
    return regex;
}

- (NSData *)data {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

@end
