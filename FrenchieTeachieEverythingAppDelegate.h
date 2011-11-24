//
//  FrenchieTeachieEverythingAppDelegate.h
//  FrenchieTeachieEverything
//
//  Created by Cyril Gaillard on 18/10/10.
//  Copyright Voila Design 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LISTTYPETAG @"ObjectType"
#define OBJECTTAG @"Object"

@interface FrenchieTeachieEverythingAppDelegate : NSObject <UIApplicationDelegate, NSXMLParserDelegate> {
	UIWindow *window;
	NSMutableArray *foodListType;
	NSMutableArray *foodListin1Category;	
	NSMutableArray *foodList;
	NSXMLParser *clientParser;
	BOOL accumulateParsedCharacterData;
	NSMutableString *currentParsedCharacterData;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) NSMutableArray *foodListType;
@property (nonatomic, retain) NSMutableArray *foodListin1Category;
@property (nonatomic, retain) NSMutableArray *foodList;
@property (nonatomic, retain) NSMutableString *currentParsedCharacterData;
@property (nonatomic, retain) NSXMLParser *clientParser;


- (void)parseXMLFile:(NSString *)pathToFile;

@end

