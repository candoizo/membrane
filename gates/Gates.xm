#import "Master.h"

#define kFlipOn 	        CFSTR("ca.ndoizo.membrane.flipOn")
#define kFlipOff 	        CFSTR("ca.ndoizo.membrane.flipOff")
#define kTempAppKey 	  	  CFSTR("cellApp")
#define kDefault 			  @"error"

static void turnOn(NSString * bundle) {
   [%c(AppWirelessDataUsageManager) setAppCellularDataEnabled:@(YES) forBundleIdentifier:bundle completionHandler:nil];
}

static void turnOff(NSString * bundle) {
   [%c(AppWirelessDataUsageManager) setAppCellularDataEnabled:@(NO) forBundleIdentifier:bundle completionHandler:nil];
   CFPreferencesSetAppValue(kTempAppKey, nil, kPrefsAppID); //might be able to set the label from here instead of using the other label since it always cayses crashing
   CFPreferencesAppSynchronize(kPrefsAppID);
}

static void flipMeOn(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
   CFPreferencesAppSynchronize(kPrefsAppID);
   NSString * string = !CFPreferencesCopyAppValue(kTempAppKey, kPrefsAppID) ? kDefault : CFBridgingRelease(CFPreferencesCopyAppValue(kTempAppKey, kPrefsAppID));
   turnOn(string);
}

static void flipMeOff(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
   NSString * string = !CFPreferencesCopyAppValue(kTempAppKey, kPrefsAppID) ? kDefault : CFBridgingRelease(CFPreferencesCopyAppValue(kTempAppKey, kPrefsAppID));
   turnOff(string);
}

static NSUserDefaults * prefs;

%hook PSUIAppCellularUsageGroupController //can prob do this from the notification
-(NSNumber *)totalBytesUsed{
   NSNumber * used = %orig;
   [prefs setValue:used forKey:@"bytesUsed"];
   [prefs synchronize];
   return used;
}
%end

%hook PSUISettingsNetworkController
%property (nonatomic, assign) PSSpecifier * membrane;

-(void)dealloc { //holy fuck this solved so much
   [[%c(NSDistributedNotificationCenter) defaultCenter] removeObserver:self];
   %orig;
}

-(id)init {
   self = %orig;
      if (self) {
         HBLogDebug(@"init add observers");
         [[%c(NSDistributedNotificationCenter) defaultCenter] addObserver:self selector:@selector(notified:) name:@"FlipOn" object:nil];
         [[%c(NSDistributedNotificationCenter) defaultCenter] addObserver:self selector:@selector(flipOff:) name:@"FlipOff" object:nil];
      }
   return self;
}

-(void)viewDidLoad {
   %orig;

   if (!self.membrane) {
      HBLogDebug(@"loaded");
      NSString * prefLoader = @"/Library/PreferenceLoader/Preferences/MembranePrefs.plist"; //path to entry.plist representation
      NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:prefLoader]; //get dict (everything is under the entry key)
      NSDictionary *entry = [plist objectForKey:@"entry"]; //get entries
      [entry setValue:@YES forKey:@"isController"]; //we turn this off so it doesnt show in 3rd party list, but it will work for in cell data!
      HBLogDebug(@"entry / %@", entry);

      //manual PreferenceLoader
      NSDictionary *specifierPlist = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:entry, nil], @"items", nil];
      BOOL isBundle = [entry objectForKey:@"bundle"] != nil;
      NSBundle *prefBundle;
      NSString *bundleName = [entry objectForKey:@"bundle"];
      NSString *bundlePath;
         if(isBundle) {
      		bundlePath = [NSString stringWithFormat:@"/Library/PreferenceBundles/%@.bundle", bundleName];
      		prefBundle = [NSBundle bundleWithPath:bundlePath];
      	}
      NSArray *bundleControllers = [self valueForKey:@"_bundleControllers"];//MSHookIvar<NSArray *>(self, "_bundleControllers");
      NSArray *specs = SpecifiersFromPlist(specifierPlist, nil, /*_Firmware_lt_60 ? [self rootController] :*/ self, @"Membrane", prefBundle, NULL, NULL, (PSListController*)self, &bundleControllers);
      HBLogDebug(@"specs / %@", specs);

      self.membrane = specs.firstObject; //specifiers are in an array, but usually we need the first one
   }
}

