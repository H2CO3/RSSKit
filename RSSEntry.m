//
// RSSEntry.m
// RSSKit
//
// Created by Árpád Goretity on 01/11/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "RSSEntry.h"


@implementation RSSEntry

@synthesize title;
@synthesize url;
@synthesize uid;
@synthesize date;
@synthesize summary;

// NSCopying
- (id) copyWithZone:(NSZone *)zone {
	RSSEntry *copy = [[RSSEntry alloc] init];
	copy.title = self.title;
	copy.url = self.url;
	copy.uid = self.uid;
	copy.date = self.date;
	copy.summary = self.summary;
	return copy;
}

@end

