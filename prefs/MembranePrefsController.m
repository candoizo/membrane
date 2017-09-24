#import "MembranePrefsController.h"
//#import "LOCALMembrane.h"
#import "PrefUtils.h"

static MembranePrefsController * memController;

// #define pB(x) [self.prefs boolForKey:x]
// #define pV(x)  [self.prefs valueForKey:x]
// #define sV(x)fK(y) [self.prefs setValue:x forKey:y]

@implementation MembranePrefsController
+(void)clearPrefs {
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"ca.ndoizo.membrane"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	memController = self;
	self.prefs = [[NSUserDefaults alloc] initWithSuiteName:@"ca.ndoizo.membrane"];

	UIBarButtonItem *loveButton = [[UIBarButtonItem alloc] initWithTitle:[self.prefs boolForKey:@"likedMembrane"] ?  @"♥":@"♡" style:UIBarButtonItemStylePlain target:self action:@selector(showLove)];
	loveButton.tintColor = UIColor.whiteColor;
	[self.navigationItem setRightBarButtonItem:loveButton];

}

- (void)viewWillAppear:(BOOL)animated {
		if ([self.prefs boolForKey:@"firstMembrane"]) {
			 HBLogDebug(@"First screen already shown");
			 //[self.prefs setBool:NO forKey:@"firstMembrane"];
			 //[self.prefs synchronize];
		} else {
			self.firstUse = [[UIViewController alloc] init];
			UIView * firstView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
			self.firstUse.view = firstView;
			firstView.backgroundColor = [UIColor groupTableViewBackgroundColor];

			UILabel * welcome = [[UILabel alloc] initWithFrame:CGRectMake(0, firstView.bounds.size.height/6, firstView.bounds.size.width, 30)];
			welcome.font = [UIFont fontWithName:@".SFUIDisplay-Light" size:28];
			welcome.textColor = [UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1];
			welcome.textAlignment = 1;
			welcome.text = @"Welcome to Membrane";

			UILabel * desc = [[UILabel alloc] initWithFrame:CGRectMake(0, welcome.frame.origin.y + welcome.frame.size.height + 10, welcome.frame.size.width/1.5, 50)];
			desc.adjustsFontSizeToFitWidth = YES;
			desc.minimumFontSize = 10.0;
			desc.numberOfLines = 0;
			desc.font = [UIFont fontWithName:@".SFUIText" size:16];
			desc.center = CGPointMake(welcome.center.x, desc.center.y);
			desc.textColor = [UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:0.8];
			desc.textAlignment = 1;
			desc.text = kIntroDesc;

			//sec3 1
			UIView * sec1 = [[UIView alloc] initWithFrame:CGRectMake(0,0,firstView.bounds.size.width/1.8, 75)];
			UIImageView * imgOne = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,sec1.bounds.size.height/1.6, sec1.bounds.size.height/1.6)];
			imgOne.image = [UIImage imageNamed:@"Sections/Carrier_Bundles" inBundle:[NSBundle bundleWithPath:@"/Applications/Cydia.app"]];

			UILabel * lblOne = [[UILabel alloc] initWithFrame:CGRectMake(imgOne.frame.size.width + 20,0,sec1.frame.size.width - imgOne.frame.size.width, sec1.frame.size.height)];
			lblOne.font = [desc.font fontWithSize:12.5];
			lblOne.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.6];
			lblOne.numberOfLines = 0;
			lblOne.text = kSectionOne;

			imgOne.center = CGPointMake(imgOne.center.x, lblOne.center.y);

			[sec1 addSubview:imgOne];
			[sec1 addSubview:lblOne];
			sec1.center = CGPointMake(desc.center.x, desc.center.y + (firstView.bounds.size.width/4.25));

			//sec2 2
			UIView * sec2 = [[UIView alloc] initWithFrame:CGRectMake(0,0,firstView.bounds.size.width/1.8, 75)];

			UIImageView * imgTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,sec2.bounds.size.height/1.6, sec2.bounds.size.height/1.6)];
			imgTwo.image = [UIImage imageNamed:@"Sections/Networking" inBundle:[NSBundle bundleWithPath:@"/Applications/Cydia.app"]];

			UILabel * lblTwo = [[UILabel alloc] initWithFrame:CGRectMake(imgTwo.frame.size.width + 20,0,sec2.frame.size.width - imgTwo.frame.size.width, sec2.frame.size.height)];
			lblTwo.font = [desc.font fontWithSize:12.5];
			lblTwo.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.6];
			lblTwo.numberOfLines = 0;
			lblTwo.text = kSectionTwo;

			imgTwo.center = CGPointMake(imgTwo.center.x, lblTwo.center.y);

			[sec2 addSubview:imgTwo];
			[sec2 addSubview:lblTwo];

			sec2.center = CGPointMake(desc.center.x, sec1.center.y + 100);

			//sec3 3
			UIView * sec3 = [[UIView alloc] initWithFrame:CGRectMake(0,0,firstView.bounds.size.width/1.8, 75)];

			UIImageView * imgThree = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,sec3.bounds.size.height/1.6, sec3.bounds.size.height/1.6)];
			imgThree.image = [UIImage imageNamed:@"Sections/Localization" inBundle:[NSBundle bundleWithPath:@"/Applications/Cydia.app"]];

			UILabel * lblThree = [[UILabel alloc] initWithFrame:CGRectMake(imgOne.frame.size.width + 20,0,sec3.frame.size.width - imgThree.frame.size.width, sec3.frame.size.height)];
			lblThree.font = [desc.font fontWithSize:12.5];
			lblThree.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.6];
			lblThree.numberOfLines = 0;
			lblThree.text = kSectionThree;

			imgThree.center = CGPointMake(imgThree.center.x, lblThree.center.y);

			[sec3 addSubview:imgThree];
			[sec3 addSubview:lblThree];

			sec3.center = CGPointMake(desc.center.x, sec2.center.y + 100);
			//end of serctions

			UIButton * cont = [[UIButton alloc] initWithFrame:CGRectMake(0, firstView.bounds.size.height -firstView.bounds.size.height/8, firstView.bounds.size.width/1.4 , firstView.bounds.size.width/8)];
			cont.backgroundColor = kMembraneTint;
			cont.layer.masksToBounds = YES;
			cont.layer.cornerRadius = 10;
			cont.center = CGPointMake(welcome.center.x, cont.center.y);
			[cont setTitle: @"Continue" forState:UIControlStateNormal];
			[cont addTarget:self action:@selector(dismissIntro) forControlEvents:UIControlEventTouchUpInside];

			[firstView addSubview:welcome];
			[firstView addSubview:desc];

			[firstView addSubview:sec1];
			[firstView addSubview:sec2];
			[firstView addSubview:sec3];

			[firstView addSubview:cont];

			[self.view addSubview:self.firstUse.view];

			[self.prefs setBool:YES forKey:@"firstMembrane"];
			[self.prefs synchronize];
	}
	[super viewWillAppear:animated];

	self.navigationController.navigationController.navigationBar.barTintColor = kMembraneTint;
	self.navigationController.navigationController.navigationBar.tintColor = UIColor.whiteColor;
}

