//
//  Where.h
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 18/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@class What;

@interface Where :  NSManagedObject <MKAnnotation>
{
}

@property (nonatomic, retain) NSNumber * wherePrice;
@property (nonatomic, retain) NSString * whereNotes;
@property (nonatomic, retain) NSString * whereName;
@property (nonatomic, retain) NSNumber * whereLongitude;
@property (nonatomic, retain) NSNumber * whereLatitude;
@property (nonatomic, retain) What * what;


@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (NSString *) title;
- (NSString *) subtitle;

@end



