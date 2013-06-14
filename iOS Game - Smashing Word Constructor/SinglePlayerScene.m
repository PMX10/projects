//
//  SinglePlayerScene.m
//  SmashingWord_me
//
//  Created by Edward on 3/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SinglePlayerScene.h"
#import "CCBReader.h"

@implementation SinglePlayerScene
//const bool TEST_MODE_S = false;                // A FLAG TO INDICATE WHETHER THE GAME IS IN TEST MODE

const int MAX_LETTER_ARRAY = 15;             // SIZE OF THE LETTER ARRAY
const int MAX_BUTTON_APPEAR = 9;             // MAXIMUM NUMBER OF BUTTONS APPEAR ON EACH TIME STEP
const int STARTING_MINUTES = 1;              // STAGE DURATION
const int STARTING_SECONDS = 0;             // STAGE DURATION
const int INCR_SCORE = 10;                   // score increment step

const int TOTAL_WORDS_IN_FILE = 20;          // MAXIMUM NUMBER OF WORDS IN A DICTIONARY FILE
const int RANGE_OF_WORD_LENGTH = 2;         // RANGE OF WORD LENGTH USED
const int START_OF_WORD_LENGTH = 3;
const bool easy = false;

NSString *l;
int tempTag;
int currMinute;
int currSeconds;
NSString *STARTING_TIME = @"Time :";
BOOL STOP = false;
NSString *letter[MAX_LETTER_ARRAY];
int total_tests = 0;
int successful_tests = 0;
int failed_tests = 0;
//NSInteger score = 0;

NSMutableDictionary *word1Dict;
NSMutableDictionary *word2Dict;
NSMutableDictionary *word3Dict;
NSMutableDictionary *lettersDict;

//new variables needed for features from the shop
int maxChar = 10;
BOOL isFreeze = NO;
BOOL isSlowDown = NO;
int timeInterval = 1;
int freezeMinute = 0;
int freezeSecond = 0;
int slowSecond = 0;
double freezeButtonDuration = 0;


//************** generating the words **********************
- (void) getWords
{
    int r1, r2, r3;
    int l1, l2, l3;
    NSString *fileName;
    
    r1 = rand() % TOTAL_WORDS_IN_FILE;
    l1 = rand() % RANGE_OF_WORD_LENGTH + START_OF_WORD_LENGTH;
    fileName = [NSString stringWithFormat:@"%i.txt", l1];
    word_1 = [self readDictionaryFile:r1 fileName:fileName];
    [word1 setString:word_1];
    
    r2 = rand() % TOTAL_WORDS_IN_FILE;
    l2 = rand() % RANGE_OF_WORD_LENGTH + START_OF_WORD_LENGTH;
    fileName = [NSString stringWithFormat:@"%i.txt", l2];
    while (r2==r1){ r2 = rand() % TOTAL_WORDS_IN_FILE;}
    word_2 = [self readDictionaryFile:r2 fileName:fileName];
    [word2 setString:word_2];
    
    r3 = rand() % TOTAL_WORDS_IN_FILE;
    l3 = rand() % RANGE_OF_WORD_LENGTH + START_OF_WORD_LENGTH;
    fileName = [NSString stringWithFormat:@"%i.txt", l3];
    while (r3==r1 || r3 == r2){ r3 = rand() % TOTAL_WORDS_IN_FILE;}
    word_3 = [self readDictionaryFile:r3 fileName:fileName];
    [word3 setString:word_3];
    /************** CHANGE boolean 'easy' ON TOP FOR EASY GAME ****************/
    if(easy)
    {
        r1 = rand() % 26;
        l1 = 1;
        fileName = [NSString stringWithFormat:@"%i.txt", l1];
        word_1 = [self readDictionaryFile:r1 fileName:fileName];
        [word1 setString:word_1];
        
        
        r2 = rand() % 26;
        l2 = 1;
        fileName = [NSString stringWithFormat:@"%i.txt", l2];
        while (r2==r1){ r2 = rand() % TOTAL_WORDS_IN_FILE;}
        word_2 = [self readDictionaryFile:r2 fileName:fileName];
        [word2 setString:word_2];
        
        r3 = rand() % 26;
        l3 = 1;
        fileName = [NSString stringWithFormat:@"%i.txt", l3];
        while (r3==r1 || r3 == r2){ r3 = rand() % TOTAL_WORDS_IN_FILE;}
        word_3 = [self readDictionaryFile:r3 fileName:fileName];
        [word3 setString:word_3];
    }
}

//Methods added for testing

- (void) resetSelectArray
{
    for (int i = 0; i < maxChar; i++) {
        select[i].tag = 0;
    }
}

- (CCLabelTTF*) getWord1
{
    return word1;
}
-(NSString*) get_l
{
    return l;
}

- (CCMenuItemImage*) getButton0
{
    return button[0];
}
- (CCMenuItemImage*) getButton1
{
    return button[1];
}
- (CCMenuItemImage*) getButton2
{
    return button[2];
}
- (CCMenuItemImage*) getButton3
{
    return button[3];
}
- (CCMenuItemImage*) getButton4
{
    return button[4];
}
- (CCMenuItemImage*) getButton5
{
    return button[5];
}
- (CCMenuItemImage*) getButton6
{
    return button[6];
}
- (CCMenuItemImage*) getButton7
{
    return button[7];
}
- (CCMenuItemImage*) getButton8
{
    return button[8];
}

- (CCMenuItemImage*) getSelect0
{
    return select[0];
}
- (CCMenuItemImage*) getSelect1
{
    return select[1];
}
- (CCMenuItemImage*) getSelect2
{
    return select[2];
}
- (CCMenuItemImage*) getSelect3
{
    return select[3];
}
- (CCMenuItemImage*) getSelect4
{
    return select[4];
}
- (CCMenuItemImage*) getSelect5
{
    return select[5];
}
- (CCMenuItemImage*) getSelect6
{
    return select[6];
}
- (CCMenuItemImage*) getSelect7
{
    return select[7];
}
- (CCMenuItemImage*) getSelect8
{
    return select[8];
}
- (CCMenuItemImage*) getSelect9
{
    return select[9];
}

