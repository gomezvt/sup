//
//  YLPCategory.m
//  Pods
//
//  Created by David Chen on 1/11/16.
//
//

#import "YLPCategory.h"

@implementation YLPCategory

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.alias = [aDecoder decodeObjectForKey:@"alias"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_alias forKey:@"alias"];
}

- (instancetype) initWithName:(NSString *)name alias:(NSString *)alias {
    if (self = [super init]) {
        _name = name;
        _alias = alias;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)categoryDict {
    return [self initWithName:categoryDict[@"title"]
                        alias:categoryDict[@"alias"]];
}

@end
