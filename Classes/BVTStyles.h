//
//  BVTStyles.h
//  burlingtonian
//
//  Created by Greg on 12/30/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#define kBVTCategories @[ @"Arts, Museums, & Music", @"Coffee, Sweets, & Bakeries", @"Hotels, Hostels, Bed & Breakfast", @"Entertainment & Recreation", @"Bars & Lounges", @"Restaurants", @"Shopping", @"Tours & Festivals", @"Travel" ]

// Categories modeled after those found on https://www.yelp.com/developers/documentation/v2/category_list
#define kArtsMuseums @[ @"Art Galleries", @"Museums", @"Music Venues", @"Performing Arts" ]

#define kCoffeeSweetsBakeries @[ @"Bakeries", @"Candy Stores", @"Chocolatiers & Shops", @"Coffee & Tea", @"Coffee Roasteries", @"Desserts", @"Ice Cream & Frozen Yogurt", @"Tea Rooms" ]

//#define kMusic @[ @"Music Venues" ]

#define kHotelsHostelsBB @[ @"Bed & Breakfast",  @"Guest Houses", @"Hostels", @"Hotels", @"Rest Stops" ]

#define kEntertainmentRecreation @[ @"Amusement Parks", @"ATV Rentals/Tours", @"Basketball Courts", @"Beaches", @"Bike Rentals", @"Boating", @"Bowling", @"Campgrounds", @"Cinema", @"Climbing", @"Country Clubs", @"Cultural Center", @"Cycling Classes", @"Dance Studios", @"Disc Golf", @"Fishing", @"Golf", @"Gun/Rifle Ranges", @"Gyms", @"Gymnastics", @"Hiking", @"Horseback Riding", @"Hot Air Balloons", @"Kids Activities", @"Lakes", @"Martial Arts", @"Mini Golf", @"Paddleboarding", @"Parks", @"Race Tracks", @"Rafting/Kayaking", @"Recreation Centers", @"Rock Climbing", @"Sailing", @"Ski Resorts", @"Skating Rinks", @"Skydiving", @"Sledding", @"Stadiums & Arenas", @"Surfing", @"Swimming Pools", @"Tennis", @"Wineries", @"Yoga", @"Ziplining", @"Zoos"]

#define kBarsLounges @[ @"Bars", @"Beer Bar",  @"Beer Gardens", @"Cocktail Bars", @"Dive Bars", @"Lounges", @"Pubs", @"Sports Bars", @"Tiki Bars", @"Wine Bars" ]

#define kRestaurants @[ @"American (New)", @"American (Traditional)", @"Asian Fusion", @"Austrian", @"Barbeque", @"Breakfast & Brunch", @"British", @"Buffets", @"Burgers", @"Cafes", @"Cajun/Creole",  @"Cheesesteaks", @"Chinese", @"Creperies", @"Delis", @"Diners", @"French", @"German", @"Greek", @"Halal", @"Himalayan/Nepalese", @"Indian", @"Italian", @"Irish", @"Japanese", @"Korean", @"Live/Raw Food", @"Malaysian", @"Mediterranean", @"Mexican", @"Middle Eastern", @"Noodles", @"Pizza", @"Poutineries", @"Salad", @"Sandwiches", @"Scandinavian", @"Seafood", @"Soup", @"Steakhouses", @"Sushi Bars", @"Tapas Bars", @"Tapas/Small Plates", @"Tex-Mex", @"Thai", @"Turkish", @"Vegan", @"Vegetarian", @"Vietnamese" ]

#define kShopping @[ @"Antiques", @"Appliances", @"Art Supplies", @"Auto Repair", @"Bikes", @"Bookstores", @"Brewing Supplies", @"Bridal", @"Children's Clothing", @"Comic Books", @"Computers", @"Cosmetics & Beauty Supply", @"Department Stores", @"Drugstores", @"Electronics", @"Embroidery & Crochet", @"Eyewear & Opticians", @"Fabric Stores", @"Fitness/Exercise Equipment", @"Florists", @"Formal Wear", @"Framing", @"Furniture Stores", @"Gift Shops", @"Grilling Equipment", @"Guitar Stores", @"Hardware Stores", @"Hats", @"Hobby Shops", @"Holiday Decorations", @"Home Decor", @"Hot Tub & Pool", @"Hunting & Fishing Supplies", @"Jewelry", @"Kitchen & Bath", @"Knitting Supplies", @"Leather Goods", @"Lingerie", @"Luggage", @"Maternity Wear", @"Mattresses", @"Medical Supplies", @"Men's Clothing", @"Mobile Phones", @"Mobile Phone Accessories", @"Motorcycle Gear", @"Music & DVDs", @"Office Equipment", @"Oil Change Stations", @"Outdoor Gear", @"Paint Stores", @"Photography Stores & Services", @"Shoe Stores", @"Shopping Centers", @"Skate Shops", @"Ski & Snowboard Shops", @"Spiritual Shop", @"Sports Wear", @"Tabletop Games", @"Thrift Stores", @"Tobacco Shops", @"Toy Stores", @"Vape Shops", @"Vinyl Records", @"Vitamins & Supplements", @"Watches", @"Wholesale Stores" ]

#define kToursFestivals @[ @"Beer Tours", @"Boat Tours", @"Bus Tours", @"Festivals", @"Historical Tours", @"Hot Air Balloons", @"Wine Tours" ]

#define kTravel @[ @"Airports", @"Airport Shuttles", @"Car Rental", @"Limos", @"Motorcycle Rental", @"Public Transportation", @"RV Rental", @"Taxis", @"Town Car Service", @"Trains", @"Train Stations", @"Vacation Rentals", @"Vacation Rental Agents", @"Visitor Centers" ]

extern NSString *const star_zero_mini;
extern NSString *const star_one_mini;
extern NSString *const star_one_half_mini;
extern NSString *const star_two_mini;
extern NSString *const star_two_half_mini;
extern NSString *const star_three_mini;
extern NSString *const star_three_half_mini;
extern NSString *const star_four_mini;
extern NSString *const star_four_half_mini;
extern NSString *const star_five_mini;

extern NSString *const star_zero;
extern NSString *const star_one;
extern NSString *const star_one_half;
extern NSString *const star_two;
extern NSString *const star_two_half;
extern NSString *const star_three;
extern NSString *const star_three_half;
extern NSString *const star_four;
extern NSString *const star_four_half;
extern NSString *const star_five;

@interface BVTStyles : NSObject

+ (UIColor *)buttonBackGround;
+ (UIColor *)buttonBorder;
+ (UIColor *)lightGray;
+ (UIColor *)iconGreen;
+ (UIColor *)tabBarTint;
@end
