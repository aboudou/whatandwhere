//
//  WhatDetailsController.h
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "What.h"


@interface WhatDetailsController : UIViewController <UINavigationControllerDelegate , UIImagePickerControllerDelegate, UIActionSheetDelegate, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
}

@property(nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property(nonatomic, weak) IBOutlet UIView *imageBg;
@property(nonatomic, weak) IBOutlet UIImageView *imageView;
@property(nonatomic, weak) IBOutlet UITextField *whatTextField;
@property(nonatomic, weak) IBOutlet UITextView *notesTextView;
@property(nonatomic, weak) IBOutlet UIButton *addButton;
@property(nonatomic, weak) IBOutlet UIButton *delPhotoButton;
@property(nonatomic, weak) IBOutlet UILabel *cheapest;

@property(nonatomic, weak) IBOutlet UILabel *bestPriceLabel;
@property(nonatomic, weak) IBOutlet UIImageView *noPhoto;

@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, assign) BOOL imageResized;
@property(nonatomic, assign) CGRect imageRect;
@property(nonatomic, assign) BOOL keyboardVisible;
@property(nonatomic, assign) BOOL addMode;
@property(nonatomic, strong) What *what;

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;

-(IBAction) addPhotoButtonClicked:(id)sender;
-(IBAction) delPhotoButtonClicked:(id)sender;
-(IBAction) addButtonClicked:(id)sender;

-(IBAction) switchEdit:(id)sender;
-(IBAction) save:(id)sender;
-(IBAction) cancel:(id)sender;

-(void)keyboardDidShow:(NSNotification *)notif;
-(void)keyboardDidHide:(NSNotification *)notif;

-(void) setEditableView;
-(void) setNonEditableView;

@end
