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

@synthesize scrollView, imageBg, imageView, whatTextField, notesTextView, whereButton, delPhotoButton, cheapest, bestPriceLabel, noPhotoLabel;
@synthesize imageRect, imageResized, keyboardVisible, addMode, what;
@synthesize managedObjectContext = managedObjectContext_;
@synthesize tapGesture;

#pragma mark -
#pragma mark controller/view lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = what.whatName;

    if (addMode == YES) {
        [self setEditableView];
    } else {
        [self setNonEditableView];
    }
    
    whatTextField.text = what.whatName;
    notesTextView.text = what.whatNotes;
    
    scrollView.contentSize = self.view.frame.size;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhotoButtonClicked:)];
    [imageBg addGestureRecognizer:tapGesture];
    
}
 
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    self.imageView.image = [[UIImage alloc] initWithData:what.whatPhoto];

    
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
        
    } else {
        cheapest.text = @"";
    }
    
    imageView.layer.cornerRadius = 9.0;
    imageView.layer.masksToBounds = YES;
    imageBg.layer.cornerRadius = 9.0;
    imageBg.layer.masksToBounds = YES;
    if (imageView.image != nil) {
        imageBg.backgroundColor = [UIColor blackColor];
    }
    
    imageRect = imageView.frame;
    imageResized = NO;
    
    keyboardVisible = NO;
    
    // Localisation interface
    [whatTextField setPlaceholder:NSLocalizedString(@"What ?", @"")];
    [bestPriceLabel setText:NSLocalizedString(@"Best price:", @"")];
    [noPhotoLabel setText:NSLocalizedString(@"No photo", @"")];
    [whereButton setTitle:NSLocalizedString(@"Where ?", @"") forState:UIControlStateNormal];
    [whereButton setTitle:NSLocalizedString(@"Where ?", @"") forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidUnload {
    // Sauvegarde des modifications
    if (whatTextField.enabled) {
        [self save:nil];
    }

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark UI management functions

-(IBAction) addPhotoButtonClicked:(id)sender {
    if (whatTextField.enabled) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // Un appareil photo est disponible, on laisse le choix de la source
            UIActionSheet *photoSourceSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Add a photo", @"") 
                                                                          delegate:self 
                                                                 cancelButtonTitle:NSLocalizedString(@"Cancel", @"") 
                                                            destructiveButtonTitle:nil 
                                                                 otherButtonTitles:NSLocalizedString(@"Take new photo", ""), 
                                                                                   NSLocalizedString(@"Choose existing photo", ""), 
                                                                                   nil, nil];
            [photoSourceSheet showInView:self.view];
        } else {
            // Pas d'appareil photo, on va directement dans la bibliothèque d'images
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            
            [self presentModalViewController:picker animated:YES];
        }
    } else {
        if ([imageView image] != nil) {
            if (!imageResized) {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                
                imageView.layer.cornerRadius = 0.0;
                imageView.layer.masksToBounds = NO;
                imageBg.layer.cornerRadius = 0.0;
                imageBg.layer.masksToBounds = NO;

                [[self navigationController] setNavigationBarHidden:YES animated:YES];
                [imageView setFrame:CGRectMake(0, 70, 320, 320)];
                [imageBg setFrame:CGRectMake(0, 0, 320, 460)];
                [imageBg setBackgroundColor:[UIColor blackColor]];

                imageResized = YES;
                
                [UIView commitAnimations];

                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];

            } else {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                
                imageView.layer.cornerRadius = 9.0;
                imageView.layer.masksToBounds = YES;
                imageBg.layer.cornerRadius = 9.0;
                imageBg.layer.masksToBounds = YES;
                
                [[self navigationController] setNavigationBarHidden:NO animated:YES];
                [imageView setFrame:imageRect];
                [imageBg setFrame:imageRect];
                if (imageView.image != nil) {
                    imageBg.backgroundColor = [UIColor blackColor];
                } else {
                    [imageBg setBackgroundColor:[UIColor whiteColor]];
                }

                imageResized = NO;
                
                [UIView commitAnimations];

                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }
        }
    }
}

-(IBAction) delPhotoButtonClicked:(id)sender {
    imageView.image = nil;
    
    [imageBg setBackgroundColor:[UIColor whiteColor]];

    delPhotoButton.enabled = NO;
    delPhotoButton.hidden = YES;
}

-(IBAction) whereButtonClicked:(id)sender {
    WhereListController *whereListController = [[WhereListController alloc] initWithNibName:@"WhereListController" bundle:nil];
    
    whereListController.what = what;
    whereListController.managedObjectContext = self.managedObjectContext;
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:whereListController animated:YES];
    
}


- (IBAction)switchEdit:(id)sender {
    [self setEditableView];
}


- (IBAction)cancel:(id)sender {
    whatTextField.text = what.whatName;
    notesTextView.text = what.whatNotes;
    imageView.image = [[UIImage alloc] initWithData:what.whatPhoto];
    
    self.title = what.whatName;
    
    [self setNonEditableView];
}

- (IBAction)save:(id)sender {
    if (what != nil) {
        if ([whatTextField.text length] != 0) {
            what.whatName = whatTextField.text;
        }
        what.whatNotes = notesTextView.text;        
        what.whatPhoto = UIImagePNGRepresentation(imageView.image);
        
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                            target:self action:@selector(cancel:)];

    whatTextField.enabled = YES;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")) {
        whatTextField.backgroundColor = [UIColor whiteColor];
    }
    whatTextField.borderStyle =  UITextBorderStyleRoundedRect;
    notesTextView.editable = YES;
    whereButton.enabled = NO;
    whereButton.hidden = YES;

    if (imageView.image != nil) {
        delPhotoButton.enabled = YES;
        delPhotoButton.hidden = NO;
    }
}

-(void) setNonEditableView {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
                                                                                            target:self action:@selector(switchEdit:)];
    whatTextField.enabled = NO;
    whatTextField.borderStyle =  UITextBorderStyleNone;
    whatTextField.backgroundColor = [UIColor clearColor];

    notesTextView.editable = NO;
    whereButton.enabled = YES;
    whereButton.hidden = NO;

    delPhotoButton.enabled = NO;
    delPhotoButton.hidden = YES;
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate functions


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // On sauvegarde directement la photo : la prise de photo avec iPhone 3GS provoque un memory warning et décharge la vue courante,
    //   du coup l'image est perdue.
    what.whatPhoto = UIImagePNGRepresentation((UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"]);
    
    if (what.whatPhoto != nil) {
        delPhotoButton.enabled = YES;
        delPhotoButton.hidden = NO;
    }
    
    [self dismissModalViewControllerAnimated:YES];
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
            return;
    }
    
    [self presentModalViewController:picker animated:YES];
}


@end
