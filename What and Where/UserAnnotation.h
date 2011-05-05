//
//  UserAnnotation.h
//  What and Where
//
//  Created by Arnaud Boudou on 13/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface UserAnnotation : NSObject <MKAnnotation> {
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
- (NSString *) title;
- (NSString *) subtitle;

@end
