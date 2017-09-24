#import "Master.h"

#define SETTINGS 		((SBApplication *)[[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:@"com.apple.Preferences"])

#define kOtherButton 	@"Enable Temporarily"
#define kGrantAccess	@"Cellular access has been granted."
#define kRevokeAccess 	@"Cellular permission has been revoked."

NSUserDefaults * prefs = nil;

static SBUserNotificationAlert * alert; //the cellular alert
static BOOL cfNotify = NO; //keeps track if CFPrefs need to take over
static NSString * tempCell; //keep track of the app which has been given cell access

//Notification Stuff

static int bulletinNum = 0;
static BBServer *bbServer = nil;
static NSString * nextBulletinID() {
	++bulletinNum;
	return [NSString stringWithFormat:@"ca.ndoizo.membrane.notification-id-%@", @(bulletinNum)];
}

static void sendNotification(BBServer *server, NSUInteger destinations, NSString * bundle, NSString * title) {
	NSString *bulletinID = nextBulletinID();
	BBBulletinRequest *bulletin = [[%c(BBBulletinRequest) alloc] init];
   bulletin.title = title;
	bulletin.sectionID = bundle;
	bulletin.recordID = bulletinID;
	bulletin.publisherBulletinID = bulletinID;
	bulletin.clearable = YES;
	NSDate *date = [NSDate date];
	bulletin.date = date;
	bulletin.publicationDate = date;
	bulletin.lastInterruptDate = date;
	bulletin.defaultAction = [%c(BBAction) actionWithLaunchURL:[NSURL URLWithString:@"prefs:root=Cellular"]];
   [server publishBulletinRequest:bulletin destinations:destinations alwaysToLockScreen:NO];
}

static dispatch_queue_t getBBServerQueue() {
	static dispatch_queue_t queue;
	static dispatch_once_t predicate;
		dispatch_once(&predicate, ^{
			void *handle = dlopen(NULL, RTLD_GLOBAL);
				if (handle) {
					dispatch_queue_t *pointer = (dispatch_queue_t *) dlsym(handle, "__BBServerQueue");
						if (pointer) queue = *pointer;
					dlclose(handle);
				}
		});
	return queue;
}

static void willNotify(NSString * bundle, NSString * title) {
	dispatch_queue_t queue = getBBServerQueue();
	if (!bbServer || !queue) return;

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.7 * NSEC_PER_SEC), queue, ^{
		sendNotification(bbServer, 8, bundle, title);
	});
}

%hook BBServer
- (id)init {return bbServer = %orig;}
%end
//End of Notifications

%group NSDNC //NSDistributedNotifications
//@TODO Make the alert show everytime the app is open (as opposed to when apple thinks is proper)
//@TODO make it so the alert has information about the current plan
%hook SBAlertItemsController
-(void)activateAlertItem:(id)arg1 {
	HBLogDebug(@"arg1 %@", [arg1 _publicDescription])

		if ([arg1 isMemberOfClass:%c(SBUserNotificationAlert)]) {
			if ([[arg1 valueForKey:@"_alertSource"] isEqualToString:@"CommCenter"]) {
				if (SETTINGS.processState || SETTINGS.pid > 0) {
					alert = arg1;
					HBLogDebug(@"NSDNC hook activateAlertItem \n%@", [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:@"com.apple.Preferences"]);
	  		      	NSString *body = [alert.alertMessage substringToIndex:[alert.alertMessage length] -1]; //remove period to add my end message
	   		     	alert.alertMessage = [body stringByAppendingString:@", or grant access temporarily for the session."];

						// float monthlyAllotment = 1000000 * [[prefs valueForKey:@"data"] floatValue];
						// NSString * remain = [NSByteCountFormatter stringFromByteCount:monthlyAllotment - [[prefs valueForKey:@"bytesUsed"] floatValue]
																	//  countStyle:NSByteCountFormatterCountStyleFile];

						// alert.alertMessage = [NSString stringWithFormat:@"%@ \n\n You have %@ remaining.", alert.alertMessage, remain];
					//@TODO put info about data usage here

	    	    	alert.otherButtonTitle = kOtherButton;
	  			}
    		}
  		}
   %orig(arg1);
}
%end

%hook SBUserNotificationAlert
-(void)dismissIfNecessaryWithResponse:(int)arg1 {
	HBLogDebug(@"chosen response %d", arg1);
		if (arg1 != 2) cfNotify = NO;
     	if (self == alert && arg1 == 2 && !cfNotify) {
			if (SETTINGS.processState || SETTINGS.pid > 0) {
				HBLogDebug(@"NSDNC dispatching NSDNC Notification in 2s");
        		tempCell = [[[%c(UIApplication) sharedApplication] _accessibilityFrontMostApplication] bundleIdentifier];
				[[%c(NSDistributedNotificationCenter) defaultCenter] postNotificationName:@"FlipOn" object:tempCell userInfo:nil];
				[[%c(SpringBoard) sharedApplication] launchApplicationWithIdentifier:@"com.apple.Preferences" suspended:YES]; //DOES NOT WORK WITHOUT
				willNotify(tempCell, kGrantAccess);
		  	}
     	}
   %orig;
}
%end


