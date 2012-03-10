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
}

@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet UIButton *addPhotoButton;
@property(nonatomic, strong) IBOutlet UITextField *whatTextField;
@property(nonatomic, strong) IBOutlet UITextView *notesTextView;
@property(nonatomic, strong) IBOutlet UIButton *whereButton;
@property(nonatomic, strong) IBOutlet UILabel *cheapest;

@property(nonatomic, assign) BOOL keyboardVisible;
@property(nonatomic, assign) BOOL addMode;
@property(nonatomic, strong) What *what;

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;

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
