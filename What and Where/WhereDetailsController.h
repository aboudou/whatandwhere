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
}

@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet UITextField *whereTextField;
@property(nonatomic, strong) IBOutlet UITextField *priceTextField;
@property(nonatomic, strong) IBOutlet UILabel *currencyLabel;
@property(nonatomic, strong) IBOutlet UITextView *notesTextView;
@property(nonatomic, strong) IBOutlet UIButton *locationButton;
@property(nonatomic, strong) IBOutlet UILabel *recapLabel;

@property(nonatomic, assign) BOOL keyboardVisible;
@property(nonatomic, assign) BOOL addMode;
@property(nonatomic, assign) BOOL editMode;
@property(nonatomic, strong) Where *where;

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
