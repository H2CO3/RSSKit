//
// RSSEntry.h
// RSSKit
//
// Created by Árpád Goretity on 01/11/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import <Foundation/Foundation.h>


@interface RSSEntry: NSObject <NSCopying> {
	NSString *title;
	NSString *url;
	NSString *uid;
	NSString *date;
	NSString *summary;
}

@property (retain) NSString *title;
@property (retain) NSString *url;
@property (retain) NSString *uid;
@property (retain) NSString *date;
@property (retain) NSString *summary;

@end

