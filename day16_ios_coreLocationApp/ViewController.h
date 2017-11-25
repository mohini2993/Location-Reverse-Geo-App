//
//  ViewController.h
//  day16_ios_coreLocationApp
//
//  Created by Student 01 on 27/09/17.
//  Copyright © 2017 mohini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface ViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

- (IBAction)detectButton:(id)sender;


@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;
- (IBAction)changeMapView:(id)sender;

@property CLLocationManager *locationManager;



@end

