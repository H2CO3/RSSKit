//
// RSSParser.h
// RSSKit
//
// Created by Árpád Goretity on 01/11/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import <Foundation/Foundation.h>
#import "RSSDefines.h"
#import "RSSFeed.h"
#import "RSSEntry.h"

@protocol RSSParserDelegate;


@interface RSSParser: NSObject {
	NSString *url;
	NSXMLParser *xmlParser;
	NSMutableArray *tagStack;
	RSSFeed *feed;
	RSSEntry *entry;
	id <RSSParserDelegate> delegate;
}

@property (assign) id <RSSParserDelegate> delegate;

- (id) initWithUrl:(NSString *)theUrl;
- (void) parse;

@end


@protocol RSSParserDelegate <NSObject>
@optional
- (void) rssParser:(RSSParser *)parser parsedFeed:(RSSFeed *)feed;
- (void) rssParser:(RSSParser *)parser errorOccurred:(NSError *)error;
@end

