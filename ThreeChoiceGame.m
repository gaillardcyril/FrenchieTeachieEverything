//
//  FruitGame.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "ThreeChoiceGame.h"
#import "SimpleAudioEngine.h"
#import "ResultsPage.h"
#import "FrenchieTeachieEverythingAppDelegate.h"
#import "GameCategorieChoice.h"


@implementation ThreeChoiceGame

@synthesize backgroundImagePath,foodList,objectName, currentObjectName,objectToFindArray,emitter1,emitter2,emitter3;
@synthesize greenTick,redCross,correctAnsLabel,wrongAnsLabel,winningSong,xCoordinatesImages,pickedAnimals;
@synthesize endImagePath,foodListType,currentGamePlayed,objectNamePlayed,menuGame,fullFoodList,fullFoodListType;
/*+(id) scene
 {
 // 'scene' is an autorelease object.
 CCScene *scene = [CCScene node];
 
 // 'layer' is an autorelease object.
 KitchenGame *layer = [KitchenGame node];
 
 // add layer as a child to scene
 [scene addChild: layer];
 
 // return the scene
 return scene;
 }*/

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
		xCoordinatesImages  = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:IMAGE1X],[NSNumber numberWithInt:IMAGE2X],[NSNumber numberWithInt:IMAGE3X],nil];
				
		//Positioning the green tick and red cross on the center at the top at the screen
		greenTick = [CCSprite spriteWithFile:@"greenTickMark.png"];
		redCross = [CCSprite spriteWithFile:@"redCross.png"];
		greenTick.position=redCross.position=ccp(230,290);
		greenTick.visible = NO;
		redCross.visible = NO;
		
		imagesY = 120;
		[self addChild:greenTick z:101];
		[self addChild:redCross z:101];
		
		//Initializing counting variables
		numberofIterations=0;
		numberOfObjectsFounds=0;	
		objectNamePlayed.numberOfLoops = 0;
		//Displaying the current score and initializing score variables
		
		correctAnswers = 0;
		wrongAnswers = 0;
		
		foundCurrentObject = NO;
		touchedObject = NO;
		
		//Initializing the star explosion
		self.emitter1 = [CCQuadParticleSystem particleWithFile:@"cloud.plist"];
		emitter1.visible = NO;
		[self addChild: emitter1 z:100];
		
		self.emitter2 = [CCQuadParticleSystem particleWithFile:@"cloud.plist"];
		emitter2.visible = NO;
		[self addChild: emitter2 z:100];
		
		self.emitter3 = [CCQuadParticleSystem particleWithFile:@"cloud.plist"];
		emitter3.visible = NO;
		[self addChild: emitter3 z:100];

	}
	return self;
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
	
	//preloading sound effects 