-(NSArray *)specifiers {
   NSArray * orig = %orig;
   if (![[orig mutableCopy] containsObject:self.membrane] && self.membrane) {
      [self insertSpecifier:self.membrane atIndex:0];
   }
   return orig;
}

-(id)tableView:(id)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2 {
   PSTableCell * cell = %orig;
   if ([cell.specifier.identifier hasPrefix:@"Reset"] && [prefs boolForKey:@"manage"]) { //perhaps i should just use the identifier ?
      cell.textLabel.text = @"Managed by Membrane";
      cell.textLabel.textColor = [%c(UIColor) colorWithRed:0.58 green:0.77 blue:0.49 alpha:0.75];
      cell.userInteractionEnabled = NO;
   }
   else if (cell.specifier == self.membrane) {
      //can use the canReload method to maybe avoid the refreshing shit
      cell.detailTextLabel.textColor = [UIColor clearColor];
      cell.detailTextLabel.text = @"Please configure me!";

      if (!cell.firstSubtitle){
         cell.firstSubtitle = [[%c(UILabel) alloc] initWithFrame:CGRectMake(0,0,140, 14)];
         cell.firstSubtitle.textColor = [[%c(UIColor) blackColor] colorWithAlphaComponent:0.5];
         cell.firstSubtitle.textAlignment = cell.detailTextLabel.textAlignment;
         cell.firstSubtitle.font = [[cell titleLabel].font fontWithSize:12];
         [cell addSubview:cell.firstSubtitle];

      }

      if (!cell.secondSubtitle){
         cell.secondSubtitle = [[%c(UILabel) alloc] initWithFrame:CGRectMake(0,0,140, 14)];
         cell.secondSubtitle.textColor = [[%c(UIColor) blackColor] colorWithAlphaComponent:0.5];
         cell.secondSubtitle.textAlignment = cell.detailTextLabel.textAlignment;
         cell.secondSubtitle.font = [[cell titleLabel].font fontWithSize:12];
         [cell addSubview:cell.secondSubtitle];

      }
   }
   return cell;
}

-(id)_lastUpdateDate {
   NSDate * last = %orig;
   [prefs setValue:last forKey:@"lastUpdate"];
   [prefs synchronize];

   if ([[prefs valueForKey:@"cycleBegin"] timeIntervalSinceDate:last] > 0){ //if lastUpdated is older than current start of plan, try to reset the stats
      HBLogDebug(@"\n\nSTATS RESET omg we did it bro\n\n");
      [self clearStats:@YES];
      [prefs setValue:@0 forKey:@"tempOffset"];
      // set the value for tempOffset to zero, so that it can be used if necessary, and basically start adding temoOffset in a form that works wirh - /
   }
   return last;
}

-(void)totalBytesUsedChangedNotification {
   if ([prefs boolForKey:@"loaded"]) {
      NSMutableArray * spec = [[self specifiers] mutableCopy];
       for (PSSpecifier * s in spec) {
         if (s != self.membrane) {
            [self reloadSpecifier:s];
         }
      }
   }
   %orig;
   [self updateMembane];
}

-(void)viewWillAppear:(BOOL)arg1 {
   %orig();
   if (arg1) [self updateMembane];
}

-(BOOL)shouldReloadSpecifiersOnResume {return /*NO;}*/[prefs boolForKey:@"loaded"] ? YES: NO;} //causes crash, luckily we can work it out pretty easily since totalBytesUsed is called everytime it reopens :)

