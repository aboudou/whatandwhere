//
//  MapController.m
//  What, Where, How Much
//
//  Created by Arnaud Boudou on 12/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapController.h"
#import "UserAnnotation.h"

@implementation MapController

@synthesize mapView, editToolbar, viewToolbar;
@synthesize editMode, lsAvailable, where, locationManager, pinCoordinates, userCoordinates;

#pragma mark -
#pragma mark controller/view lifecycle

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Init location manager
    [self checkForLocationService];
    
    if (lsAvailable) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
    
    CLLocationCoordinate2D mapCenter;
    if ([where.whereLatitude doubleValue] != -1) {
        // Center map on Where object coordinates
        mapCenter.latitude = [where.whereLatitude doubleValue];
        mapCenter.longitude = [where.whereLongitude doubleValue];
    } else {
        if (lsAvailable) {
            // Center map on users' coordinates
            CLLocation *position = self.locationManager.location;
            if (position != nil) {
                mapCenter.latitude = position.coordinate.latitude;
                mapCenter.longitude = position.coordinate.longitude;
            } else {
                mapCenter.latitude = 0;
                mapCenter.longitude = 0;
            }
        } else {
            mapCenter.latitude = 0;
            mapCenter.longitude = 0;
        }
    }
    
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = 0.005f;
    mapSpan.longitudeDelta = 0.005f;
    
    MKCoordinateRegion mapRegion;
    mapRegion.span = mapSpan;
    mapRegion.center = mapCenter;
    
    if ([where.whereLatitude doubleValue] != -1) {
        [self.mapView addAnnotation:where];
    }
    if ([where.whereLatitude doubleValue] != -1 || lsAvailable) {
        self.mapView.region = mapRegion;
    }
    self.mapView.mapType = MKMapTypeHybrid;
    self.mapView.showsUserLocation = YES;
    
    if (editMode) {
        editToolbar.hidden = NO;
        viewToolbar.hidden = YES;
    } else {
        editToolbar.hidden = YES;
        viewToolbar.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (lsAvailable) {
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
        self.locationManager = nil;
    }
    
    mapView.delegate = nil;
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
    
    [mapView release];
    [editToolbar release];
    [viewToolbar release];
    
    [where release];
    [locationManager release];
}

#pragma mark -
#pragma mark UI management methods

-(IBAction) doneButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) saveButtonPressed:(id)sender {
    where.whereLatitude = [NSNumber numberWithDouble:pinCoordinates.latitude];
    where.whereLongitude = [NSNumber numberWithDouble:pinCoordinates.longitude];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) changeLocationButtonPressed:(id)sender {
    UserAnnotation *userAnno = [[UserAnnotation alloc] init];
    
    userAnno.coordinate = mapView.region.center;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:userAnno];
    
    pinCoordinates.latitude = userAnno.coordinate.latitude;
    pinCoordinates.longitude = userAnno.coordinate.longitude;
    
    [userAnno release];
}

-(IBAction) centerLocationButtonPressed:(id)sender {
    [self checkForLocationService];
    
    
    
    if (lsAvailable) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        [self.mapView setCenterCoordinate:userCoordinates animated:YES];
        
        [UIView commitAnimations];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LocDisabled", @"Title for localisation disabled") 
                                                        message:NSLocalizedString(@"LocDisabledMsg", @"Message for localisation disabled") 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void) checkForLocationService {
    lsAvailable = YES;
    
    if ([CLLocationManager respondsToSelector:@selector (authorizationStatus)]) {
        if ([CLLocationManager locationServicesEnabled] == NO || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
            lsAvailable = NO;
        }
    } else if ([CLLocationManager locationServicesEnabled] == NO) {
        lsAvailable = NO;
    }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

// Update user location on core location update
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    userCoordinates.latitude = newLocation.coordinate.latitude;
    userCoordinates.longitude = newLocation.coordinate.longitude;
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"toto");
    NSLog(@"Error %@ %@", error, [error userInfo]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"The current location could not be obtained.", @"Message for localisation error") delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles:nil];
    [alert show];
    [alert release];
}


#pragma mark -
#pragma mark MKMapViewDelegate methods

/*
 // Center view on user location update
 - (void)mapView:(MKMapView *)theMapView didUpdateUserLocation:(MKUserLocation *)userLocation {
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:0.3];
 
 [theMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
 
 [UIView commitAnimations];
 }
 */


-(MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    pinCoordinates.latitude = annotation.coordinate.latitude;
    pinCoordinates.longitude = annotation.coordinate.longitude;
    
    if ([annotation isKindOfClass:[UserAnnotation class]]) {
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        
        if (!pinView) {
            pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                       reuseIdentifier:@"MyCustomAnnotation"] autorelease];
            pinView.draggable = YES;
            pinView.pinColor = MKPinAnnotationColorPurple;
            pinView.animatesDrop = YES;
            pinView.annotation = annotation;
            pinView.canShowCallout = NO;
        }
        
        return pinView;
    } else {
        return nil;
    }
}

-(void)mapView:(MKMapView *)theMapView annotationView:(MKAnnotationView *)theView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    // Wait for the end of drag and drop process
    if (oldState == MKAnnotationViewDragStateDragging) {
        UserAnnotation *annotation = (UserAnnotation *)theView.annotation;
        
        // Store new coordinates
        pinCoordinates.latitude = annotation.coordinate.latitude;
        pinCoordinates.longitude = annotation.coordinate.longitude;
        
        // Center the map on the annotation coordinates
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        MKCoordinateRegion mapRegion = self.mapView.region;
        CLLocationCoordinate2D mapCenter = mapRegion.center;
        
        mapCenter.latitude = annotation.coordinate.latitude;
        mapCenter.longitude = annotation.coordinate.longitude;
        
        mapRegion.center = mapCenter;
        
        self.mapView.region = mapRegion;
        
        [UIView commitAnimations];
    }
}

@end
