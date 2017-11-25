//
//  ViewController.m
//  day16_ios_coreLocationApp
//
//  Created by Student 01 on 27/09/17.
//  Copyright © 2017 mohini. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration=2;
    [self.myMapView addGestureRecognizer:longPress];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    CLLocationCoordinate2D coordinate;
    if(gesture.state==UIGestureRecognizerStateBegan)
    {
        CGPoint locationPoint=[gesture locationInView:gesture.view];
        coordinate=[self.myMapView convertPoint:locationPoint toCoordinateFromView:gesture.view];
        MKPointAnnotation *annotationPoint=[[MKPointAnnotation alloc]init];
        annotationPoint.coordinate=coordinate;
        NSLog(@"%f Latitude and %f Longitude",annotationPoint.coordinate.latitude,annotationPoint.coordinate.longitude);
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        CLLocation *location=[[CLLocation alloc]initWithLatitude:annotationPoint.coordinate.latitude longitude:annotationPoint.coordinate.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
         {
        if(placemarks.count >0)
        {
            CLPlacemark *placemark=[placemarks lastObject];
            NSString *title=[placemark.subThoroughfare stringByAppendingString:placemark.thoroughfare];
            NSString *subtitle=placemark.locality;
            annotationPoint.title=title;
            annotationPoint.subtitle=subtitle;
            [self.myMapView addAnnotation:annotationPoint];
            
       }
   }];
    }
}
-(void)detectLocation
{
    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.delegate=self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
 
    CLLocation *currentLocation=[locations lastObject];
    if(currentLocation !=nil)
    {
    CLLocationCoordinate2D  coOrdinate;
    CGFloat latitude,longitude;
    latitude=currentLocation.coordinate.latitude;
    NSLog(@"Latitude=%f",latitude);
    longitude=currentLocation.coordinate.longitude;
    NSLog(@"Longitude=%f",longitude);
    coOrdinate=currentLocation.coordinate;
    MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region=MKCoordinateRegionMake(coOrdinate, span);
    [self.myMapView setRegion:region];
    };
   /* //pin location
    MKPointAnnotation *mkPoint=[[MKPointAnnotation alloc]init];
    CLLocation *location=[[CLLocation alloc]initWithLatitude:coOrdinate.latitude longitude:coOrdinate.longitude];
    mkPoint.coordinate=location.coordinate;
    
    //reverse Geocoder
      CLGeocoder *reverseGeo;
    [reverseGeo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSString *locality= placemark.locality;
        NSString *title=[placemark.thoroughfare stringByAppendingString:locality];
        NSString *subTitle=placemark.subThoroughfare;
        mkPoint.title=title;
        mkPoint.subtitle=subTitle;
       // [self.myMapView addAnnotation:mkPoint];
    }];
    [self.myMapView addAnnotation:mkPoint];*/
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        MKAnnotationView *pinView=(MKAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:@"myPin"];
        if(!pinView)
        {
            pinView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myPin"];
            pinView.canShowCallout=YES;
            pinView.calloutOffset=CGPointMake(0, 32);
        }
        return pinView;
        }
       else
        {
        return nil;
       }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeMapView:(id)sender
{
  switch(self.mySegment.selectedSegmentIndex)
    {
        case 0:
            self.myMapView.mapType=MKMapTypeStandard;
            break;
        case 1:
            self.myMapView.mapType=MKMapTypeSatellite;
            break;
        case 2 :
            self.myMapView.mapType=MKMapTypeHybrid;
            break;
        default:
               break;
    }
}
- (IBAction)detectButton:(id)sender
{
    [self detectLocation];
}
@end