%new
-(void)updateMembane {
      HBLogDebug(@"where di di crash "); //these seem to cause crashes the most
      if (self.membrane && [[[self specifiers] mutableCopy] containsObject:self.membrane]) {
      PSTableCell * cell = [self cachedCellForSpecifier:self.membrane];
      HBLogDebug(@"cell ? %@", cell);
      cell.detailTextLabel.textColor = [prefs valueForKey:@"data"] && [prefs valueForKey:@"cycleFinish"] && [prefs boolForKey:@"manage"] ? [%c(UIColor) clearColor] : [%c(UIColor) grayColor]; //if value for key of data && date ? hmm idk well if a valid one i iguess

         if (cell.firstSubtitle && cell.secondSubtitle) {
         if (cell.detailTextLabel.textColor != [%c(UIColor) clearColor]) {
            cell.firstSubtitle.hidden = YES;
            cell.secondSubtitle.hidden = YES;
         }
         else {
            cell.firstSubtitle.hidden = NO;
            cell.secondSubtitle.hidden = NO;
         }
         // Days until reset label
         NSDateComponents *comps = [[NSCalendar currentCalendar] components: NSDayCalendarUnit fromDate:[NSDate date] toDate:[prefs valueForKey:@"cycleFinish"] options:0];
         cell.firstSubtitle.text = [NSString stringWithFormat:@"Renews in %d days", ((int)[comps day])];
         cell.firstSubtitle.center = CGPointMake(cell.detailTextLabel.center.x, cell.detailTextLabel.center.y + 8);

         // Data Remaining label
         //HBLogDebug(@"temo offset is %f", );

         float monthlyAllotment = ([[prefs valueForKey:@"data"] floatValue] < 1000 ? 1048576 : 1000000) * ([[prefs valueForKey:@"data"] floatValue] + [[prefs valueForKey:@"tempOffset"] floatValue]);//float monthlyAllotment = 1048576 * [[prefs valueForKey:@"data"] floatValue];
         //HBLogDebug(@"monthlyAllotment %f - tempOffset %f = %f", monthlyAllotment, [[prefs valueForKey:@"tempOffset"] floatValue], monthlyAllotment - [[prefs valueForKey:@"tempOffset"] floatValue]);                                            //maybe make intValue
         cell.secondSubtitle.text = [NSByteCountFormatter stringFromByteCount:monthlyAllotment - [[self.appUsageGroupController totalBytesUsed] floatValue] countStyle:NSByteCountFormatterCountStyleFile];
         cell.secondSubtitle.text = [NSString stringWithFormat:@"Data Remaining: %@", cell.secondSubtitle.text];
         cell.secondSubtitle.center = CGPointMake(cell.detailTextLabel.center.x, cell.detailTextLabel.center.y - 8);
         }
      }
}

%new
-(void)notified:(id)sender {
   HBLogDebug(@"notified method");
   [%c(AppWirelessDataUsageManager) setAppCellularDataEnabled:@(YES) forBundleIdentifier:[sender object] completionHandler:nil];
}

%new
-(void)flipOff:(id)sender {
   HBLogDebug(@"flipoff method");
   [%c(AppWirelessDataUsageManager) setAppCellularDataEnabled:@(NO) forBundleIdentifier:[sender object] completionHandler:nil];
}

%end

%hook PSTableCell
%property (nonatomic, retain) UILabel * firstSubtitle;
%property (nonatomic, retain) UILabel * secondSubtitle;
%end

%ctor {
      prefs = [[NSUserDefaults alloc] initWithSuiteName:@"ca.ndoizo.membrane"];

       CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
		 	NULL,
		 	(CFNotificationCallback)flipMeOn,
		 	kFlipOn,
		 	NULL,
		 	CFNotificationSuspensionBehaviorDeliverImmediately
  		 );

       CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
     	 	NULL,
     	 	(CFNotificationCallback)flipMeOff,
     	 	kFlipOff,
     	 	NULL,
     	 	CFNotificationSuspensionBehaviorDeliverImmediately
       );

}
