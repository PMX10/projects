//
//  MultiPlayerScene.h
//  SmashingWord_me
//
//  Created by Edward on 4/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "globalVar.h"
#import "GCHelper.h"


typedef enum {
    kMessageTypeRandomNumber = 0,
    kMessageTypeGameBegin,
    kMessageTypePressButton,
    kMessageTypeGenerateButton,
    kMessageTypeHideButton,
    kMessageTypeGameOver, 
    kMessageTypeStartButton,
    kMessageTypeWord1,
    kMessageTypeWord2,
    kMessageTypeWord3,
    kMessageTypeTime,
    kMessageTypeUseCloud,
    kMessageTypeEndGame,
    kMessageTypeScore
} MessageType;

typedef struct {
    MessageType messageType;
} Message;


typedef struct{
    Message message;
    //char Item[30];
}MessageUseCloud;


typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageRandomNumber;

typedef struct {
    Message message;
} MessageGameBegin;

typedef struct {
    Message message;
    int buttonPosition;
} MessagePressButton;

typedef struct {
    Message message;
    int buttonPosition;
} MessageHideButton;

typedef struct {
    Message message;
    int buttonPosition;
    int letterTag;
}MessageGenerateButton;

typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;

typedef struct {
    Message message;
} MessageStartButton;

typedef struct {
    Message message;
    char word[30];
} MessageWord1;

typedef struct {
    Message message;
    char word[30];
} MessageWord2;

typedef struct {
    Message message;
    char word[30];
} MessageWord3;

typedef struct {
    Message message;
    char time[30];
} MessageTime;

typedef struct {
    Message message;
} MessageEndGame;

typedef struct {
    Message message;
    int score;
} MessageScore;

typedef enum {
    kEndReasonWin,
    kEndReasonLose,
    kEndReasonDisconnect
} EndReason;

typedef enum {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
} GameState;

//score=0;


NSString *word_1;
NSString *word_2;
NSString *word_3;

NSInteger score_1;
NSInteger score_2;
NSInteger score_3;



NSString* selfName;

@interface MultiPlayerScene : CCLayer <GCHelperDelegate>{ 
    CCMenuItemImage* startButton;
    CCMenuItemImage* back;
    CCMenuItemImage* button[9];
    CCMenuItemImage* select[15];
    CCLabelTTF* clock;
    CCLabelTTF* word1;
    CCLabelTTF* word2;
    CCLabelTTF* word3;
    CCSprite* bg;
    
    //BOOL isPlayer1;
    GameState gameState;
    CCLabelTTF *debugLabel;
    uint32_t ourRandom;
    BOOL receivedRandom;
    NSString *otherPlayerID;
    
    CCLabelTTF *player1Label;
    CCLabelTTF *player2Label;
    
    int my_score;
    int opponent_score;
    int my_penalty;
    CCMenuItemImage* shopItem[2];
    CCLabelTTF* shopItemCounter[2];
}

@property (strong, nonatomic) NSTimer *aTimer;              //stage timer
@property (strong, nonatomic) NSTimer *timer;               //button appear duration timer
@property (strong, nonatomic) NSTimer *cloudTimer;
//@property double BUTTON_APPEAR_DURATION;
@property (strong, nonatomic) NSArray *strArray;

@property (retain) GCHelper *helper;
@property (retain) NSData *result;

//Methods used for testing
- (void) getWords;
- (NSArray*) request:(NSString*) path SecondParameter:(NSDictionary*) parameter;
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

- (CCLabelTTF*) getWord1;
-(void)pressButton0:(id)sender;
-(void)pressButton1:(id)sender;
-(void)pressButton2:(id)sender;
-(void)pressButton3:(id)sender;
-(void)pressButton4:(id)sender;
-(void)pressButton5:(id)sender;
-(void)pressButton6:(id)sender;
-(void)pressButton7:(id)sender;
-(void)pressButton8:(id)sender;

-(void)hideButtons;
-(void)resetSelectArray;

-(NSData*) getNSData;
-(void)sendData:(NSData *)data;
-(void)sendRandomNumber;
-(void)sendGameBegin;
-(void)sendGenerateButton:(int)position :(int)type;
-(void)sendStartButton;
-(void)sendWord1:(const char*) words;
-(void)sendWord2:(const char*) words;
-(void)sendWord3:(const char*) words;
-(void)sendTime:(const char*) times;
-(void)sendEndGame;
-(void)sendScore:(int)score;
- (void)sendGameOver:(BOOL)player1Won;
-(void)sendUseCloud;

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
- (CCMenuItemImage*) getStartButton;


- (CCLabelTTF*) getShopItemCounter0;
- (CCLabelTTF*) getShopItemCounter1;

- (CCLabelTTF*) getClock;


- (int) getMaxChar;

-(void)increasePress:(id)sender;

-(void)getLetter;
-(NSString*) get_l;

-(int) getPenalty;
-(void) setPenalty:(int)p;
-(void)generateButton;
-(void)cloudPress:(id)sender;
-(void)start:(id)sender;
@end

