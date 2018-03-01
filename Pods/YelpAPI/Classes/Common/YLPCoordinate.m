//
//  YLPCoordinate.m
//  Pods
//
//  Created by David Chen on 1/13/16.
//
//

#import "YLPCoordinate.h"

@implementation YLPCoordinate

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        self.longitude = [aDecoder decodeDoubleForKey:@"longitude"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:_latitude forKey:@"latitude"];
    [aCoder encodeDouble:_longitude forKey:@"longitude"];
}

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude {
    if (self = [super init]) {
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%f,%f", self.latitude, self.longitude];
}
@end
