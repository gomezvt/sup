//
//  SUPYelpMapTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/30/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "SUPYelpMapTableViewCell.h"
#import <MapKit/MapKit.h>
#import "YLPLocation.h"
#import "YLPCoordinate.h"

@interface SUPYelpMapTableViewCell ()

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation SUPYelpMapTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelectedBusiness:(YLPBusiness *)selectedBusiness
{
    _selectedBusiness = selectedBusiness;
    
    CLLocationCoordinate2D location;
    location.latitude = self.selectedBusiness.location.coordinate.latitude;
    location.longitude = self.selectedBusiness.location.coordinate.longitude;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.001;
    span.longitudeDelta = 0.001;
    
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = location;
    annotationPoint.title = self.selectedBusiness.name;
    [self.mapView addAnnotation:annotationPoint];

}

@end
