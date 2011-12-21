TARGET = RSSKit

SYSROOT = /User/sysroot
CC = gcc
LD = $(CC)
CFLAGS  = -isysroot $(SYSROOT) \
	  -Wall \
	  -std=gnu99 \
	  -I. \
	  -c
LDFLAGS = -isysroot $(SYSROOT) \
	  -w \
	  -dynamiclib \
	  -install_name /System/Library/Frameworks/$(TARGET).framework/$(TARGET) \
	  -lobjc \
	  -framework Foundation
	  
OBJECTS = RSSFeed.o RSSEntry.o RSSParser.o RSSCloudService.o RSSAttachedMedia.o NSMutableString+RSSKit.o

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(LD) $(LDFLAGS) -o $(TARGET) $(OBJECTS)
	cp $(TARGET) /System/Library/Frameworks/$(TARGET).framework

clean:
	rm -rf $(OBJECTS) $(TARGET)

%.o: %.m
	$(CC) $(CFLAGS) -o $@ $^

