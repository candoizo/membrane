#import <Preferences/PSSpecifier.h>

@interface LOCALMembrane : NSObject
+(NSString *)localisedStringForKey:(NSString *)key;
+(void)parseSpecifiers:(NSArray *)specifiers;
@end