- (CCMenuItemImage*) getSelect10
{
    return select[10];
}
- (CCMenuItemImage*) getSelect11
{
    return select[11];
}
- (CCMenuItemImage*) getSelect12
{
    return select[12];
}
- (CCMenuItemImage*) getSelect13
{
    return select[13];
}
- (CCMenuItemImage*) getSelect14
{
    return select[14];
}

- (CCMenuItemImage*) getShopItem0
{
    return shopItem[0];
}

- (CCMenuItemImage*) getShopItem1
{
    return shopItem[1];
}

- (CCMenuItemImage*) getShopItem2
{
    return shopItem[2];
}

- (CCMenuItemImage*) getShopItem3
{
    return shopItem[3];
}

- (CCLabelTTF*) getShopItemCounter0
{
    return shopItemCounter[0];
}

- (CCLabelTTF*) getShopItemCounter1
{
    return shopItemCounter[1];
}

- (CCLabelTTF*) getShopItemCounter2
{
    return shopItemCounter[2];
}

- (CCLabelTTF*) getShopItemCounter3
{
    return shopItemCounter[3];
}

- (CCLabelTTF*) getClock
{
    return clock;
}

- (void) setCurrentMinute :(int)minute
{
    currMinute = minute;
}

- (int) getCurrentMinute
{
    return currMinute;
}

- (void) setCurrentSecond :(int)second
{
    currSeconds = second;
}

- (int) getCurrentSecond
{
    return currSeconds;
}

- (int) getFreezeMinute
{
    return freezeMinute;
}

-(int) getFreezeSecond
{
    return freezeSecond;
}

- (BOOL) getIsFreeze
{
    return isFreeze;
}

- (BOOL) getIsSlowDown
{
    return isSlowDown;
}

- (int) getMaxChar
{
    return maxChar;
}

- (NSString*) testing
{
    return @"hello";
}

//************** readDictionaryFile  **********************
// This function will take 2 parameters lineNum and wordLength, read a file called fileName
// containing a dictionary of words and return the corresponding word given the
// line number.
- (NSString*) readDictionaryFile:(NSInteger)lineNum fileName:(NSString*)fileName
{
    
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    
    //NSString *home = NSHomeDirectory();
    
    //NSString *destinationPath = [NSString stringWithFormat:@"%@/SmashingWord_me.app/%@", home, fileName];
    //NSLog(@"\nText File: %@\n", destinationPath);
    //NSLog( @"THIZZZZ: %@" , [[NSBundle mainBundle] bundlePath] );
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *destinationPath = [NSString stringWithFormat:@"%@/%@", bundlePath, fileName];
    
    NSLog(@"\nText File: %@\n", destinationPath);
    if ([filemgr fileExistsAtPath: destinationPath] == YES)
        NSLog (@"File exists");
    else
        NSLog (@"File not found!");
     
    
    NSString *readText = [[NSString alloc] initWithContentsOfFile:destinationPath
                                                         encoding:NSUTF8StringEncoding
                                                            error:nil];
    NSArray *lines = [readText componentsSeparatedByString:@"\n"];
    
    //NSLog(@"%@ HAA", lines[lineNum]);
    
    return [lines[lineNum] lowercaseString];
}

