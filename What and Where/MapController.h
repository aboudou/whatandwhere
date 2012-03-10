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
}

@property(nonatomic, strong) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) IBOutlet UIToolbar *viewToolbar;
@property(nonatomic, strong) IBOutlet UIToolbar *editToolbar;

@property(nonatomic, assign) BOOL editMode;
@property(nonatomic, assign) BOOL lsAvailable;
@property(nonatomic, strong) Where *where;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, assign) CLLocationCoordinate2D pinCoordinates;
@property(nonatomic, assign) CLLocationCoordinate2D userCoordinates;

-(IBAction) doneButtonPressed:(id)sender;
-(IBAction) saveButtonPressed:(id)sender;
-(IBAction) changeLocationButtonPressed:(id)sender;
-(IBAction) centerLocationButtonPressed:(id)sender;

-(void) checkForLocationService;

@end
