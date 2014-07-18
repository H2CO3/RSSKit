# RSSKit

RSSKit is an easy-to use iOS framework to make RSS feed processing simple. It consists of only 5 small classes, so it's extremely lightweight yet powerful. It supports both the RSS 2.0 and the Atom 1.0 feed formats.


## How to use the framework


1. `#import <RSSKit/RSSKit.h>`

1. Define a class which conforms to the RSSParserDelegate protocol, i. e.:
  `@interface MyParserDelegate: NSObject <RSSParserDelegate>`

1. Instantiate an RSSParser object using an NSString with an URL containing a valid RSS/Atom feed; e. g.
  `RSSParser *parser = [[RSSParser alloc] initWithUrl:@"http://example.com/feed" synchronous:NO];`

1. Set an instance of your freshly declared deleate class as the parser's delegate, that is:
   ```objc
   MyParserDelegate *theDelegateObject = [[MyParserDelegate alloc] init];
   parser.delegate = theDelegateObject;
   ```

1. Call `[parser parse];`

1. Implement the `rssParser:parsedFeed:` method in your delegate class. As the 2nd parameter it'll be passed an `RSSFeed` instance. The properties of this class are named meaningfully; the articles property will contain an `NSArray` of `RSSEntry` objects, representing the items/summaries of the feed, respectively (this class also has obviously-named properties).
  