/*	[[SimpleAudioEngine sharedEngine] preloadEffect:@"goodAnswer.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"badAnswer.mp3"];
*/	
	pickedAnimals  = [[NSMutableArray alloc] init];
	
	backgroundImagePath = [foodListType objectAtIndex:2];
	endImagePath = [foodListType objectAtIndex:3];
	winningSong = [foodListType objectAtIndex:4];
	
	//Loading background for all games
	CCSprite *kitchenBgnd = [CCSprite spriteWithFile:backgroundImagePath];
	// position the label on the center of the screen
	kitchenBgnd.position =  ccp( sizeofScreen.width /2 , sizeofScreen.height/2 );
	[self addChild: kitchenBgnd z:1];
	
	
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
	//NSLog(@"number of items to find %d",[foodList count]);
	//Displaying the Menu to navigate: back and reset game
	[self displayNavigationMenu];
	
	//Positioning the label displaying the name of the object and setting its color according to game
	objectName = [CCLabel labelWithString:@" " fontName:@"MarkerFelt-Wide" fontSize:20];
	objectName.position=ccp(240,300);
	objectName.visible = NO;
	[self addChild:objectName z:100];
	//Loading all the object to find in an array
	
	//Loading localized string to display instructions for the game
	NSString *myInstruction = NSLocalizedString(@"InstructionsGame", nil);
	NSString *popUpTitle = NSLocalizedString(@"popUpTitle", nil);
	NSString *popUpButton = NSLocalizedString(@"popUpButton", nil);
	UIAlertView *startAlert = [[UIAlertView alloc] initWithTitle:popUpTitle message:myInstruction delegate:self cancelButtonTitle:popUpButton otherButtonTitles:nil, nil];
	
	NSString *currentCategoriePlayed =[foodListType objectAtIndex:0];
	
	NSURL *correctAnsPath;
	NSURL *wrongAnsPath;

	
	currentGamePlayed = @"Animals";
	if ([currentCategoriePlayed isEqualToString:@"Wild"] || [currentCategoriePlayed isEqualToString:@"Farm"] || [currentCategoriePlayed isEqualToString:@"Sea"]) {
		currentGamePlayed = @"Animals";
		imagesY = 140;
		correctAnsPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/youpi.mp3", [[NSBundle mainBundle] resourcePath]]];
		wrongAnsPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/honk.mp3", [[NSBundle mainBundle] resourcePath]]];	
		
	}
	else if ([currentCategoriePlayed isEqualToString:@"Kitchen"] || [currentCategoriePlayed isEqualToString:@"Bedroom"] || [currentCategoriePlayed isEqualToString:@"Transport"]) {
		currentGamePlayed = @"Objects";
			
	}
	else if ([currentCategoriePlayed isEqualToString:@"Fruits"] || [currentCategoriePlayed isEqualToString:@"Veggies"] || [currentCategoriePlayed isEqualToString:@"Treats"]) {
		currentGamePlayed = @"Food";
		correctAnsPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/poof.mp3", [[NSBundle mainBundle] resourcePath]]];
		wrongAnsPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/poof.mp3", [[NSBundle mainBundle] resourcePath]]];	

	}
	else if ([currentCategoriePlayed isEqualToString:@"Alphabet"] || [currentCategoriePlayed isEqualToString:@"Numbers"] || [currentCategoriePlayed isEqualToString:@"Colors"]) {
		currentGamePlayed = @"ABCs";
		imagesY=140;
		CCSprite *woodClip = [CCSprite spriteWithFile:@"woodClip.png"];
		[self addChild:woodClip z:5];
		woodClip.position = ccp( sizeofScreen.width /2 , 220 );
		correctAnsPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/missile.mp3", [[NSBundle mainBundle] resourcePath]]];
		wrongAnsPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/missile.mp3", [[NSBundle mainBundle] resourcePath]]];	

		
	}
	correctAnswerBuzzer = [[AVAudioPlayer alloc] initWithContentsOfURL:correctAnsPath error:NULL];
	wrongAnswerBuzzer = 	[[AVAudioPlayer alloc] initWithContentsOfURL:wrongAnsPath error:NULL];
	
	[correctAnswerBuzzer prepareToPlay];
	[wrongAnswerBuzzer prepareToPlay];
	
	//NSLog(@"the game is %@",currentGamePlayed);
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
	
	if ([objectToFindArray count] > 0) {
		for (ObjectToFind *objectToF in objectToFindArray) {
			[self removeChild:objectToF cleanup:YES];
		}
	}
	
	if (numberofIterations >=([foodList count]))
	{
		[self showResultsPage];	
		objectName.visible=NO;
		//NSLog(@"going to results page");
		//numberofIterations = 0;
	}
	else {
		//currentObjectName = (NSString*)[[foodList objectAtIndex:numberofIterations]objectAtIndex:0];
		//[objectName setString:currentObjectName];
		//NSLog(@"go play sound");
		//[self performSelector:@selector(playObjectSound) withObject:nil afterDelay:1.5];
		NSInteger randAnimalIndex1; 
		NSInteger randAnimalIndex2; 
		NSInteger randAnimalIndex3;
		
		NSInteger shuffleIndex;
		//NSLog(@"1st item:%d, 2nd item:%d 3rd item:%d",[[xCoordinatesImages objectAtIndex:0]intValue],[[xCoordinatesImages objectAtIndex:1]intValue],[[xCoordinatesImages objectAtIndex:2]intValue]);
		for (shuffleIndex=0; shuffleIndex<3; shuffleIndex++) {
			NSInteger indexToSwitch= arc4random()%[xCoordinatesImages count];
			[xCoordinatesImages exchangeObjectAtIndex:shuffleIndex withObjectAtIndex:indexToSwitch];
		}
		//NSLog(@"1st item:%d, 2nd item:%d 3rd item:%d",[[xCoordinatesImages objectAtIndex:0]intValue],[[xCoordinatesImages objectAtIndex:1]intValue],[[xCoordinatesImages objectAtIndex:2]intValue]);
		
		do {
			randAnimalIndex1 = arc4random() % [foodList count];
			//NSLog(@"finding randanimalindex1");
		}while ([pickedAnimals containsObject:[NSNumber numberWithInt:randAnimalIndex1]] );
		
		[pickedAnimals addObject:[NSNumber numberWithInt:randAnimalIndex1]];
		currentFoodItemIdx = randAnimalIndex1;
		do {
			randAnimalIndex2 = arc4random() % [foodList  count];
			//NSLog(@"finding randanimalindex1");
		} while (randAnimalIndex2==randAnimalIndex1);
		
		do {
			randAnimalIndex3 = arc4random() % [foodList count];
			//NSLog(@"finding randanimalindex1");
		} while ((randAnimalIndex3 == randAnimalIndex1) || (randAnimalIndex3 == randAnimalIndex2));	
		

		[objectName setString:[[foodList objectAtIndex:randAnimalIndex1]objectAtIndex:0]];
		ObjectToFind *foodItem1 = [ObjectToFind spriteWithFile:[[foodList objectAtIndex:randAnimalIndex1] objectAtIndex:2] ];
		ObjectToFind *foodItem2 = [ObjectToFind spriteWithFile:[[foodList objectAtIndex:randAnimalIndex2] objectAtIndex:2] ];
		ObjectToFind *foodItem3 = [ObjectToFind spriteWithFile:[[foodList objectAtIndex:randAnimalIndex3] objectAtIndex:2] ];
	
		foodItem1.position=ccp((NSInteger)[[xCoordinatesImages objectAtIndex:0]intValue], imagesY);
		foodItem2.position=ccp((NSInteger)[[xCoordinatesImages objectAtIndex:1]intValue], imagesY);
		foodItem3.position=ccp((NSInteger)[[xCoordinatesImages objectAtIndex:2]intValue], imagesY);

		foodItem1.tag=1;
		foodItem2.tag=2;
		foodItem3.tag=3;

		objectNamePlayed = [[foodList objectAtIndex:currentFoodItemIdx]objectAtIndex:1];
		
		if ([currentGamePlayed isEqualToString:@"ABCs"]) {
			foodItem1.scale=0.1;
			foodItem2.scale=0.1;
			foodItem3.scale=0.1;
		}	
		else {
			foodItem1.opacity=0;
			foodItem2.opacity=0;
			foodItem3.opacity=0;
		}

		
		NSMutableArray *objectToFindArrayT = [NSMutableArray arrayWithCapacity:3];
		
		[objectToFindArrayT addObject: foodItem1];
		[objectToFindArrayT addObject: foodItem2];
		[objectToFindArrayT addObject: foodItem3];
		
		objectToFindArray = [objectToFindArrayT copy];
		
		for (ObjectToFind *objectToDisplay in objectToFindArray)
		{
			[self addChild:objectToDisplay z:2];
		}
		for (ObjectToFind *objectToDisplay in objectToFindArray)
		{
			if ([currentGamePlayed isEqualToString:@"ABCs"]) {
				[objectToDisplay runAction:[CCScaleTo actionWithDuration: 0.3f scale:1.0f]];
			}
			else {
				[objectToDisplay runAction:[CCFadeIn actionWithDuration:0.4f]];
			}			
		}				
		[self performSelector:@selector(playObjectSound) withObject:nil afterDelay:1.0];
	}
}