-(void)dismissIntro {
	[UIView animateWithDuration:.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				//topHalf.frame  = CGRectMake(topHalf.frame.origin.x, -60, topHalf.frame.size.width, topHalf.frame.size.height);
				self.firstUse.view.alpha = 0;
				 }  completion:^(BOOL finished) {
				  	if (finished)
				  		[self.firstUse.view removeFromSuperview];
					 }
					];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	self.navigationController.navigationController.navigationBar.barTintColor = nil;
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		//[LOCALMembrane parseSpecifiers:_specifiers];
	}

	return _specifiers;
}

- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) return 120;
	else if (section == 1) return 60;
	else return [super tableView:tableView heightForHeaderInSection:section];
}

- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 120)];
		headerView.backgroundColor = UIColor.clearColor;

		UILabel *copyright = [[UILabel alloc] initWithFrame:CGRectMake(0, - 25, headerView.bounds.size.width, 12)];
		copyright.font = [UIFont fontWithName:@"HelveticaNeue" size:7];
		copyright.text = @"©hirp ©hirp";
		copyright.textColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
		copyright.textAlignment = NSTextAlignmentCenter;
		[headerView addSubview:copyright];

		//icon
		UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0, 40, 40)];
		icon.layer.masksToBounds = YES;
		icon.layer.cornerRadius = 9;
		icon.image = [UIImage imageNamed:@"Header" inBundle:kPrefBundle];

		//title label
		UILabel *tweakTitle = [[UILabel alloc] initWithFrame:CGRectZero];
		tweakTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:36];
		tweakTitle.text = [@"Membrane" uppercaseString];
		tweakTitle.textAlignment = NSTextAlignmentCenter;
		tweakTitle.textColor = [UIColor.blackColor colorWithAlphaComponent:0.75];
		tweakTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		[tweakTitle sizeToFit];
		tweakTitle.frame = CGRectMake(50, 0, tweakTitle.bounds.size.width, 40);

		//title container
		UIView * contV = [[UIView alloc] initWithFrame:CGRectMake(0,0,tweakTitle.intrinsicContentSize.width + 50, 40)];

		[contV addSubview:tweakTitle];
		[contV addSubview:icon];
		contV.center = headerView.center;

		[headerView addSubview:contV];

		//new shit
		// title
		UILabel *cred = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 30, headerView.bounds.size.width, 12)];
		cred.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
		cred.text = @"made by @candoizo";//[LOCALMembrane localisedStringForKey:@"CREATOR"];
		cred.textColor = [UIColor.blackColor colorWithAlphaComponent:0.65];
		cred.textAlignment = NSTextAlignmentCenter;
		cred.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		[headerView addSubview:cred];

		return headerView;
	}

	else if (section == 1 ) {
		UIView *planInfo = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 120)];
		planInfo.backgroundColor = UIColor.clearColor;

		UILabel * data = self.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,00, planInfo.frame.size.width/1.1, 30)];
		data.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
		data.textAlignment = 1;
		[self updateDataLabel];

		UILabel * days = self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,40, planInfo.frame.size.width/1.1, 30)];
		days.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
		days.textAlignment = 1;
		[self updateDateLabel];

		[planInfo addSubview:data];
		[planInfo addSubview:days];

		data.center = CGPointMake(self.view.center.x, data.center.y);
		days.center =	CGPointMake(self.view.center.x, days.center.y);

		return planInfo;

	}
	else if (section == 3) {
		UIView * orig = [[UIView alloc] initWithFrame:[super tableView:tableView viewForHeaderInSection:section].frame];
		UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = [label.font fontWithSize:13];
		label.text = [@"Monthly Data Allowance" uppercaseString];
		label.textColor = [UIColor.darkTextColor colorWithAlphaComponent:0.55];
		[label sizeToFit];
		[orig addSubview:label];

		UIButton * editdata = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 56,24,40,16)];
		editdata.backgroundColor = kMembraneTint;
		[editdata setTitle:@"Tweak" forState:UIControlStateNormal];
		editdata.titleLabel.font = [editdata.titleLabel.font fontWithSize:11];
		editdata.layer.masksToBounds = YES;
		editdata.layer.cornerRadius = editdata.frame.size.width/9;
		[editdata addTarget:self action:@selector(tweakData:) forControlEvents:UIControlEventTouchUpInside];
		[orig addSubview:editdata];

		label.center = CGPointMake(label.center.x + 15, editdata.center.y);

		return orig;

	} else if (section == 4) {
		UIView * orig = [[UIView alloc] initWithFrame:[super tableView:tableView viewForHeaderInSection:section].frame];
		UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = [label.font fontWithSize:13];
		label.text = [@"Monthly Cycle Tracker" uppercaseString];
		label.textColor = [UIColor.darkTextColor colorWithAlphaComponent:0.55];
		[label sizeToFit];
		[orig addSubview:label];


		UIButton * editdate = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 56, 24,40,16)];
	  editdate.backgroundColor = kMembraneTint;//[UIColor.redColor colorWithAlphaComponent:0.5];
	  [editdate setTitle:@"Tweak" forState:UIControlStateNormal];
	  editdate.titleLabel.font = [editdate.titleLabel.font fontWithSize:11];
	  editdate.layer.masksToBounds = YES;
	  editdate.layer.cornerRadius = editdate.frame.size.width/9;

	  [editdate addTarget:self action:@selector(tweakDate:) forControlEvents:UIControlEventTouchUpInside];
	  [orig addSubview:editdate];
	  label.center = CGPointMake(label.center.x + 15, editdate.center.y);

	  return orig;

	}
	else {
		return [super tableView:tableView viewForHeaderInSection:section];
	}
}

