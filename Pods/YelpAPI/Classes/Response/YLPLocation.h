//
//  YLPLocation.h
//  Pods
//
//  Created by David Chen on 1/12/16.
//
//

#import <Foundation/Foundation.h>

@class YLPCoordinate;

NS_ASSUME_NONNULL_BEGIN

@interface YLPLocation : NSObject

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *stateCode;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSString *countryCode;

@property (nonatomic, copy) NSArray<NSString *> *address;
@property (nonatomic, nullable) YLPCoordinate *coordinate;

@end

NS_ASSUME_NONNULL_END
