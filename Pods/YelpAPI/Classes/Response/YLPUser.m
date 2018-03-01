//
//  YLPUser.m
//  Pods
//
//  Created by David Chen on 1/13/16.
//
//

#import "YLPUser.h"
#import "YLPResponsePrivate.h"

@implementation YLPUser

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_imageURL forKey:@"imageURL"];
}

- (instancetype)initWithDictionary:(NSDictionary *)userDict {
    if (self = [super init]) {
        _name = userDict[@"name"];
        NSString *imageURLString = [userDict ylp_objectMaybeNullForKey:@"image_url"];
        _imageURL = imageURLString ? [NSURL URLWithString:imageURLString] : nil;
    }
    return self;
}

@end