-(void)tweakDate:(id)sender {
	NSDate * refDate = [self.prefs valueForKey:@"referenceDate"];
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

	UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"Tweak Date Calculations" message:@"Incase our calculated dates don't align precisely with your carrier, use these buttons to compensate." preferredStyle:UIAlertControllerStyleAlert];
   UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
								handler:^(UIAlertAction * action) {
											[alert dismissViewControllerAnimated:YES completion:nil];
										 }];

	UIAlertAction* plus = [UIAlertAction actionWithTitle:@"+1 Day" style:UIAlertActionStyleDefault
									handler:^(UIAlertAction * action){
										[dateComponents setDay:+1];
										NSDate * newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:refDate options:0];
										[self.prefs setValue:newDate forKey:@"referenceDate"];
										[self.prefs synchronize];
										HBLogDebug(@"uh new ? \n\norig %@ \n\nnew %@", refDate, newDate);

										[self updateDateLabel];
										[alert dismissViewControllerAnimated:YES completion:nil];
										}];
   UIAlertAction* minus = [UIAlertAction actionWithTitle:@"-1 Day" style:UIAlertActionStyleDefault
											handler:^(UIAlertAction * action)	{
										[dateComponents setDay:-1];
										NSDate * newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:refDate options:0];
										[self.prefs setValue:newDate forKey:@"referenceDate"];
										[self.prefs synchronize];
										HBLogDebug(@"uh new ? \n\norig %@ \n\nnew %@", refDate, newDate);
										[self updateDateLabel];
										[alert dismissViewControllerAnimated:YES completion:nil];
										}];

	[alert addAction:plus];
	[alert addAction:minus];
	[alert addAction:cancel];
	[self presentViewController:alert animated:YES completion:nil];
}