%hook SBApplication
-(void)updateProcessState:(id)arg1 {
	   if (tempCell == [self bundleIdentifier] && !cfNotify) {
			if (SETTINGS.processState||SETTINGS.pid > 0) {
				HBLogDebug(@"NSDNC %@ processState %@", [self bundleIdentifier], self.processState);
				[[%c(NSDistributedNotificationCenter) defaultCenter] postNotificationName:@"FlipOff" object:tempCell userInfo:nil];
				[[%c(SpringBoard) sharedApplication] launchApplicationWithIdentifier:@"com.apple.Preferences" suspended:YES]; //DOES NOT WORK WITHOUT THIS
	            willNotify(tempCell, kRevokeAccess);
	            tempCell = nil;
			}
	   }
	%orig;
}
%end
%end

%group CF //CFPreferences

%hook SBAlertItemsController
-(void)activateAlertItem:(id)arg1 {
		if ([arg1 isMemberOfClass:%c(SBUserNotificationAlert)]) { //sometimes its sends a SBLaunchAlertItem which would crash the system
		HBLogDebug(@" arg1 pbulicDesc %@", [arg1 valueForKey:@"_processAssertion"]);
			if ([[arg1 valueForKey:@"_alertSource"] isEqualToString:@"CommCenter"]) {
				if (!(SETTINGS.processState || SETTINGS.pid > 0)) {
					HBLogDebug(@"CF alert hooking in");
					cfNotify = YES;
					alert = arg1; //get reference of this alert for dismiss method
			 		[[%c(SpringBoard) sharedApplication] launchApplicationWithIdentifier:@"com.apple.Preferences" suspended:YES]; //DOES NOT WORK WITHOUT THIS
			        NSString *body = [alert.alertMessage substringToIndex:[alert.alertMessage length]-1];
			        alert.alertMessage = [body stringByAppendingString:@", or grant access temporarily for the session."];


			        alert.otherButtonTitle = kOtherButton;
	  			}
    		}

  		}
   %orig(arg1);
}
%end

%hook SBUserNotificationAlert
-(void)dismissIfNecessaryWithResponse:(int)arg1 {
		if (arg1 != 2) cfNotify = NO;
  		if (self == alert && arg1 == 2) {
			if ( !(SETTINGS.processState || SETTINGS.pid > 0) || cfNotify){
					HBLogDebug(@"CF dispatching CF Notification in 2s");
	         	tempCell = [[[%c(UIApplication) sharedApplication] _accessibilityFrontMostApplication] bundleIdentifier];
					[[%c(SpringBoard) sharedApplication] launchApplicationWithIdentifier:@"com.apple.Preferences" suspended:YES]; //DOES NOT WORK WITHOUT THIS

					CFPreferencesSetAppValue(kTempAppKey, (CFStringRef)tempCell, kPrefsAppID);
					CFPreferencesAppSynchronize(kPrefsAppID);
					CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), kFlipOn, NULL, NULL, true);
					willNotify(tempCell, kGrantAccess);

			}
      }
   %orig;
}
%end


%hook SBApplication
-(void)updateProcessState:(id)arg1 {
	   if (tempCell == [self bundleIdentifier]) {
			if (!(SETTINGS.processState || SETTINGS.pid > 0) || cfNotify){
			  	HBLogDebug(@"CF taking over %@ processState %@", [self bundleIdentifier], self.processState);
				[[%c(SpringBoard) sharedApplication] launchApplicationWithIdentifier:@"com.apple.Preferences" suspended:YES]; //DOES NOT WORK WITHOUT THIS
				CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), kFlipOff, NULL, NULL, true);
	            willNotify(tempCell, kRevokeAccess);
	            tempCell = nil;
				cfNotify = NO;
			}
	   }
	%orig;
}
%end
%end


%ctor {
    prefs = [[NSUserDefaults alloc] initWithSuiteName:@"ca.ndoizo.membrane"];
	 [prefs registerDefaults:@{
		 // Preferences
		 @"wordDate" : @"no plan data", //stores the wording that will go in the referenceDate textfield
		 @"loaded" : @(NO), //has the settings page been opened?
		 @"tempOffset" : @0, // a positive or negative value that is subtracted from the current data allotment to allow temp + / -
	 }];
	    [prefs setBool:NO forKey:@"loaded"];
		 [prefs synchronize];
		HBLogDebug(@"prefs loaded ??? %d", [prefs boolForKey:@"loaded"]);
	%init;
	%init(CF);
	%init(NSDNC);
}
