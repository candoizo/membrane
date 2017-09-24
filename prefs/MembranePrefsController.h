#import <Social/Social.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSSegmentTableCell.h>
#import <Preferences/PSEditableTableCell.h>

@interface MembranePrefsController : PSListController
@property (nonatomic) UIViewController * firstUse;
@property (nonatomic) NSUserDefaults * prefs;
@property (nonatomic) UILabel * dataLabel;
@property (nonatomic) UILabel * dateLabel;
@property (nonatomic) UILabel * alertSub;
//overridden
-(void)viewDidLoad;
-(void)viewWillAppear:(BOOL)arg1;
-(void)viewWillDisappear:(BOOL)arg1;
- (NSArray *)specifiers;
- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section;
- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section;

//custom methods
+(void)clearPrefs;
-(void)dismissIntro;
-(void)tweakData:(id)sender;
-(void)tweakDate:(id)sender;
-(void)updateDataLabel;
-(void)updateDateLabel;
-(void)twitterButton;
-(void)supportButton;
-(void)hugButton;
- (void)showLove;
@end


@interface MembraneSwitchCell : PSSwitchTableCell
@end

@interface MembraneSegmentCell : PSSegmentTableCell
@end

@interface PSEditableTableCell (Unknown)
-(UITextField *)textField;
@end

@interface MembraneDatePickerCell : PSEditableTableCell
@property (nonatomic) UIDatePicker * datePicker;
-(UITextField *)textField;
@end

@interface MembraneDataAmtCell : PSEditableTableCell
-(UITextField *)textField;
@end
