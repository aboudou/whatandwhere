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

@interface Where :  NSManagedObject <MKAnnotation> {
}

@property (nonatomic, strong) NSNumber * wherePrice;
@property (nonatomic, strong) NSString * whereNotes;
@property (nonatomic, strong) NSString * whereName;
@property (nonatomic, strong) NSNumber * whereLongitude;
@property (nonatomic, strong) NSNumber * whereLatitude;
@property (nonatomic, strong) What * what;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (NSString *) title;
- (NSString *) subtitle;

@end



