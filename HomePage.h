//
//  HomePage.h
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HomePage : CCLayer {
	NSMutableArray *objectListType;
	NSMutableArray *objectList;
}
+(id) scene;
-(void) loadGameCategorie:(NSString*)xmlFile withBGImg:(NSString*)BGImagePath withPadding:(NSInteger)paddingToUse;


@property(nonatomic,retain) NSMutableArray* objectListType;
@property(nonatomic,retain) NSMutableArray* objectList;

@end