-(void)tweakData:(id)sender {

	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Adjust Current Allotment" message:[NSString stringWithFormat:@"Incase your plan usage does not match exactly with the device's cellular usage, use these buttons to temporarily offset the current month. Useful for topping up your limit, as well as setting up for the first time.\n\n Currently we are modifying this months limit by %.1f MB", [[self.prefs valueForKey:@"tempOffset"] doubleValue]] preferredStyle:UIAlertControllerStyleAlert];
	[alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		 textField.textAlignment = 1;
	    textField.placeholder = @"500";
		 textField.keyboardType = UIKeyboardTypeNumberPad;
	    textField.secureTextEntry = NO;
	}];

	UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
								handler:^(UIAlertAction * action) {
											[alert dismissViewControllerAnimated:YES completion:nil];
										 }];

	UIAlertAction* plus = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault
									handler:^(UIAlertAction * action){
										[self.prefs setValue:@([[self.prefs valueForKey:@"tempOffset"] doubleValue]+[[[alert textFields][0] text] doubleValue]) forKey:@"tempOffset"];
										[alert dismissViewControllerAnimated:YES completion:nil];
										[self updateDataLabel];
										}];
	UIAlertAction* minus = [UIAlertAction actionWithTitle:@"Subtract" style:UIAlertActionStyleDefault
											handler:^(UIAlertAction * action)	{
												[self.prefs setValue:@([[self.prefs valueForKey:@"tempOffset"] doubleValue]-[[[alert textFields][0] text] doubleValue]) forKey:@"tempOffset"];
										[alert dismissViewControllerAnimated:YES completion:nil];
										[self updateDataLabel];
										}];

	[alert addAction:plus];
	[alert addAction:minus];
	[alert addAction:cancel];
	[self presentViewController:alert animated:YES completion:nil];
}

