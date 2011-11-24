//
//  VeggiesGame.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "HIddenObjectGame.h"
#import "SimpleAudioEngine.h"
#import "ResultsPage.h"
#import "FrenchieTeachieEverythingAppDelegate.h"
#import "GameCategorieChoice.h"



@implementation HiddenObjectGame

@synthesize backgroundImagePath,objectList,objectName, currentObjectName,objectToFindArray,emitter;
@synthesize greenTick,redCross,correctAnsLabel,wrongAnsLabel,winningSong,endImagePath,objectListType;
@synthesize currentGamePlayed,fullObjectListType,fullObjectList,objectNamePlayed;

// on "init" you need to initialize your instance
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
		
		//Positioning the green tick and red cross on the center at the top at the screen
		greenTick = [CCSprite spriteWithFile:@"greenTickMark.png"];
		redCross = [CCSprite spriteWithFile:@"redCross.png"];
		greenTick.position=redCross.position=ccp(230,290);
		greenTick.visible = NO;
		redCross.visible = NO;
		
		[self addChild:greenTick z:101];
		[self addChild:redCross z:101];
		
		objectNamePlayed.numberOfLoops = 0;
		
		//Initializing counting variables
		numberofIterations=0;
		numberOfObjectsFounds=0;	
		
		//Displaying the current score and initializing score variables
		
		correctAnswers = 0;
		wrongAnswers = 0;
		
		foundCurrentObject = NO;
		touchedObject = NO;
		
				
	}
	return self;
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];

	backgroundImagePath = [objectListType objectAtIndex:2];
	endImagePath = [objectListType objectAtIndex:3];
	winningSong = [objectListType objectAtIndex:4];
	//NSLog(@"the back image is %@",backgroundImagePath);
	//Loading background for all games
	CCSprite *kitchenBgnd = [CCSprite spriteWithFile:backgroundImagePath];
	// position the label on the center of the screen
	kitchenBgnd.position =  ccp( sizeofScreen.width /2 , sizeofScreen.height/2 );
	[self addChild: kitchenBgnd];
	
	NSString *noCorrectAns = NSLocalizedString(@"noCorrectAnswers",nil);
	NSString *noWrongAns = NSLocalizedString(@"noWrongAnswers",nil);
	correctAnsLabel = [CCLabel labelWithString:noCorrectAns fontName:@"MarkerFelt-Wide" fontSize:20];
	wrongAnsLabel = [CCLabel labelWithString:noWrongAns fontName:@"MarkerFelt-Wide" fontSize:20];
	correctAnsLabel.color = ccc3(22,112,17);
	wrongAnsLabel.color = ccc3(255,0,0);
	correctAnsLabel.position = ccp(60,15);
	wrongAnsLabel.position=ccp(185,15);
	
	[self addChild:correctAnsLabel z:100];
	[self addChild:wrongAnsLabel z:100];
	
	//Displaying the Menu to navigate: back and reset game
	[self displayNavigationMenu];
	
	//Positioning the label displaying the name of the object and setting its color according to game
	objectName = [CCLabel labelWithString:@" " fontName:@"MarkerFelt-Wide" fontSize:20];
	objectName.position=ccp(240,300);
	objectName.visible = NO;
	[self addChild:objectName z:100];
	//Loading all the object to find in an array
	[self loadObjectsToFind];
	
	//Loading localized string to display instructions for the game
	NSString *myInstruction = NSLocalizedString(@"InstructionsGame", nil);
	NSString *popUpTitle = NSLocalizedString(@"popUpTitle", nil);
	NSString *popUpButton = NSLocalizedString(@"popUpButton", nil);
	
	NSURL *correctAnsPath;
	NSURL *wrongAnsPath;
	
	NSString *currentCategoriePlayed =[objectListType objectAtIndex:0];
	currentGamePlayed = @"Animals";
	if ([currentCategoriePlayed isEqualToString:@"Wild"] || [currentCategoriePlayed isEqualToString:@"Farm"] || [currentCategoriePlayed isEqualToString:@"Sea"]) {
		currentGamePlayed = @"Animals";
	}
	else if ([currentCategoriePlayed isEqualToString:@"Kitchen"] || [currentCategoriePlayed isEqualToString:@"Bedroom"] || [currentCategoriePlayed isEqualToString:@"Transport"]) {
		currentGamePlayed = @"Objects";
		correctAnsPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/chimeGoodAnswer.mp3", [[NSBundle mainBundle] resourcePath]]];
		wrongAnsPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/chimeBadAnswer.mp3", [[NSBundle mainBundle] resourcePath]]];	

	}
	else if ([currentCategoriePlayed isEqualToString:@"Fruits"] || [currentCategoriePlayed isEqualToString:@"Veggies"] || [currentCategoriePlayed isEqualToString:@"Treats"]) {
		currentGamePlayed = @"Food";
		correctAnsPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/poof.mp3", [[NSBundle mainBundle] resourcePath]]];
		wrongAnsPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/wrongAnswer.mp3", [[NSBundle mainBundle] resourcePath]]];	

	}
	else if ([currentCategoriePlayed isEqualToString:@"Alphabet"] || [currentCategoriePlayed isEqualToString:@"Numbers"] || [currentCategoriePlayed isEqualToString:@"Colors"]) {
		currentGamePlayed = @"ABCs";
	}

	correctAnswerBuzzer = [[AVAudioPlayer alloc] initWithContentsOfURL:correctAnsPath error:NULL];
	wrongAnswerBuzzer = 	[[AVAudioPlayer alloc] initWithContentsOfURL:wrongAnsPath error:NULL];
	
	[correctAnswerBuzzer prepareToPlay];
	[wrongAnswerBuzzer prepareToPlay];
	
	//Initializing the star explosion
	if ([currentGamePlayed isEqualToString:@"Objects"]) {
		self.emitter = [CCQuadParticleSystem particleWithFile:@"flower.plist"];
	}
	else	
	{
		self.emitter = [CCQuadParticleSystem particleWithFile:@"cloud.plist"];
	}
	emitter.position = ccp(200,200);
	emitter.visible = NO;
	[self addChild: emitter z:100];
		
	UIAlertView *startAlert = [[UIAlertView alloc] initWithTitle:popUpTitle message:myInstruction delegate:self cancelButtonTitle:popUpButton otherButtonTitles:nil, nil];
	startAlert.tag=0;
	[startAlert show];	
	[startAlert release];
	
	//use to display a grid on the screen to place object more easily
	
}

