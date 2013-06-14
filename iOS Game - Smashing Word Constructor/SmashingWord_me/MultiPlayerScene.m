//
//  MultiPlayerScene.m
//  SmashingWord_me
//
//  Created by Edward on 4/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.


#import "MultiPlayerScene.h"
#import "CCBReader.h"
#import "AppDelegate.h"

@implementation MultiPlayerScene
const bool TEST_MODE_M = false;                // A FLAG TO INDICATE WHETHER THE GAME IS IN TEST MODE
int testsCount = 0;
int successTests = 0;
int failedTests = 0;

const int MAX_LETTER_ARRAY_M = 10;             // SIZE OF THE LETTER ARRAY
const int MAX_BUTTON_APPEAR_M = 9;             // MAXIMUM NUMBER OF BUTTONS APPEAR ON EACH TIME STEP
const int STARTING_MINUTES_M = 1;              // STAGE DURATION
const int STARTING_SECONDS_M = 0;             // STAGE DURATION
const int INCR_SCORE_M = 50;                   // score increment step

const int TOTAL_WORDS_IN_FILE_M = 20;          // MAXIMUM NUMBER OF WORDS IN A DICTIONARY FILE
const int RANGE_OF_WORD_LENGTH_M = 2;         // RANGE OF WORD LENGTH USED
const int START_OF_WORD_LENGTH_M = 3;
const bool easy_M = false;

NSString *l_M;
int tempTag;
int currMinute;
int currSeconds;
int temp_score;
NSString *STARTING_TIME_M = @"Time : 1:00";
BOOL STOP_M = false;
//NSString *letter[MAX_LETTER_ARRAY_M];
//int total_tests = 0;
//int successful_tests = 0;
//int failed_tests = 0;
//NSInteger score = 0;

NSString* ExtraTime =  @"Extra Time";
NSString* ViewObstructor = @"View Obstructor";
NSString* CharacterIncrease = @"Character Increase";



NSString* TimeFreezer = @"Time Freezer";
NSString* TimeSlower =@"Time Slower";

NSMutableDictionary *word1Dict;
NSMutableDictionary *word2Dict;
NSMutableDictionary *word3Dict;
NSMutableDictionary *lettersDict;

///////for testing purposes

int pressButtonTest;

//new variables needed for features from the shop
int maxChar_m = 10;
int cloudTime;
int p1CloudedTime;
BOOL isCloud = NO;
BOOL p1Clouded = NO;


