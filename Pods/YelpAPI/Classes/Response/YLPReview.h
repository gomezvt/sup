//
//  YLPReview.h
//  Pods
//
//  Created by David Chen on 1/13/16.
//
//

#import <Foundation/Foundation.h>

@class YLPUser;

NS_ASSUME_NONNULL_BEGIN

@interface YLPReview : NSObject

@property(nonatomic, copy) NSString *excerpt;

@property(nonatomic, copy) NSDate *timeCreated;

@property(nonatomic) double rating;

@property(nonatomic) YLPUser *user;

@end

NS_ASSUME_NONNULL_END
