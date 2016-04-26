//
//  NSURL+QueryDictionary.h
//  iLeft
//
//  Created by 刘建平 on 16/4/8.
//  Copyright © 2016年 JamesLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - NSURL (URLQueryDictionary)

@interface NSURL (URLQueryDictionary)
/**
 *  @return URL's query component as keys/values
 *  Returns nil for an empty query
 */
- (NSDictionary*) queryDictionary;

/**
 *  @return URL with keys values appending to query string
 *  @param queryDictionary Query keys/values
 *  @param sortedKeys Sorted the keys alphabetically?
 *  @warning If keys overlap in receiver and query dictionary,
 *  behaviour is undefined.
 */
- (NSURL*) URLByAppendingQueryDictionary:(NSDictionary*) queryDictionary
                          withSortedKeys:(BOOL) sortedKeys;



/** As above, but `sortedKeys=NO` */
- (NSURL*) URLByAppendingQueryDictionary:(NSDictionary*) queryDictionary;

/**
 *  @return Copy of URL with its query component replaced with
 *  the specified dictionary.
 *  @param queryDictionary A new query dictionary
 *  @param sortedKeys      Whether or not to sort the query keys
 */
- (NSURL*) URLByReplacingQueryWithDictionary:(NSDictionary*) queryDictionary
                              withSortedKeys:(BOOL) sortedKeys;

/** As above, but `sortedKeys=NO` */
- (NSURL*) URLByReplacingQueryWithDictionary:(NSDictionary*) queryDictionary;

/** @return Receiver with query component completely removed */
- (NSURL*) URLByRemovingQuery;


@end


#pragma mark - NSString (URLQueryDictionary)

@interface NSString (URLQueryDictionary)

/**
 *  @return If the receiver is a valid URL query component, returns
 *  components as key/value pairs. If couldn't split into *any* pairs,
 *  returns nil.
 */
- (NSDictionary*) URLQueryDictionary;

@end

#pragma mark - NSDictionary (URLQueryDictionary)

@interface NSDictionary (URLQueryDictionary)

/**
 *  @return URL query string component created from the keys and values in
 *  the dictionary. Returns nil for an empty dictionary.
 *  @param sortedKeys Sorted the keys alphabetically?
 *  @see cavetas from the main `NSURL` category as well.
 */
- (NSString*) URLQueryStringWithSortedKeys:(BOOL) sortedKeys;

/** As above, but `sortedKeys=NO` */
- (NSString*) URLQueryString;

@end