//
//  HelloWorldLayer.h
//  ParallaxNode
//
//  Created by SangChan Lee on 12. 6. 6..
//  Copyright gyaleon@paran.com 2012년. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CGSize winSize;
    
    CCSprite *rightSprite;
    CCSprite *rightPressedSprite;
    CCSprite *leftSprite;
    CCSprite *leftPressedSprite;
    
    CCSprite *dragon;
    
    BOOL isLeftPressed;
    BOOL isRightPressed;
}

// returns a CCScene that contains the HelloWorldLayer as the only child

@property (nonatomic, retain) CCSprite *rightSprite;
@property (nonatomic, retain) CCSprite *rightPressedSprite;
@property (nonatomic, retain) CCSprite *leftSprite;
@property (nonatomic, retain) CCSprite *leftPressedSprite;
@property (nonatomic, retain) CCSprite *dragon;

+(CCScene *) scene;
-(void) createBackgroundParallax;
-(void) createArrowButton;

-(BOOL)isTouchInside:(CCSprite*)sprite withTouch:(UITouch*)touch;
-(void)startMovingBackground;
-(void)stopMovingBackground;
-(void)moveBackground;

-(void) createDragon;

@end
