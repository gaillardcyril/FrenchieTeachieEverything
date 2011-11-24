//
//  GameCategorieChoice.h
//  FrenchieTeachieEverything
//
//  Created by Cyril Gaillard on 19/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameCategorieChoice : CCLayer 
{
	CGSize sizeofScreen;
	NSString *backgroundImagePath;
	NSString *firstThumbPath;
	NSString *secondThumbPath;
	NSString *thirdThumbPath;
	NSInteger thumbPadding;
	NSMutableArray* objectListType;
	NSMutableArray* objectList;
}

@property(nonatomic,retain) NSString *backgroundImagePath;
@property(nonatomic,retain) NSString *firstThumbPath;
@property(nonatomic,retain) NSString *secondThumbPath;
@property(nonatomic,retain) NSString *thirdThumbPath;
@property(nonatomic,retain) NSMutableArray* objectListType;
@property(nonatomic,retain) NSMutableArray* objectList;

-(id) initWithBackgroundImage:(NSString*)imagePath;
-(id) initWithThumbPadding:(NSInteger)thumbPad;
-(id) initWithObjectList:(NSMutableArray*)listObject;
-(id) initWithObjectListType:(NSMutableArray*)listObjectType;
-(void)displayPlayingInterface:(NSInteger)categoryIdx;

@end
