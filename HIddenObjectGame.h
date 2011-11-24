//
//  VeggiesGame.h
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HomePage.h"
#import "ObjectToFind.h"
#import <AVFoundation/AVFoundation.h>

@interface HiddenObjectGame : CCLayer {
	
	NSString* backgroundImagePath;
	NSMutableArray *objectList;
	NSMutableArray *objectListType;
	NSMutableArray *fullObjectList;
	NSMutableArray *fullObjectListType;	
	CGSize sizeofScreen;
	CCLabel *objectName;
	NSArray *objectToFindArray;
	NSInteger numberofIterations;
	NSInteger numberOfObjectsFounds;
	NSString *currentObjectName;
	BOOL foundCurrentObject;
	BOOL touchedObject;
	NSString *winningSong;
	NSInteger gameIdx;
	NSInteger correctAnswers;
	NSInteger wrongAnswers;
	CCSprite *greenTick;
	CCSprite *redCross;
	CCParticleSystem *emitter;
	CCLabel *correctAnsLabel;
	CCLabel *wrongAnsLabel;
	NSString* endImagePath;
	NSString *currentGamePlayed;
	AVAudioPlayer *objectNamePlayed;
	AVAudioPlayer *correctAnswerBuzzer;
	AVAudioPlayer *wrongAnswerBuzzer;
	
}
-(void) displayNavigationMenu;
-(id) initWithObjectList:(NSMutableArray*)objectListArray;
-(id) initWithGameIndex:(NSInteger)gameIndex;
-(void) displayObjectsToFind;
-(void) loadObjectsToFind;
-(void) displayCoordGrid;
-(void) startPlaying;
-(void) showResultsPage;
-(void) playObjectSound;
-(void) enableTouchesAllObjects;
-(void) disableTouchesAllObjects;
-(id) initWithObjectListType:(NSMutableArray*)objectListTypeArray;
-(id) initWithFullObjectList:(NSMutableArray*)fullObjectListArray;
-(id) initWithFullObjectListType:(NSMutableArray*)fullObjectListTypeArray;
-(void) loadGameCategorie:(NSString*)xmlFile withBGImg:(NSString*)BGImagePath withPadding:(NSInteger)paddingToUse;



@property(nonatomic,retain) NSString* backgroundImagePath;
@property(nonatomic,retain) AVAudioPlayer *objectNamePlayed;
@property(nonatomic,retain) CCLabel *correctAnsLabel;
@property(nonatomic,retain)	NSString *currentGamePlayed;
@property(nonatomic,retain) CCLabel *wrongAnsLabel;
@property(nonatomic,retain) NSMutableArray *objectList;
@property(nonatomic,retain) NSMutableArray *objectListType;
@property(nonatomic,retain) NSMutableArray *fullObjectList;
@property(nonatomic,retain) NSMutableArray *fullObjectListType;
@property(nonatomic,retain) CCLabel *objectName;
@property(nonatomic,retain) NSString *currentObjectName;
@property(nonatomic,retain) NSArray *objectToFindArray;
@property (readwrite,retain) CCParticleSystem *emitter;
@property(nonatomic,retain) CCSprite *greenTick;
@property(nonatomic,retain) CCSprite *redCross;
@property(nonatomic,retain) NSString *winningSong;
@property(nonatomic,retain) NSString* endImagePath;
@end
