//
//  What.h
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 18/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Where;

@interface What :  NSManagedObject {
}

@property (nonatomic, strong) NSData * whatPhoto;
@property (nonatomic, strong) NSString * whatName;
@property (nonatomic, strong) NSString * whatNotes;
@property (nonatomic, strong) NSSet* wheres;

@end


@interface What (CoreDataGeneratedAccessors)
- (void)addWheresObject:(Where *)value;
- (void)removeWheresObject:(Where *)value;
- (void)addWheres:(NSSet *)value;
- (void)removeWheres:(NSSet *)value;

@end