-(void)updateDateLabel {
	HBLogDebug(@"update ");
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

	[dateComponents setMonth:+1]; //increment by

	NSDate * refDate = [self.prefs valueForKey:@"referenceDate"]; //a date of reset from the cell plan
	HBLogDebug(@"The date of reference \n\n %@ \n", refDate);

	while ([refDate timeIntervalSinceNow] < 0.0) { //while the date is still in the past, add 1 month so we can figure out when the plan ends
		refDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:refDate options:0];
		HBLogDebug(@"after one increment, refDate is now %@", refDate);
	}
	HBLogDebug(@"The next day that the plan should end is %@", refDate);
	[self.prefs setValue:refDate forKey:@"cycleFinish"]; //the next future date the plan should end based on the ref date

	[dateComponents setMonth:-1]; //change to subtract one month so we can figure out when the plan wouldve started from our cycleFinish
	NSDate * startOfPlan = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:refDate options:0];
	[self.prefs setValue:startOfPlan forKey:@"cycleBegin"];

	//calculate days from the current day to the end of the plan
	NSDateComponents *comps = [[NSCalendar currentCalendar] components: NSDayCalendarUnit fromDate:[NSDate date] toDate:refDate options:0];
	HBLogDebug(@"the next day we should refresh cellular stats is (refDate FINAL) %@! days till %f", refDate, ((double)[comps day]));


	NSDate * lastRefresh = [self.prefs valueForKey:@"lastUpdate"];

	HBLogWarn(@"OK HERES INFO ABOUT THE PLAN WE HAVE FIGURED OUT:\n start of cycle \n%@\n end of cycle \n%@\n\n, last stat update\n %@\n\n, how long has it been since we last updated compared to the start of the plan\n %f", startOfPlan, refDate, lastRefresh, ((double)[startOfPlan timeIntervalSinceDate:lastRefresh]));

	// if ([startOfPlan timeIntervalSinceDate:lastRefresh] > 0){ //if lastUpdated is older than current start of plan, try to reset the stats
	// 	HBLogDebug(@"\n\nSTATS RESET\n\n");
	// 	//[this.cellController clearStats:@YES];
	// 	[[NSClassFromString(@"PSUISettingsNetworkController") sharedInstanceIfExists] clearStats:@YES];
	// }

	self.dateLabel.text = [NSString stringWithFormat:@"Your plan renews in %d days", ((int)[comps day])]; //update the label with how many days

}

-(void)updateDataLabel {
	HBLogDebug(@"suhuuhuhuh");
	//if data > 1000 > use 1000
	float monthlyAllotment = ([[self.prefs valueForKey:@"data"] floatValue] < 1000 ? 1048576 : 1000000) * ([[self.prefs valueForKey:@"data"] floatValue] + [[self.prefs valueForKey:@"tempOffset"] floatValue]); //this fucks up if it turns into gigs... zzz
	float remaining = monthlyAllotment - [[self.prefs valueForKey:@"bytesUsed"] floatValue];
	self.dataLabel.text = [NSByteCountFormatter stringFromByteCount:remaining countStyle:NSByteCountFormatterCountStyleFile];
	self.dataLabel.text = [NSString stringWithFormat:remaining > 0 ? @"Remaining: %@" : @"Limit Exceeded: %@", self.dataLabel.text];//remaining > 0 ? self.dataLabel.text : @"???"];

}

-(void)twitterButton {
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"likedMembrane"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	HBLogDebug(@"set like yes");

	NSString *user = @"candoizo";
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];

	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];

	else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];


}

-(void)supportButton {
	NSString *url = @"https://cydia.saurik.com/api/support/org.thebigboss.membrane";
		if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia:"]])
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"cydia://url/" stringByAppendingString:url]]];
		else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)hugButton {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"likedMembrane"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		HBLogDebug(@"set like yes");

		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/andreasott"]];

}