//************** generating the words **********************
- (void) getWords
{
    int r1, r2, r3;
    int l1, l2, l3;
    NSString *fileName;
    
    r1 = rand() % TOTAL_WORDS_IN_FILE_M;
    l1 = rand() % RANGE_OF_WORD_LENGTH_M + START_OF_WORD_LENGTH_M;
    fileName = [NSString stringWithFormat:@"%i.txt", l1];
    word_1 = [self readDictionaryFile:r1 fileName:fileName];
    [word1 setString:word_1];
    
    r2 = rand() % TOTAL_WORDS_IN_FILE_M;
    l2 = rand() % RANGE_OF_WORD_LENGTH_M + START_OF_WORD_LENGTH_M;
    fileName = [NSString stringWithFormat:@"%i.txt", l2];
    while (r2==r1){ r2 = rand() % TOTAL_WORDS_IN_FILE_M;}
    word_2 = [self readDictionaryFile:r2 fileName:fileName];
    [word2 setString:word_2];
    
    r3 = rand() % TOTAL_WORDS_IN_FILE_M;
    l3 = rand() % RANGE_OF_WORD_LENGTH_M + START_OF_WORD_LENGTH_M;
    fileName = [NSString stringWithFormat:@"%i.txt", l3];
    while (r3==r1 || r3 == r2){ r3 = rand() % TOTAL_WORDS_IN_FILE_M;}
    word_3 = [self readDictionaryFile:r3 fileName:fileName];
    [word3 setString:word_3];
    /************** CHANGE boolean 'easy' ON TOP FOR EASY GAME ****************/
    if(easy_M)
    {
        r1 = rand() % 26;
        l1 = 1;
        fileName = [NSString stringWithFormat:@"%i.txt", l1];
        word_1 = [self readDictionaryFile:r1 fileName:fileName];
        [word1 setString:word_1];
        
        r2 = rand() % 26;
        l2 = 1;
        fileName = [NSString stringWithFormat:@"%i.txt", l2];
        while (r2==r1){ r2 = rand() % TOTAL_WORDS_IN_FILE_M;}
        word_2 = [self readDictionaryFile:r2 fileName:fileName];
        [word2 setString:word_2];
        
        r3 = rand() % 26;
        l3 = 1;
        fileName = [NSString stringWithFormat:@"%i.txt", l3];
        while (r3==r1 || r3 == r2){ r3 = rand() % TOTAL_WORDS_IN_FILE_M;}
        word_3 = [self readDictionaryFile:r3 fileName:fileName];
        [word3 setString:word_3];
    }
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
    [self sendHideButton:0];
    [button[1] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[1] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[1].isEnabled=NO;
    [self sendHideButton:1];
    [button[2] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[2] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[2].isEnabled=NO;
    [self sendHideButton:2];
    [button[3] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[3] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[3].isEnabled=NO;
    [self sendHideButton:3];
    [button[4] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[4] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[4].isEnabled=NO;
    [self sendHideButton:4];
    [button[5] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[5] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[5].isEnabled=NO;
    [self sendHideButton:5];
    [button[6] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[6] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[6].isEnabled=NO;
    [self sendHideButton:6];
    [button[7] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[7] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[7].isEnabled=NO;
    [self sendHideButton:7];
    [button[8] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [button[8] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    button[8].isEnabled=NO;
    [self sendHideButton:8];
}


//************** Timer action **********************
-(void)timerFired
{
    // time's up
    if (currMinute ==0 && currSeconds == 1){
        [self.timer invalidate];
        STOP_M = true;
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
            NSString* tempString = [NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",currMinute,@":",currSeconds];
            [clock setString:tempString];
            [self sendTime:[tempString UTF8String]];
            if(isCloud == YES && currSeconds == cloudTime - 5){
                isCloud = NO;
                shopItem[1].isEnabled = YES;
            }
            if(p1Clouded == YES && currSeconds == p1CloudedTime -5){
                p1Clouded = NO;
                [self sendStartButton];
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
    
    if (!STOP_M){
        [self hideButtons];
        if(isPlayer1){
            int max_buttons = rand() % MAX_BUTTON_APPEAR_M + 1;
        
            for (int i=0; i<max_buttons; i++)
                [self generateButton];
        }
        
    }
    else{
        [self matchEnded];
        [self.aTimer invalidate];
    }
}

//When the game finishes
/*
-(void) endOfGame{
    [self hideButtons];
    [self countLetters];
    
    
    my_score = [self getScore:word1Dict];
    my_score += [self getScore:word2Dict];
    my_score += [self getScore:word3Dict];
    [self sendScore:my_score];
    if(isPlayer1)
        [self sendEndGame];

    word1Dict = nil;
    word2Dict = nil;
    word3Dict = nil;
    lettersDict = nil;
    
    if(my_score < opponent_score)
        scorePageMessage = @"You Lost!";
    else if(my_score > opponent_score)
        scorePageMessage = @"You Win!";
    else
        scorePageMessage = @"Tie";
    
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"Score.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
    [self init];
    
}*/

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
    
    return INCR_SCORE_M;
}


//counting letters occurance in letter array
-(void) countLetters{
    
    NSInteger count = 0;
    
    for (int i=0; i<maxChar_m; i++){
        
        if ([lettersDict objectForKey:[NSString stringWithFormat:@"%c",(char)(select[i].tag+32)]]==nil && select[i].tag != 0){
            for (int j=i; j<maxChar_m; j++){
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
            if(p1Clouded){
                [button[0] setNormalImage:[CCSprite spriteWithFile:@"^.png"]];
                [button[0] setSelectedImage:[CCSprite spriteWithFile:@"^.png"]];
                button[0].tag = 94;
                button[0].isEnabled=YES;
            }
            else{
                [button[0] setNormalImage:[CCSprite spriteWithFile:l_M]];
                [button[0] setSelectedImage:[CCSprite spriteWithFile:l_M]];
                button[0].tag = tempTag;
                button[0].isEnabled=YES;
            }
            if(isCloud)
                [self sendGenerateButton:0 :94];
            else
                [self sendGenerateButton:0 :tempTag];
            break;
        case 2:
            if(p1Clouded){
                [button[1] setNormalImage:[CCSprite spriteWithFile:@"^.png"]];
                [button[1] setSelectedImage:[CCSprite spriteWithFile:@"^.png"]];
                button[1].tag = 94;
                button[1].isEnabled=YES;
            }
            else{
                [button[1] setNormalImage:[CCSprite spriteWithFile:l_M]];
                [button[1] setSelectedImage:[CCSprite spriteWithFile:l_M]];
                button[1].tag = tempTag;
                button[1].isEnabled=YES;
            }
            if(isCloud)
                [self sendGenerateButton:1 :94];
            else
                [self sendGenerateButton:1 :tempTag];
            break;
        case 3:
            if(p1Clouded){
                [button[2] setNormalImage:[CCSprite spriteWithFile:@"^.png"]];
                [button[2] setSelectedImage:[CCSprite spriteWithFile:@"^.png"]];
                button[2].tag = 94;
                button[2].isEnabled=YES;
            }
            else{
                [button[2] setNormalImage:[CCSprite spriteWithFile:l_M]];
                [button[2] setSelectedImage:[CCSprite spriteWithFile:l_M]];
                button[2].tag = tempTag;
                button[2].isEnabled=YES;
            }            if(isCloud)
                [self sendGenerateButton:2 :94];
            else
                [self sendGenerateButton:2 :tempTag];
            break;
        case 4:
            if(p1Clouded){
                [button[3] setNormalImage:[CCSprite spriteWithFile:@"^.png"]];
                [button[3] setSelectedImage:[CCSprite spriteWithFile:@"^.png"]];
                button[3].tag = 94;
                button[3].isEnabled=YES;
            }
            else{
                [button[3] setNormalImage:[CCSprite spriteWithFile:l_M]];
                [button[3] setSelectedImage:[CCSprite spriteWithFile:l_M]];
                button[3].tag = tempTag;
                button[3].isEnabled=YES;
            }
            if(isCloud)
                [self sendGenerateButton:3 :94];
            else
                [self sendGenerateButton:3 :tempTag];
            break;
        case 5:
            if(p1Clouded){
                [button[4] setNormalImage:[CCSprite spriteWithFile:@"^.png"]];
                [button[4] setSelectedImage:[CCSprite spriteWithFile:@"^.png"]];
                button[4].tag = 94;
                button[4].isEnabled=YES;
            }
            else{
                [button[4] setNormalImage:[CCSprite spriteWithFile:l_M]];
                [button[4] setSelectedImage:[CCSprite spriteWithFile:l_M]];
                button[4].tag = tempTag;
                button[4].isEnabled=YES;
            }
            if(isCloud)
                [self sendGenerateButton:4 :94];
            else
                [self sendGenerateButton:4 :tempTag];
            break;
        case 6:
            if(p1Clouded){
                [button[5] setNormalImage:[CCSprite spriteWithFile:@"^.png"]];
                [button[5] setSelectedImage:[CCSprite spriteWithFile:@"^.png"]];
                button[5].tag = 94;
                button[5].isEnabled=YES;
            }
            else{
                [button[5] setNormalImage:[CCSprite spriteWithFile:l_M]];
                [button[5] setSelectedImage:[CCSprite spriteWithFile:l_M]];
                button[5].tag = tempTag;
                button[5].isEnabled=YES;
            }
            if(isCloud)
                [self sendGenerateButton:5 :94];
            else
                [self sendGenerateButton:5 :tempTag];
            break;
        case 7:
            if(p1Clouded){
                [button[6] setNormalImage:[CCSprite spriteWithFile:@"^.png"]];
                [button[6] setSelectedImage:[CCSprite spriteWithFile:@"^.png"]];
                button[6].tag = 94;
                button[6].isEnabled=YES;
            }
            else{
                [button[6] setNormalImage:[CCSprite spriteWithFile:l_M]];
                [button[6] setSelectedImage:[CCSprite spriteWithFile:l_M]];
                button[6].tag = tempTag;
                button[6].isEnabled=YES;
            }
            if(isCloud)
                [self sendGenerateButton:6 :94];
            else
                [self sendGenerateButton:6 :tempTag];
            break;
        case 8:
            if(p1Clouded){
                [button[7] setNormalImage:[CCSprite spriteWithFile:@"^.png"]];
                [button[7] setSelectedImage:[CCSprite spriteWithFile:@"^.png"]];
                button[7].tag = 94;
                button[7].isEnabled=YES;
            }
            else{
                [button[7] setNormalImage:[CCSprite spriteWithFile:l_M]];
                [button[7] setSelectedImage:[CCSprite spriteWithFile:l_M]];
                button[7].tag = tempTag;
                button[7].isEnabled=YES;
            }
            if(isCloud)
                [self sendGenerateButton:7 :94];
            else
                [self sendGenerateButton:7 :tempTag];
            break;
        case 9:
            if(p1Clouded){
                [button[8] setNormalImage:[CCSprite spriteWithFile:@"^.png"]];
                [button[8] setSelectedImage:[CCSprite spriteWithFile:@"^.png"]];
                button[8].tag = 94;
                button[8].isEnabled=YES;
            }
            else{
                [button[8] setNormalImage:[CCSprite spriteWithFile:l_M]];
                [button[8] setSelectedImage:[CCSprite spriteWithFile:l_M]];
                button[8].tag = tempTag;
                button[8].isEnabled=YES;
            }
            if(isCloud)
                [self sendGenerateButton:8 :94];
            else
                [self sendGenerateButton:8 :tempTag];
            break;
        default: break;
    }
    
}

//generating a letter to show on the button
- (void)getLetter{
    tempTag = (rand()%28) + 65;
    char c = (char)tempTag;
    l_M = [NSString stringWithFormat:@"%c"@".png" , c];
}


////////////////////////////////////////////////////////
//**************  start the game  ************************
-(void)start: (id)sender{
    if(TEST_MODE){
        [self temporaryTests];
        return;
    }
    shopItem[0].isEnabled = YES;
    shopItem[1].isEnabled = YES;
    [self sendStartButton];
    [self getWords];
    //self.word1.text = @"Edwarda";
    [self parseWord: [word1 string] dictionary:word1Dict];
    [self sendWord1:[word_1 UTF8String]];
    [self parseWord: [word2 string] dictionary:word2Dict];
    [self sendWord2:[word_2 UTF8String]];
    [self parseWord: [word3 string] dictionary:word3Dict];
    [self sendWord3:[word_3 UTF8String]];
    
    [self.aTimer invalidate];
    [self.timer invalidate];
    self.timer = nil;
    self.aTimer = nil;
    
    currMinute = STARTING_MINUTES_M;
    currSeconds = STARTING_SECONDS_M;
    
    clock.color = ccBLACK;
    [clock setString: STARTING_TIME_M];
    //self.clock.backgroundColor=[UIColor clearColor];
    
    STOP_M = false;
    score = 0;
    //stage timer
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
    
    //button appear timer
    self.aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTick) userInfo:nil repeats:YES];
    
    [startButton setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [startButton setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    startButton.isEnabled=NO;
    
    
}

-(void)pressButton0:(id)sender{
    for(int i = 0; i<maxChar_m; i++){
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
                    my_penalty += 10;
                }
                if(button[0].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar_m;i++){
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
            }
            else{
                [self sendPressButton:0];
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[0].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[0].tag]]];
                select[i].tag = button[0].tag;
            }
            break;
        }
    }
}

-(void)pressButton1:(id)sender{
    for(int i = 0; i<maxChar_m; i++){
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
                    my_penalty += 10;
                }
                if(button[1].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar_m;i++){
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
            }
            else{
                [self sendPressButton:1];
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[1].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[1].tag]]];
                select[i].tag = button[1].tag;
            }
            break;
        }
    }
}

-(void)pressButton2:(id)sender{
    for(int i = 0; i<maxChar_m; i++){
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
                    my_penalty += 10;
                }
                if(button[2].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar_m;i++){
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
            }
            else{
                [self sendPressButton:2];
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[2].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[2].tag]]];
                select[i].tag = button[2].tag;
            }
            break;
        }
    }
}

