#import "LOCALMembrane.h"
#import "PrefUtils.h"

@implementation LOCALMembrane

+(NSString *)localisedStringForKey:(NSString *)key {
																					 //resource == default lang code
	NSBundle *defaultLang = [NSBundle bundleWithURL:[kPrefBundle URLForResource:@"en" withExtension:@"lproj"]];
   NSString * defaultStr = [defaultLang localizedStringForKey:key value:@"" table:nil];


	NSBundle *localLang = [NSBundle bundleWithURL:[kPrefBundle URLForResource:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] withExtension:@"lproj"]];
		if (localLang) { //if theres a bundle for the local localLanguage, we should see if there's a localised key,
			NSString * localStr = [localLang localizedStringForKey:key value:@"" table:nil];

			//if theres a value for the key, return the localised string, else substitute the default
			return [kPrefBundle localizedStringForKey:key value:![localStr isEqualToString:key] ? localStr : defaultStr table:nil];
		}

	return [kPrefBundle localizedStringForKey:key value:defaultStr table:nil];
}

+(void)parseSpecifiers:(NSArray *)specifiers {
	for (PSSpecifier *specifier in specifiers) {
		NSString *localisedTitle = [LOCALMembrane localisedStringForKey:specifier.properties[@"label"]];
		NSString *localisedFooter = [LOCALMembrane localisedStringForKey:specifier.properties[@"footerText"]];
		[specifier setProperty:localisedFooter forKey:@"footerText"];
		specifier.name = localisedTitle;
	}
}
@end
