//
//  WhereListController.h
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 18/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "What.h"

@interface WhereListController : UITableViewController <NSFetchedResultsControllerDelegate> {
    What *what;
    
@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectContext *addingManagedObjectContext_;
}

@property(nonatomic, retain) What *what;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;


- (void)segAction:(id)sender;
- (void)editDone;
- (void)setEditMode;
- (void)exitEditMode;

@end