-(void) enableTouchesAllObjects
{
	for (ObjectToFind *objectToDisplay in objectToFindArray)
	{ 
		[objectToDisplay disableTouch:NO];
	}
}

-(void) disableTouchesAllObjects
{
	for (ObjectToFind *objectToDisplay in objectToFindArray)
	{ 
		[objectToDisplay disableTouch:YES];
	}
}

-(void) playObjectSound
{
	[self enableTouchesAllObjects];
	if(numberofIterations == 0)
	{
		emitter1.visible=YES;
		emitter2.visible=YES;
		emitter3.visible=YES;
	}	
	else {
		//emitter.visible=NO;
	}
	greenTick.visible=NO;
	redCross.visible=NO;
	
	//NSLog(@"the name of the sound is %@",objectNamePlayed);
	if (numberofIterations <([foodList count]))
		[objectNamePlayed play];
		 //[[SimpleAudioEngine sharedEngine]playEffect:[[foodList objectAtIndex:currentFoodItemIdx]objectAtIndex:1]];
		//[[SimpleAudioEngine sharedEngine]playEffect:@"raisinNoir.mp3"];
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
	menuGame = [CCMenu menuWithItems:menuItemBackArrow, menuItemResetArrow, nil];
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
	//[layer initWithBackgroundImage:@"BgndHomePageABC.png"];
	[layer initWithBackgroundImage:BGImagePath];
	[layer initWithObjectList:fullFoodList];
	[layer initWithObjectListType:fullFoodListType];
	[layer initWithThumbPadding:paddingToUse];
	[scene addChild:layer];
	[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.5f scene:scene]];
	 
}

