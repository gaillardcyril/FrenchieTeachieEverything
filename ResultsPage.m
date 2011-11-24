//
//  ResultsPage.m
//  FrenchieTeachieObjects
//
//  Created by Cyril Gaillard on 30/09/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "ResultsPage.h"
#import "ThreeChoiceGame.h"
#import "GameCategorieChoice.h"
#import "HIddenObjectGame.h"



@implementation ResultsPage
@synthesize dancingNote1, dancingNote2,dancingNote3, dancingNote4,winningSong,endSound,endImagePath;
@synthesize currentGamePlayed,objectListType,fullObjectListType,fullObjectList;
-(id) init 
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		sizeofScreen = [[CCDirector sharedDirector] winSize];
		self.dancingNote1 = [CCQuadParticleSystem particleWithFile:@"note.plist"];
		self.dancingNote2 = [CCQuadParticleSystem particleWithFile:@"note.plist"];
		self.dancingNote3 = [CCQuadParticleSystem particleWithFile:@"note.plist"];
		self.dancingNote4 = [CCQuadParticleSystem particleWithFile:@"note.plist"];
		dancingNote1.position= ccp(175,150);
		dancingNote2.position = ccp (275,150);
		dancingNote3.position= ccp(375,125);
		dancingNote4.position = ccp (450,125);
		
	}
	return self;
}


//-------------------------DISPLAY COORD GRID------------------------------------//
-(void) displayCoordGrid
{
	for (NSInteger i=0; i<10; i++)
	{
		CCSprite *VerticalBar = [CCSprite spriteWithFile:@"VerticalBar.png" ];
		VerticalBar.position=ccp(i*50,sizeofScreen.height/2);
		[self addChild:VerticalBar z:100];
	}
	for (NSInteger i=0; i<7; i++)
	{
		CCSprite *VerticalBar = [CCSprite spriteWithFile:@"HorizontalBar.png" ];
		VerticalBar.position=ccp(sizeofScreen.width/2,i*50);
		[self addChild:VerticalBar z:100];
	}
}
//--------------------------------------------------------------------------------//

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
	//NSLog(@"transition did finish");
	// ask director the the window size
	
	CCSprite *endGameBgnd = [CCSprite spriteWithFile:endImagePath];		
	// position the sprite on the center of the screen
	endGameBgnd.position =  ccp(sizeofScreen.width /2, sizeofScreen.height/2 );

	// add the label as a child to this Layer
	[self addChild: endGameBgnd];
	[self displayNavigationMenu];
	
	NSString *resultString;
	CGPoint positionResultStr;
	
	
	NSURL *pathFinishSong = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],winningSong]];
	endSound = [[AVAudioPlayer alloc] initWithContentsOfURL:pathFinishSong error:NULL];
	endSound.delegate = self;
	[endSound prepareToPlay];
	
	NSString *currentCategoriePlayed =[objectListType objectAtIndex:0];
	currentGamePlayed = @"Animals";
	positionResultStr =ccp(sizeofScreen.width/2,180);
	if ([currentCategoriePlayed isEqualToString:@"Wild"] || [currentCategoriePlayed isEqualToString:@"Farm"] || [currentCategoriePlayed isEqualToString:@"Sea"]) {
		currentGamePlayed = @"Animals";
		positionResultStr =ccp(sizeofScreen.width/2,180);
	}
	else if ([currentCategoriePlayed isEqualToString:@"Kitchen"] || [currentCategoriePlayed isEqualToString:@"Bedroom"] || [currentCategoriePlayed isEqualToString:@"Transport"]) {
		currentGamePlayed = @"Objects";
		positionResultStr =ccp(sizeofScreen.width/2,180);
	}
	else if ([currentCategoriePlayed isEqualToString:@"Fruits"] || [currentCategoriePlayed isEqualToString:@"Veggies"] || [currentCategoriePlayed isEqualToString:@"Treats"]) {
		currentGamePlayed = @"Food";
		positionResultStr =ccp(sizeofScreen.width/2,180);
	}
	else if ([currentCategoriePlayed isEqualToString:@"Alphabet"] || [currentCategoriePlayed isEqualToString:@"Numbers"] || [currentCategoriePlayed isEqualToString:@"Colors"]) {
		currentGamePlayed = @"ABCs";
		positionResultStr =ccp(290,150);
	}
	
	if (correctAnswersG == 100) {
		//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:winningSong loop:NO];
		[endSound play];
		resultString =[[NSString alloc]initWithString:NSLocalizedString(@"allCorrectAnswers", nil)];
		[self addChild:dancingNote1];
		[self addChild:dancingNote2];
		[self addChild:dancingNote3];
		[self addChild:dancingNote4];
		
	}
	else {
		
	resultString =[[NSString alloc]initWithFormat:NSLocalizedString(@"someCorrectAnswers", nil),correctAnswersG ];
		
	}
	CCLabel *notSoBravoString = [CCLabel labelWithString:resultString dimensions:CGSizeMake(330.0f, 200.0f) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:18];
	[resultString release];
	notSoBravoString.color = ccc3(39,28,147);
	notSoBravoString.position = positionResultStr;
	[self addChild:notSoBravoString];
	//[self schedule:@selector(checkForEndOfSong:) interval: 0.5];
	//[self displayCoordGrid];
		
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	//NSLog(@"cdAudioSourceDidFinishPlaying ");
	dancingNote1.duration=1;
	dancingNote2.duration=1;
	dancingNote3.duration=1;
	dancingNote4.duration=1;
	
}



