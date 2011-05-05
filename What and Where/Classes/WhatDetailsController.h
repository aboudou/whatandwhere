//
//  WhatDetailsController.h
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "What.h"


@interface WhatDetailsController : UIViewController <UINavigationControllerDelegate , UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *addPhotoButton;
    IBOutlet UITextField *whatTextField;
    IBOutlet UITextView *notesTextView;
    IBOutlet UIButton *whereButton;
    IBOutlet UILabel *cheapest;

    BOOL keyboardVisible;
    BOOL addMode;
    What *what;
    
@private
    NSManagedObjectContext *managedObjectContext_;
}

@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UIButton *addPhotoButton;
@property(nonatomic, retain) IBOutlet UITextField *whatTextField;
@property(nonatomic, retain) IBOutlet UITextView *notesTextView;
@property(nonatomic, retain) IBOutlet UIButton *whereButton;
@property(nonatomic, retain) IBOutlet UILabel *cheapest;

@property(nonatomic, assign) BOOL keyboardVisible;
@property(nonatomic, assign) BOOL addMode;
@property(nonatomic, retain) What *what;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(IBAction) addPhotoButtonClicked:(id)sender;
-(IBAction) whereButtonClicked:(id)sender;

-(IBAction) switchEdit:(id)sender;
-(IBAction) save:(id)sender;
-(IBAction) cancel:(id)sender;

-(void)keyboardDidShow:(NSNotification *)notif;
-(void)keyboardDidHide:(NSNotification *)notif;

-(void) setEditableView;
-(void) setNonEditableView;

@end
