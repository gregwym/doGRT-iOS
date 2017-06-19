//
//  GRTGtfsParser.m
//  doGRT
//
//  Created by Greg on 2017-04-09.
//
//

#import "GRTGtfsParser.h"

#import <SSZipArchive/ZipArchive.h>
#import <CHCSVParser/CHCSVParser.h>


static NSArray *GTFS_FILENAMES = nil;
static NSString *GTFS_FILE_EXTENSION = @"txt";


@interface GRTGtfsParser () <CHCSVParserDelegate>

@property (nonatomic, strong) NSURL *archiveURL;
@property (nonatomic, strong) NSString *parsingFile;

@end

@implementation GRTGtfsParser

- (GRTGtfsParser *)initWithGtfsArchiveUrl:(NSURL *)archiveURL
{
    self = [super init];
    if (self != nil) {
        self.archiveURL = archiveURL;

        GTFS_FILENAMES = @[@"calendar", @"calendar_dates", @"routes",
                           @"stops", @"trips", @"stop_times", @"shapes"];
    }
    return self;
}

- (void)parseWithCallback:(BOOL (^)(NSString *, NSArray *, NSArray *))callback
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // Unzip archive
    NSString *tempCsvDirPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"GRT_GTFS"];
    [fileManager removeItemAtPath:tempCsvDirPath error:nil];
    NSLog(@"Unzipping GTFS Archive to %@", tempCsvDirPath);
    [SSZipArchive unzipFileAtPath:self.archiveURL.path toDestination:tempCsvDirPath];
    NSLog(@"Unzipped GTFS Archive");

    // Parse
    for (NSString *filename in GTFS_FILENAMES) {
        NSURL *csvUrl = [[[NSURL fileURLWithPath:tempCsvDirPath]
                          URLByAppendingPathComponent:filename]
                         URLByAppendingPathExtension:GTFS_FILE_EXTENSION];
        if (![fileManager fileExistsAtPath:csvUrl.path]) {
            continue;
        }

        NSArray *parsedArray = [NSArray arrayWithContentsOfCSVURL:csvUrl];
        NSArray *headers = parsedArray[0];
        [parsedArray enumerateObjectsUsingBlock:^(NSArray *content, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                return;
            }
            callback(filename, headers, content);
        }];
    }
}

@end
