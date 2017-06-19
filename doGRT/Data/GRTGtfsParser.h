//
//  GRTGtfsParser.h
//  doGRT
//
//  Created by Greg on 2017-04-09.
//
//

#import <Foundation/Foundation.h>

@interface GRTGtfsParser : NSObject

- (GRTGtfsParser *)initWithGtfsArchiveUrl:(NSURL *)archiveURL;

- (void)parseWithCallback:(BOOL (^)(NSString *filename, NSArray *keys, NSArray *values))callback;

@end
