//
//  SinglePlayerScene.h
//  SmashingWord_me
//
//  Created by Edward on 3/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "globalVar.h"
//score=0;
/*
NSString *word_1;
NSString *word_2;
NSString *word_3;

NSInteger score_1;
NSInteger score_2;
NSInteger score_3;
 */

@interface SinglePlayerScene : CCLayer {
    CCMenuItemImage* startButton;
    CCMenuItemImage* button[9];
    CCMenuItemImage* select[15];
    CCLabelTTF* clock;
    CCLabelTTF* word1;
    CCLabelTTF* word2;
    CCLabelTTF* word3;
    CCSprite* bg;
    
    //needed for features from the shop
    BOOL increaseCharUsed;
    CCMenuItemImage* shopItem[4];
    CCLabelTTF* shopItemCounter[4];
    
}

@property (strong, nonatomic) NSTimer *aTimer;              //stage timer
@property (strong, nonatomic) NSTimer *timer;               //button appear duration timer
//@property double BUTTON_APPEAR_DURATION;
@property (strong, nonatomic) NSArray *strArray;

- (NSString*) readDictionaryFile:(NSInteger)lineNum fileName:(NSString*)fileName;
- (NSString*) testing;
- (void) getWords;
- (NSArray*) request:(NSString*) path SecondParameter:(NSDictionary*) parameter;


//Methods used for testing
- (CCMenuItemImage*) getButton0;
- (CCMenuItemImage*) getButton1;
- (CCMenuItemImage*) getButton2;
- (CCMenuItemImage*) getButton3;
- (CCMenuItemImage*) getButton4;
- (CCMenuItemImage*) getButton5;
- (CCMenuItemImage*) getButton6;
- (CCMenuItemImage*) getButton7;
- (CCMenuItemImage*) getButton8;

- (CCMenuItemImage*) getSelect0;
- (CCMenuItemImage*) getSelect1;
- (CCMenuItemImage*) getSelect2;
- (CCMenuItemImage*) getSelect3;
- (CCMenuItemImage*) getSelect4;
- (CCMenuItemImage*) getSelect5;
- (CCMenuItemImage*) getSelect6;
- (CCMenuItemImage*) getSelect7;
- (CCMenuItemImage*) getSelect8;
- (CCMenuItemImage*) getSelect9;
- (CCMenuItemImage*) getSelect10;
- (CCMenuItemImage*) getSelect11;
- (CCMenuItemImage*) getSelect12;
- (CCMenuItemImage*) getSelect13;
- (CCMenuItemImage*) getSelect14;

-(void)unSelect0: (id)sender;
-(void)unSelect1: (id)sender;
-(void)unSelect2: (id)sender;
-(void)unSelect3: (id)sender;
-(void)unSelect4: (id)sender;
-(void)unSelect5: (id)sender;
-(void)unSelect6: (id)sender;
-(void)unSelect7: (id)sender;
-(void)unSelect8: (id)sender;
-(void)unSelect9: (id)sender;
-(void)unSelect10: (id)sender;
-(void)unSelect11: (id)sender;
-(void)unSelect12: (id)sender;
-(void)unSelect13: (id)sender;
-(void)unSelect14: (id)sender;


- (CCMenuItemImage*) getShopItem0;
- (CCMenuItemImage*) getShopItem1;
- (CCMenuItemImage*) getShopItem2;
- (CCMenuItemImage*) getShopItem3;

- (CCLabelTTF*) getShopItemCounter0;
- (CCLabelTTF*) getShopItemCounter1;
- (CCLabelTTF*) getShopItemCounter2;
- (CCLabelTTF*) getShopItemCounter3;

- (CCLabelTTF*) getWord1;
- (CCLabelTTF*) getClock;

- (int) getFreezeMinute;
- (int) getFreezeSecond;
- (BOOL) getIsFreeze;
- (BOOL) getIsSlowDown;
- (int) getCurrentMinute;
- (void) setCurrentMinute :(int)minute;
- (int) getCurrentSecond;
- (void) setCurrentSecond :(int)second;
- (int) getMaxChar;

-(void)pressButton0:(id)sender;
-(void)pressButton1:(id)sender;
-(void)pressButton2:(id)sender;
-(void)pressButton3:(id)sender;
-(void)pressButton4:(id)sender;
-(void)pressButton5:(id)sender;
-(void)pressButton6:(id)sender;
-(void)pressButton7:(id)sender;
-(void)pressButton8:(id)sender;

-(void)freezeTimePress:(id)sender;
-(void)extraTimePress:(id)sender;
-(void)slowdownTimePress:(id)sender;
-(void)increasePress:(id)sender;

-(void)hideButtons;
-(void)resetSelectArray;
-(void)getLetter;
-(NSString*) get_l;
-(void)parseWord: (NSString*) str dictionary:(NSMutableDictionary*) dict;
-(void)generateButton;
@end
