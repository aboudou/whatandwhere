//
//  WhatDetailsController.m
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "WhatDetailsController.h"
#import "WhereDetailsController.h"
#import "What.h"
#import "Where.h"
#import <QuartzCore/QuartzCore.h>
#import "macros.h"


@implementation WhatDetailsController

@synthesize scrollView, imageBg, imageView, whatTextField, notesTextView, addButton, delPhotoButton, cheapest, bestPriceLabel, noPhoto;
@synthesize imageRect, imageResized, keyboardVisible, addMode, what;
@synthesize tableView;
@synthesize managedObjectContext = managedObjectContext_;
@synthesize fetchedResultsController = fetchedResultsController_;
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
    
    [self.tableView reloadData];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    
    // Localisation interface
    [whatTextField setPlaceholder:NSLocalizedString(@"What ?", @"")];
    [bestPriceLabel setText:NSLocalizedString(@"Best price:", @"")];
    [noPhoto setImage:[UIImage imageNamed:@"empty"]];
    [self.addButton setTitle:NSLocalizedString(@"Add", @"") forState:UIControlStateNormal];
    [self.addButton setTitle:NSLocalizedString(@"Add", @"") forState:UIControlStateHighlighted];
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
                [noPhoto setHidden:YES];

                [UIView animateWithDuration:0.3
                                 animations:^{
                                     imageView.layer.cornerRadius = 0.0;
                                     imageView.layer.masksToBounds = NO;
                                     imageBg.layer.cornerRadius = 0.0;
                                     imageBg.layer.masksToBounds = NO;
                                     
                                     [[self navigationController] setNavigationBarHidden:YES animated:YES];
                                     [imageView setFrame:CGRectMake(0, 70, 320, 320)];
                                     [imageBg setFrame:CGRectMake(0, 0, 320, 460)];
                                     [imageBg setBackgroundColor:[UIColor blackColor]];
                                     
                                     imageResized = YES;
                                 }
                                 completion:^(BOOL finished){
                                     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
                                 }];
            } else {
                [UIView animateWithDuration:0.3
                                 animations:^{
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
                                 }
                                 completion:^(BOOL finished){
                                     [noPhoto setHidden:NO];
                                     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                                 }];
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

-(IBAction) addButtonClicked:(id)sender {
    WhereDetailsController *whereDetailViewController = [[WhereDetailsController alloc] initWithNibName:@"WhereDetailsController" bundle:nil];
    
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Where *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    [newManagedObject setValue:NSLocalizedString(@"Where ?", @"") forKey:@"whereName"];
    [newManagedObject setValue:what forKey:@"what"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    whereDetailViewController.where = newManagedObject;
    whereDetailViewController.addMode = YES;
    
    [self.navigationController pushViewController:whereDetailViewController animated:YES];
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
    [addButton setEnabled:NO];
    [addButton setHidden:YES];
    [tableView setHidden:YES];

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
    [addButton setEnabled:YES];
    [addButton setHidden:NO];
    [tableView setHidden:NO];

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

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Where" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wherePrice" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // NSPredicate : équivalent SQL du WHERE
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"what == %@", what];
    [fetchRequest setPredicate:predicate];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchedResultsController_;
}

#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark Table view data source

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    cell.textLabel.text = [NSString localizedStringWithFormat:@"%@ (%1.3f %@)",
                           [[managedObject valueForKey:@"whereName"] description],
                           [[managedObject valueForKey:@"wherePrice"] floatValue],
                           [f currencySymbol]];
    
    cell.detailTextLabel.text = [[managedObject valueForKey:@"whereNotes"] description];
    
    if ([[managedObject valueForKey:@"whereLatitude"] intValue] != -1 && [[managedObject valueForKey:@"whereLongitude"] intValue] != -1) {
        [cell.imageView setHidden:NO];
        cell.imageView.image = [UIImage imageNamed:@"pin"];
    } else {
        [cell.imageView setHidden:YES];
        cell.imageView.image = [UIImage imageNamed:@"empty"];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here -- for example, create and push another view controller.
    WhereDetailsController *whereDetailViewController = [[WhereDetailsController alloc] initWithNibName:@"WhereDetailsController" bundle:nil];
    
    Where *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    whereDetailViewController.where = selectedObject;
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:whereDetailViewController animated:YES];
}




@end
