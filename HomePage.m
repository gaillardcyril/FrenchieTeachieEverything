//
//  HomePage.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "HomePage.h"
#import "frenchieTeachieEverythingAppDelegate.h"
#import "GameCategorieChoice.h"


@implementation HomePage


@synthesize objectListType,objectList;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HomePage *layer = [HomePage node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		//NSLog(@"init home page");
		// create and initialize a Label
		CCSprite *homePgBgnd = [CCSprite spriteWithFile:@"BgndHomePage.png"];
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// position the label on the center of the screen
		homePgBgnd.position =  ccp( size.width /2 , size.height/2 );
		// add the label as a child to this Layer
		[self addChild:homePgBgnd z:1];
		
		
		CCMenuItemImage *menuItemAnimals =[CCMenuItemImage itemFromNormalImage:@"AnimalsIcon.png"
																 selectedImage: @"AnimalsIconS.png"
																		target:self
																	  selector:@selector(showAnimalsGame:)];
		
		CCMenuItemImage *menuItemFood =[CCMenuItemImage itemFromNormalImage:@"FoodIcon.png"
															  selectedImage: @"FoodIconS.png"
																	 target:self
																   selector:@selector(showFoodGame:)];
		
		CCMenuItemImage *menuItemObjects =[CCMenuItemImage itemFromNormalImage:@"ObjectsIcon.png"
																 selectedImage: @"ObjectsIconS.png"
																		target:self
																	  selector:@selector(showObjectsGame:)];
				
		CCMenuItemImage *menuItemABCs =[CCMenuItemImage itemFromNormalImage:@"ABCsIcon.png"
																 selectedImage: @"ABCsIconS.png"
																		target:self
																	  selector:@selector(showABCsGame:)];
						
		CCMenu *menuHomePage = [CCMenu menuWithItems:menuItemAnimals, menuItemFood, menuItemObjects, menuItemABCs, nil];
		[menuHomePage alignItemsHorizontallyWithPadding:5];
		menuHomePage.position =ccp(size.width /2 , 155);
		[self addChild:menuHomePage z:2];
		
	}
	return self;
}

-(void) loadGameCategorie:(NSString*)xmlFile withBGImg:(NSString*)BGImagePath withPadding:(NSInteger)paddingToUse
{
	//NSLog(@"xml file right after call%@",xmlFile);
	FrenchieTeachieEverythingAppDelegate *frenchieTeachieEverythingAppDelegate = (FrenchieTeachieEverythingAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:xmlFile ofType:@"xml"];    
	//NSLog(@"xml file %@",xmlFilePath);
	
	[frenchieTeachieEverythingAppDelegate parseXMLFile:xmlFilePath];
	
	objectListType = [frenchieTeachieEverythingAppDelegate foodListType];
	objectList = [frenchieTeachieEverythingAppDelegate foodList];
	//NSLog(@"the 1st object is %@", [objectList objectAtIndex:0]);
	CCScene *scene = [CCScene node];
	GameCategorieChoice *layer = [GameCategorieChoice node];
	[layer initWithBackgroundImage:BGImagePath];
	[layer initWithObjectList:objectList];
	[layer initWithObjectListType:objectListType];
	[layer initWithThumbPadding:paddingToUse];
	[scene addChild:layer];
	[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.5f scene:scene]];
}


- (void) showABCsGame: (CCMenuItem *) menuItem 
{	
	[self loadGameCategorie:@"ABCs" withBGImg:@"BgndHomePageABC.png" withPadding:65];
	//NSLog(@"the number of objects is %d",[objectList count]);

}

- (void) showAnimalsGame: (CCMenuItem *) menuItem 
{
	[self loadGameCategorie:@"animals" withBGImg:@"backGroundHomePageAnimals.png" withPadding:40];	
	//NSLog(@"the number of objects is %d",[objectList count]);
}

- (void) showObjectsGame: (CCMenuItem *) menuItem 
{
	[self loadGameCategorie:@"objects" withBGImg:@"BgndHomePageObjects.png" withPadding:10];
	//NSLog(@"the number of objects is %d",[objectList count]);
	
}
- (void) showFoodGame: (CCMenuItem *) menuItem 
{
	[self loadGameCategorie:@"food" withBGImg:@"BgndHomePageFood.png" withPadding:30];
	//NSLog(@"the number of objects is %d",[objectList count]);
	
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"

	[super dealloc];
}

@end
