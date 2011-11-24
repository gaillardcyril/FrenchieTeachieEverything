//
//  GameCategorieChoice.m
//  FrenchieTeachieEverything
//
//  Created by Cyril Gaillard on 19/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "GameCategorieChoice.h"
#import "HomePage.h"
#import "ThreeChoiceGame.h"
#import "HIddenObjectGame.h"

@implementation GameCategorieChoice

@synthesize backgroundImagePath,firstThumbPath,secondThumbPath,thirdThumbPath;
@synthesize objectListType,objectList;

-(id) init 
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {		
		//Measuring size of screen
		sizeofScreen = [[CCDirector sharedDirector] winSize];
		// Positioning Loading... on the center of the screen
		CCSprite *loadingBgnd = [CCSprite spriteWithFile:@"HLoading.png"];	
		[self addChild:loadingBgnd];
		loadingBgnd.position=ccp(sizeofScreen.width/2,sizeofScreen.height/2);
	}
	return self;
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
	
	
	//Loading background for all games
	CCSprite *choiceBgnd = [CCSprite spriteWithFile:backgroundImagePath];
	// position the label on the center of the screen
	choiceBgnd.position =  ccp( sizeofScreen.width /2 , sizeofScreen.height/2 );
	[self addChild: choiceBgnd z:1];
	CCMenuItemImage *menuItemBackHome =[CCMenuItemImage itemFromNormalImage:@"BackArrow.png"
															 selectedImage: @"BackArrow.png"
																	target:self
																  selector:@selector(goBackHome:)];


	CCMenu *menuBackHome = [CCMenu menuWithItems:menuItemBackHome, nil];
	menuBackHome.position =ccp(30,290);
	[self addChild:menuBackHome z:2];
	firstThumbPath = [[objectListType objectAtIndex:0] objectAtIndex:1];
	secondThumbPath = [[objectListType objectAtIndex:1] objectAtIndex:1];
	thirdThumbPath = [[objectListType objectAtIndex:2] objectAtIndex:1];
/*	NSLog(@"1st thumb:%@",firstThumbPath);
	NSLog(@"2nd thumb:%@",secondThumbPath);
	NSLog(@"3rd thumb:%@",thirdThumbPath);
	
*/	
	
	CCMenuItemImage *menuItem1stThumb =[CCMenuItemImage itemFromNormalImage:firstThumbPath
															  selectedImage: firstThumbPath
																	 target:self
																   selector:@selector(show1stThumbGame:)];
	CCMenuItemImage *menuItem2ndThumb =[CCMenuItemImage itemFromNormalImage:secondThumbPath
														   selectedImage: secondThumbPath
																  target:self
																selector:@selector(show2ndThumbGame:)];
	CCMenuItemImage *menuItem3rdThumb =[CCMenuItemImage itemFromNormalImage:thirdThumbPath
															selectedImage: thirdThumbPath
																   target:self
																 selector:@selector(show3rdThumbGame:)];
	
	CCMenu *menuThumbs = [CCMenu menuWithItems:menuItem1stThumb, menuItem2ndThumb, menuItem3rdThumb, nil];
	[menuThumbs alignItemsHorizontallyWithPadding:thumbPadding];
	//menuItem2ndThumb.opacity=60;
	//menuItem3rdThumb.opacity=60;
	if ([backgroundImagePath isEqualToString: @"BgndHomePageABC.png"]) {
		CCSprite *woodClip = [CCSprite spriteWithFile:@"woodClip.png"];
		[self addChild:woodClip z:5];
		woodClip.position = ccp( sizeofScreen.width /2 , 200 );
		menuThumbs.position = ccp( sizeofScreen.width /2 , 120 );
	}
	[self addChild:menuThumbs z:2];	
}

- (void) goBackHome: (CCMenuItem *) menuItem 
{
   [[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.5f scene:[HomePage scene]]];
}

- (void) show1stThumbGame: (CCMenuItem *) menuItem
{	
	[self displayPlayingInterface:0];
}

- (void) show2ndThumbGame: (CCMenuItem *) menuItem
{
	[self displayPlayingInterface:1];
}

- (void) show3rdThumbGame: (CCMenuItem *) menuItem
{

	[self displayPlayingInterface:2];
	
}

-(void)displayPlayingInterface:(NSInteger)categoryIdx
{
	CCScene *scene = [CCScene node];
	NSString* gameType =  [[objectListType objectAtIndex:categoryIdx]objectAtIndex:5];
	//NSLog(@"THE TYPE OF GAME IS %@",gameType);
	if ([gameType isEqualToString:@"hidden"]) {
		HiddenObjectGame *layer = [HiddenObjectGame node];
		[layer initWithObjectList:[objectList objectAtIndex:categoryIdx]];
		[layer initWithObjectListType:[objectListType objectAtIndex:categoryIdx]];
		[layer initWithFullObjectList:objectList];
		[layer initWithFullObjectListType:objectListType];
		[scene addChild:layer];
	}
	else {
		ThreeChoiceGame *layer = [ThreeChoiceGame node];
		[layer initWithObjectList:[objectList objectAtIndex:categoryIdx]];
		[layer initWithObjectListType:[objectListType objectAtIndex:categoryIdx]];
		[layer initWithFullObjectList:objectList];
		[layer initWithFullObjectListType:objectListType];
		[scene addChild:layer];
		
	}
	gameType = nil;
	[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.5f scene:scene]];
	
	
}

-(id) initWithBackgroundImage:(NSString*)imagePath
{
	backgroundImagePath=imagePath;
	//NSLog(@"background image: %@",imagePath);
	return self;
}

-(id) initWithThumbPadding:(NSInteger)thumbPad
{
	thumbPadding = thumbPad;
	return self;
}

-(id) initWithObjectList:(NSMutableArray*)listObject
{
	
	objectList = listObject;
	return self;
}

-(id) initWithObjectListType:(NSMutableArray*)listObjectType
{
	objectListType  = listObjectType;
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	// don't forget to call "super dealloc"
	//NSLog(@"dealloc gamechoice");
	[super dealloc];
}

@end
