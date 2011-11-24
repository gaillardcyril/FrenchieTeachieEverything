//
//  FrenchieTeachieEverythingAppDelegate.m
//  FrenchieTeachieEverything
//
//  Created by Cyril Gaillard on 18/10/10.
//  Copyright Voila Design 2010. All rights reserved.
//

#import "FrenchieTeachieEverythingAppDelegate.h"
#import "cocos2d.h"
#import "HomePage.h"
#import <AVFoundation/AVFoundation.h>

@implementation FrenchieTeachieEverythingAppDelegate

@synthesize window, foodListType,foodListin1Category,foodList,currentParsedCharacterData,clientParser;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// CC_DIRECTOR_INIT()
	//
	// 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
	// 2. EAGLView multiple touches: disabled
	// 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
	// 4. Parents EAGLView to the newly created window
	// 5. Creates Display Link Director
	// 5a. If it fails, it will use an NSTimer director
	// 6. It will try to run at 60 FPS
	// 7. Display FPS: NO
	// 8. Device orientation: Portrait
	// 9. Connects the director to the EAGLView
	//
	CC_DIRECTOR_INIT();
	
	// Obtain the shared director in order to...
	CCDirector *director = [CCDirector sharedDirector];
	
	// Sets landscape mode
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	
	// Turn on display FPS
	[director setDisplayFPS:NO];
	
	// Turn on multiple touches
	EAGLView *view = [director openGLView];
	[view setMultipleTouchEnabled:YES];
	
		
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];	
	
	self.foodListType=[NSMutableArray array];
	self.foodListin1Category=[NSMutableArray array];
	self.foodList=[NSMutableArray array];
	
	[[CCDirector sharedDirector] runWithScene: [HomePage scene]];
}


- (void)parseXMLFile:(NSString *)pathToFile 
{
	//NSLog(@"xml file path = %@",pathToFile);
	accumulateParsedCharacterData = NO;
	NSData *xml = [NSData dataWithContentsOfFile: pathToFile];
	/*NSString *content = [[NSString alloc]  initWithBytes:[xml bytes]
												  length:[xml length] encoding: NSUTF8StringEncoding];	
	NSLog(@"xml file: %@",content);
	[content release];
	NSLog(@"xml file path:%@",pathToFile); 
	*/
	
	[self.foodListType removeAllObjects];
	[self.foodListin1Category removeAllObjects];
	[self.foodList removeAllObjects];
	
	clientParser = [[NSXMLParser alloc] initWithData:xml];
    [clientParser setDelegate:self];
    [clientParser setShouldResolveExternalEntities:YES];
	[clientParser parse]; // return value not used
	/*//NSLog(@"1st object %@",[[foodList objectAtIndex:0]objectAtIndex:0]);
	//NSLog(@"the number of categories is %d",[self.animalListType count]);
	//NSLog(@"the 1st animal of the 1st category is %@",[self.animalList objectAtIndex:0]);*/
	[clientParser release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict 
{ 
	if ([elementName isEqualToString:LISTTYPETAG]) 
	{		
		NSString *ttlAttribute = [attributeDict valueForKey:@"title"];
		NSString *thumbAttribute = [attributeDict valueForKey:@"thumb"];
		NSString *bgAttribute = [attributeDict valueForKey:@"background"];
		NSString *endBgAttribute = [attributeDict valueForKey:@"endBackground"];
		NSString *endSongAttribute = [attributeDict valueForKey:@"finishSong"];
		NSString *typeOfGame = [attributeDict valueForKey:@"gameType"];
		NSMutableArray *lineToAdd = [[NSMutableArray alloc]initWithObjects:(NSString*)ttlAttribute,(NSString*)thumbAttribute,(NSString*)bgAttribute,(NSString*)endBgAttribute,(NSString*)endSongAttribute,(NSString*)typeOfGame,nil];
		[self.foodListType addObject:lineToAdd];
		[lineToAdd release];
	}
	else if([elementName isEqualToString:OBJECTTAG])
	{
		NSString* pixNameXML = [attributeDict valueForKey:@"title"];
		NSString* soundPixXML = [attributeDict valueForKey:@"sound"];
		NSString* imagePixXML = [attributeDict valueForKey:@"image"];
		NSURL *pathAnimalSound = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],soundPixXML]];
		NSString* xCoordXML = [attributeDict valueForKey:@"xCoord"];
		NSString* yCoordXML = [attributeDict valueForKey:@"yCoord"];	
		
		AVAudioPlayer* soundToPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:pathAnimalSound error:nil];
		
		NSMutableArray *lineToAddToCategory = [[NSMutableArray alloc] initWithObjects:(NSString*)pixNameXML,(AVAudioPlayer*) soundToPlay,(NSString*)imagePixXML,(NSString*)xCoordXML,(NSString*)yCoordXML,nil];
		[self.foodListin1Category  addObject:lineToAddToCategory];
		[soundToPlay release];
		[lineToAddToCategory release];
	}
	
	accumulateParsedCharacterData=YES;
    [currentParsedCharacterData setString:@""];
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{   
	accumulateParsedCharacterData=NO;
	
	if([elementName isEqualToString:LISTTYPETAG])
	{
		[self.foodList  addObject:[[[NSMutableArray alloc]initWithArray:foodListin1Category copyItems:YES]autorelease]];
		[self.foodListin1Category removeAllObjects];
	}
	
}

// This method is called by the parser when it find parsed character data ("PCDATA") in an element.
// The parser is not guaranteed to deliver all of the parsed character data for an element in a single
// invocation, so it is necessary to accumulate character data until the end of the element is reached.
//
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(accumulateParsedCharacterData)
	{
		[self.currentParsedCharacterData appendString:string];
	}
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	//NSLog(@"dealloc appdelegate");
	[[CCDirector sharedDirector] release];
	[window release];
	[clientParser release];
	[super dealloc];
}

@end