-(void)pressButton3:(id)sender{
    for(int i = 0; i<maxChar_m; i++){
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
                    my_penalty += 10;
                }
                if(button[3].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar_m;i++){
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
            }
            else{
                [self sendPressButton:3];
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[3].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[3].tag]]];
                select[i].tag = button[3].tag;
            }
            break;
        }
    }
}

-(void)pressButton4:(id)sender{
    for(int i = 0; i<maxChar_m; i++){
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
                    my_penalty += 10;
                }
                if(button[4].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar_m;i++){
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
            }
            
            else{
                [self sendPressButton:4];
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[4].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[4].tag]]];
                select[i].tag = button[4].tag;
            }
            break;
        }
    }
}

-(void)pressButton5:(id)sender{
    for(int i = 0; i<maxChar_m; i++){
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
                    my_penalty += 10;
                }
                if(button[5].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar_m;i++){
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
            }
            else{
                [self sendPressButton:5];
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[5].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[5].tag]]];
                select[i].tag = button[5].tag;
            }
            break;
        }
    }
}

-(void)pressButton6:(id)sender{
    for(int i = 0; i<maxChar_m; i++){
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
                    my_penalty += 10;
                }
                if(button[6].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar_m;i++){
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

            }
            else{
                [self sendPressButton:6];
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[6].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[6].tag]]];
                select[i].tag = button[6].tag;
            }
            break;
        }
    }
}

-(void)pressButton7:(id)sender{
    for(int i = 0; i<maxChar_m; i++){
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
                    my_penalty += 10;
                }
                if(button[7].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar_m;i++){
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
            }
            else{
                [self sendPressButton:7];
                [select[i] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[7].tag]]];
                [select[i] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)button[7].tag]]];
                select[i].tag = button[7].tag;
            }
            break;
        }
    }
}

