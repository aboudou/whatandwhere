//
//  MapController.h
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 12/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Where.h"

@interface MapController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate> {    
    BOOL editMode;
    BOOL lsAvailable;
    Where *where;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D pinCoordinates;
    CLLocationCoordinate2D userCoordinates;
}

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet UIToolbar *viewToolbar;
@property(nonatomic, retain) IBOutlet UIToolbar *editToolbar;

@property(nonatomic, assign) BOOL editMode;
@property(nonatomic, assign) BOOL lsAvailable;
@property(nonatomic, retain) Where *where;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, assign) CLLocationCoordinate2D pinCoordinates;
@property(nonatomic, assign) CLLocationCoordinate2D userCoordinates;

-(IBAction) doneButtonPressed:(id)sender;
-(IBAction) saveButtonPressed:(id)sender;
-(IBAction) changeLocationButtonPressed:(id)sender;
-(IBAction) centerLocationButtonPressed:(id)sender;

-(void) checkForLocationService;

@end