- (void) showHomePage: (CCMenuItem  *) menuItem 
{
	//[[SimpleAudioEngine sharedEngine] stopEffect:currentSoundId];
	[objectNamePlayed stop];
	menuGame.isTouchEnabled=NO;
	//NSLog(@"The current game played is %@",currentGamePlayed);
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
	[self emptyObjectArray];
	[pickedAnimals removeAllObjects];
	NSString *noCorrectAns = NSLocalizedString(@"noCorrectAnswers",nil);
	NSString *noWrongAns = NSLocalizedString(@"noWrongAnswers",nil);
	[correctAnsLabel setString:noCorrectAns];
	[wrongAnsLabel setString:noWrongAns];
	[self startPlaying];
	//[self showResultsPage];
}

- (void)doStep:(ccTime)delta
{
	for (ObjectToFind *objectToDisplay in objectToFindArray)
	{
		foundCurrentObject = [objectToDisplay objectHasBeenFound:1];
		touchedObject = [objectToDisplay objectHasBeenTouched:nil];
		if (foundCurrentObject)
		{
			numberOfObjectsFounds++;
			[self disableTouchesAllObjects];
			[correctAnswerBuzzer play];
			if ([currentGamePlayed isEqualToString:@"Animals"]) {
				
			}
			else if ([currentGamePlayed isEqualToString:@"ABCs"])
			{
				
				[self resetEmitters];	
			}
			else {
				//Setting up exploding clouds 
				[self resetEmitters];			
				//playing poof sounds
				
			}

			//displaying green Tick
			greenTick.visible = YES;
			
			//NSLog(@"before: number of It:%d count: %d",numberofIterations,[objectToFindArray count]);
			//[[SimpleAudioEngine sharedEngine]unloadEffect:[[foodList objectAtIndex:currentFoodItemIdx]objectAtIndex:1] ];
			numberofIterations++;
			correctAnswers++;
			//NSLog(@"after: number of It:%d count: %d",numberofIterations,[objectToFindArray count]);
						
			//Update correct answer label
			NSString *correctAnswersStr = NSLocalizedString(@"CorrectString",nil);
			NSString *correctCounterMsg = [[NSString alloc] initWithFormat:correctAnswersStr,correctAnswers];			
			[correctAnsLabel setString:correctCounterMsg];
			[correctCounterMsg release];
			[self emptyObjectArray];
			[self performSelector:@selector(startPlaying) withObject:nil afterDelay:0.5f];
		}		
		else if (touchedObject) 
		{
			//NSLog(@"Touched wrong object");
			[objectToDisplay touchAcknowledge];
			[wrongAnswerBuzzer play];
			[self disableTouchesAllObjects];
			if ([currentGamePlayed isEqualToString:@"Animals"]) {
				
			}
			else if ([currentGamePlayed isEqualToString:@"ABCs"])
			{
			
				[self resetEmitters];	
			}
			else {
				//Setting up exploding clouds 
				[self resetEmitters];			
				//playing poof sounds
			}
			redCross.visible = YES;
			//NSLog(@"before: number of It:%d count: %d",numberofIterations,[objectToFindArray count]);
			//[[SimpleAudioEngine sharedEngine]unloadEffect:[[foodList objectAtIndex:currentFoodItemIdx]objectAtIndex:1] ];
			numberofIterations++;
			wrongAnswers++;
			//Update wrong answer label
			NSString* wrongAnswersStr = NSLocalizedString(@"WrongString",nil);
			NSString* wrongCounterMsg = [[NSString alloc] initWithFormat:wrongAnswersStr,wrongAnswers];			
			[wrongAnsLabel setString:wrongCounterMsg];
			[wrongCounterMsg release];
			[self emptyObjectArray];
			[self performSelector:@selector(startPlaying) withObject:nil afterDelay:0.5f];
		}		
	}
}