-(void) hideButtons{
    [button[0] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[0] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[0].isEnabled=NO;
    [button[1] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[1] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[1].isEnabled=NO;
    [button[2] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[2] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[2].isEnabled=NO;
    [button[3] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[3] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[3].isEnabled=NO;
    [button[4] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[4] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[4].isEnabled=NO;
    [button[5] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[5] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[5].isEnabled=NO;
    [button[6] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[6] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[6].isEnabled=NO;
    [button[7] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[7] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[7].isEnabled=NO;
    [button[8] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[8] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[8].isEnabled=NO;
}


//************** Timer action **********************
-(void)timerFired
{
    // time's up
    if (currMinute ==0 && currSeconds == 1){
        [self.timer invalidate];
        STOP = true;
    }
    
    // if the game is still playing....
    else if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1){
            if(!isFreeze ){
                [clock setString:[NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",currMinute,@":",currSeconds]];
                if(isSlowDown && currSeconds == slowSecond-3){
                    isSlowDown = NO;
                    shopItem[0].isEnabled = YES;
                    shopItem[1].isEnabled = YES;
                    shopItem[2].isEnabled = YES;
                    [self.timer invalidate];
                    self.timer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
                    [self.aTimer invalidate];
                    self.aTimer = [NSTimer scheduledTimerWithTimeInterval:BUTTON_APPEAR_DURATION target:self selector:@selector(onTick) userInfo:nil repeats:YES];
                }
            }
            else if(isFreeze && freezeSecond == currSeconds){
                isFreeze = NO;
                //isSlowDown = NO;
                shopItem[0].isEnabled = YES;
                shopItem[1].isEnabled = YES;
                shopItem[2].isEnabled = YES;
                //[self.timer invalidate];
                //self.timer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
                [self.aTimer invalidate];
                self.aTimer = [NSTimer scheduledTimerWithTimeInterval:BUTTON_APPEAR_DURATION target:self selector:@selector(onTick) userInfo:nil repeats:YES];
            }
        }
    }
    
    // time's up
    else
    {
        [self.timer invalidate];

    }
}

- (void)onTick{
    
    if (!STOP){
        [self hideButtons];
        int max_buttons = rand() % MAX_BUTTON_APPEAR + 1;
        
        for (int i=0; i<max_buttons; i++)
            [self generateButton];
        
    }
    else{
        [self endOfGame];
        [self.aTimer invalidate];
    }
}

//When the game finishes
-(void) endOfGame{
    [self hideButtons];
    
    //self.startButton.hidden = false;
    [self countLetters];
    
    score = [self getScore:word1Dict];
    score += [self getScore:word2Dict];
    score += [self getScore:word3Dict];
    /*
     for (int i =0; i<MAX_LETTER_ARRAY;i++)
     NSLog(@"%@", letter[i]);
     */
    NSLog(@"%i", score);
    NSLog(@"sdasdasdasdas %i", penalty_score);
    score_p1 = score;
    score_p1 -= penalty_score;
    score_p2 = -1;
    
    word1Dict = nil;
    word2Dict = nil;
    word3Dict = nil;
    lettersDict = nil;
    
    money += 10;
    [self saveData];
    
    NSNumber * tempScore = [NSNumber numberWithInt:score_p1];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys: tempScore,@"score",nil];
    [self request:@"users/SaveScores/single" SecondParameter:param];
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"Score.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
    [self init];

}

// calculate the score
-(NSInteger) getScore: (NSMutableDictionary*) dict{
    
    if ([dict count]== 0)
        return 0;
    
    Boolean hit = false;
    
    for (id wordkey in dict){ //for each key in the word dictionary
        //NSLog(@"wordkey: %@", wordkey);
        for (id letterkey in lettersDict){ //compare with each key in letter dictionary
            //NSLog(@"%@ %@ %i %i",wordkey, letterkey, [[dict objectForKey:wordkey] intValue], [[lettersDict objectForKey:letterkey] intValue]);
            if ([wordkey isEqualToString:letterkey] && ([[lettersDict objectForKey:letterkey] intValue] >= [[dict objectForKey:wordkey] intValue])){
                hit = true;
                
            }
        }
        if (!hit) return 0;
        else hit = false;
    }
    
    return INCR_SCORE;
}


//counting letters occurance in letter array
-(void) countLetters{
    
    NSInteger count = 0;
    
    for (int i=0; i<maxChar; i++){
        
        if ([lettersDict objectForKey:[NSString stringWithFormat:@"%c",(char)(select[i].tag+32)]]==nil && select[i].tag != 0){
            for (int j=i; j<maxChar; j++){
                if (select[i].tag == select[j].tag)
                    count++;
            }
            [lettersDict setObject:[NSString stringWithFormat:@"%i", count] forKey:[NSString stringWithFormat:@"%c",(char)(select[i].tag+32)]];
        }
        count = 0;  // reset count
    }
    /*
     for (id key in lettersDict) {
     NSLog(@"key: %@, value: %@", key, [lettersDict objectForKey:key]);
     }
     */
}

//counting letters occurance in a word
-(void)parseWord: (NSString*) str dictionary:(NSMutableDictionary*) dict{
    if (str == NULL){
        dict = NULL;
        return;
    }
    
    NSString *key, *value;
    NSInteger numberOfChar=0;
    NSInteger i = 0;
    char c;
    
    for (i=0; i<[str length];i++){
        c = [str characterAtIndex:i];
        key = [NSString stringWithFormat:@"%c",c];
        if ([dict objectForKey:key]==nil){        //if c is not one of the key in dictionary
            //numberOfChar = [self occurrencesOfCharacter: &c nsstring:str];
            numberOfChar = [[str componentsSeparatedByString:key] count] - 1;
            value = [NSString stringWithFormat:@"%d", numberOfChar];
            [dict setObject:value forKey: key];
        }
    }
    /*
     for (id key in dict) {
     NSLog(@"key: %@, value: %@", key, [dict objectForKey:key]);
     }*/
     
}

//generating a button to appear
- (void) generateButton{
    int buttonToAppear = rand()%9 + 1;
    [self getLetter];
    switch (buttonToAppear) {
        case 1:
            [button[0] setNormalImage:[CCSprite spriteWithFile:l]];
            [button[0] setSelectedImage:[CCSprite spriteWithFile:l]];
            button[0].tag = tempTag;
            button[0].isEnabled=YES;
            break;
        case 2:
            [button[1] setNormalImage:[CCSprite spriteWithFile:l]];
            [button[1] setSelectedImage:[CCSprite spriteWithFile:l]];
            button[1].tag = tempTag;
            button[1].isEnabled=YES;
            break;
        case 3:
            [button[2] setNormalImage:[CCSprite spriteWithFile:l]];
            [button[2] setSelectedImage:[CCSprite spriteWithFile:l]];
            button[2].tag = tempTag;
            button[2].isEnabled=YES;
            break;
        case 4:
            [button[3] setNormalImage:[CCSprite spriteWithFile:l]];
            [button[3] setSelectedImage:[CCSprite spriteWithFile:l]];
            button[3].tag = tempTag;
            button[3].isEnabled=YES;
            break;
        case 5:
            [button[4] setNormalImage:[CCSprite spriteWithFile:l]];
            [button[4] setSelectedImage:[CCSprite spriteWithFile:l]];
            button[4].tag = tempTag;
            button[4].isEnabled=YES;
            break;
        case 6:
            [button[5] setNormalImage:[CCSprite spriteWithFile:l]];
            [button[5] setSelectedImage:[CCSprite spriteWithFile:l]];
            button[5].tag = tempTag;
            button[5].isEnabled=YES;
            break;
        case 7:
            [button[6] setNormalImage:[CCSprite spriteWithFile:l]];
            [button[6] setSelectedImage:[CCSprite spriteWithFile:l]];
            button[6].tag = tempTag;
            button[6].isEnabled=YES;
            break;
        case 8:
            [button[7] setNormalImage:[CCSprite spriteWithFile:l]];
            [button[7] setSelectedImage:[CCSprite spriteWithFile:l]];
            button[7].tag = tempTag;
            button[7].isEnabled=YES;
            break;
        case 9:
            [button[8] setNormalImage:[CCSprite spriteWithFile:l]];
            [button[8] setSelectedImage:[CCSprite spriteWithFile:l]];
            button[8].tag = tempTag;
            button[8].isEnabled=YES;
            break;
        default: break;
    }
    
}

//generating a letter to show on the button
- (void)getLetter{
    tempTag = (rand()%29) + 65;
    char c = (char)tempTag;
    l = [NSString stringWithFormat:@"%c"@".png" , c];
}


////////////////////////////////////////////////////////
//**************  start the game  ************************
-(void)start: (id)sender{
    shopItem[0].isEnabled = YES;
    shopItem[1].isEnabled = YES;
    shopItem[2].isEnabled = YES;
    shopItem[3].isEnabled = YES;
    
    [self getWords];
    //self.word1.text = @"Edwarda";
    [self parseWord: [word1 string] dictionary:word1Dict];
    [self parseWord: [word2 string] dictionary:word2Dict];
    [self parseWord: [word3 string] dictionary:word3Dict];
    
    [self.aTimer invalidate];
    [self.timer invalidate];
    self.timer = nil;
    self.aTimer = nil;
    
    currMinute = STARTING_MINUTES;
    currSeconds = STARTING_SECONDS;
    
    clock.color = ccBLACK;
    [clock setString: STARTING_TIME];
    //self.clock.backgroundColor=[UIColor clearColor];
    
    STOP = false;
    score = 0;
    //stage timer
    self.timer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
    
    //button appear timer
    
    self.aTimer = [NSTimer scheduledTimerWithTimeInterval:BUTTON_APPEAR_DURATION target:self selector:@selector(onTick) userInfo:nil repeats:YES];
    
    [startButton setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [startButton setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    startButton.isEnabled=NO;

}

-(void)pressButton0:(id)sender{
    for(int i = 0; i<maxChar; i++){
        if(select[i].tag == 0){
            [button[0] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            [button[0] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            button[0].isEnabled=NO;
            
            if(button[0].tag == 91 || button[0].tag == 92 || button[0].tag ==93){
                ///////added exlosion animation
                CCNode* explosion = [CCBReader nodeGraphFromFile:@"Explosion.ccbi"];
                explosion.position = button[0].parent.position;
                [button[0].parent.parent addChild:explosion];
                if(button[0].tag ==91){
                    penalty_score += 10;
                }
                if(button[0].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar;i++){
                        if(select[i].tag >=65){
                            select[i].tag = 0;
                            [select[i] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            [select[i] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            tempCount++;
                        }
                        if(tempCount ==3)
                            break;
                    }
                }
                if(button[0].tag ==93){
                    currMinute = 0;
                    currSeconds = 1;
                }
            }
            else{
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[0].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[0].tag]]];
                select[i].tag = button[0].tag;
            }
            break;
        }        
    }
}

-(void)pressButton1:(id)sender{
    for(int i = 0; i<maxChar; i++){
        if(select[i].tag == 0){
            [button[1] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            [button[1] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            button[1].isEnabled=NO;
            
            if(button[1].tag == 91 || button[1].tag == 92 || button[1].tag ==93){
                ///////added exlosion animation
                CCNode* explosion = [CCBReader nodeGraphFromFile:@"Explosion.ccbi"];
                explosion.position = button[1].parent.position;
                [button[1].parent.parent addChild:explosion];
                if(button[1].tag ==91){
                    penalty_score += 10;
                }
                if(button[1].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar;i++){
                        if(select[i].tag >=65){
                            select[i].tag = 0;
                            [select[i] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            [select[i] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            tempCount++;
                        }
                        if(tempCount ==3)
                            break;
                    }
                }
                if(button[1].tag ==93){
                    currMinute = 0;
                    currSeconds = 1;
                }
            }
            else{
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[1].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[1].tag]]];
                select[i].tag = button[1].tag;
            }
            break;
        }
    }
}

-(void)pressButton2:(id)sender{
    for(int i = 0; i<maxChar; i++){
        if(select[i].tag == 0){
            [button[2] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            [button[2] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            button[2].isEnabled=NO;
            
            if(button[2].tag == 91 || button[2].tag == 92 || button[2].tag ==93){
            ///////added exlosion animation
            CCNode* explosion = [CCBReader nodeGraphFromFile:@"Explosion.ccbi"];
            explosion.position = button[2].parent.position;
            [button[2].parent.parent addChild:explosion];
                if(button[2].tag ==91){
                    penalty_score += 10;
                }
                if(button[2].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar;i++){
                        if(select[i].tag >=65){
                            select[i].tag = 0;
                            [select[i] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            [select[i] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            tempCount++;
                        }
                        if(tempCount ==3)
                            break;
                    }
                }
                if(button[2].tag ==93){
                    currMinute = 0;
                    currSeconds = 1;
                }
            }
            else{
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[2].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[2].tag]]];
                select[i].tag = button[2].tag;
            }
            break;
        }
    }
}

-(void)pressButton3:(id)sender{
    for(int i = 0; i<maxChar; i++){
        if(select[i].tag == 0){
            [button[3] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            [button[3] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            button[3].isEnabled=NO;
            
            if(button[3].tag == 91 || button[3].tag == 92 || button[3].tag ==93){
                ///////added exlosion animation
                CCNode* explosion = [CCBReader nodeGraphFromFile:@"Explosion.ccbi"];
                explosion.position = button[3].parent.position;
                [button[3].parent.parent addChild:explosion];
                if(button[3].tag ==91){
                    penalty_score += 10;
                }
                if(button[3].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar;i++){
                        if(select[i].tag >=65){
                            select[i].tag = 0;
                            [select[i] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            [select[i] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            tempCount++;
                        }
                        if(tempCount ==3)
                            break;
                    }
                }
                if(button[3].tag ==93){
                    currMinute = 0;
                    currSeconds = 1;
                }
            }
            else{
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[3].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[3].tag]]];
                select[i].tag = button[3].tag;
            }
            break;
        }
    }
}

-(void)pressButton4:(id)sender{
    for(int i = 0; i<maxChar; i++){
        if(select[i].tag == 0){
            [button[4] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            [button[4] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            button[4].isEnabled=NO;
            
            if(button[4].tag == 91 || button[4].tag == 92 || button[4].tag ==93){
                ///////added exlosion animation
                CCNode* explosion = [CCBReader nodeGraphFromFile:@"Explosion.ccbi"];
                explosion.position = button[4].parent.position;
                [button[4].parent.parent addChild:explosion];
                if(button[4].tag ==91){
                    penalty_score += 10;
                }
                if(button[4].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar;i++){
                        if(select[i].tag >=65){
                            select[i].tag = 0;
                            [select[i] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            [select[i] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            tempCount++;
                        }
                        if(tempCount ==3)
                            break;
                    }
                }
                if(button[4].tag ==93){
                    currMinute = 0;
                    currSeconds = 1;
                }
            }
            
            else{
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[4].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[4].tag]]];
                select[i].tag = button[4].tag;
            }
            break;
        }
    }
}

-(void)pressButton5:(id)sender{
    for(int i = 0; i<maxChar; i++){
        if(select[i].tag == 0){
            [button[5] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            [button[5] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            button[5].isEnabled=NO;
            
            if(button[5].tag == 91 || button[5].tag == 92 || button[5].tag ==93){
                ///////added exlosion animation
                CCNode* explosion = [CCBReader nodeGraphFromFile:@"Explosion.ccbi"];
                explosion.position = button[5].parent.position;
                [button[5].parent.parent addChild:explosion];
                if(button[5].tag ==91){
                    penalty_score += 10;
                }
                if(button[5].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar;i++){
                        if(select[i].tag >=65){
                            select[i].tag = 0;
                            [select[i] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            [select[i] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            tempCount++;
                        }
                        if(tempCount ==3)
                            break;
                    }
                }
                if(button[5].tag ==93){
                    currMinute = 0;
                    currSeconds = 1;
                }
            }
            else{
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[5].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[5].tag]]];
                select[i].tag = button[5].tag;
            }
            break;
        }
    }
}

-(void)pressButton6:(id)sender{
    for(int i = 0; i<maxChar; i++){
        if(select[i].tag == 0){
            [button[6] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            [button[6] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            button[6].isEnabled=NO;
            if(button[6].tag == 91 || button[6].tag == 92 || button[6].tag ==93){
                ///////added exlosion animation
                CCNode* explosion = [CCBReader nodeGraphFromFile:@"Explosion.ccbi"];
                explosion.position = button[6].parent.position;
                [button[6].parent.parent addChild:explosion];
                if(button[6].tag ==91){
                    penalty_score += 10;
                }
                if(button[6].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar;i++){
                        if(select[i].tag >=65){
                            select[i].tag = 0;
                            [select[i] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            [select[i] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            tempCount++;
                        }
                        if(tempCount ==3)
                            break;
                    }
                }
                if(button[6].tag ==93){
                    currMinute = 0;
                    currSeconds = 1;
                }
            }
            else{
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[6].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[6].tag]]];
                select[i].tag = button[6].tag;
            }
            break;
        }
    }
}

-(void)pressButton7:(id)sender{
    for(int i = 0; i<maxChar; i++){
        if(select[i].tag == 0){
            [button[7] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            [button[7] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            button[7].isEnabled=NO;
            
            if(button[7].tag == 91 || button[7].tag == 92 || button[7].tag ==93){
                ///////added exlosion animation
                CCNode* explosion = [CCBReader nodeGraphFromFile:@"Explosion.ccbi"];
                explosion.position = button[7].parent.position;
                [button[7].parent.parent addChild:explosion];
                if(button[7].tag ==91){
                    penalty_score += 10;
                }
                if(button[7].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar;i++){
                        if(select[i].tag >=65){
                            select[i].tag = 0;
                            [select[i] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            [select[i] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            tempCount++;
                        }
                        if(tempCount ==3)
                            break;
                    }
                }
                if(button[7].tag ==93){
                    currMinute = 0;
                    currSeconds = 1;
                }
            }
            else{
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[7].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[7].tag]]];
                select[i].tag = button[7].tag;
            }
            break;
        }
    }
}

-(void)pressButton8:(id)sender{
    for(int i = 0; i<maxChar; i++){
        if(select[i].tag == 0){
            [button[8] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            [button[8] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
            button[8].isEnabled=NO;
            
            if(button[8].tag == 91 || button[8].tag == 92 || button[8].tag ==93){
                ///////added exlosion animation
                CCNode* explosion = [CCBReader nodeGraphFromFile:@"Explosion.ccbi"];
                explosion.position = button[8].parent.position;
                [button[8].parent.parent addChild:explosion];
                if(button[8].tag ==91){
                    penalty_score += 10;
                }
                if(button[8].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar;i++){
                        if(select[i].tag >=65){
                            select[i].tag = 0;
                            [select[i] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            [select[i] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
                            tempCount++;
                        }
                        if(tempCount ==3)
                            break;
                    }
                }
                if(button[8].tag ==93){
                    currMinute = 0;
                    currSeconds = 1;
                }
            }
            else{
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[8].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[8].tag]]];
                select[i].tag = button[8].tag;
            }
            break;
        }
    }
}

-(void)unSelect0: (id)sender{
    [select[0] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[0] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[0].tag > 0)
        penalty_score += 1;
    select[0].tag = 0;
}

-(void)unSelect1: (id)sender{
    [select[1] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[1] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[1].tag > 0)
        penalty_score += 1;
    select[1].tag = 0;
}

-(void)unSelect2: (id)sender{
    [select[2] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[2] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[2].tag > 0)
        penalty_score += 1;
    select[2].tag = 0;
}

-(void)unSelect3: (id)sender{
    [select[3] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[3] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[3].tag > 0)
        penalty_score += 1;
    select[3].tag = 0;
}

-(void)unSelect4: (id)sender{
    [select[4] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[4] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[4].tag > 0)
        penalty_score += 1;
    select[4].tag = 0;
}

-(void)unSelect5: (id)sender{
    [select[5] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[5] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[5].tag > 0)
        penalty_score += 1;
    select[5].tag = 0;
}

-(void)unSelect6: (id)sender{
    [select[6] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[6] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[6].tag > 0)
        penalty_score += 1;
    select[6].tag = 0;
}

-(void)unSelect7: (id)sender{
    [select[7] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[7] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[7].tag > 0)
        penalty_score += 1;
    select[7].tag = 0;
}

-(void)unSelect8: (id)sender{
    [select[8] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[8] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[8].tag > 0)
        penalty_score += 1;
    select[8].tag = 0;
}

-(void)unSelect9: (id)sender{
    [select[9] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[9] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[9].tag > 0)
        penalty_score += 1;
    select[9].tag = 0;
}

-(void)unSelect10: (id)sender{
    [select[10] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[10] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[10].tag > 0)
        penalty_score += 1;
    select[10].tag = 0;
}

-(void)unSelect11: (id)sender{
    [select[11] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[11] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[11].tag > 0)
        penalty_score += 1;
    select[11].tag = 0;
}

-(void)unSelect12: (id)sender{
    [select[12] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[12] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[12].tag > 0)
        penalty_score += 1;
    select[12].tag = 0;
}

-(void)unSelect13: (id)sender{
    [select[13] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[13] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[13].tag > 0)
        penalty_score += 1;
    select[13].tag = 0;
}

-(void)unSelect14: (id)sender{
    [select[14] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[14] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[14].tag > 0)
        penalty_score += 1;
    select[14].tag = 0;
}


////////////selector for shop
-(void)freezeTimePress: (id)sender{
    if(freezeTimeCounter > 0){
        shopItem[0].isEnabled = NO;
        shopItem[1].isEnabled = NO;
        shopItem[2].isEnabled = NO;
        freezeTimeCounter --;
        [self saveData];
        isFreeze = YES;
        [shopItemCounter[0] setString:[NSString stringWithFormat:@"x%i", freezeTimeCounter]];
        freezeMinute = currMinute;
        freezeSecond = currSeconds;
        [clock setString:[NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",freezeMinute,@":",freezeSecond]];
        currSeconds += 5;
        [self.aTimer invalidate];
        self.aTimer = [NSTimer scheduledTimerWithTimeInterval:99999 target:self selector:@selector(onTick) userInfo:nil repeats:YES];
    }
}

-(void)extraTimePress: (id)sender{
    if(extraTimeCounter > 0){
        extraTimeCounter --;
        [self saveData];
        [shopItemCounter[2] setString:[NSString stringWithFormat:@"x%i", extraTimeCounter]];
        currSeconds += 5;
        if(currSeconds>59)
        {
            currMinute++;
            currSeconds -=60;
        }
    }
}

-(void)slowdownTimePress: (id)sender{
    if(slowdownTimeCounter > 0){
        shopItem[0].isEnabled = NO;
        shopItem[1].isEnabled = NO;
        shopItem[2].isEnabled = NO;
        slowdownTimeCounter --;
        [self saveData];
        [shopItemCounter[1] setString:[NSString stringWithFormat:@"x%i", slowdownTimeCounter]];
        isSlowDown = YES;
        slowSecond = currSeconds;
        [self.timer invalidate];
        self.timer=[NSTimer scheduledTimerWithTimeInterval:timeInterval*2 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [self.aTimer invalidate];
        self.aTimer = [NSTimer scheduledTimerWithTimeInterval:BUTTON_APPEAR_DURATION*2 target:self selector:@selector(onTick) userInfo:nil repeats:YES];
    }
}

-(void)increasePress: (id)sender{
    shopItem[3].isEnabled = NO;
    if(increaseCounter > 0){
        increaseCounter --;
        [self saveData];
        [shopItemCounter[3] setString:[NSString stringWithFormat:@"x%i", increaseCounter]];
        maxChar = 15;
    }
}


-(id)init{
    if((self=[super init])){
        //fetch game setting from plist
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        
        plistPath = [rootPath stringByAppendingPathComponent:@"SavedState.plist"];
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *unarchivedData = (NSDictionary *)[NSPropertyListSerialization
                                                        propertyListFromData:plistXML
                                                        mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                        format:&format
                                                        errorDescription:&errorDesc];
        
        // If NSDictionary exists, look to see if it holds a saved game state
        if (!unarchivedData)
        {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        else
        {
            NSNumber *integerValue = [unarchivedData objectForKey:@"money"];
            money = [integerValue integerValue];
            
            integerValue = [unarchivedData objectForKey:@"extraTimeCounter"];
            extraTimeCounter = [integerValue integerValue];
            
            integerValue = [unarchivedData objectForKey:@"freezeTimeCounter"];
            freezeTimeCounter =[integerValue integerValue];
            
            integerValue = [unarchivedData objectForKey:@"slowdownTimeCounter"];
            slowdownTimeCounter =[integerValue integerValue];
            
            integerValue = [unarchivedData objectForKey:@"cloudCounter"];
            cloudCounter =[integerValue integerValue];
            
            integerValue = [unarchivedData objectForKey:@"increaseCounter"];
            increaseCounter =[integerValue integerValue];
        }
        
                //NSLog(@"sddddddddddddddddd");
        
        srand ( time(NULL) );//clear out random numbers
        
        self.strArray = [NSArray arrayWithObjects:@"HELLO",@"WORLD",@"EDWARD",@"BING",@"WENHAO",@"DENNY",nil];
        
        //word1Dict= [NSMutableDictionary dictionary];
        word1Dict= [[NSMutableDictionary alloc] init];
        word2Dict= [[NSMutableDictionary alloc] init];
        word3Dict= [[NSMutableDictionary alloc] init];
        
        lettersDict= [[NSMutableDictionary alloc] init];
        
        bg = [CCSprite spriteWithFile:@"background.png"];
        [bg setPosition:ccp(160, 240)];
        [self addChild:bg z:0];
        //[self addChild:[CCMenuLayer node] z:1];
        
        ////////////////////////add 9 buttons and selected letters
        CCMenu *starMenu;
        button[0] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(pressButton0:)];
        [button[0] setScale:0.55];
        button[0].tag = 0;
        button[0].isEnabled=NO;
        starMenu = [CCMenu menuWithItems:button[0], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(50,150)];
        [self addChild:starMenu z:1];
        
        button[1] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(pressButton1:)];
        [button[1] setScale:0.55];
        button[1].isEnabled=NO;
        starMenu = [CCMenu menuWithItems:button[1], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(150,150)];
        [self addChild:starMenu z:1];
        
        button[2] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(pressButton2:)];
        [button[2] setScale:0.55];
        button[2].isEnabled=NO;
        starMenu = [CCMenu menuWithItems:button[2], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(250,150)];
        [self addChild:starMenu z:1];
        
        button[3] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(pressButton3:)];
        [button[3] setScale:0.55];
        button[3].isEnabled=NO;
        starMenu = [CCMenu menuWithItems:button[3], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(50,210)];
        [self addChild:starMenu z:1];
        
        button[4] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(pressButton4:)];
        [button[4] setScale:0.55];
        button[4].isEnabled=NO;
        starMenu = [CCMenu menuWithItems:button[4], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(150,210)];
        [self addChild:starMenu z:1];
        
        button[5] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(pressButton5:)];
        [button[5] setScale:0.55];
        button[5].isEnabled=NO;
        starMenu = [CCMenu menuWithItems:button[5], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(250,210)];
        [self addChild:starMenu z:1];
        
        button[6] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(pressButton6:)];
        [button[6] setScale:0.55];
        button[6].isEnabled=NO;
        starMenu = [CCMenu menuWithItems:button[6], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(50,270)];
        [self addChild:starMenu z:1];
        
        button[7] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(pressButton7:)];
        [button[7] setScale:0.55];
        button[7].isEnabled=NO;
        starMenu = [CCMenu menuWithItems:button[7], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(150,270)];
        [self addChild:starMenu z:1];
        
        button[8] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(pressButton8:)];
        [button[8] setScale:0.55];
        button[8].isEnabled=NO;
        starMenu = [CCMenu menuWithItems:button[8], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(250,270)];
        [self addChild:starMenu z:1];
        
        /////////////////////////
        select[0] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect0:)];
        [select[0] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[0], nil];
        select[0].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(30,40)];
        [self addChild:starMenu z:1];
        
        select[1] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect1:)];
        [select[1] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[1], nil];
        select[1].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(60,40)];
        [self addChild:starMenu z:1];
        
        select[2] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect2:)];
        [select[2] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[2], nil];
        select[2].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(90,40)];
        [self addChild:starMenu z:1];
        
        select[3] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect3:)];
        [select[3] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[3], nil];
        select[3].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(120,40)];
        [self addChild:starMenu z:1];
        
        select[4] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect4:)];
        [select[4] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[4], nil];
        select[4].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(150,40)];
        [self addChild:starMenu z:1];
        
        select[5] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect5:)];
        [select[5] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[5], nil];
        select[5].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(180,40)];
        [self addChild:starMenu z:1];
        
        select[6] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect6:)];
        [select[6] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[6], nil];
        select[6].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(210,40)];
        [self addChild:starMenu z:1];
        
        select[7] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect7:)];
        [select[7] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[7], nil];
        select[7].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(240,40)];
        [self addChild:starMenu z:1];
        
        select[8] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect8:)];
        [select[8] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[8], nil];
        select[8].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(270,40)];
        [self addChild:starMenu z:1];
        
        select[9] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect9:)];
        [select[9] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[9], nil];
        select[9].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(300,40)];
        [self addChild:starMenu z:1];
        
        select[10] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect10:)];
        [select[10] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[10], nil];
        select[10].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(30,80)];
        [self addChild:starMenu z:1];

        select[11] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect11:)];
        [select[11] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[11], nil];
        select[11].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(60,80)];
        [self addChild:starMenu z:1];

        select[12] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect12:)];
        [select[12] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[12], nil];
        select[12].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(90,80)];
        [self addChild:starMenu z:1];

        select[13] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect13:)];
        [select[13] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[13], nil];
        select[13].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(120,80)];
        [self addChild:starMenu z:1];
        
        select[14] = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(unSelect14:)];
        [select[14] setScale:0.3];
        starMenu = [CCMenu menuWithItems:select[14], nil];
        select[14].tag = 0;
        starMenu.position = CGPointZero;
        //[self addChild:starMenu];
        [starMenu setPosition:ccp(150,80)];
        [self addChild:starMenu z:1];
        
        /////////////////////////////shop items
        maxChar = 10;
        
        shopItem[0] = [CCMenuItemImage itemWithNormalImage:@"freezeTime.png" selectedImage:@"freezeTime.png" target:self selector:@selector(freezeTimePress:)];
        [shopItem[0] setScale:0.2];
        shopItem[0].isEnabled=YES;
        starMenu = [CCMenu menuWithItems:shopItem[0], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(30,340)];
        [self addChild:starMenu z:1];
        
        shopItemCounter[0] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x%i", freezeTimeCounter] fontName:@"ArialRoundedMTBold" fontSize:24];
        shopItemCounter[0].position = ccp(30,310);
        shopItemCounter[0].color = ccBLACK;
        [self addChild:shopItemCounter[0] z:1];
        
        shopItem[1] = [CCMenuItemImage itemWithNormalImage:@"slowdownTime.png" selectedImage:@"slowdownTime.png" target:self selector:@selector(slowdownTimePress:)];
        [shopItem[1] setScale:0.2];
        shopItem[1].isEnabled=YES;
        starMenu = [CCMenu menuWithItems:shopItem[1], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(110,350)];
        [self addChild:starMenu z:1];
        
        shopItemCounter[1] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x%i", slowdownTimeCounter] fontName:@"ArialRoundedMTBold" fontSize:24];
        shopItemCounter[1].position = ccp(110,310);
        shopItemCounter[1].color = ccBLACK;
        [self addChild:shopItemCounter[1] z:1];
        
        shopItem[2] = [CCMenuItemImage itemWithNormalImage:@"extraTime.png" selectedImage:@"extraTime.png" target:self selector:@selector(extraTimePress:)];
        [shopItem[2] setScale:0.2];
        shopItem[2].isEnabled=YES;
        starMenu = [CCMenu menuWithItems:shopItem[2], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(190,350)];
        [self addChild:starMenu z:1];
        
        shopItemCounter[2] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x%i", extraTimeCounter] fontName:@"ArialRoundedMTBold" fontSize:24];
        shopItemCounter[2].position = ccp(190,310);
        shopItemCounter[2].color = ccBLACK;
        [self addChild:shopItemCounter[2] z:1];
        
        shopItem[3] = [CCMenuItemImage itemWithNormalImage:@"increase.png" selectedImage:@"increase.png" target:self selector:@selector(increasePress:)];
        [shopItem[3] setScale:0.2];
        shopItem[3].isEnabled=YES;
        starMenu = [CCMenu menuWithItems:shopItem[3], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(270,350)];
        [self addChild:starMenu z:1];
        
        shopItemCounter[3] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x%i", increaseCounter] fontName:@"ArialRoundedMTBold" fontSize:24];
        shopItemCounter[3].position = ccp(270,310);
        shopItemCounter[3].color = ccBLACK;
        [self addChild:shopItemCounter[3] z:1];
        
        shopItem[0].isEnabled = NO;
        shopItem[1].isEnabled = NO;
        shopItem[2].isEnabled = NO;
        shopItem[3].isEnabled = NO;


        
        ///////////////////////////////////////////////////
        ///////////////////start button
        startButton = [CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"start.png" target:self selector:@selector(start:)];
        [startButton setScale:0.5];
        starMenu = [CCMenu menuWithItems:startButton, nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(300,455)];
        [self addChild:starMenu z:1];
        
        ////////////////add clock and given words labels
        clock = [CCLabelTTF labelWithString:@"Time" fontName:@"ArialRoundedMTBold" fontSize:24];
        clock.position = ccp(250,420);
        clock.color = ccBLACK;
        [self addChild:clock z:1];
        
        word1 = [CCLabelTTF labelWithString:@"Word1:" fontName:@"ArialRoundedMTBold" fontSize:15];
        word1.position = ccp(50,460);
        word1.color = ccBLACK;
        [self addChild:word1 z:1];
        
        word2 = [CCLabelTTF labelWithString:@"Word2:" fontName:@"ArialRoundedMTBold" fontSize:15];
        word2.position = ccp(50,430);
        word2.color = ccBLACK;
        [self addChild:word2 z:1];
        
        word3 = [CCLabelTTF labelWithString:@"Word3:" fontName:@"ArialRoundedMTBold" fontSize:15];
        word3.position = ccp(50,400);
        word3.color = ccBLACK;
        [self addChild:word3 z:1];
        
    }
    return self;
}


