//
//  YLPLocation.m
//  Pods
//
//  Created by David Chen on 1/12/16.
//
//

#import "YLPLocation.h"
#import "YLPCoordinate.h"
#import "YLPResponsePrivate.h"

@implementation YLPLocation

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.stateCode = [aDecoder decodeObjectForKey:@"stateCode"];
        self.postalCode = [aDecoder decodeObjectForKey:@"postalCode"];
        self.countryCode = [aDecoder decodeObjectForKey:@"countryCode"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.coordinate = [aDecoder decodeObjectForKey:@"coordinate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_stateCode forKey:@"stateCode"];
    [aCoder encodeObject:_postalCode forKey:@"postalCode"];
    [aCoder encodeObject:_countryCode forKey:@"countryCode"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_coordinate forKey:@"coordinate"];
}

- (instancetype)initWithDictionary:(NSDictionary *)location coordinate:(YLPCoordinate *)coordinate {
    if (self = [super init]) {
        _city = location[@"city"];
        _stateCode = location[@"state"];
        _postalCode = location[@"zip_code"];
        _countryCode = location[@"country"];
        
        NSMutableArray *address = [NSMutableArray array];
        for (NSString *addressKey in @[@"address1", @"address2", @"address3"]) {
            NSString *addressLine = [location ylp_objectMaybeNullForKey:addressKey];
            // Skip empty lines
            if (addressLine.length > 0) {
                [address addObject:addressLine];
            }
        }
        _address = address;

        _coordinate = coordinate;
    }
    
    return self;
}

@end
