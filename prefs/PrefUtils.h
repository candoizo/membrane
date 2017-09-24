//Definitions
#define kMembraneTint [UIColor colorWithRed:0.44 green:0.78 blue:0.29 alpha:0.8]   //[UIColor colorWithRed:0.58 green:0.77 blue:0.49 alpha:1.0]
#define kPrefBundlePath @"/Library/PreferenceBundles/MembranePrefs.bundle"
#define kPrefBundle [NSBundle bundleWithPath:kPrefBundlePath]
#define kTweet @"wow @candoizo's new tweak is insane in the Membrane!"


//First Use Controller
#define kIntroDesc @"A sweet & simple cell suite designed to help manage & monitor your use!"
#define kSectionOne @"Effortless\nControl when and why your data is spent. Automatic revokes so you never forget."
#define kSectionTwo @"Informative\nStay on-top of where your stand with your current plan from start to finish"
#define kSectionThree @"Integrated\nDeeply integrated with the system for a harmonious & intuitive experience"

@interface UIColor  (PVT)
+ (UIColor *)groupTableViewBackgroundColor;
+ (UIColor *)lightTextColor;
+ (UIColor *)darkTextColor;
@end

//Stuff
@interface UIImage (PVT)
+ (UIImage *)imageNamed:(id)img inBundle:(id)bndl;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(int)scale;
@end
