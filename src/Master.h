#define kPrefsAppID 					CFSTR("ca.ndoizo.membrane")
#define kSettingsChangedNotification 	CFSTR("ca.ndoizo.membrane.changed")

#import <Preferences/PSListController.h>
#define kFlipOn 	        CFSTR("ca.ndoizo.membrane.flipOn")
#define kFlipOff 	        CFSTR("ca.ndoizo.membrane.flipOff")
#define kTempAppKey 	  	  CFSTR("cellApp")
#define kDefault 			  @"none"

@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (id)defaultCenter;
- (void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3 deliverImmediately:(BOOL)arg4;
@end

@interface UIApplication (WTF)
-(id)_accessibilityFrontMostApplication;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface PreferencesAppController : UIApplication
@end

@interface SpringBoard : UIApplication
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface SBAlertItem : NSObject
@end

@interface SBLaunchAlertItem : SBAlertItem
-(id)initWithLaunchAlertType:(int)arg1 dataAlert:(BOOL)arg2 usesCellNetwork:(BOOL)arg3 bundleID:(id)arg4 ;
-(void)setAssociatedWithDisplay:(id)arg1 ;
-(void)_displayDeactivated:(id)arg1 ;
-(void)configureForAirplaneModeDataAlertOnCellular:(BOOL)arg1 ;
-(void)configureForAirplaneModeDataAlertOffCellular:(BOOL)arg1 ;
-(void)configureForAirplaneModeNonDataAlert;
-(void)configureForInCall;
-(void)turnOffAirplaneMode;
-(void)sendUserToSettings;
-(void)dealloc;
-(BOOL)dismissOnLock;
-(void)configure:(BOOL)arg1 requirePasscodeForActions:(BOOL)arg2 ;
@end

@interface SBUserNotificationAlert : SBAlertItem
@property (retain) NSString * remoteServiceBundleIdentifier;
@property (retain) NSString * defaultButtonTitle;
@property (retain) NSString * alternateButtonTitle;
@property (retain) NSString * otherButtonTitle;
@property (retain) NSString * alertHeader;
@property (retain) NSString * alertMessage;
@property (retain) NSString * defaultResponseLaunchBundleID;
@property (retain) NSURL * defaultResponseLaunchURL;
@property (retain) NSString * remoteViewControllerClassName;
@property (retain) UIViewController * contentViewControllerForAlertController;
-(id)_publicDescription;
-(id)extensionRequest;
-(NSString *)extensionIdentifier;
@end

@interface FBProcessManager : NSObject
+ (id)sharedInstance;
- (id)applicationProcessForPID:(int)pid;
@end

@interface FBSSceneSettings : NSObject
@end

@interface FBSMutableSceneSettings : FBSSceneSettings
@property(nonatomic, getter=isBackgrounded) BOOL backgrounded;
-(id)otherSettings;
@end

@interface FBScene : NSObject
@property(readonly, retain, nonatomic) FBSMutableSceneSettings *mutableSettings;
@property(readonly, retain, nonatomic) FBSSceneSettings *settings;
- (void)_applyMutableSettings:(id)arg1 withTransitionContext:(id)arg2 completion:(id)arg3;
@end

@interface FBBundleInfo
@property(copy) NSString * bundleIdentifier;
@end

@interface FBProcessState : NSObject
@property (assign,getter=isForeground,nonatomic) BOOL foreground;
@property (assign,nonatomic) int pid;
@property (assign,nonatomic) int visibility;
@property (assign,nonatomic) int effectiveVisibility;
@property (assign,nonatomic) int taskState;
@property (assign,getter=isRunning,nonatomic) BOOL running;
@end

@interface FBProcess
@property(retain,readonly) FBBundleInfo * applicationInfo;
@end

@interface SBApplication
@property (retain) FBProcessState * processState;
@property (nonatomic,readonly) int pid;
-(id)bundleIdentifier;
-(int)dataUsage;
-(FBScene *)mainScene;
-(void)willActivate;
-(void)applyProcessSettings:(id)arg1 ;
-(void)processDidLaunch:(id)arg1;
-(void)willActivateForScene:(id)arg1 transactionID:(unsigned long long)arg2 ;
-(void)spdResumeForTrafficRequested;
-(void)preHeatForUserLaunchIfNecessary;
- (void)processWillLaunch:(id)arg1;
-(void)setApplicationState:(unsigned)arg1 ;
@end


@interface SBBulletinBannerController : NSObject
+(id)sharedInstance;
@end

@interface BBServer : NSObject
+(id)sharedInstance;
+(void)initialize;
-(void)publishBulletinRequest:(id)arg1 destinations:(unsigned long long)arg2 ;
-(void)publishBulletinRequest:(id)arg1 destinations:(unsigned long long)arg2 alwaysToLockScreen:(BOOL)arg3 ;
@end

@interface BBAction : NSObject
+(id)actionWithLaunchURL:(id)arg1;
@end

@interface BBBulletin : NSObject
@end

@interface BBBulletinRequest : BBBulletin
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic,copy) NSString * sectionID;
@property (nonatomic,copy) NSString * recordID;
@property (nonatomic,copy) NSString * publisherBulletinID;
@property (assign,nonatomic) BOOL clearable;
@property (assign,nonatomic) BOOL showsMessagePreview;
@property (nonatomic,retain) NSDate * date;
@property (nonatomic,retain) NSDate * publicationDate;
@property (nonatomic,retain) NSDate * lastInterruptDate;
@property (nonatomic,copy) BBAction * defaultAction;
@end

@interface SBApplicationController : NSObject
+(id)sharedInstance;
-(void)applicationService:(id)arg1 suspendApplicationWithBundleIdentifier:(id)arg2 ;
-(id)applicationWithBundleIdentifier:(id)arg1;
@end

@interface BSAuditToken : NSObject
@property (nonatomic,copy) NSString * bundleID;
@property (nonatomic,readonly) int pid;
@end

@interface SBDismissOnlyAlertItem : SBAlertItem {

	NSString* _title;
	NSString* _body;

}
-(id)dismissButtonText;
-(void)setTitle:(id)arg1 ;
-(id)title;
-(void)setBodyText:(id)arg1 ;
-(id)bodyText;
-(id)initWithTitle:(id)arg1 body:(id)arg2 ;
-(void)performUnlockAction;
-(void)configure:(BOOL)arg1 requirePasscodeForActions:(BOOL)arg2 ;
@end

@interface SBCarrierDebuggingAlert : SBDismissOnlyAlertItem
+(BOOL)haveShownAlert;
-(void)didDeactivateForReason:(int)arg1 ;
@end
