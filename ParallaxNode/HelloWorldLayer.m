//
//  HelloWorldLayer.m
//  ParallaxNode
//
//  Created by SangChan Lee on 12. 6. 6..
//  Copyright gyaleon@paran.com 2012년. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#define IMG_WIDTH 1024
enum {
    kTag_Parallax,
    kTag_ArrowButtonPressed,
    kTag_ArrowButton
};
// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize rightSprite;
@synthesize rightPressedSprite;
@synthesize leftSprite;
@synthesize leftPressedSprite;
@synthesize dragon;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		
        self.isTouchEnabled = YES;
        winSize = [[CCDirector sharedDirector]winSize];
        [self createBackgroundParallax];
        [self createArrowButton];
        [self createDragon];
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[rightSprite release];
    [rightPressedSprite release];
    [leftSprite release];
    [leftPressedSprite release];
    [dragon release];
    [super dealloc];
}

-(void)createBackgroundParallax {
    CCSprite *bgSprite1 = [CCSprite spriteWithFile:@"background1.png"];
    CCSprite *bgSprite2 = [CCSprite spriteWithFile:@"background2.png"];
    bgSprite1.anchorPoint = ccp(0,0);
    bgSprite2.anchorPoint = ccp(0,0);
    [bgSprite1.texture setAliasTexParameters];
    [bgSprite2.texture setAliasTexParameters];
    CCParallaxNode *voidNode = [CCParallaxNode node];
    [voidNode addChild:bgSprite1 z:1 parallaxRatio:ccp(1.0f,0) positionOffset:CGPointZero];
    [voidNode addChild:bgSprite2 z:1 parallaxRatio:ccp(1.0f,0) positionOffset:ccp(512,0)];
    [self addChild:voidNode z:kTag_Parallax tag:kTag_Parallax];
}
-(void)createArrowButton {
    CCSprite *sprite = [[CCSprite alloc]initWithFile:@"b1.png"];
    self.leftSprite = sprite;
    self.leftSprite.position = ccp(180,30);
    [self addChild:self.leftSprite z:kTag_ArrowButton];
    [sprite release];
    
    sprite = [[CCSprite alloc]initWithFile:@"b2.png"];
    self.leftPressedSprite = sprite;
    self.leftPressedSprite.position = self.leftSprite.position;
    [self addChild:self.leftPressedSprite z:kTag_ArrowButtonPressed];
    [sprite release];
    
    sprite = [[CCSprite alloc]initWithFile:@"f1.png"];
    self.rightSprite = sprite;
    self.rightSprite.position = ccp(300,30);
    [self addChild:self.rightSprite z:kTag_ArrowButton];
    [sprite release];
    
    sprite = [[CCSprite alloc]initWithFile:@"f2.png"];
    self.rightPressedSprite = sprite;
    self.rightPressedSprite.position = self.rightSprite.position;
    [self addChild:self.rightPressedSprite z:kTag_ArrowButtonPressed];
    [sprite release];
}

-(void) createDragon {
    CCSprite *sprite = [CCSprite spriteWithFile:@"dragon_animation.png"];
    CCAnimation *animation = [[CCAnimation alloc]init];
    [animation setDelay:0.1];
    self.dragon = [CCSprite spriteWithTexture:sprite.texture rect:CGRectMake(0, 0, 130, 140)];
    for (int i = 0; i<6; i++) {
        NSUInteger index = i%4;
        NSUInteger rowIndex = i/4;
        [animation addFrameWithTexture:sprite.texture rect:CGRectMake(index*130, rowIndex*140, 130, 140)];
    }
    
    self.dragon.position = ccp(240,160);
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    animate = [CCRepeatForever actionWithAction:animate];
    [self.dragon runAction:animate];
    [self addChild:self.dragon];
    
}

#pragma mark Touch event handling

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    isLeftPressed = NO;
    isRightPressed = NO;
    
    if ([self isTouchInside:self.leftSprite withTouch:touch] == YES) {
        self.leftSprite.visible = NO;
        isLeftPressed = YES;
    } else if ([self isTouchInside:self.rightSprite withTouch:touch] == YES) {
        self.rightSprite.visible = NO;
        isRightPressed = YES;
    }
    if (isLeftPressed == YES || isRightPressed == YES) {
        [self startMovingBackground];
    }
    
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isLeftPressed == YES || isRightPressed == YES) {
        [self stopMovingBackground];
    }
    
    if (isLeftPressed) {
        self.leftSprite.visible = YES;
    }
    
    if (isRightPressed) {
        self.rightSprite.visible = YES;
    }

}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (isLeftPressed == YES && [self isTouchInside:self.leftSprite withTouch:touch] == NO) {
        self.leftSprite.visible = YES;
        [self stopMovingBackground];
    }else if (isRightPressed == YES && [self isTouchInside:self.rightSprite withTouch:touch] == NO) {
        self.rightSprite.visible = YES;
        [self stopMovingBackground];
    }
}

#pragma mark Game Play 
-(BOOL)isTouchInside:(CCSprite *)sprite withTouch:(UITouch *)touch {
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint convertLocation = [[CCDirector sharedDirector]convertToGL:location];
    
    CGFloat halfWidth = sprite.contentSize.width / 2.0;
    CGFloat halfHeight = sprite.contentSize.height / 2.0;
    
    if (convertLocation.x > (sprite.position.x+halfWidth) || convertLocation.x < (sprite.position.x - halfWidth) ||
        convertLocation.y > (sprite.position.y+halfHeight) || convertLocation.y < (sprite.position.y - halfHeight)) {
        return NO;
    }
    
    return YES;
}

-(void)startMovingBackground {
    if (isLeftPressed == YES && isRightPressed == YES) {
        return;
    }
    NSLog(@"start Moving");
    [self schedule:@selector(moveBackground)];
}

-(void)stopMovingBackground {
    NSLog(@"stop Moving");
    [self unschedule:@selector(moveBackground)];
}

-(void)moveBackground {
    if (isRightPressed) {
        self.dragon.flipX = YES;
    }
    else {
        self.dragon.flipX = NO;
    }
    
    CCNode *voidNode = [self getChildByTag:kTag_Parallax];
    CGPoint moveStep = ccp(3,0);
    
    if (isRightPressed) {
        moveStep.x = -moveStep.x;
    }
    
    CGFloat bgParallaxRatio = 1.0f;
    CGPoint newPos = ccp(voidNode.position.x+moveStep.x, voidNode.position.y);
    
    if (isLeftPressed == YES && newPos.x > 0) {
        newPos.x = 0;
    }
    else if (isRightPressed == YES && newPos.x < -(IMG_WIDTH - winSize.width)/bgParallaxRatio) {
        newPos.x = -(IMG_WIDTH - winSize.width)/bgParallaxRatio;
    }
    
    voidNode.position = newPos;
}
@end
