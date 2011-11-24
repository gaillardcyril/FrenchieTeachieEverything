//
//  ResultsPage.h
//  FrenchieTeachieObjects
//
//  Created by Cyril Gaillard on 30/09/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HomePage.h"
//#import "PlayingInterfaceScene.h"
#import "SimpleAudioEngine.h"

@interface ResultsPage : CCLayer  <AVAudioPlayerDelegate>
{
	CGSize sizeofScreen;
	NSInteger correctAnswersG;
	NSInteger gameIdx;
	NSString *backgroundImagePath;
	NSString *winningSong;
	NSMutableArray *objectList;
	NSMutableArray *objectListType;
	CCParticleSystem *dancingNote1;
	CCParticleSystem *dancingNote2;
	CCParticleSystem *dancingNote3;
	CCParticleSystem *dancingNote4;
	NSString* endImagePath;
	NSMutableArray *fullObjectList;
	NSMutableArray *fullObjectListType;
	AVAudioPlayer* endSound;
	NSString *currentGamePlayed;
}
-(void) initWithCorrectAnswers : (double)correctAnswers;
-(void) displayNavigationMenu;
-(id) initWithBackgroundImage:(NSString*)imagePath;
-(id) initWithObjectList:(NSMutableArray*)objectListArray;
-(id) initWithFullObjectList:(NSMutableArray*)fullObjectListArray;
-(id) initWithObjectListType:(NSMutableArray*)objectListTypeArray;
-(id) initWithFullObjectListType:(NSMutableArray*)fullObjectListTypeArray;
-(id) initWithWinningSong:(NSString*)endSong;
-(id) initWithEndImage:(NSString*)imagePath;

@property (readwrite,retain) CCParticleSystem *dancingNote1;
@property (readwrite,retain) CCParticleSystem *dancingNote2;
@property (readwrite,retain) CCParticleSystem *dancingNote3;
@property (readwrite,retain) CCParticleSystem *dancingNote4;
@property (readwrite,retain) NSString *currentGamePlayed;
@property(nonatomic,retain) NSString* endImagePath;
@property (readwrite,retain) NSString *winningSong;
@property(nonatomic,retain) AVAudioPlayer* endSound;
@property(nonatomic,retain) NSMutableArray *objectListType;
@property(nonatomic,retain) NSMutableArray *fullObjectList;
@property(nonatomic,retain) NSMutableArray *fullObjectListType;

@end
