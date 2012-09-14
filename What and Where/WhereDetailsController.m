//
//  WhereDetailsController.m
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 18/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WhereDetailsController.h"
#import "MapController.h"
#import "macros.h"


@implementation WhereDetailsController


@synthesize scrollView, whereTextField, priceTextField, currencyLabel, bgNotesButton, notesTextView, locationButton, recapLabel;
@synthesize keyboardVisible, addMode, editMode;
@synthesize where;
@synthesize whereLatOld, whereLonOld, whereLatNew, whereLonNew;

#pragma mark -
#pragma mark controller/view lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = where.whereName;
    [self setRecapLabelText];
    
    whereTextField.text = where.whereName;
    notesTextView.text = where.whereNotes;
    priceTextField.text = [NSString localizedStringWithFormat:@"%1.3f", [where.wherePrice floatValue]];
    
    if ((UIKeyboardTypeDecimalPad) && ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)) {
        priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    } else {
        priceTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    
    // Initialize backup of where coordinates
    whereLatOld = [where.whereLatitude doubleValue];
    whereLonOld = [where.whereLongitude doubleValue];
    whereLatNew = [where.whereLatitude doubleValue];
    whereLonNew = [where.whereLongitude doubleValue];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    currencyLabel.text = [f currencySymbol];
    
    scrollView.contentSize = self.view.frame.size;
    
    if ([[UIScreen mainScreen] bounds].size.height > 480.0f) {
        self.locationButton.frame = CGRectMake(20, 447, 280, 37);
        self.bgNotesButton.frame = CGRectMake(20, 127, 280, 312);
        self.notesTextView.frame = CGRectMake(28, 134, 263, 297);
    }
    
    if (addMode == YES) {
        [self setEditableView];
    } else {
        [self setNonEditableView];
    }
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (editMode) {
        // Save new coordinates which will eventually be saved
        whereLatNew = [where.whereLatitude doubleValue];
        whereLonNew = [where.whereLongitude doubleValue];
        
        // Restore original coordinates in case of cancel
        where.whereLatitude = [NSNumber numberWithDouble:whereLatOld];
        where.whereLongitude = [NSNumber numberWithDouble:whereLonOld];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    keyboardVisible = NO;
    
    // Localisation interface
    [whereTextField setPlaceholder:NSLocalizedString(@"Where ?", @"")];
    [priceTextField setPlaceholder:NSLocalizedString(@"How much ?", @"")];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#pragma mark -
#pragma mark UI management functions

-(IBAction) locationClick:(id)sender {
    MapController *controller = [[MapController alloc] initWithNibName:@"MapController" bundle:nil];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    controller.where = self.where;
    controller.editMode = editMode;
    
    [self.navigationController presentModalViewController:controller animated:YES];
}

- (IBAction)switchEdit:(id)sender {
    [self setEditableView];
}


- (IBAction)cancel:(id)sender {
    whereTextField.text = where.whereName;
    notesTextView.text = where.whereNotes;
    priceTextField.text = [NSString localizedStringWithFormat:@"%1.3f", [where.wherePrice floatValue]];
    
    self.title = where.whereName;
    [self setRecapLabelText];
    
    // Undo previously saved coordinates
    whereLatNew = [where.whereLatitude doubleValue];
    whereLonNew = [where.whereLongitude doubleValue];
    
    [self setNonEditableView];
}

- (IBAction)save:(id)sender {
    if (where != nil) {
        if ([whereTextField.text length] != 0) {
            where.whereName = whereTextField.text;
        }
        where.whereNotes = notesTextView.text;
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        self.where.wherePrice = [f numberFromString:priceTextField.text];
        
        
        // Save new coordinates
        where.whereLatitude = [NSNumber numberWithDouble:whereLatNew];
        where.whereLongitude = [NSNumber numberWithDouble:whereLonNew];
        
        // Backup new coordinates for a new edit / save cycle
        whereLatOld = [where.whereLatitude doubleValue];
        whereLonOld = [where.whereLongitude doubleValue];
        
        priceTextField.text = [NSString localizedStringWithFormat:@"%1.3f", [where.wherePrice floatValue]];
        self.title = where.whereName;
        [self setRecapLabelText];
    }
    
    [self setNonEditableView];
}

#pragma mark -
#pragma mark Keyboard management functions

-(void)keyboardDidShow:(NSNotification *)notif {
    if (keyboardVisible) {
        return;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         // Get the size of the keyboard.
                         NSDictionary *info = [notif userInfo];
                         NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
                         CGSize keyboardSize = [aValue CGRectValue].size;
                         
                         // Resize the scroll view to make room for the keyboard;
                         CGRect viewFrame = self.view.frame;
                         viewFrame.size.height -= keyboardSize.height;
                         
                         scrollView.frame = viewFrame;
                         scrollView.contentSize = self.view.frame.size;
                         
                         keyboardVisible = YES;
                     }];
}

-(void)keyboardDidHide:(NSNotification *)notif {
    if (!keyboardVisible) {
        return;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         scrollView.frame = self.view.frame;
                         keyboardVisible = NO;
                     }];
}

#pragma mark -
#pragma mark Local functions

-(void) setEditableView {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                            target:self action:@selector(cancel:)];
    editMode = YES;
    whereTextField.enabled = YES;
    notesTextView.editable = YES;
    priceTextField.enabled = YES;
    whereTextField.hidden = NO;
    priceTextField.hidden = NO;
    currencyLabel.hidden = NO;
    recapLabel.hidden = YES;
    
    priceTextField.backgroundColor = [UIColor whiteColor];
    whereTextField.backgroundColor = [UIColor whiteColor];
    priceTextField.borderStyle =  UITextBorderStyleRoundedRect;
    whereTextField.borderStyle =  UITextBorderStyleRoundedRect;

    [locationButton setTitle:NSLocalizedString(@"Edit location", @"") forState:UIControlStateNormal];
    [locationButton setTitle:NSLocalizedString(@"Edit location", @"") forState:UIControlStateHighlighted];
}

-(void) setNonEditableView {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
                                                                                            target:self action:@selector(switchEdit:)];
    editMode = NO;
    whereTextField.enabled = NO;
    notesTextView.editable = NO;
    priceTextField.enabled = NO;
    whereTextField.hidden = YES;
    priceTextField.hidden = YES;
    currencyLabel.hidden = YES;
    recapLabel.hidden = NO;
    
    priceTextField.borderStyle =  UITextBorderStyleNone;
    whereTextField.borderStyle =  UITextBorderStyleNone;
    
    [locationButton setTitle:NSLocalizedString(@"View location", @"") forState:UIControlStateNormal];
    [locationButton setTitle:NSLocalizedString(@"View location", @"") forState:UIControlStateHighlighted];
}

-(void) setRecapLabelText {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    recapLabel.text = [NSString localizedStringWithFormat:@"%@ (%1.3f %@)", where.whereName, [where.wherePrice floatValue], [f currencySymbol]];
}    

@end
