//
//  YLPUser.h
//  Pods
//
//  Created by David Chen on 1/13/16.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPUser : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy, nullable) NSURL *imageURL;

@end

NS_ASSUME_NONNULL_END
