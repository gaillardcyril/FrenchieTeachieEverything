//
//  ObjectToFind.m
//  FrenchieTeachieObjects
//
//  Created by Cyril Gaillard on 29/09/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "ObjectToFind.h"


@implementation ObjectToFind
@synthesize emitter;

- (CGRect)rect
{
	CGSize s = [self.texture contentSize];
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

- (void)onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:self.tag swallowsTouches:YES];
	[super onEnter];
	disableTouch=YES;
}

- (void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}	

- (BOOL)containsTouchLocation:(UITouch *)touch
{
	return CGRectContainsPoint(self.rect, [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (disableTouch) {
		//NSLog(@"item disabled");
		return NO;		
	}

	if ( ![self containsTouchLocation:touch] )	
	{
		isTouched = NO;
		return NO;
	}		
		
	isTouched = YES;
	//NSLog(@"Touched object %d",self.tag);
	//self.scale = self.scale* 1.1;
	return YES;
}

- (void)disableTouch:(BOOL)disable
{
	disableTouch = disable;
	//NSLog(@"disabling objects");
}


-(BOOL) objectHasBeenFound:(NSInteger)objectTag
{
	if ((objectTag == self.tag) && isTouched)
	{
		//NSLog(@"You found the object");
		isTouched = NO;
		self.visible = NO;
		return YES;		
	}
	return NO;
}
-(CGPoint) objectPosition
{
	return self.position;
}
-(BOOL) objectHasBeenTouched
{
	return isTouched;
}
-(void)touchAcknowledge
{
	isTouched = NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	//isTouched = NO;
}

@end