//Waiting for the user to click to start the game
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{ 
	if (alertView.tag == 0) 
	{
		[self displayObjectsToFind];
		[self startPlaying];
		[self schedule:@selector(doStep:)];
		//[self displayCoordGrid];
	}
	else if (alertView.tag==1)
	{
	}
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
-(void)startPlaying
{
	//NSLog(@"the number of iterations is %d and total number of objects is %d",numberofIterations,[objectList count]);
	
	//NSLog(@" startPlaying number of Iterations: %d",numberofIterations);
	if (numberofIterations >=([objectList count]))
	{
		[self showResultsPage];	
		objectName.visible=NO;
		//NSLog(@"going to results page");
		//numberofIterations = 0;
	}
	else {
		currentObjectName = (NSString*)[[objectList objectAtIndex:numberofIterations]objectAtIndex:0];
		[objectName setString:currentObjectName];
		//NSLog(@"go play sound");
		objectNamePlayed = [[objectList objectAtIndex:numberofIterations]objectAtIndex:1];
		[self performSelector:@selector(playObjectSound) withObject:nil afterDelay:1.5];		
	}
}

-(void) playObjectSound
{
	if(numberofIterations == 0)
		emitter.visible=YES;
	else {
		//emitter.visible=NO;
	}
	[self enableTouchesAllObjects];
	greenTick.visible=NO;
	redCross.visible=NO;
	if (numberofIterations <([objectList count]))
		[objectNamePlayed play];
		//[[SimpleAudioEngine sharedEngine]playEffect:[[objectList objectAtIndex:numberofIterations]objectAtIndex:1] ];
	
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
	
	CCMenuItemImage *menuItemRepeatSound =[CCMenuItemImage itemFromNormalImage:@"repeterBouton.png"
																 selectedImage: @"repeterBouton.png"
																		target:self
																	  selector:@selector(repeatSound:)];
	
	CCMenuItemImage *menuItemDisplayHelp =[CCMenuItemImage itemFromNormalImage:@"helpButton.png"
																 selectedImage: @"helpButton.png"
																		target:self
																	  selector:@selector(displayHelp:)];
	CCMenu *menuGame = [CCMenu menuWithItems:menuItemBackArrow, menuItemResetArrow, nil];
	[menuGame alignItemsHorizontallyWithPadding:320];
	menuGame.position=ccp( sizeofScreen.width/2,sizeofScreen.height-30);
	[self addChild:menuGame z:100];
	
	CCMenu *helpMenu = [CCMenu menuWithItems:menuItemRepeatSound, menuItemDisplayHelp, nil];
	[helpMenu alignItemsHorizontallyWithPadding:10];
	helpMenu.position=ccp(400,40);
	[self addChild:helpMenu z:100];
}

- (void) displayHelp: (CCMenuItem  *) menuItem 
{
	if (objectName.visible) {
		objectName.visible=NO;
	}
	else {
		objectName.visible=YES;
	}	
}

- (void) repeatSound: (CCMenuItem  *) menuItem
{
	[self playObjectSound];
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
	//NSLog(@"the current game is %@",currentGamePlayed);
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
	numberofIterations = 0;
	numberOfObjectsFounds=0;
	correctAnswers=0;
	wrongAnswers=0;
	for (NSInteger itemIdx=0;itemIdx < [objectToFindArray count];itemIdx++)
	{
		[self removeChild:[objectToFindArray objectAtIndex:itemIdx] cleanup:NO];
	}
	[self loadObjectsToFind];
	[self displayObjectsToFind];
	[self startPlaying];
	NSString *noCorrectAns = NSLocalizedString(@"noCorrectAnswers",nil);
	NSString *noWrongAns = NSLocalizedString(@"noWrongAnswers",nil);
	[correctAnsLabel setString:noCorrectAns];
	[wrongAnsLabel setString:noWrongAns];
}

-(void) disableTouchesAllObjects
{
	for (ObjectToFind *objectToDisplay in objectToFindArray)
	{ 
		[objectToDisplay disableTouch:YES];
	}
}

-(void) enableTouchesAllObjects
{
	for (ObjectToFind *objectToDisplay in objectToFindArray)
	{ 
		[objectToDisplay disableTouch:NO];
	}
}

- (void)doStep:(ccTime)delta
{
	for (ObjectToFind *objectToDisplay in objectToFindArray)
	{
		foundCurrentObject = [objectToDisplay objectHasBeenFound:numberofIterations];
		touchedObject = [objectToDisplay objectHasBeenTouched:numberofIterations];
		if (foundCurrentObject)
		{
			//NSLog(@"Found Object");
			numberOfObjectsFounds++;
			emitter.position=[objectToDisplay objectPosition];
			[emitter resetSystem];
			//Initializing the star explosion
			[correctAnswerBuzzer play];
			
			[self removeChild:[objectToFindArray objectAtIndex:numberofIterations] cleanup:NO];
			greenTick.visible=YES;
			[self disableTouchesAllObjects];
			emitter.visible=YES;
			numberofIterations++;
			correctAnswers++;
						
			[self startPlaying];
			
			//Update correct answer label
			NSString *correctAnswersStr = NSLocalizedString(@"CorrectString",nil);
			NSString* correctCounterMsg = [[NSString alloc] initWithFormat:correctAnswersStr,correctAnswers];			
			[correctAnsLabel setString:correctCounterMsg];
		}		
		else if (touchedObject) 
		{
			[objectToDisplay touchAcknowledge];
			//NSLog(@"Touched wrong object");
			[wrongAnswerBuzzer play];			
			redCross.visible=YES;
			[self disableTouchesAllObjects];
			//NSLog(@"before: number of It:%d count: %d",numberofIterations,[objectToFindArray count]);
			//[[SimpleAudioEngine sharedEngine]unloadEffect:[[objectList objectAtIndex:numberofIterations]objectAtIndex:1] ];
			numberofIterations++;
			wrongAnswers++;
			//NSLog(@"after: number of It:%d count: %d",numberofIterations,[objectToFindArray count]);
			[self startPlaying];
			
			//Update wrong answer label
			NSString* wrongAnswersStr = NSLocalizedString(@"WrongString",nil);
			NSString* wrongCounterMsg = [[NSString alloc] initWithFormat:wrongAnswersStr,wrongAnswers];			
			[wrongAnsLabel setString:wrongCounterMsg];
		}		
	}
}

-(void) loadObjectsToFind
{
	NSInteger objectIndex;
	NSInteger xCoordObj;
	NSInteger yCoordObj;
	NSMutableArray *objectToFindArrayT = [NSMutableArray arrayWithCapacity:[objectList count]];
	
	for (objectIndex = 0; objectIndex < [objectList count]; objectIndex++) {
		ObjectToFind *objectToFind = [ObjectToFind spriteWithFile:[[objectList objectAtIndex:objectIndex] objectAtIndex:2] ];
		xCoordObj = [[[objectList objectAtIndex:objectIndex] objectAtIndex:3] doubleValue];
		yCoordObj = [[[objectList objectAtIndex:objectIndex] objectAtIndex:4] doubleValue];
		//NSLog(@"The Coord are %d, and %d", xCoordObj,yCoordObj);
		objectToFind.tag = objectIndex;
		objectToFind.position = ccp(xCoordObj,yCoordObj);
		[objectToFindArrayT addObject:objectToFind];
	}
	objectToFindArray = [objectToFindArrayT copy];
}

-(void) displayObjectsToFind
{
	NSInteger zIndex=[objectToFindArray count];
	for (ObjectToFind *objectToDisplay in objectToFindArray)
	{
		[self addChild:objectToDisplay z:zIndex];
		zIndex--;
	}	
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
-(id) initWithGameIndex:(NSInteger)gameIndex
{
	gameIdx = gameIndex;
	return self;
}

- (void) showResultsPage {
	//NSLog(@"show end Page");
	CCScene *scene = [CCScene node];
	 ResultsPage *layer = [ResultsPage node];
	 [scene addChild:layer];
	 double correctAnswerRatio = ((double)numberOfObjectsFounds / (double)[objectList count]) * 100;
	 [layer initWithObjectList:objectList];
	 [layer initWithObjectListType:objectListType];
	
	 [layer initWithFullObjectList:fullObjectList];
	 [layer initWithFullObjectListType:fullObjectListType];
	
	 [layer initWithBackgroundImage:backgroundImagePath];
	 [layer initWithEndImage:endImagePath];
	 [layer initWithCorrectAnswers:correctAnswerRatio];
	 [layer initWithWinningSong:winningSong];
	 [[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.5f scene:scene]];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[correctAnswerBuzzer release];
	[wrongAnswerBuzzer release];
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
