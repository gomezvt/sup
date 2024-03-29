//
//  YLPCoordinate.h
//  Pods
//
//  Created by David Chen on 1/13/16.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPCoordinate : NSObject

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude;

@end

NS_ASSUME_NONNULL_END
