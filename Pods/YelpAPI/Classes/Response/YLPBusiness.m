//
//  Business.m
//  Pods
//
//  Created by David Chen on 1/5/16.
//
//

#import "YLPBusiness.h"

#import "YLPCategory.h"
#import "YLPCoordinate.h"
#import "YLPLocation.h"
#import "YLPResponsePrivate.h"
#import <CoreLocation/CoreLocation.h>

@implementation YLPBusiness

- (instancetype)initWithDictionary:(NSDictionary *)businessDict {
    if (self = [super init]) {
        NSString *phone = [businessDict ylp_objectMaybeNullForKey:@"phone"];
        NSString *imageURLString = [businessDict ylp_objectMaybeNullForKey:@"image_url"];
//        if (imageURLString)
//        {
//            NSURL *url = [NSURL URLWithString:imageURLString];
//            NSData *imageData = [NSData dataWithContentsOfURL:url];
//            self.businessThumbnail = [UIImage imageWithData:imageData];
//        }
        _closed = [businessDict[@"is_closed"] boolValue];
        if (businessDict[@"url"])
        {
            _URL = [[NSURL alloc] initWithString:businessDict[@"url"]];
        }
        
        id reviews = businessDict[@"reviews"];
        if (reviews)
        {
            if ([reviews isKindOfClass:[NSArray class]])
            {
                _reviews = reviews;
            }
        }
        
        id photos = businessDict[@"photos"];
        if (photos)
        {
//            NSMutableArray *photosArray = [NSMutableArray array];
            if ([photos isKindOfClass:[NSArray class]])
            {
//                for (NSString *imageStr in photos)
//                {
//                    NSURL *url = [NSURL URLWithString:imageStr];
//                    NSData *imageData = [NSData dataWithContentsOfURL:url];
//                    UIImage *image = [UIImage imageWithData:imageData];
//                    [photosArray addObject:image];
//                }
                _photos = photos;
            }
        }
        _imageURL = imageURLString.length > 0 ? [[NSURL alloc] initWithString:imageURLString] : nil;
        _rating = [businessDict[@"rating"] doubleValue];
        _reviewCount = [businessDict[@"review_count"] integerValue];
        _name = businessDict[@"name"];
        _identifier = businessDict[@"id"];
        _phone = phone.length > 0 ? phone : nil;
        _price = businessDict[@"price"];
         _open_now = businessDict[@"is_open_now"];
        // BusinessWithID returned values
        id hoursItem = businessDict[@"hours"];
        if ([hoursItem isKindOfClass:[NSArray class]])
        {
            NSArray *hoursArray = (NSArray *)hoursItem;
            if ([[hoursArray lastObject] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *hoursDict = [hoursArray lastObject];
                id value = hoursDict[@"is_open_now"];
                if ([value isKindOfClass:[NSNumber class]])
                {
                    _isOpenNow = [value boolValue];
                }
                
                _businessHours = hoursDict[@"open"];
            }
        }
        
//        if (businessDict[@"reviews"])
//        {
//            _reviews = businessDict[@"reviews"];
//        }


        _categories = [self.class categoriesFromJSONArray:businessDict[@"categories"]];
        YLPCoordinate *coordinate = [self.class coordinateFromJSONDictionary:businessDict[@"coordinates"]];
        _location = [[YLPLocation alloc] initWithDictionary:businessDict[@"location"] coordinate:coordinate];
        
        //        for (YLPBusiness *business in self.filteredArrayCopy)
        //        {
        //            CLLocation *bizLocation = [[CLLocation alloc] initWithLatitude:business.location.coordinate.latitude longitude:business.location.coordinate.longitude];
        //
        //
        //
        //        }
        

        
    }
    
//    NSArray *photos
//    if (business.photos.count > 0)
//    {
//        for (NSString *imageStr in business.photos)
//        {
//            NSURL *url = [NSURL URLWithString:imageStr];
//            NSData *imageData = [NSData dataWithContentsOfURL:url];
//            UIImage *image = [UIImage imageWithData:imageData];
//            [business.photosArray addObject:image];
//        }
//    }
//    
//    [[AppDelegate sharedClient] businessWithId:selectedBusiness.identifier completionHandler:^
//     (YLPBusiness *business, NSError *error) {
//         dispatch_async(dispatch_get_main_queue(), ^{
//             if (business.photos.count > 0)
//             {
//                 for (NSString *imageStr in business.photos)
//                 {
//                     NSURL *url = [NSURL URLWithString:imageStr];
//                     NSData *imageData = [NSData dataWithContentsOfURL:url];
//                     UIImage *image = [UIImage imageWithData:imageData];
//                     [business.photosArray addObject:image];
//                 }
//             }
//             [[AppDelegate sharedClient] reviewsWithId:selectedBusiness.identifier completionHandler:^
//              (YLPBusiness *reviewsBiz, NSError *error) {
//                  dispatch_async(dispatch_get_main_queue(), ^{
//                      business.reviews = reviewsBiz.reviews;
//                      [self performSegueWithIdentifier:kShowDetailSegue sender:business ];
//                  });
//              }];
//         });
//     }];
    
    return self;
}

+ (NSArray *)categoriesFromJSONArray:(NSArray *)categoriesJSON {
    NSMutableArray *mutableCategories = [[NSMutableArray alloc] init];
    for (NSDictionary *category in categoriesJSON) {
        [mutableCategories addObject:[[YLPCategory alloc] initWithDictionary:category]];
    }
    return mutableCategories;
}

+ (YLPCoordinate *)coordinateFromJSONDictionary:(NSDictionary *)coordinatesDict {
    NSNumber *latitude = [coordinatesDict ylp_objectMaybeNullForKey:@"latitude"];
    NSNumber *longitude = [coordinatesDict ylp_objectMaybeNullForKey:@"longitude"];
    if (latitude && longitude) {
        return [[YLPCoordinate alloc] initWithLatitude:[latitude doubleValue]
                                             longitude:[longitude doubleValue]];
    } else {
        return nil;
    }
}

@end