- (void)showLove {

	SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

	UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/7)];
   alertWindow.windowLevel = UIWindowLevelAlert + 3;
	[alertWindow setBackgroundColor:[UIColor clearColor]];
	alertWindow.rootViewController = [UIViewController new];

	UIView * fakeshadow = [[UIView alloc] initWithFrame:CGRectMake(0, -40, self.view.bounds.size.width, 40)];
	fakeshadow.backgroundColor = UIColor.blackColor;
	fakeshadow.alpha = 0;
	[composeController.view insertSubview:fakeshadow atIndex:0];

	UIView * topHalf = [[UIView alloc] initWithFrame:CGRectMake(0, -10 - self.view.bounds.size.height/7.5, self.view.bounds.size.width/1.05, self.view.bounds.size.height/7.25)];
	topHalf.backgroundColor = UIColor.whiteColor;
	topHalf.layer.masksToBounds = YES;
	topHalf.layer.cornerRadius = 9;


	UILabel *tweakTitle = [[UILabel alloc] initWithFrame:CGRectZero];
	tweakTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
	tweakTitle.text = @"Love This Tweak? Let me know! -candoizo";
	tweakTitle.textAlignment = NSTextAlignmentRight;
	tweakTitle.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.95];
	tweakTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	[tweakTitle sizeToFit];

	tweakTitle.frame = CGRectMake(25, 0, tweakTitle.bounds.size.width, 20);

	UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0, 20, 20)];
	icon.layer.masksToBounds = YES;
	icon.layer.cornerRadius = 3;
	icon.image = [UIImage imageNamed:@"Membrane" inBundle:kPrefBundle];

	UIView * contV = [[UIView alloc] initWithFrame:CGRectMake(0,15,tweakTitle.intrinsicContentSize.width + 25, 20)];
	contV.alpha = 0;
	[contV addSubview:tweakTitle];
	[contV addSubview:icon];
	contV.center = CGPointMake(topHalf.center.x, contV.center.y);

	[topHalf addSubview:contV];


	float btnSize = topHalf.frame.size.width/9;
	UIButton *twit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize)];
	[twit setImage:[UIImage _applicationIconImageForBundleIdentifier:@"com.atebits.Tweetie2" format:1 scale:[UIScreen mainScreen].scale] forState:UIControlStateNormal];
 	[twit addTarget:self action:@selector(twitterButton) forControlEvents:UIControlEventTouchUpInside];


 	UIButton *cydia = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize)];
 	[cydia setImage:[UIImage _applicationIconImageForBundleIdentifier:@"com.saurik.Cydia" format:1 scale:[UIScreen mainScreen].scale] forState:UIControlStateNormal];
	[cydia addTarget:self action:@selector(supportButton) forControlEvents:UIControlEventTouchUpInside];


	UIButton *saf = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnSize, btnSize)];
	[saf setImage:[UIImage _applicationIconImageForBundleIdentifier:@"com.apple.mobileme.fmf1" format:1 scale:[UIScreen mainScreen].scale] forState:UIControlStateNormal];
	[saf addTarget:self action:@selector(hugButton) forControlEvents:UIControlEventTouchUpInside];

	twit.center = CGPointMake(topHalf.center.x, contV.center.y + 35);
	saf.center = CGPointMake(topHalf.center.x - ([UIScreen mainScreen].bounds.size.width/3), twit.center.y);
	cydia.center = CGPointMake(topHalf.center.x + ([UIScreen mainScreen].bounds.size.width/3), twit.center.y);

	UILabel *twitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	twitLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:9];
	twitLabel.text = @"Twitter";
	twitLabel.textAlignment = NSTextAlignmentCenter;
	twitLabel.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.95];
	[twitLabel sizeToFit];

	UILabel *safLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	safLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:9];
	safLabel.text = @"Coffee";
	safLabel.textAlignment = NSTextAlignmentCenter;
	safLabel.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.95];
	[safLabel sizeToFit];

	UILabel *cydiaLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	cydiaLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:9];
	cydiaLabel.text = @"Support";
	cydiaLabel.textAlignment = NSTextAlignmentCenter;
	cydiaLabel.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.95];
	[cydiaLabel sizeToFit];

	[topHalf addSubview:twit];
	[topHalf addSubview:saf];
	[topHalf addSubview:cydia];

	twitLabel.center = CGPointMake(twit.center.x, twit.frame.origin.y + twit.frame.size.height + 5);
	safLabel.center = CGPointMake(saf.center.x, saf.frame.origin.y + saf.frame.size.height + 5);
	cydiaLabel.center = CGPointMake(cydia.center.x, cydia.frame.origin.y + cydia.frame.size.height + 5);

	[topHalf addSubview:twitLabel];
	[topHalf addSubview:safLabel];
	[topHalf addSubview:cydiaLabel];
	//[topHalf addSubview:linkBox];



	[alertWindow.rootViewController.view addSubview:topHalf];

	topHalf.center = CGPointMake(alertWindow.rootViewController.view.center.x, topHalf.center.y);

	[alertWindow makeKeyAndVisible];

	topHalf.userInteractionEnabled = YES;
	alertWindow.userInteractionEnabled = YES;


	[composeController setInitialText:kTweet];
	composeController.view.tintColor = kMembraneTint;

	[composeController setCompletionHandler:^(SLComposeViewControllerResult result) {
		if (result == SLComposeViewControllerResultDone) {

			  if ([self.prefs boolForKey:@"likedMembrane"]) {
			  	 HBLogDebug(@"already liked");
			  }
			  else {
			  	 self.navigationItem.rightBarButtonItem.title = @"♥";
			  	 [self.prefs setBool:YES forKey:@"likedMembrane"];
			  	 [self.prefs synchronize];
			  	 HBLogDebug(@"set like yes");
			  }

		}

		[UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
					//topHalf.frame  = CGRectMake(topHalf.frame.origin.x, -60, topHalf.frame.size.width, topHalf.frame.size.height);
					topHalf.alpha = 0;
					}
					completion:^(BOOL finished) {
					  	  if (finished)[alertWindow.rootViewController.view removeFromSuperview];
					}
		];
   }];


	[self presentViewController:composeController animated:YES completion:^(void) { //creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.

		[UIView animateWithDuration:.45 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			  		fakeshadow.alpha = 0.41;
		 	  	   }
		 			completion:nil
		];

	composeController.view.center = CGPointMake(composeController.view.center.x, composeController.view.center.y + 40);
	contV.alpha = 0.4;

		[UIView animateKeyframesWithDuration:2.0 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationCurveEaseInOut animations:^{
				     contV.alpha = 1;
				  }
				  completion:nil
		];

    }
	];

		[UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			      topHalf.frame  = CGRectMake(topHalf.frame.origin.x, -10, topHalf.frame.size.width, topHalf.frame.size.height);
			     }
				  completion:nil];


}
@end

