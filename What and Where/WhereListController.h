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
}

@property (nonatomic, strong) What *what;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *addingManagedObjectContext;

- (void)segAction:(id)sender;
- (void)editDone;
- (void)setEditMode;
- (void)exitEditMode;

@end