-(void) displayNavigationMenu
{
	CCMenuItemImage *menuItemBackArrow =[CCMenuItemImage itemFromNormalImage:@"BackArrow.png"
															   selectedImage: @"BackArrow.png"
																	  target:self
																	selector:@selector(showHomePage:)];
	
	CCMenuItemImage *menuItemResetArrow =[CCMenuItemImage itemFromNormalImage:@"resetStar.png"
																selectedImage: @"resetStar.png"
																	   target:self
																	 selector:@selector(resetCurrentGame:)];
	CCMenu *menuGame = [CCMenu menuWithItems:menuItemBackArrow, menuItemResetArrow, nil];
	[menuGame alignItemsHorizontallyWithPadding:320];
	
	menuGame.position=ccp( sizeofScreen.width/2,sizeofScreen.height-30);
	[self addChild:menuGame];
}

-(void) initWithCorrectAnswers : (double)correctAnswers
{
	correctAnswersG = correctAnswers;
}

-(id) initWithBackgroundImage:(NSString*)imagePath
{
	backgroundImagePath=imagePath;
	return self;
}

-(id) initWithEndImage:(NSString*)imagePath
{
	endImagePath = imagePath;
	return self;
}

-(id) initWithWinningSong:(NSString*)endSong
{
	//NSLog(@"the end song is%@",endSong);
	winningSong=endSong;
	return self;
}


-(id) initWithObjectList:(NSMutableArray*)objectListArray
{
	objectList = objectListArray;
	return self;
}

-(id) initWithObjectListType:(NSMutableArray*)objectListTypeArray
{
	
	objectListType = objectListTypeArray;
	return self;
}

-(id) initWithFullObjectList:(NSMutableArray*)fullObjectListArray
{
	fullObjectList = fullObjectListArray;
	return self;
}
-(id) initWithFullObjectListType:(NSMutableArray*)fullObjectListTypeArray
{
	fullObjectListType = fullObjectListTypeArray;
	return self;
}

-(void) loadGameCategorie:(NSString*)xmlFile withBGImg:(NSString*)BGImagePath withPadding:(NSInteger)paddingToUse
{
	
	CCScene *scene = [CCScene node];
	GameCategorieChoice *layer = [GameCategorieChoice node];
	[layer initWithBackgroundImage:BGImagePath];
	[layer initWithObjectList:fullObjectList];
	[layer initWithObjectListType:fullObjectListType];
	[layer initWithThumbPadding:paddingToUse];
	[scene addChild:layer];
	[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.5f scene:scene]];
	
}

- (void) showHomePage: (CCMenuItem  *) menuItem 
{
	[endSound stop];
	if ([currentGamePlayed isEqual:@"Animals"]) {
		[self loadGameCategorie:@"animals" withBGImg:@"backGroundHomePageAnimals.png" withPadding:40];
	}
	else if ([currentGamePlayed isEqual:@"Objects"]){
		[self loadGameCategorie:@"objects" withBGImg:@"BgndHomePageObjects.png" withPadding:10];
	}
	else if ([currentGamePlayed isEqual:@"Food"]) {
		[self loadGameCategorie:@"food" withBGImg:@"BgndHomePageFood.png" withPadding:30];
	}		  
	else if ([currentGamePlayed isEqual:@"ABCs"]) {
		[self loadGameCategorie:@"ABCs" withBGImg:@"BgndHomePageABC.png" withPadding:65];
	}
		
}

- (void) resetCurrentGame: (CCMenuItem  *) menuItem 
{
	[endSound stop];
	CCScene *scene = [CCScene node];
	NSString* gameType =  [objectListType objectAtIndex:5];
	//NSLog(@"THE TYPE OF GAME IS %@",gameType);
	if ([gameType isEqualToString:@"hidden"]) {
		HiddenObjectGame *layer = [HiddenObjectGame node];
		[layer initWithObjectList:objectList];
		[layer initWithObjectListType:objectListType];
		[layer initWithFullObjectList:fullObjectList];
		[layer initWithFullObjectListType:fullObjectListType];
		[scene addChild:layer];
	}
	else {
		ThreeChoiceGame *layer = [ThreeChoiceGame node];
		[layer initWithObjectList:objectList];
		[layer initWithObjectListType:objectListType];
		[layer initWithFullObjectList:fullObjectList];
		[layer initWithFullObjectListType:fullObjectListType];
		[scene addChild:layer];
		
	}
	gameType = nil;
	[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.5f scene:scene]];	
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
