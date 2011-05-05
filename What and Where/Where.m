// 
//  Where.m
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 18/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Where.h"

#import "What.h"

@implementation Where 

@dynamic wherePrice;
@dynamic whereNotes;
@dynamic whereName;
@dynamic whereLongitude;
@dynamic whereLatitude;
@dynamic what;

-(CLLocationCoordinate2D) coordinate {
    CLLocationCoordinate2D captureCoord;
    captureCoord.latitude = [self.whereLatitude doubleValue];
    captureCoord.longitude = [self.whereLongitude doubleValue];
    
    return captureCoord;
}

-(NSString *) title {
    return self.whereName;
}

-(NSString *) subtitle {
    return nil;
}

@end