-(void)pressButton8:(id)sender{
    for(int i = 0; i<maxChar_m; i++){
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
                    my_penalty += 10;
                }
                if(button[8].tag ==92){
                    int tempCount = 0;
                    for(int i=0;i<maxChar_m;i++){
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
            }
            else{
                [self sendPressButton:8];
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
        my_penalty += 1;
    select[0].tag = 0;
}

-(void)unSelect1: (id)sender{
    [select[1] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[1] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[1].tag > 0)
        my_penalty += 1;
    select[1].tag = 0;
}

-(void)unSelect2: (id)sender{
    [select[2] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[2] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[2].tag > 0)
        my_penalty += 1;
    select[2].tag = 0;
}

-(void)unSelect3: (id)sender{
    [select[3] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[3] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[3].tag > 0)
        my_penalty += 1;
    select[3].tag = 0;
}

-(void)unSelect4: (id)sender{
    [select[4] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[4] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[4].tag > 0)
        my_penalty += 1;
    select[4].tag = 0;
}

-(void)unSelect5: (id)sender{
    [select[5] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[5] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[5].tag > 0)
        my_penalty += 1;
    select[5].tag = 0;
}

-(void)unSelect6: (id)sender{
    [select[6] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[6] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[6].tag > 0)
        my_penalty += 1;
    select[6].tag = 0;
}

-(void)unSelect7: (id)sender{
    [select[7] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[7] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[7].tag > 0)
        my_penalty += 1;
    select[7].tag = 0;
}

-(void)unSelect8: (id)sender{
    [select[8] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[8] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[8].tag > 0)
        my_penalty += 1;
    select[8].tag = 0;
}

-(void)unSelect9: (id)sender{
    [select[9] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[9] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[9].tag > 0)
        my_penalty += 1;
    select[9].tag = 0;
}

-(void)unSelect10: (id)sender{
    [select[10] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[10] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[10].tag > 0)
        my_penalty += 1;
    select[10].tag = 0;
}

-(void)unSelect11: (id)sender{
    [select[11] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[11] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[11].tag > 0)
        my_penalty += 1;
    select[11].tag = 0;
}

-(void)unSelect12: (id)sender{
    [select[12] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[12] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[12].tag > 0)
        my_penalty += 1;
    select[12].tag = 0;
}

-(void)unSelect13: (id)sender{
    [select[13] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[13] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[13].tag > 0)
        my_penalty += 1;
    select[13].tag = 0;
}

-(void)unSelect14: (id)sender{
    [select[14] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
    [select[14] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
    if(select[14].tag > 0)
        my_penalty += 1;
    select[14].tag = 0;
}

-(void)increasePress: (id)sender{
    shopItem[0].isEnabled = NO;
    if(increaseCounter > 0){
        increaseCounter --;
        [self saveData];
        [shopItemCounter[0] setString:[NSString stringWithFormat:@"x%i", increaseCounter]];
        maxChar_m = 15;
    }
}

-(void)cloudPress: (id)sender{
    shopItem[1].isEnabled = NO;
    if(cloudCounter > 0){
        cloudCounter --;
        [self saveData];
        [shopItemCounter[1] setString:[NSString stringWithFormat:@"x%i", cloudCounter]];
        if(!isPlayer1)
            [self sendUseCloud];
        else{
            isCloud = YES;
            cloudTime = currSeconds;
        }

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
        
        //
        my_score = 0;
        opponent_score = 0;
    
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
        
        back = [CCMenuItemImage itemWithNormalImage:@"transparent.png" selectedImage:@"transparent.png" target:self selector:@selector(BackButtonPress:)];
        starMenu = [CCMenu menuWithItems:back, nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(280,60)];
        [self addChild:starMenu z:1];

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
        maxChar_m = 10;
        
        shopItem[0] = [CCMenuItemImage itemWithNormalImage:@"increase.png" selectedImage:@"increase.png" target:self selector:@selector(increasePress:)];
        [shopItem[0] setScale:0.2];
        shopItem[0].isEnabled=YES;
        starMenu = [CCMenu menuWithItems:shopItem[0], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(30,350)];
        [self addChild:starMenu z:1];
        
        shopItemCounter[0] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x%i", increaseCounter] fontName:@"ArialRoundedMTBold" fontSize:24];
        shopItemCounter[0].position = ccp(30,310);
        shopItemCounter[0].color = ccBLACK;
        [self addChild:shopItemCounter[0] z:1];
        
        shopItem[1] = [CCMenuItemImage itemWithNormalImage:@"cloud.png" selectedImage:@"cloud.png" target:self selector:@selector(cloudPress:)];
        [shopItem[1] setScale:0.2];
        shopItem[1].isEnabled=YES;
        starMenu = [CCMenu menuWithItems:shopItem[1], nil];
        starMenu.position = CGPointZero;
        [starMenu setPosition:ccp(110,340)];
        [self addChild:starMenu z:1];
        
        shopItemCounter[1] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x%i", cloudCounter] fontName:@"ArialRoundedMTBold" fontSize:24];
        shopItemCounter[1].position = ccp(110,310);
        shopItemCounter[1].color = ccBLACK;
        [self addChild:shopItemCounter[1] z:1];
        
        shopItem[0].isEnabled = NO;
        shopItem[1].isEnabled = NO;
        
        
        ///////////////////////////////////////////////////
        ///////////////////start button
        
        
        ////////////////add clock and given words labels
        clock = [CCLabelTTF labelWithString:@"Time" fontName:@"Arial" fontSize:24];
        clock.position = ccp(250,420);
        clock.color = ccBLACK;
        [self addChild:clock z:1];
        
        word1 = [CCLabelTTF labelWithString:@"Word1:" fontName:@"Arial" fontSize:15];
        word1.position = ccp(50,460);
        word1.color = ccBLACK;
        [self addChild:word1 z:1];
        
        word2 = [CCLabelTTF labelWithString:@"Word2:" fontName:@"Arial" fontSize:15];
        word2.position = ccp(50,430);
        word2.color = ccBLACK;
        [self addChild:word2 z:1];
        
        word3 = [CCLabelTTF labelWithString:@"Word3:" fontName:@"Arial" fontSize:15];
        word3.position = ccp(50,400);
        word3.color = ccBLACK;
        [self addChild:word3 z:1];
        
        AppController * delegate = (AppController *) [UIApplication sharedApplication].delegate;
        
        if  (!TEST_MUL)
        [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:delegate.navController delegate:self];
        
        
        ///////////////////
        isPlayer1 = YES;
        
        debugLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:15];
        debugLabel.position = ccp(200,200);
        debugLabel.color = ccBLACK;
        [self addChild:debugLabel z:1];
        
        ourRandom = arc4random();
        [self setGameState:kGameStateWaitingForStart];
        
        self.helper = [GCHelper sharedInstance];
        
    }
    return self;
}


-(void)BackButtonPress:(id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"GameMenu.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
}


- (void)setGameState:(GameState)state {
    
    gameState = state;
    if (gameState == kGameStateWaitingForMatch) {
        [debugLabel setString:@"Waiting for match"];
    } else if (gameState == kGameStateWaitingForRandomNumber) {
        [debugLabel setString:@"Waiting for rand #"];
    } else if (gameState == kGameStateWaitingForStart) {
        [debugLabel setString:@"Waiting for start"];
        [back setNormalImage:[CCSprite spriteWithFile:@"backarrow.png"]];
        [back setSelectedImage:[CCSprite spriteWithFile:@"backarrow.png"]];
        back.isEnabled=YES;


    } else if (gameState == kGameStateActive) {
        [debugLabel setString:@""];
        [back setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
        [back setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
        back.isEnabled=NO;
    } else if (gameState == kGameStateDone) {
        [debugLabel setString:@"Done"];
    }
    
    
}

- (void)sendData:(NSData *)data {
    //self.helper = [GCHelper sharedInstance];
    NSLog(@"Sending Data...");
    self.result = [self.helper broadcastData:data];
    /*
    NSError *error;
    NSLog(@"Sending Data...");
    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        CCLOG(@"Error sending init packet");
        //[self matchEnded];
        [[GCHelper sharedInstance].match disconnect];
        [GCHelper sharedInstance].match = nil;
    }
     */
}

NSData* data;

- (void)sendRandomNumber {
    
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = ourRandom;
    data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}

- (void)sendGameBegin {
    
    MessageGameBegin message;
    message.message.messageType = kMessageTypeGameBegin;
    data = [NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];
    [self sendData:data];
    
}

- (void)sendPressButton:(int) position{
    
    MessagePressButton message;
    message.buttonPosition = position;
    message.message.messageType = kMessageTypePressButton;
    data = [NSData dataWithBytes:&message length:sizeof(MessagePressButton)];
    [self sendData:data];
    
}

-(void)sendGenerateButton:(int) position :(int) tag {
    MessageGenerateButton message;
    message.buttonPosition = position;
    message.letterTag = tag;
    message.message.messageType = kMessageTypeGenerateButton;
    data = [NSData dataWithBytes:&message length:sizeof(MessageGenerateButton)];
    [self sendData:data];
}

-(void)sendHideButton:(int) position{
    MessageHideButton message;
    message.buttonPosition = position;
    message.message.messageType = kMessageTypeHideButton;
    data = [NSData dataWithBytes:&message length:sizeof(MessageHideButton)];
    [self sendData:data];
}

-(void)sendStartButton{
    MessageStartButton message;
    message.message.messageType = kMessageTypeStartButton;
    data = [NSData dataWithBytes:&message length:sizeof(MessageStartButton)];
    [self sendData:data];
}

-(void)sendWord1:(const char*) words{
    MessageWord1 message;
    strcpy(message.word,words);
    message.message.messageType = kMessageTypeWord1;
    data = [NSData dataWithBytes:&message length:sizeof(MessageWord1)];
    [self sendData:data];
}

-(void)sendWord2:(const char*) words{
    MessageWord2 message;
    strcpy(message.word,words);
    message.message.messageType = kMessageTypeWord2;
    data = [NSData dataWithBytes:&message length:sizeof(MessageWord2)];
    [self sendData:data];}

-(void)sendWord3:(const char*) words{
    MessageWord3 message;
    strcpy(message.word,words);
    message.message.messageType = kMessageTypeWord3;
    data = [NSData dataWithBytes:&message length:sizeof(MessageWord3)];
    [self sendData:data];
}

-(void)sendTime:(const char*) times{
    MessageTime message;
    strcpy(message.time, times);
    message.message.messageType = kMessageTypeTime;
    data = [NSData dataWithBytes:&message length:sizeof(MessageTime)];
    [self sendData:data];
}

-(void)sendEndGame {
    MessageEndGame message;
    message.message.messageType = kMessageTypeEndGame;
    data = [NSData dataWithBytes:&message length:sizeof(MessageEndGame)];
    [self sendData:data];   
}

-(void)sendScore: (int) score {
    MessageScore message;
    message.message.messageType = kMessageTypeScore;
    message.score = score;
    data = [NSData dataWithBytes:&message length:sizeof(MessageScore)];
    [self sendData:data];
}

- (void)sendGameOver:(BOOL)player1Won {
    
    MessageGameOver message;
    message.message.messageType = kMessageTypeGameOver;
    message.player1Won = player1Won;
    data = [NSData dataWithBytes:&message length:sizeof(MessageGameOver)];
    [self sendData:data];
    
}

/*Send data method for item usage*/
-(void)sendUseCloud{
    MessageEndGame message;
    message.message.messageType = kMessageTypeUseCloud;
    data = [NSData dataWithBytes:&message length:sizeof(MessageUseCloud)];
    [self sendData:data];
}

- (void)tryStartGame {
    
    if (isPlayer1 && gameState == kGameStateWaitingForStart) {
        [self setGameState:kGameStateActive];
        [self sendGameBegin];
        //[self setupStringsWithOtherPlayerId:otherPlayerID];
    }
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    [otherPlayerID release];
    otherPlayerID = nil;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GCHelperDelegate

- (void)matchStarted {
    selfName =[[GKLocalPlayer localPlayer]alias];
    NSLog(@"%@", selfName);
    CCLOG(@"Match started");
    if (receivedRandom) {
        [self setGameState:kGameStateWaitingForStart];
    } else {
        [self setGameState:kGameStateWaitingForRandomNumber];
    }
    [self sendRandomNumber];
    [self tryStartGame];
}

/*
- (void)inviteReceived {
    [self restartTapped:nil];
}*/

- (void)matchEnded {
    CCLOG(@"Match ended");
    //[[GCHelper sharedInstance].match disconnect];
    //[GCHelper sharedInstance].match = nil;
    //[self endScene:kEndReasonDisconnect];
    if(isPlayer1)
        [self hideButtons];
    [self countLetters];
    
    
    my_score = [self getScore:word1Dict];
    my_score += [self getScore:word2Dict];
    my_score += [self getScore:word3Dict];
    [self sendScore:my_score];
    if(isPlayer1)
        [self sendEndGame];
    /*
     for (int i =0; i<MAX_LETTER_ARRAY_M;i++)
     NSLog(@"%@", letter[i]);
     */
    //NSLog(@"%i", score);
    word1Dict = nil;
    word2Dict = nil;
    word3Dict = nil;
    lettersDict = nil;
    if(!isPlayer1){
        money += 20;
        [self saveData];
        if(my_score < opponent_score)
            scorePageMessage = @"You Lost!";
        else if(my_score > opponent_score)
            scorePageMessage = @"You Win!";
        else
            scorePageMessage = @"Tie";
        
        if(isPlayer1){
            score_p1 = my_score;
            score_p2 = opponent_score;
        }
        else{
            score_p1 = opponent_score;
            score_p2 = my_score;
        }
        NSNumber *tempNum = [NSNumber numberWithInt:my_score];
        NSDictionary* tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  tempNum,@"score",
                                  selfName,@"user",
                                  nil];
        [self request:@"/users/SaveScores/multiple" SecondParameter:tempDict];
        CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"Score.ccbi"];
        [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
    }
    //[self init];

}



- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
    // Store away other player ID for later
    if (otherPlayerID == nil) {
        otherPlayerID = [playerID retain];
    }
    
    Message *message = (Message *) [data bytes];
    if (message->messageType == kMessageTypeRandomNumber) {
        
        MessageRandomNumber * messageInit = (MessageRandomNumber *) [data bytes];
        CCLOG(@"Received random number: %ud, ours %ud", messageInit->randomNumber, ourRandom);
        bool tie = false;
        
        if (messageInit->randomNumber == ourRandom) {
            CCLOG(@"TIE!");
            tie = true;
            ourRandom = arc4random();
            [self sendRandomNumber];
        } else if (ourRandom > messageInit->randomNumber) {
            CCLOG(@"We are player 1");
            isPlayer1 = YES;
            if(isPlayer1){
                startButton = [CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"start.png" target:self selector:@selector(start:)];
                [startButton setScale:0.5];
                CCMenu* starMenu = [CCMenu menuWithItems:startButton, nil];
                starMenu.position = CGPointZero;
                [starMenu setPosition:ccp(300,455)];
                [self addChild:starMenu z:1];
            }
        } else {
            CCLOG(@"We are player 2");
            isPlayer1 = NO;
        }
        
        if (!tie) {
            receivedRandom = YES;
            if (gameState == kGameStateWaitingForRandomNumber) {
                [self setGameState:kGameStateWaitingForStart];
            }
            [self tryStartGame];
        }
        
    } else if (message->messageType == kMessageTypeGameBegin) {
        
        [self setGameState:kGameStateActive];
        //[self setupStringsWithOtherPlayerId:playerID];
        
    }
    else if (message->messageType == kMessageTypeStartButton) {
        shopItem[0].isEnabled = YES;
        shopItem[1].isEnabled = YES;
    }
    
    else if (message->messageType == kMessageTypeGenerateButton) {
        
        MessageGenerateButton * tempMessage = (MessageGenerateButton*) [data bytes];
        //CCLOG(@"Received button information to generate");
        if(!isPlayer1){
            [button[tempMessage->buttonPosition] setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)tempMessage->letterTag]]];
            [button[tempMessage->buttonPosition] setSelectedImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"%c"@".png", (char)tempMessage->letterTag]]];
            button[tempMessage->buttonPosition].tag = tempMessage->letterTag;
            button[tempMessage->buttonPosition].isEnabled = YES;
        }
    } else if(message->messageType == kMessageTypePressButton) {
        MessagePressButton * tempMessage = (MessagePressButton *) [data bytes];
        //CCLOG(@"Received button information to hide");
        [button[tempMessage->buttonPosition] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
        [button[tempMessage->buttonPosition] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
        button[tempMessage->buttonPosition].isEnabled = NO;
        /*
        if(TEST_MODE && !isPlayer1){
            NSLog(@"buttonposition is %d", tempMessage->buttonPosition);
            [self sendPressButton:tempMessage->buttonPosition];
        }
        else if(TEST_MODE && isPlayer1){
            NSLog(@"buttonposition is %d", tempMessage->buttonPosition);
            pressButtonTest = tempMessage->buttonPosition;
        }*/
        
    } else if(message->messageType == kMessageTypeHideButton) {
        MessageHideButton * tempMessage = (MessageHideButton *) [data bytes];
        //CCLOG(@"Hide button information");
        [button[tempMessage->buttonPosition] setNormalImage:[CCSprite spriteWithFile:@"transparent.png"]];
        [button[tempMessage->buttonPosition] setSelectedImage:[CCSprite spriteWithFile:@"transparent.png"]];
        button[tempMessage->buttonPosition].isEnabled = NO;
    }
    
    else if(message->messageType == kMessageTypeWord1){
        //NSLog(@"sdasdddddda111");
        MessageWord1 * tempMessage = (MessageWord1*) [data bytes];
        NSString* tempString = [NSString stringWithUTF8String:tempMessage->word];
        [word1 setString: tempString];
        [self parseWord: tempString dictionary:word1Dict];

    }
    
    else if(message->messageType == kMessageTypeWord2){
        MessageWord2 * tempMessage = (MessageWord2*) [data bytes];
        NSString* tempString = [NSString stringWithUTF8String:tempMessage->word];
        [word2 setString: tempString];
        [self parseWord: tempString dictionary:word2Dict];

    }
    
    else if(message->messageType == kMessageTypeWord3){
        MessageWord3 * tempMessage = (MessageWord3*) [data bytes];
        NSString* tempString = [NSString stringWithUTF8String:tempMessage->word];
        [word3 setString: tempString];
        [self parseWord: tempString dictionary:word3Dict];

    }
    
    else if(message->messageType == kMessageTypeTime){
        MessageTime * tempMessage = (MessageTime*) [data bytes];
        NSString* tempString = [NSString stringWithUTF8String:tempMessage->time];
        [clock setString: tempString];
    }
    else if(message->messageType == kMessageTypeEndGame){
        //MessageEndGame * tempMessage = (MessageEndGame*) [data bytes];
        [self matchEnded];
    }
    
    else if(message->messageType == kMessageTypeScore) {
        MessageScore* tempMessage = (MessageScore*) [data bytes];
        opponent_score = tempMessage->score;
        if(isPlayer1){
            money += 20;
            [self saveData];
            if(my_score < opponent_score)
                scorePageMessage = @"You Lost!";
            else if(my_score > opponent_score)
                scorePageMessage = @"You Win!";
            else
                scorePageMessage = @"Tie";
            
            if(isPlayer1){
                score_p1 = my_score;
                score_p2 = opponent_score;
            }
            else{
                score_p1 = opponent_score;
                score_p2 = my_score;
            }
            NSNumber *tempNum = [NSNumber numberWithInt:my_score];
            NSDictionary* tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      tempNum,@"score",
                                      selfName,@"user",
                                      nil];
            [self request:@"/users/SaveScores/multiple" SecondParameter:tempDict];
            CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"Score.ccbi"];
            [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
        }
    }
    else if(message->messageType == kMessageTypeUseCloud){
        p1Clouded = YES;
        p1CloudedTime = currSeconds;
    }


}

