//
// RSSFeed.m
// RSSKit
//
// Created by Árpád Goretity on 01/11/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "RSSFeed.h"


@implementation RSSFeed

- (id) init {
	self = [super init];
	articles = [[NSMutableArray alloc] init];
	return self;
}

- (void) dealloc {
	[articles release];
	[super dealloc];
}

@synthesize type;
@synthesize title;
@synthesize description;
@synthesize url;
@synthesize date;
@synthesize author;
@synthesize articles;

@end

