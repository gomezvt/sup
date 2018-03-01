//
//  YLPReview.m
//  Pods
//
//  Created by David Chen on 1/13/16.
//
//

#import "YLPReview.h"
#import "YLPUser.h"
#import "YLPResponsePrivate.h"

@implementation YLPReview

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.excerpt = [aDecoder decodeObjectForKey:@"excerpt"];
        self.timeCreated = [aDecoder decodeObjectForKey:@"timeCreated"];
        self.rating = [aDecoder decodeDoubleForKey:@"rating"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_excerpt forKey:@"excerpt"];
    [aCoder encodeObject:_timeCreated forKey:@"timeCreated"];
    [aCoder encodeDouble:_rating forKey:@"rating"];
    [aCoder encodeObject:_user forKey:@"user"];
}

- (instancetype)initWithDictionary:(NSDictionary *)reviewDict {
    if (self = [super init]) {
        _rating = [reviewDict[@"rating"] doubleValue];
        _excerpt = reviewDict[@"text"];
        _timeCreated = [self.class dateFromTimestamp:reviewDict[@"time_created"]];
        _user = [[YLPUser alloc] initWithDictionary:reviewDict[@"user"]];
    }
    
    return self;
}

+ (NSDate *)dateFromTimestamp:(NSString *)timestamp {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd' 'HH:mm:ss";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    });

    return [dateFormatter dateFromString:timestamp];
}

@end