@implementation MembraneSwitchCell
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 {
	self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
	if (self) {
		[((UISwitch *)[self control]) setOnTintColor:kMembraneTint];
		[self control].userInteractionEnabled = NO;


		UIView * gest = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/3, self.frame.size.height)];
		gest.center = CGPointMake(UIScreen.mainScreen.bounds.size.width- (gest.frame.size.width/2), self.center.y);
		UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(inform:)];
		longPress.minimumPressDuration = ((UISwitch *)[self control]).on ? 0.15f : 0.05f;
		[gest addGestureRecognizer: longPress];
		[self addSubview:gest];

	}
	return self;
}

-(void)inform:(id)sender {
			UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"Caution!" message:@"This feature should not be disabled as it is necessary for determining usage, and will cripple our ability to present you with accurate info." preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction* disable = [UIAlertAction actionWithTitle:@"Disable Stats Manager" style:UIAlertActionStyleDestructive
										handler:^(UIAlertAction * action) {
													[((UISwitch *)[self control]) setOn:NO animated:YES];
													[memController.prefs setBool:NO forKey:@"manage"];
													[alert dismissViewControllerAnimated:YES completion:nil];
												 }];
		   UIAlertAction* cancel = [UIAlertAction actionWithTitle:((UISwitch *)[self control]).on ? @"Cancel" : @"Activate!" style:UIAlertActionStyleCancel
										handler:^(UIAlertAction * action) {
													if (!((UISwitch *)[self control]).on)[((UISwitch *)[self control]) setOn:YES animated:YES];
													[memController.prefs setBool:YES forKey:@"manage"];
													[alert dismissViewControllerAnimated:YES completion:nil];
												 }];

												 [alert addAction:disable];
												 [alert addAction:cancel];
												 [memController presentViewController:alert animated:YES completion:nil];
}
@end

