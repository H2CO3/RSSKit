//
// RSSFeed.h
// RSSKit
//
// Created by Árpád Goretity on 01/11/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import <Foundation/Foundation.h>
#import "RSSDefines.h"


@interface RSSFeed: NSObject {
	RSSFeedType type;
	NSString *title;
	NSString *description;
	NSString *url;
	NSString *date;
	NSString *author;
	NSMutableArray *articles;
}

@property (assign) RSSFeedType type;
@property (retain) NSString *title;
@property (retain) NSString *description;
@property (retain) NSString *url;
@property (retain) NSString *date;
@property (retain) NSString *author;
@property (retain) NSMutableArray *articles;

@end

