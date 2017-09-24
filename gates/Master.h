#define kPrefsAppID 					CFSTR("ca.ndoizo.membrane")
#define kSettingsChangedNotification 	CFSTR("ca.ndoizo.membrane.changed")

#import "Preferences/PSListController.h"
#import "Preferences/PSTableCell.h"
#import "Preferences/PSSpecifier.h"

extern "C" NSArray* SpecifiersFromPlist(NSDictionary* plist,
					PSSpecifier* prevSpec,
					id target,
					NSString* plistName,
					NSBundle* curBundle,
					NSString** pTitle,
					NSString** pSpecifierID,
					PSListController* callerList,
					NSMutableArray** pBundleControllers);

@interface PSTableCell (Add)
@property (nonatomic, retain) UILabel * firstSubtitle;
@property (nonatomic, retain) UILabel * secondSubtitle;
@end

@interface PSUIAppCellularUsageGroupController : NSObject
-(id)appCellularDataEnabledForSpecifier:(id)arg1;
-(id)dataUsageForApplicationSpecifier:(id)arg1;
-(id)specifiers;
-(BOOL)isEnabled;
-(BOOL)isCancelled;
-(BOOL)hasManagedCellularData;
-(void)setAppCellularDataEnabled:(id)arg1 forSpecifier:(id)arg2;
-(void)calculateUsage;
-(id)totalBytesUsed;
-(void)_updateTotalBytesUsed:(CGFloat)arg1 roamingBytesUsed:(CGFloat)arg2;
@end

@interface PSUISettingsNetworkController : PSListController
@property (nonatomic,retain) PSUIAppCellularUsageGroupController * appUsageGroupController; //for now not needed
@property (nonatomic, assign) PSSpecifier * membrane; //@NOTE added
@property (nonatomic, assign) PSTableCell * membraneCell;
-(NSNumber *)totalDataUsageForSpecifier:(id)spec;
-(void)clearStats:(id)arg1; //refreshes cellular stats
-(NSDate *)_lastUpdateDate;
-(void)totalBytesUsedChangedNotification;
-(void)updateMembane;
-(id)loadSpecifiersFromPlistName:(id)arg1 target:(id)arg2 bundle:(id)arg3 ;
-(void)_addIdentifierForSpecifier:(id)arg1 ;
-(void)reloadSpecifiers:(id)arg1;
@end

@interface AppWirelessDataUsageManager : NSObject
+(void)setAppCellularDataEnabled:(id)arg1 forBundleIdentifier:(id)arg2 completionHandler:(/*^block*/id)arg3 ;
@end