@implementation MembraneSegmentCell
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 {
	self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
	if (self) {
		self.tintColor = kMembraneTint;
	}
	return self;
}
@end

@implementation MembraneDatePickerCell
-(UITextField *)textField {
	UITextField * textField = [super textField];
	textField.tintColor = UIColor.clearColor;
	textField.textAlignment = 2;
	NSUserDefaults * prefs = [[NSUserDefaults alloc] initWithSuiteName:@"ca.ndoizo.membrane"];
	UIDatePicker* pickerView = [[UIDatePicker alloc] init];
	self.datePicker = pickerView;
	pickerView.datePickerMode = UIDatePickerModeDate;
	[pickerView sizeToFit];
	pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	textField.inputView = pickerView;

	UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
	keyboardDoneButtonView.barStyle = UIBarStyleDefault;
	keyboardDoneButtonView.translucent = YES;
	keyboardDoneButtonView.tintColor = UIColor.blackColor;
	[keyboardDoneButtonView sizeToFit];

	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save Reference Date" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
	[keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexSpace, doneButton, nil]];
	// Plug the keyboardDoneButtonView into the text field...
	textField.inputAccessoryView = keyboardDoneButtonView;
	if ([prefs valueForKey:@"referenceDate"]) self.datePicker.date = [prefs valueForKey:@"referenceDate"];
	return textField;
}

-(void)doneClicked:(id)sender {
	HBLogDebug(@"sender ?N %@", sender);
	NSDate *selectedTime = self.datePicker.date;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"d"];//@"MMM d, yyyy"];

	NSString * day = [formatter stringFromDate:selectedTime];
	NSDate *date = selectedTime;
	NSUserDefaults * prefs = [[NSUserDefaults alloc] initWithSuiteName:@"ca.ndoizo.membrane"];
	[prefs setValue:date forKey:@"referenceDate"]; //should set this as the orginal date probably

	if ([day hasSuffix:@"1"] && ![day isEqualToString:@"11"]) day = [NSString stringWithFormat:@"%@st", day];
	else if ([day hasSuffix:@"2"] && ![day isEqualToString:@"12"]) day = [NSString stringWithFormat:@"%@nd", day];
	else if ([day hasSuffix:@"3"] && ![day isEqualToString:@"13"]) day = [NSString stringWithFormat:@"%@rd", day];
	else day = [NSString stringWithFormat:@"%@th", day];

	[self textField].text = [NSString stringWithFormat:@"Renews on the %@", day];

	[prefs setValue:[self textField].text forKey:@"wordDate"];
	[prefs synchronize];


	[memController updateDateLabel];

  	[[self textField] resignFirstResponder];
}
@end

@implementation MembraneDataAmtCell
-(UITextField *)textField {
	UITextField * textField = [super textField];
	textField.placeholder = @"1000";
	textField.textAlignment = 2;

	UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
	keyboardDoneButtonView.barStyle = UIBarStyleDefault;
	keyboardDoneButtonView.translucent = YES;
	keyboardDoneButtonView.tintColor = UIColor.blackColor;
	[keyboardDoneButtonView sizeToFit];

	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Set Monthly Allotment" style:UIBarButtonItemStylePlain target:self action:@selector(saveData:)];
	[keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexSpace, doneButton, nil]];

	// Plug the keyboardDoneButtonView into the text field...
	textField.inputAccessoryView = keyboardDoneButtonView;
	return textField;
}

-(void)saveData:(id)sender {

	NSUserDefaults * prefs = [[NSUserDefaults alloc] initWithSuiteName:@"ca.ndoizo.membrane"];
	[prefs setValue:@([[self textField].text intValue]) forKey:@"data"];
	[prefs synchronize];

	[memController updateDataLabel];
  	[[self textField] resignFirstResponder];
}
@end
