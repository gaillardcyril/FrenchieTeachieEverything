//
//  FruitGame.h
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d.h"
#import "HomePage.h"
#import "ObjectToFind.h"
#import <AVFoundation/AVFoundation.h>

//#import "ResultsPage.h";
#define IMAGE1X 78 
#define IMAGE2X 236
#define IMAGE3X 393
#define IMAGESY 120

@interface ThreeChoiceGame : CCLayer {

	NSString* backgroundImagePath;

	NSMutableArray *foodList;
	NSMutableArray *foodListType;
	NSMutableArray *fullFoodList;
	NSMutableArray *fullFoodListType;
	NSInteger imagesY;
	NSMutableArray *xCoordinatesImages;
	NSMutableArray *pickedAnimals;
	CGSize sizeofScreen;
	CCLabel *objectName;
	NSMutableArray *objectToFindArray;
	NSInteger numberofIterations;
	NSInteger numberOfObjectsFounds;
	NSString *currentObjectName;
	BOOL foundCurrentObject;
	BOOL touchedObject;
	NSString *winningSong;
	NSInteger gameIdx;
	NSInteger correctAnswers;
	NSInteger currentFoodItemIdx;
	NSInteger wrongAnswers;
	CCSprite *greenTick;
	AVAudioPlayer *objectNamePlayed;
	CCSprite *redCross;
	CCParticleSystem *emitter1;
	CCParticleSystem *emitter2;
	CCParticleSystem *emitter3;
	CCLabel *correctAnsLabel;
	CCLabel *wrongAnsLabel;
	NSString* endImagePath;
	NSString *currentGamePlayed;
	CCMenu *menuGame;
//	ALuint currentSoundId;
	AVAudioPlayer *correctAnswerBuzzer;
	AVAudioPlayer *wrongAnswerBuzzer;
	
}
-(void) loadGameCategorie:(NSString*)xmlFile withBGImg:(NSString*)BGImagePath withPadding:(NSInteger)paddingToUse;
-(void) displayNavigationMenu;
-(id) initWithObjectList:(NSMutableArray*)objectListArray;
-(id) initWithObjectListType:(NSMutableArray*)objectListTypeArray;
-(id) initWithFullObjectList:(NSMutableArray*)fullObjectListArray;
-(id) initWithFullObjectListType:(NSMutableArray*)fullObjectListTypeArray;
-(id) initWithGameIndex:(NSInteger)gameIndex;

-(void) disableTouchesAllObjects;
-(void) displayCoordGrid;
-(void) startPlaying;
-(void) showResultsPage;
-(void) playObjectSound;
-(void) enableTouchesAllObjects;
-(void) emptyObjectArray;
-(void) playObjectSound;
-(void) resetEmitters;


@property(nonatomic,retain) NSString* backgroundImagePath;
@property(nonatomic,retain)	NSString *currentGamePlayed;
@property(nonatomic,retain) NSMutableArray* xCoordinatesImages;
@property(nonatomic,retain) CCMenu *menuGame;
@property(nonatomic,retain) CCLabel *correctAnsLabel;
@property(nonatomic,retain) CCLabel *wrongAnsLabel;
@property(nonatomic,retain) NSMutableArray *foodList;
@property(nonatomic,retain) NSMutableArray *foodListType;
@property(nonatomic,retain) NSMutableArray *fullFoodList;
@property(nonatomic,retain) NSMutableArray *fullFoodListType;
@property(nonatomic,retain) NSString* endImagePath;
@property(nonatomic,retain) CCLabel *objectName;
@property(nonatomic,retain) NSString *currentObjectName;
@property(nonatomic,retain) NSMutableArray *objectToFindArray;
@property(readwrite,retain) CCParticleSystem *emitter1;
@property(readwrite,retain) CCParticleSystem *emitter2;
@property(readwrite,retain) CCParticleSystem *emitter3;
@property(nonatomic,retain) CCSprite *greenTick;
@property(nonatomic,retain) CCSprite *redCross;
@property(nonatomic,retain) NSMutableArray *pickedAnimals;
@property(nonatomic,retain) NSString *winningSong;
@property(nonatomic,retain) AVAudioPlayer *objectNamePlayed;

@end
