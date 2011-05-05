//
//  What.h
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 18/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Where;

@interface What :  NSManagedObject  
{
}

@property (nonatomic, retain) NSData * whatPhoto;
@property (nonatomic, retain) NSString * whatName;
@property (nonatomic, retain) NSString * whatNotes;
@property (nonatomic, retain) NSSet* wheres;

@end


@interface What (CoreDataGeneratedAccessors)
- (void)addWheresObject:(Where *)value;
- (void)removeWheresObject:(Where *)value;
- (void)addWheres:(NSSet *)value;
- (void)removeWheres:(NSSet *)value;

@end

