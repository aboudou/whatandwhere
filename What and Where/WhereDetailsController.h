//
//  WhereDetailsController.h
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 18/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Where.h"


@interface WhereDetailsController : UIViewController {
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *whereTextField;
    IBOutlet UITextField *priceTextField;
    IBOutlet UILabel *currencyLabel;
    IBOutlet UITextView *notesTextView;
    IBOutlet UIButton *locationButton;
    IBOutlet UILabel *recapLabel;
    
    BOOL keyboardVisible;
    BOOL addMode;
    BOOL editMode;
    Where *where;
    
    double whereLatOld;
    double whereLonOld;
    double whereLatNew;
    double whereLonNew;
    
}

@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UITextField *whereTextField;
@property(nonatomic, retain) IBOutlet UITextField *priceTextField;
@property(nonatomic, retain) IBOutlet UILabel *currencyLabel;
@property(nonatomic, retain) IBOutlet UITextView *notesTextView;
@property(nonatomic, retain) IBOutlet UIButton *locationButton;
@property(nonatomic, retain) IBOutlet UILabel *recapLabel;

@property(nonatomic, assign) BOOL keyboardVisible;
@property(nonatomic, assign) BOOL addMode;
@property(nonatomic, assign) BOOL editMode;
@property(nonatomic, retain) Where *where;

// Original Where coordinates in case of edit cancel
@property(nonatomic, assign) double whereLatOld;
@property(nonatomic, assign) double whereLonOld;
// New Where coordinates to save
@property(nonatomic, assign) double whereLatNew;
@property(nonatomic, assign) double whereLonNew;

-(IBAction) locationClick:(id)sender;

-(IBAction) switchEdit:(id)sender;
-(IBAction) save:(id)sender;
-(IBAction) cancel:(id)sender;

-(void)keyboardDidShow:(NSNotification *)notif;
-(void)keyboardDidHide:(NSNotification *)notif;

-(void) setEditableView;
-(void) setNonEditableView;
-(void) setRecapLabelText;

@end
