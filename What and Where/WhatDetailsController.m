//
//  WhatDetailsController.m
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "WhatDetailsController.h"
#import "WhereListController.h"
#import "What.h"
#import "Where.h"
#import <QuartzCore/QuartzCore.h>
#import "macros.h"


@implementation WhatDetailsController

@synthesize scrollView, imageView, addPhotoButton, whatTextField, notesTextView, whereButton, cheapest;
@synthesize keyboardVisible, addMode, what;
@synthesize managedObjectContext=managedObjectContext_;

#pragma mark -
#pragma mark controller/view lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    imageView.layer.cornerRadius = 9.0;
    imageView.layer.masksToBounds = YES;
    
    self.title = what.whatName;

    if (addMode == YES) {
        [self setEditableView];
    } else {
        [self setNonEditableView];
    }
    
    whatTextField.text = what.whatName;
    notesTextView.text = what.whatNotes;
    
    scrollView.contentSize = self.view.frame.size;
    
}
 
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    self.imageView.image = [[[UIImage alloc] initWithData:what.whatPhoto] autorelease];

    
    // Get cheaper price
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wherePrice" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSArray *wheres = [what.wheres sortedArrayUsingDescriptors:sortDescriptors];
    if ([wheres count] > 0) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];

        cheapest.text = [NSString localizedStringWithFormat:@"%@ (%1.3f %@)",
         [[wheres objectAtIndex:0] whereName],
         [[[wheres objectAtIndex:0] wherePrice] floatValue],
         [f currencySymbol]];
        
        [f release];
    } else {
        cheapest.text = @"";
    }
    
    [sortDescriptors release];
    [sortDescriptor release];

    
    keyboardVisible = NO;
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

- (void)dealloc {
    [scrollView release];
    [imageView release];
    [addPhotoButton release];
    [whatTextField release];
    [notesTextView release];
    [whereButton release];
    [cheapest release];
    
    [what release];
    
    [managedObjectContext_ release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark UI management functions

-(IBAction) addPhotoButtonClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // Un appareil photo est disponible, on laisse le choix de la source
        UIActionSheet *photoSourceSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Add a photo", @"Title for photo source sheet") 
                                                                      delegate:self 
                                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel button on photo source sheet") 
                                                        destructiveButtonTitle:nil 
                                                             otherButtonTitles:NSLocalizedString(@"Take new photo", "Photo from camera button on photo source sheet"), 
                                                                               NSLocalizedString(@"Choose existing photo", "Photo from library on photo source sheet"), 
                                                                               nil, nil];
        [photoSourceSheet showInView:self.view];
        [photoSourceSheet release];
    } else {
        // Pas d'appareil photo, on va directement dans la bibliothèque d'images
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        [self presentModalViewController:picker animated:YES];
    }
}

-(IBAction) whereButtonClicked:(id)sender {
    WhereListController *whereListController = [[WhereListController alloc] initWithNibName:@"WhereListController" bundle:nil];
    
    whereListController.what = what;
    whereListController.managedObjectContext = self.managedObjectContext;
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:whereListController animated:YES];
    [whereListController release];
    
}


- (IBAction)switchEdit:(id)sender {
    [self setEditableView];
}


- (IBAction)cancel:(id)sender {
    whatTextField.text = what.whatName;
    notesTextView.text = what.whatNotes;
    
    self.title = what.whatName;
    
    [self setNonEditableView];
}

- (IBAction)save:(id)sender {
    if (what != nil) {
        if ([whatTextField.text length] != 0) {
            what.whatName = whatTextField.text;
        }
        what.whatNotes = notesTextView.text;        
        
        self.title = what.whatName;
    }
    
    [self setNonEditableView];
}

#pragma mark -
#pragma mark keyboard management functions


-(void)keyboardDidShow:(NSNotification *)notif {
    if (keyboardVisible) {
        return;
    }
    
    // Get the size of the keyboard.
    NSDictionary *info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    // Resize the scroll view to make room for the keyboard;
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height -= keyboardSize.height;
    
    scrollView.frame = viewFrame;
    keyboardVisible = YES;
}

-(void)keyboardDidHide:(NSNotification *)notif {
    if (!keyboardVisible) {
        return;
    }
    
    // Get the size of the keyboard.
    NSDictionary *info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    // Reset the height of the scroll view to its original value
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height += keyboardSize.height;
    
    scrollView.frame = viewFrame;
    keyboardVisible = NO;
}

#pragma mark -
#pragma mark local functions

-(void) setEditableView {
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self action:@selector(save:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                            target:self action:@selector(cancel:)] autorelease];

    whatTextField.enabled = YES;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")) {
        whatTextField.backgroundColor = [UIColor whiteColor];
    }
    whatTextField.borderStyle =  UITextBorderStyleRoundedRect;
    notesTextView.editable = YES;
    addPhotoButton.enabled = YES;
    whereButton.enabled = NO;
    whereButton.hidden = YES;
}

-(void) setNonEditableView {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
                                                                                            target:self action:@selector(switchEdit:)] autorelease];
    whatTextField.enabled = NO;
    whatTextField.borderStyle =  UITextBorderStyleNone;
    whatTextField.backgroundColor = [UIColor clearColor];

    notesTextView.editable = NO;
    addPhotoButton.enabled = NO;
    whereButton.enabled = YES;
    whereButton.hidden = NO;
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate functions


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    self.what.whatPhoto = UIImagePNGRepresentation(image);
    
    [self dismissModalViewControllerAnimated:YES];
    [picker release];
}

#pragma mark -
#pragma mark UIActionSheetDelegate functions

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            [picker release];
            return;
    }
    
    [self presentModalViewController:picker animated:YES];
}


@end