-(void) resetEmitters
{
	emitter1.position=ccp(78,120);
	[emitter1 resetSystem];
	emitter2.position=ccp(236,120);
	[emitter2 resetSystem];
	emitter3.position=ccp(393,120);
	[emitter3 resetSystem];
	emitter1.visible=YES;
	emitter2.visible=YES;
	emitter3.visible=YES;
}
-(void) emptyObjectArray
{
	NSInteger xCoord;
	NSInteger yCoord;
	for (ObjectToFind *objectToDisplay in objectToFindArray)
	{
		if ([currentGamePlayed isEqualToString:@"ABCs"]) {
			do
			{
				xCoord = (arc4random()% 1000) - 500;
				yCoord = (arc4random()% 1000) - 500;
			}
			while ((xCoord*xCoord + yCoord*yCoord) < 350000);
			//NSLog(@"la valeur de x :%d and y:%d",xCoord,yCoord);
			[objectToDisplay runAction:[CCMoveTo actionWithDuration: 0.8f position:ccp(xCoord, yCoord)]];
		}
		else {
			[objectToDisplay runAction:[CCFadeOut actionWithDuration:0.3f]];
		}
	}
	
	
	//NSLog(@"number of items %d",[objectToFindArray count]);
}

-(id) initWithFullObjectList:(NSMutableArray*)fullObjectListArray
{
	fullFoodList = fullObjectListArray;
	return self;
}
-(id) initWithFullObjectListType:(NSMutableArray*)fullObjectListTypeArray
{
	fullFoodListType = fullObjectListTypeArray;
	return self;
}

-(id) initWithObjectList:(NSMutableArray*)objectListArray
{
	foodList = objectListArray;
	return self;
}
-(id) initWithObjectListType:(NSMutableArray*)objectListTypeArray
{
	foodListType = objectListTypeArray;
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
	double correctAnswerRatio = ((double)numberOfObjectsFounds / (double)[foodList count]) * 100;
	[layer initWithObjectList:foodList];
	[layer initWithObjectListType:foodListType];
	[layer initWithFullObjectList:fullFoodList];
	[layer initWithFullObjectListType:fullFoodListType];
	[layer initWithEndImage:endImagePath];
	[layer initWithBackgroundImage:backgroundImagePath];
	[layer initWithCorrectAnswers:correctAnswerRatio];
	//NSLog(@"The winning song is: %@", winningSong);
	[layer initWithWinningSong:winningSong];
	[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.5f scene:scene]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[correctAnswerBuzzer release];
	[wrongAnswerBuzzer release];
	//[objectNamePlayed release];
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
