//
//  Business.h
//  Pods
//
//  Created by David Chen on 1/5/16.
//
//

#import <Foundation/Foundation.h>

@class YLPLocation;
@class YLPCategory;

NS_ASSUME_NONNULL_BEGIN

@interface YLPBusiness : NSObject

@property (nonatomic, getter=isClosed) BOOL closed;
@property (nonatomic, strong) id hoursItem;
@property (nonatomic, nullable, copy) NSURL *imageURL;
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic) BOOL didGetDetails;
@property (nonatomic) double rating;
@property (nonatomic) NSUInteger reviewCount;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, nullable, copy) NSString *phone;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) UIImage *bizThumbNail;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSArray<YLPCategory *> *categories;
@property (nonatomic) YLPLocation *location;

@property (nonatomic, strong) NSArray *businessHours;
@property (nonatomic) BOOL isOpenNow;
@property (nonatomic, strong) id open_now;
@property (nonatomic) double miles;
@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *userPhotosArray;

@end

NS_ASSUME_NONNULL_END
