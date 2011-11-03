//
// RSSParser.m
// RSSKit
//
// Created by Árpád Goretity on 01/11/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "RSSParser.h"


@implementation RSSParser

@synthesize delegate;

- (id) initWithUrl:(NSString *)theUrl {
	self = [super init];
	url = [theUrl retain];
	NSURL *contentUrl = [[NSURL alloc] initWithString:url];
	xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:contentUrl];
	[contentUrl release];
	[xmlParser setDelegate:self];
	return self;
}

- (void) dealloc {
	[xmlParser setDelegate:NULL];
	[xmlParser release];
	[url release];
	[super dealloc];
}

// self

- (void) parse {
	[xmlParser parse];
}

// NSXMLParserDelegate (informal protocol)

- (void) parserDidStartDocument:(NSXMLParser *)parser {
	feed = [[RSSFeed alloc] init];
	tagStack = [[NSMutableArray alloc] init];
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
	[tagStack release];
	if ([delegate respondsToSelector:@selector(rssParser:parsedFeed:)]) {
		[delegate rssParser:self parsedFeed:feed];
	}
	[feed release];
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)error {
	[tagStack release];
	[feed release];
	if ([delegate respondsToSelector:@selector(rssParser:errorOccurred:)]) {
		[delegate rssParser:self errorOccurred:error];
	}
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)element namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributes {
	// decide type of the feed based on its root element
	if ([element isEqualToString:@"rss"]) {
		feed.type = RSSFeedTypeRSS;
	} else if ([element isEqualToString:@"feed"]) {
		feed.type = RSSFeedTypeAtom;
	} else if ([element isEqualToString:@"item"] || [element isEqualToString:@"entry"]) {
		// or, if it's an article summary tag, create an article object
		entry = [[RSSEntry alloc] init];
	}
	// prepare to successively receive characters
	// then push element onto stack
	NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
	[context setObject:element forKey:@"tag"];
	[context setObject:attributes forKey:@"attributes"];
	NSMutableString *text = [[NSMutableString alloc] init];
	[context setObject:text forKey:@"text"];
	[text release];
	[tagStack addObject:context];
	[context release];
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)element namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName {
	// pop
	NSMutableDictionary *context = [[tagStack lastObject] retain];
	NSMutableString *text = [context objectForKey:@"text"];
	NSDictionary *attributes = [context objectForKey:@"attributes"];
	[tagStack removeLastObject];
	// the top of the stack now is the parent tag
	// of the current one. Examine them to see what to
	// do with the built string.
	NSMutableDictionary *parent = [tagStack lastObject];
	NSString *parentTag = [parent objectForKey:@"tag"];
	if ([parentTag isEqualToString:@"channel"] || [parentTag isEqualToString:@"feed"]) {
		if ([element isEqualToString:@"title"]) {
			feed.title = text;
		} else if ([element isEqualToString:@"description"] || [element isEqualToString:@"subtitle"]) {
			feed.description = text;
		} else if ([element isEqualToString:@"link"]) {
			// RSS 2.0 or Atom 1.0?
			NSString *href = [attributes objectForKey:@"href"];
			if (href != NULL) {
				// Atom 1.0
				feed.url = href;
			} else {
				// RSS 2.0
				feed.url = text;
			}
		} else if ([element isEqualToString:@"lastBuildDate"] || [element isEqualToString:@"updated"]) {
			feed.date = text;
		} else if ([element isEqualToString:@"managingEditor"]) {
			feed.author = text;
		} else if ([element isEqualToString:@"item"] || [element isEqualToString:@"entry"]) {
			RSSEntry *copy = [entry copy];
			[entry release];
			[feed.articles addObject:copy];
			[copy release];
		}
	} else if ([parentTag isEqualToString:@"author"]) {
		if ([element isEqualToString:@"name"]) {
			if (feed.author == NULL) {
				feed.author = text;
			} else {
				feed.author = [NSString stringWithFormat:@"%@ (%@)", text, feed.author];
			}
		} else if ([element isEqualToString:@"email"]) {
			if (feed.author == NULL) {
				feed.author = text;
			} else {
				feed.author = [NSString stringWithFormat:@"%@ (%@)", feed.author, text];
			}
		}
	} else if ([parentTag isEqualToString:@"item"] || [parentTag isEqualToString:@"entry"]) {
		if ([element isEqualToString:@"title"]) {
			entry.title = text;
		} else if ([element isEqualToString:@"link"]) {
			// RSS 2.0 or Atom 1.0?
			NSString *href = [attributes objectForKey:@"href"];
			if (href != NULL) {
				// Atom 1.0
				entry.url = href;
			} else {
				// RSS 2.0
				entry.url = text;
			}
		} else if ([element isEqualToString:@"guid"] || [element isEqualToString:@"id"]) {
			entry.uid = text;
		} else if ([element isEqualToString:@"pubDate"] || [element isEqualToString:@"updated"]) {
			entry.date = text;
		} else if ([element isEqualToString:@"description"] || [element isEqualToString:@"summary"]) {
			entry.summary = text;
		}
	}
	[context release];
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	NSMutableDictionary *context = [tagStack lastObject];
	NSMutableString *text = [context objectForKey:@"text"];
	[text appendString:string];
}

- (void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)data {
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSMutableDictionary *context = [tagStack lastObject];
	NSMutableString *text = [context objectForKey:@"text"];
	[text appendString:string];
	[string release];
}

@end