-(void)BackButtonPress:(id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"GameMenu.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
}

// Changing the image of the same sprite
//[test setTexture:[[CCTextureCache sharedTextureCache] addImage:@"two.png"]];

- (NSArray*) request:(NSString*) path SecondParameter:(NSDictionary*) parameter{
    NSDictionary * jsonDict;
    NSLog(@"%@",path);
    if ([path isEqualToString:@"users/SaveScores/single"]){
        jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    [parameter objectForKey:@"score"], @"score",
                    nil];
    }
    else{
        jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    nil];
    }
    //[jsonDictionaryResponse objectForKey:@"data"];
    NSError *tempError;
    NSData *jsonRequest = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&tempError];
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", @"http://enigmatic-everglades-8004.herokuapp.com/", path];
    NSURL *url = [NSURL URLWithString:fullPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonRequest length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonRequest];
    NSURLResponse *tempResponse =[[NSURLResponse alloc]init];
    NSData *jsonResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&tempResponse error:&tempError];
    
    NSDictionary *jsonDictionaryResponse = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&tempError];
    
    return [jsonDictionaryResponse objectForKey:@"data"];
    
}

-(void)saveData{
    // We're going to save the data to SavedState.plist in our app's documents directory
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"SavedState.plist"];
    
    // Create a dictionary to store all your data
    NSMutableDictionary *prefs = [NSMutableDictionary dictionary];
    
    
    //NSUserDefaults *prefs = [[NSUserDefaults standardUserDefaults] synchronize];
    [prefs setObject:[NSNumber numberWithInteger:money] forKey:@"money"];
    [prefs setObject:[NSNumber numberWithInteger:extraTimeCounter] forKey:@"extraTimeCounter"];
    [prefs setObject:[NSNumber numberWithInteger:freezeTimeCounter] forKey:@"freezeTimeCounter"];
    [prefs setObject:[NSNumber numberWithInteger:slowdownTimeCounter] forKey:@"slowdownTimeCounter"];
    [prefs setObject:[NSNumber numberWithInteger:cloudCounter] forKey:@"cloudCounter"];
    [prefs setObject:[NSNumber numberWithInteger:increaseCounter]forKey:@"increaseCounter"];
    
    
    NSString *errorDescription;
    NSData *serializedData = [NSPropertyListSerialization dataFromPropertyList:prefs
                                                                        format:NSPropertyListXMLFormat_v1_0
                                                              errorDescription:&errorDescription];
    
    if(serializedData)
    {
        // Write file
        NSError *error;
        BOOL didWrite = [serializedData writeToFile:plistPath options:NSDataWritingFileProtectionComplete error:&error];
        //NSLog(@"Error while writing: %@", [error description]);
        
        if (didWrite)
            NSLog(@"File did write");
        else
            NSLog(@"File write failed");
    }
    else
    {
        NSLog(@"Error in creating state data dictionary: %@", errorDescription);
    }
}

@end