//Methods added for testing

- (void) resetSelectArray
{
    for (int i = 0; i < 10; i++) {
        select[i].tag = 0;
    }
}

- (CCLabelTTF*) getWord1
{
    return word1;
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

- (CCLabelTTF*) getShopItemCounter0
{
    return shopItemCounter[0];
}

- (CCLabelTTF*) getShopItemCounter1
{
    return shopItemCounter[1];
}


- (CCLabelTTF*) getClock
{
    return clock;
}
- (CCMenuItemImage*) getStartButton{
    return startButton;
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


- (int) getMaxChar
{
    return maxChar_m;
}

- (NSString*) testing
{
    return @"hello";
}

-(NSData *) getNSData{
    return data;
}

-(NSString*) get_l
{
    return l_M;
}

-(int) getPenalty{
    return my_penalty;
}

-(void) setPenalty:(int)p{
    my_penalty = p;
}

/*
//Temporary tests methods
-(void) temporaryTests
{
    testsCount = 0;
    successTests = 0;
    failedTests = 0;
    //[self testPressButton];
    [self testMulti_GetWords];
    [self testMulti_RandomWords];
    [self testMulti_Button0];
    [self testMulti_Button1];
    [self testMulti_Button0To8];
    [self testMulti_Select9];
    [self testMulti_Button0BecomesDisabled];
    [self testMulti_Button0To8_BecomesTransparent];
    //[self testPressButton];
    NSLog(@"# of tests: %d", testsCount);
    NSLog(@"# of successful Tests: %d", successTests);
    
}

- (void) testMulti_GetWords
{
    testsCount ++;
    [self getWords];
    NSAssert([self getWord1]!=nil, @"Word1 should not be nil");
    successTests ++;
}


- (void) testMulti_RandomWords
{
    testsCount ++;
    [self getWords];
    NSAssert(word_1!=nil, @"Word1 should not be nil");
    NSAssert(word_2!=nil, @"Word2 should not be nil");
    NSAssert(word_3!=nil, @"Word3 should not be nil");
    successTests ++;
    
}

- (void) testMulti_Button0
{
    testsCount ++;
    //Initialize the buttons and select lists
    [self hideButtons];
    [self resetSelectArray];
    [[self getButton0] setNormalImage:[CCSprite spriteWithFile:@"A.png"]];
    [[self getButton0] setSelectedImage:[CCSprite spriteWithFile:@"A.png"]];
    [self getButton0].tag = 65;
    [self getButton0].isEnabled=YES;
    [self pressButton0:self];
    NSAssert([self getButton0].tag == [self getSelect0].tag, @"button 0 and select 0 should have same tag values");
    successTests ++;
    
}

- (void) testMulti_Button1
{
    testsCount ++;
    //Initialize the buttons and select lists
    [self hideButtons];
    [self resetSelectArray];
    [[self getButton1] setNormalImage:[CCSprite spriteWithFile:@"B.png"]];
    [[self getButton1] setSelectedImage:[CCSprite spriteWithFile:@"B.png"]];
    [self getButton1].tag = 66;
    [self getButton1].isEnabled=YES;
    
    //Assume select[0] is occupied
    [self getSelect0].tag = 1;
    [self pressButton1:self];
    NSAssert([self getButton1].tag == [self getSelect1].tag, @"button 0 and select 0 should have same tag values");
    successTests ++;
    
}

- (void) testMulti_Button0To8
{
    testsCount ++;
    //Initialize the buttons and select lists
    [self hideButtons];
    [self resetSelectArray];
    [[self getButton0] setNormalImage:[CCSprite spriteWithFile:@"A.png"]];
    [[self getButton0] setSelectedImage:[CCSprite spriteWithFile:@"A.png"]];
    [self getButton0].tag = 65;
    [self getButton0].isEnabled=YES;
    
    [[self getButton1] setNormalImage:[CCSprite spriteWithFile:@"B.png"]];
    [[self getButton1] setSelectedImage:[CCSprite spriteWithFile:@"B.png"]];
    [self getButton1].tag = 66;
    [self getButton1].isEnabled=YES;
    
    [[self getButton2] setNormalImage:[CCSprite spriteWithFile:@"C.png"]];
    [[self getButton2] setSelectedImage:[CCSprite spriteWithFile:@"C.png"]];
    [self getButton2].tag = 67;
    [self getButton2].isEnabled=YES;
    
    [[self getButton3] setNormalImage:[CCSprite spriteWithFile:@"D.png"]];
    [[self getButton3] setSelectedImage:[CCSprite spriteWithFile:@"D.png"]];
    [self getButton3].tag = 68;
    [self getButton3].isEnabled=YES;
    
    [[self getButton4] setNormalImage:[CCSprite spriteWithFile:@"E.png"]];
    [[self getButton4] setSelectedImage:[CCSprite spriteWithFile:@"E.png"]];
    [self getButton4].tag = 69;
    [self getButton4].isEnabled=YES;
    
    [[self getButton5] setNormalImage:[CCSprite spriteWithFile:@"F.png"]];
    [[self getButton5] setSelectedImage:[CCSprite spriteWithFile:@"F.png"]];
    [self getButton5].tag = 70;
    [self getButton5].isEnabled=YES;
    
    [[self getButton6] setNormalImage:[CCSprite spriteWithFile:@"G.png"]];
    [[self getButton6] setSelectedImage:[CCSprite spriteWithFile:@"G.png"]];
    [self getButton6].tag = 71;
    [self getButton6].isEnabled=YES;
    
    [[self getButton7] setNormalImage:[CCSprite spriteWithFile:@"H.png"]];
    [[self getButton7] setSelectedImage:[CCSprite spriteWithFile:@"H.png"]];
    [self getButton7].tag = 72;
    [self getButton7].isEnabled=YES;
    
    [[self getButton8] setNormalImage:[CCSprite spriteWithFile:@"I.png"]];
    [[self getButton8] setSelectedImage:[CCSprite spriteWithFile:@"I.png"]];
    [self getButton8].tag = 73;
    [self getButton8].isEnabled=YES;
    
    [self pressButton0:self];
    [self pressButton1:self];
    [self pressButton2:self];
    [self pressButton3:self];
    [self pressButton4:self];
    [self pressButton5:self];
    [self pressButton6:self];
    [self pressButton7:self];
    [self pressButton8:self];
    
    NSAssert([self getButton0].tag == [self getSelect0].tag, @"button 0 and select 0 should have same tag values");
    NSAssert([self getButton1].tag == [self getSelect1].tag, @"button 1 and select 1 should have same tag values");
    NSAssert([self getButton2].tag == [self getSelect2].tag, @"button 2 and select 2 should have same tag values");
    NSAssert([self getButton3].tag == [self getSelect3].tag, @"button 3 and select 3 should have same tag values");
    NSAssert([self getButton4].tag == [self getSelect4].tag, @"button 4 and select 4 should have same tag values");
    NSAssert([self getButton5].tag == [self getSelect5].tag, @"button 5 and select 5 should have same tag values");
    NSAssert([self getButton6].tag == [self getSelect6].tag, @"button 6 and select 6 should have same tag values");
    NSAssert([self getButton7].tag == [self getSelect7].tag, @"button 7 and select 7 should have same tag values");
    NSAssert([self getButton8].tag == [self getSelect8].tag, @"button 8 and select 8 should have same tag values");
    successTests ++;
    
}

- (void) testMulti_Select9
{
    testsCount ++;
    //Initialize the buttons and select lists
    [self hideButtons];
    [self resetSelectArray];
    [[self getButton1] setNormalImage:[CCSprite spriteWithFile:@"B.png"]];
    [[self getButton1] setSelectedImage:[CCSprite spriteWithFile:@"B.png"]];
    [self getButton1].tag = 66;
    [self getButton1].isEnabled=YES;
    
    //Assume select[0] to select[8] is occupied
    [self getSelect0].tag = 1;
    [self getSelect1].tag = 1;
    [self getSelect2].tag = 1;
    [self getSelect3].tag = 1;
    [self getSelect4].tag = 1;
    [self getSelect5].tag = 1;
    [self getSelect6].tag = 1;
    [self getSelect7].tag = 1;
    [self getSelect8].tag = 1;
    
    [self pressButton1:self];
    NSAssert([self getSelect9].tag != [self getSelect2].tag, @"select[9] and select[2] should have diff tags");
    NSAssert([self getButton1].tag == [self getSelect9].tag, @"button 1 and select 9 should have same tag values");
    successTests ++;
    
}

- (void) testMulti_Button0BecomesDisabled
{
    testsCount ++;
    //Initialize the buttons and select lists
    [self hideButtons];
    [self resetSelectArray];
    [[self getButton0] setNormalImage:[CCSprite spriteWithFile:@"A.png"]];
    [[self getButton0] setSelectedImage:[CCSprite spriteWithFile:@"A.png"]];
    [self getButton0].tag = 65;
    [self getButton0].isEnabled=YES;
    
    [self pressButton0:self];
    NSAssert([self getButton0].isEnabled == NO, @"After pressing button, button should be disabled");
    successTests ++;
}

- (void) testMulti_Button0To8_BecomesTransparent
{
    testsCount ++;
    //Initialize the buttons and select lists
    [self hideButtons];
    [self resetSelectArray];
    [[self getButton0] setNormalImage:[CCSprite spriteWithFile:@"A.png"]];
    [[self getButton0] setSelectedImage:[CCSprite spriteWithFile:@"A.png"]];
    [self getButton0].tag = 65;
    [self getButton0].isEnabled=YES;
    
    [[self getButton1] setNormalImage:[CCSprite spriteWithFile:@"B.png"]];
    [[self getButton1] setSelectedImage:[CCSprite spriteWithFile:@"B.png"]];
    [self getButton1].tag = 66;
    [self getButton1].isEnabled=YES;
    
    [[self getButton2] setNormalImage:[CCSprite spriteWithFile:@"C.png"]];
    [[self getButton2] setSelectedImage:[CCSprite spriteWithFile:@"C.png"]];
    [self getButton2].tag = 67;
    [self getButton2].isEnabled=YES;
    
    [[self getButton3] setNormalImage:[CCSprite spriteWithFile:@"D.png"]];
    [[self getButton3] setSelectedImage:[CCSprite spriteWithFile:@"D.png"]];
    [self getButton3].tag = 68;
    [self getButton3].isEnabled=YES;
    
    [[self getButton4] setNormalImage:[CCSprite spriteWithFile:@"E.png"]];
    [[self getButton4] setSelectedImage:[CCSprite spriteWithFile:@"E.png"]];
    [self getButton4].tag = 69;
    [self getButton4].isEnabled=YES;
    
    [[self getButton5] setNormalImage:[CCSprite spriteWithFile:@"F.png"]];
    [[self getButton5] setSelectedImage:[CCSprite spriteWithFile:@"F.png"]];
    [self getButton5].tag = 70;
    [self getButton5].isEnabled=YES;
    
    [[self getButton6] setNormalImage:[CCSprite spriteWithFile:@"G.png"]];
    [[self getButton6] setSelectedImage:[CCSprite spriteWithFile:@"G.png"]];
    [self getButton6].tag = 71;
    [self getButton6].isEnabled=YES;
    
    [[self getButton7] setNormalImage:[CCSprite spriteWithFile:@"H.png"]];
    [[self getButton7] setSelectedImage:[CCSprite spriteWithFile:@"H.png"]];
    [self getButton7].tag = 72;
    [self getButton7].isEnabled=YES;
    
    [[self getButton8] setNormalImage:[CCSprite spriteWithFile:@"I.png"]];
    [[self getButton8] setSelectedImage:[CCSprite spriteWithFile:@"I.png"]];
    [self getButton8].tag = 73;
    [self getButton8].isEnabled=YES;
    
    [self pressButton0:self];
    [self pressButton1:self];
    [self pressButton2:self];
    [self pressButton3:self];
    [self pressButton4:self];
    [self pressButton5:self];
    [self pressButton6:self];
    [self pressButton7:self];
    [self pressButton8:self];
    
    NSAssert([self getButton0].isEnabled == NO, @"After pressing button0, button0 should be disabled");
    NSAssert([self getButton1].isEnabled == NO, @"After pressing button1, button1 should be disabled");
    NSAssert([self getButton2].isEnabled == NO, @"After pressing button2, button2 should be disabled");
    NSAssert([self getButton3].isEnabled == NO, @"After pressing button3, button3 should be disabled");
    NSAssert([self getButton4].isEnabled == NO, @"After pressing button4, button4 should be disabled");
    NSAssert([self getButton5].isEnabled == NO, @"After pressing button5, button5 should be disabled");
    NSAssert([self getButton6].isEnabled == NO, @"After pressing button6, button6 should be disabled");
    NSAssert([self getButton7].isEnabled == NO, @"After pressing button7, button7 should be disabled");
    NSAssert([self getButton8].isEnabled == NO, @"After pressing button8, button8 should be disabled");
    successTests ++;
}

-(void) testPressButton{
    testsCount++;
    [self sendPressButton:5];
    NSAssert(pressButtonTest == 5, @"After sending 5, pressButtonTest should be 5");
    successTests++;
}
*/

- (NSArray*) request:(NSString*) path SecondParameter:(NSDictionary*) parameter{
    NSDictionary *jsonDict;
    if ([path isEqualToString:@"users/SaveScores/multiple"]){
    jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    [parameter objectForKey:@"score"], @"score",
                    [parameter objectForKey:@"user"],@"user",
                    nil];
    }
    else{
        jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    nil];
    }
    
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
