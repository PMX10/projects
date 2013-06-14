//
//  GHUnitCocos2dBase.m
//  SmashingWord_me
//
//  Created by Denny Winoto on 4/18/13.
//
//

#import "GHUnitCocos2dBase.h"



@implementation GHUnitCocos2dBase

- (BOOL) shouldRunOnMainThread
{
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
    return YES;
}

- (void) setUpClass
{
    
	CC_DIRECTOR_INIT();
    
    spc = [[SinglePlayerScene alloc] init];
    //mpc = [[MultiPlayerScene alloc] init];

}

- (void) tearDownClass
{
	CC_DIRECTOR_END();
	// You have to do this or the test window will not get the focus back
	[window_ release];
}

- (void)testStrings {
    NSString *string1 = @"a string";
    GHTestLog(@"I can log to the GHUnit test console: %@", string1);
    
    // Assert string1 is not NULL, with no custom error description
    GHAssertNotNil(string1, nil);
    
    // Assert equal objects, add custom error description
    NSString *string2 = @"a string";
    GHAssertEqualObjects(string1, string2, @"A custom error message. string1 should be equal to: %@.", string2);
}


- (void) testSample
{
    NSString *line = [spc readDictionaryFile:1 fileName:@"test.txt"];
    GHAssertTrue([line isEqualToString: @"hello"], @"Not equal to hello");
}

- (void) testSingle_GetWords
{
    [spc getWords];
    GHAssertNotNil([spc getWord1], @"Word1 should not be nil");
}

- (void) testSingle_RandomWords
{
    [spc getWords];
    GHAssertNotNil(word_1, @"Word1 should not be nil");
    GHAssertNotNil(word_2, @"Word2 should not be nil");
    GHAssertNotNil(word_3, @"Word3 should not be nil");
    
}

- (void) testSingle_Button0
{
    //Initialize the buttons and select lists
    [spc hideButtons];
    [spc resetSelectArray];
    [[spc getButton0] setNormalImage:[CCSprite spriteWithFile:@"A.png"]];
    [[spc getButton0] setSelectedImage:[CCSprite spriteWithFile:@"A.png"]];
    [spc getButton0].tag = 65;
    [spc getButton0].isEnabled=YES;
    [spc pressButton0:self];
    GHAssertEquals([spc getButton0].tag, [spc getSelect0].tag, @"button 0 and select 0 should have same tag values");
    
}

- (void) testSingle_Button1
{
    //Initialize the buttons and select lists
    [spc hideButtons];
    [spc resetSelectArray];
    [[spc getButton1] setNormalImage:[CCSprite spriteWithFile:@"B.png"]];
    [[spc getButton1] setSelectedImage:[CCSprite spriteWithFile:@"B.png"]];
    [spc getButton1].tag = 66;
    [spc getButton1].isEnabled=YES;
    
    //Assume select[0] is occupied
    [spc getSelect0].tag = 1;
    [spc pressButton1:self];
    GHAssertEquals([spc getButton1].tag, [spc getSelect1].tag, @"button 0 and select 0 should have same tag values");
    
}

- (void) testSingle_Button0To8
{
    //Initialize the buttons and select lists
    [spc hideButtons];
    [spc resetSelectArray];
    [[spc getButton0] setNormalImage:[CCSprite spriteWithFile:@"A.png"]];
    [[spc getButton0] setSelectedImage:[CCSprite spriteWithFile:@"A.png"]];
    [spc getButton0].tag = 65;
    [spc getButton0].isEnabled=YES;

    [[spc getButton1] setNormalImage:[CCSprite spriteWithFile:@"B.png"]];
    [[spc getButton1] setSelectedImage:[CCSprite spriteWithFile:@"B.png"]];
    [spc getButton1].tag = 66;
    [spc getButton1].isEnabled=YES;

    [[spc getButton2] setNormalImage:[CCSprite spriteWithFile:@"C.png"]];
    [[spc getButton2] setSelectedImage:[CCSprite spriteWithFile:@"C.png"]];
    [spc getButton2].tag = 67;
    [spc getButton2].isEnabled=YES;
    
    [[spc getButton3] setNormalImage:[CCSprite spriteWithFile:@"D.png"]];
    [[spc getButton3] setSelectedImage:[CCSprite spriteWithFile:@"D.png"]];
    [spc getButton3].tag = 68;
    [spc getButton3].isEnabled=YES;
    
    [[spc getButton4] setNormalImage:[CCSprite spriteWithFile:@"E.png"]];
    [[spc getButton4] setSelectedImage:[CCSprite spriteWithFile:@"E.png"]];
    [spc getButton4].tag = 69;
    [spc getButton4].isEnabled=YES;
    
    [[spc getButton5] setNormalImage:[CCSprite spriteWithFile:@"F.png"]];
    [[spc getButton5] setSelectedImage:[CCSprite spriteWithFile:@"F.png"]];
    [spc getButton5].tag = 70;
    [spc getButton5].isEnabled=YES;
    
    [[spc getButton6] setNormalImage:[CCSprite spriteWithFile:@"G.png"]];
    [[spc getButton6] setSelectedImage:[CCSprite spriteWithFile:@"G.png"]];
    [spc getButton6].tag = 71;
    [spc getButton6].isEnabled=YES;
    
    [[spc getButton7] setNormalImage:[CCSprite spriteWithFile:@"H.png"]];
    [[spc getButton7] setSelectedImage:[CCSprite spriteWithFile:@"H.png"]];
    [spc getButton7].tag = 72;
    [spc getButton7].isEnabled=YES;
    
    [[spc getButton8] setNormalImage:[CCSprite spriteWithFile:@"I.png"]];
    [[spc getButton8] setSelectedImage:[CCSprite spriteWithFile:@"I.png"]];
    [spc getButton8].tag = 73;
    [spc getButton8].isEnabled=YES;
    
    [spc pressButton0:self];
    [spc pressButton1:self];
    [spc pressButton2:self];
    [spc pressButton3:self];
    [spc pressButton4:self];
    [spc pressButton5:self];
    [spc pressButton6:self];
    [spc pressButton7:self];
    [spc pressButton8:self];
    
    GHAssertEquals([spc getButton0].tag, [spc getSelect0].tag, @"button 0 and select 0 should have same tag values");
    GHAssertEquals([spc getButton1].tag, [spc getSelect1].tag, @"button 1 and select 1 should have same tag values");
    GHAssertEquals([spc getButton2].tag, [spc getSelect2].tag, @"button 2 and select 2 should have same tag values");
    GHAssertEquals([spc getButton3].tag, [spc getSelect3].tag, @"button 3 and select 3 should have same tag values");
    GHAssertEquals([spc getButton4].tag, [spc getSelect4].tag, @"button 4 and select 4 should have same tag values");
    GHAssertEquals([spc getButton5].tag, [spc getSelect5].tag, @"button 5 and select 5 should have same tag values");
    GHAssertEquals([spc getButton6].tag, [spc getSelect6].tag, @"button 6 and select 6 should have same tag values");
    GHAssertEquals([spc getButton7].tag, [spc getSelect7].tag, @"button 7 and select 7 should have same tag values");
    GHAssertEquals([spc getButton8].tag, [spc getSelect8].tag, @"button 8 and select 8 should have same tag values");
    
}

- (void) testSingle_Select9
{
    //Initialize the buttons and select lists
    [spc hideButtons];
    [spc resetSelectArray];
    [[spc getButton1] setNormalImage:[CCSprite spriteWithFile:@"B.png"]];
    [[spc getButton1] setSelectedImage:[CCSprite spriteWithFile:@"B.png"]];
    [spc getButton1].tag = 66;
    [spc getButton1].isEnabled=YES;
    
    //Assume select[0] to select[8] is occupied
    [spc getSelect0].tag = 1;
    [spc getSelect1].tag = 1;
    [spc getSelect2].tag = 1;
    [spc getSelect3].tag = 1;
    [spc getSelect4].tag = 1;
    [spc getSelect5].tag = 1;
    [spc getSelect6].tag = 1;
    [spc getSelect7].tag = 1;
    [spc getSelect8].tag = 1;
    
    [spc pressButton1:self];
    GHAssertNotEquals([spc getSelect9].tag, [spc getSelect2].tag, @"select[9] and select[2] should have diff tags");
    GHAssertEquals([spc getButton1].tag, [spc getSelect9].tag, @"button 1 and select 9 should have same tag values");
    
}

- (void) testSingle_Button0BecomesDisabled
{
    //Initialize the buttons and select lists
    [spc hideButtons];
    [spc resetSelectArray];
    [[spc getButton0] setNormalImage:[CCSprite spriteWithFile:@"A.png"]];
    [[spc getButton0] setSelectedImage:[CCSprite spriteWithFile:@"A.png"]];
    [spc getButton0].tag = 65;
    [spc getButton0].isEnabled=YES;
    
    [spc pressButton0:self];
    GHAssertEquals([spc getButton0].isEnabled, NO, @"After pressing button, button should be disabled");
}

- (void) testSingle_Button0To8_BecomesTransparent
{
    //Initialize the buttons and select lists
    [spc hideButtons];
    [spc resetSelectArray];
    [[spc getButton0] setNormalImage:[CCSprite spriteWithFile:@"A.png"]];
    [[spc getButton0] setSelectedImage:[CCSprite spriteWithFile:@"A.png"]];
    [spc getButton0].tag = 65;
    [spc getButton0].isEnabled=YES;
    
    [[spc getButton1] setNormalImage:[CCSprite spriteWithFile:@"B.png"]];
    [[spc getButton1] setSelectedImage:[CCSprite spriteWithFile:@"B.png"]];
    [spc getButton1].tag = 66;
    [spc getButton1].isEnabled=YES;
    
    [[spc getButton2] setNormalImage:[CCSprite spriteWithFile:@"C.png"]];
    [[spc getButton2] setSelectedImage:[CCSprite spriteWithFile:@"C.png"]];
    [spc getButton2].tag = 67;
    [spc getButton2].isEnabled=YES;
    
    [[spc getButton3] setNormalImage:[CCSprite spriteWithFile:@"D.png"]];
    [[spc getButton3] setSelectedImage:[CCSprite spriteWithFile:@"D.png"]];
    [spc getButton3].tag = 68;
    [spc getButton3].isEnabled=YES;
    
    [[spc getButton4] setNormalImage:[CCSprite spriteWithFile:@"E.png"]];
    [[spc getButton4] setSelectedImage:[CCSprite spriteWithFile:@"E.png"]];
    [spc getButton4].tag = 69;
    [spc getButton4].isEnabled=YES;
    
    [[spc getButton5] setNormalImage:[CCSprite spriteWithFile:@"F.png"]];
    [[spc getButton5] setSelectedImage:[CCSprite spriteWithFile:@"F.png"]];
    [spc getButton5].tag = 70;
    [spc getButton5].isEnabled=YES;
    
    [[spc getButton6] setNormalImage:[CCSprite spriteWithFile:@"G.png"]];
    [[spc getButton6] setSelectedImage:[CCSprite spriteWithFile:@"G.png"]];
    [spc getButton6].tag = 71;
    [spc getButton6].isEnabled=YES;
    
    [[spc getButton7] setNormalImage:[CCSprite spriteWithFile:@"H.png"]];
    [[spc getButton7] setSelectedImage:[CCSprite spriteWithFile:@"H.png"]];
    [spc getButton7].tag = 72;
    [spc getButton7].isEnabled=YES;
    
    [[spc getButton8] setNormalImage:[CCSprite spriteWithFile:@"I.png"]];
    [[spc getButton8] setSelectedImage:[CCSprite spriteWithFile:@"I.png"]];
    [spc getButton8].tag = 73;
    [spc getButton8].isEnabled=YES;
    
    [spc pressButton0:self];
    [spc pressButton1:self];
    [spc pressButton2:self];
    [spc pressButton3:self];
    [spc pressButton4:self];
    [spc pressButton5:self];
    [spc pressButton6:self];
    [spc pressButton7:self];
    [spc pressButton8:self];
    
    GHAssertEquals([spc getButton0].isEnabled, NO, @"After pressing button0, button0 should be disabled");
    GHAssertEquals([spc getButton1].isEnabled, NO, @"After pressing button1, button1 should be disabled");
    GHAssertEquals([spc getButton2].isEnabled, NO, @"After pressing button2, button2 should be disabled");
    GHAssertEquals([spc getButton3].isEnabled, NO, @"After pressing button3, button3 should be disabled");
    GHAssertEquals([spc getButton4].isEnabled, NO, @"After pressing button4, button4 should be disabled");
    GHAssertEquals([spc getButton5].isEnabled, NO, @"After pressing button5, button5 should be disabled");
    GHAssertEquals([spc getButton6].isEnabled, NO, @"After pressing button6, button6 should be disabled");
    GHAssertEquals([spc getButton7].isEnabled, NO, @"After pressing button7, button7 should be disabled");
    GHAssertEquals([spc getButton8].isEnabled, NO, @"After pressing button8, button8 should be disabled");
}

- (void) testSingle_unSelect
{
    penalty_score = 0;
    [spc getSelect0].tag = 1;
    [spc getSelect1].tag = 1;
    [spc getSelect2].tag = 1;
    [spc getSelect3].tag = 1;
    [spc getSelect4].tag = 1;
    [spc getSelect5].tag = 1;
    [spc getSelect6].tag = 1;
    [spc getSelect7].tag = 1;
    [spc getSelect8].tag = 1;
    [spc getSelect9].tag = 1;
    [spc getSelect10].tag = 1;
    [spc getSelect11].tag = 1;
    [spc getSelect12].tag = 1;
    [spc getSelect13].tag = 1;
    [spc getSelect14].tag = 1;
    
    [spc unSelect0:self];
    GHAssertEquals(penalty_score, 1, @"After unselecting button0, penalty_score should be 1.");
    [spc unSelect1:self];
    GHAssertEquals(penalty_score, 2, @"After unselecting button1, penalty_score should be 2.");
    [spc unSelect2:self];
    GHAssertEquals(penalty_score, 3, @"After unselecting button2, penalty_score should be 3.");
    [spc unSelect3:self];
    GHAssertEquals(penalty_score, 4, @"After unselecting button3, penalty_score should be 4.");
    [spc unSelect4:self];
    GHAssertEquals(penalty_score, 5, @"After unselecting button4, penalty_score should be 5.");
    [spc unSelect5:self];
    GHAssertEquals(penalty_score, 6, @"After unselecting button5, penalty_score should be 6.");
    [spc unSelect6:self];
    GHAssertEquals(penalty_score, 7, @"After unselecting button6, penalty_score should be 7.");
    [spc unSelect7:self];
    GHAssertEquals(penalty_score, 8, @"After unselecting button7, penalty_score should be 8.");
    [spc unSelect8:self];
    GHAssertEquals(penalty_score, 9, @"After unselecting button8, penalty_score should be 9.");
    [spc unSelect9:self];
    GHAssertEquals(penalty_score, 10, @"After unselecting button9, penalty_score should be 10.");
    [spc unSelect10:self];
    GHAssertEquals(penalty_score, 11, @"After unselecting button10, penalty_score should be 11.");
    [spc unSelect11:self];
    GHAssertEquals(penalty_score, 12, @"After unselecting button11, penalty_score should be 12.");
    [spc unSelect12:self];
    GHAssertEquals(penalty_score, 13, @"After unselecting button12, penalty_score should be 13.");
    [spc unSelect13:self];
    GHAssertEquals(penalty_score, 14, @"After unselecting button13, penalty_score should be 14.");
    [spc unSelect14:self];
    GHAssertEquals(penalty_score, 15, @"After unselecting button13, penalty_score should be 15.");
    penalty_score = 0;
}


/* The following tests are to send all different kinds of request to backend and check the response*/

- (void) testSingle_FetchBackendSampleData{
    NSDictionary * temp =[NSDictionary dictionaryWithObjectsAndKeys: nil];
    /* Request backend to generate sample data. */
    [spc request:@"diulama/inittestdb" SecondParameter:temp];
    NSArray* result = [spc request:@"users/Top10Scores/single" SecondParameter:temp];
    int Expected[10] = {100,64,42,41,23,10,8,0,0,0};
    int length = [result count];
    BOOL PASS = YES;
    NSLog(@"before is %c",PASS);
    if (length!=10){
        PASS=NO;
    }
    else{
        for (int i=0; i<length; i++){
            if ([[result objectAtIndex:i] intValue]!=Expected[i]){
                PASS=NO;
            }
        }
    }
    GHAssertEquals(PASS, YES, @"Fetch Data fail. Inconsistent with expected Result");
    
}


- (void) testSingle_saveScoreAndThenFetch{
    NSDictionary * temp =[NSDictionary dictionaryWithObjectsAndKeys: nil];
    /* Request backend to generate sample data. */
    [spc request:@"diulama/emptydb" SecondParameter:temp];
    NSNumber * tempNum = [NSNumber numberWithInt:10];
    NSDictionary* temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", nil];
    [spc request:@"users/SaveScores/single" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:11];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", nil];
    [spc request:@"users/SaveScores/single" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:9];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", nil];
    [spc request:@"users/SaveScores/single" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:8];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", nil];
    [spc request:@"users/SaveScores/single" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:7];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", nil];
    [spc request:@"users/SaveScores/single" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:6];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", nil];
    [spc request:@"users/SaveScores/single" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:5];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", nil];
    [spc request:@"users/SaveScores/single" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:4];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", nil];
    [spc request:@"users/SaveScores/single" SecondParameter:temp2];
    
    
    tempNum = [NSNumber numberWithInt:3];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", nil];
    [spc request:@"users/SaveScores/single" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:2];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", nil];
    [spc request:@"users/SaveScores/single" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:1];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", nil];
    [spc request:@"users/SaveScores/single" SecondParameter:temp2];
    
    NSArray* result = [spc request:@"users/Top10Scores/single" SecondParameter:temp];
    int Expected[10] = {11,10,9,8,7,6,5,4,3,2};
    int length = [result count];
    BOOL PASS = YES;
    NSLog(@"before is %c",PASS);
    if (length!=10){
        PASS=NO;
        NSLog(@"here");
    }
    else{
        for (int i=0; i<length; i++){
            NSLog(@"actual %i", [[result objectAtIndex:i] intValue]);
            NSLog(@"expect %i", Expected[i]);
            if ([[result objectAtIndex:i] intValue]!=Expected[i]){
                PASS=NO;
                NSLog(@"there");
            }
        }
    }
    GHAssertEquals(PASS, YES, @"Fetch Data fail. Inconsistent with expected Result");
    
}







-(void) testSingle_penaltyScoreBomb
{
    penalty_score = 0;
    
    [spc getButton0].tag = 91;
    [spc getSelect0].tag=0;
    [spc pressButton0:self];
    NSLog(@"%i", penalty_score);
    GHAssertEquals(penalty_score, 10, @"After pressing penalty_score bomb, penalty_score should be 10");
    [spc getButton1].tag = 91;
    [spc pressButton1:self];
    GHAssertEquals(penalty_score, 20, @"After pressing penalty_score bomb 2 times, penalty_score should be 20");
    [spc getButton2].tag = 91;
    [spc pressButton2:self];
    GHAssertEquals(penalty_score, 30, @"After pressing penalty_score bomb 3 times, penalty_score should be 30");
    [spc getButton3].tag = 91;
    [spc pressButton3:self];
    GHAssertEquals(penalty_score, 40, @"After pressing penalty_score bomb 4 times, penalty_score should be 40");
    [spc getButton4].tag = 91;
    [spc pressButton4:self];
    GHAssertEquals(penalty_score, 50, @"After pressing penalty_score bomb 5 times, penalty_score should be 50");
    [spc getButton5].tag = 91;
    [spc pressButton5:self];
    GHAssertEquals(penalty_score, 60, @"After pressing penalty_score bomb 6 times, penalty_score should be 60");
    [spc getButton6].tag = 91;
    [spc pressButton6:self];
    GHAssertEquals(penalty_score, 70, @"After pressing penalty_score bomb 7 times, penalty_score should be 70");
    [spc getButton7].tag = 91;
    [spc pressButton7:self];
    GHAssertEquals(penalty_score, 80, @"After pressing penalty_score bomb 8 times, penalty_score should be 80");
    [spc getButton8].tag = 91;
    [spc pressButton8:self];
    GHAssertEquals(penalty_score, 90, @"After pressing penalty_score bomb 9 times, penalty_score should be 90");
    penalty_score = 0;
}

-(void) testSingle_endGameBomb
{
    [spc getButton0].tag = 93;
    [spc getSelect0].tag=0;
    [spc pressButton0:self];
    GHAssertEquals([spc getCurrentMinute], 0, @"After pressing end-game bomb, current minute become 0");
    GHAssertEquals([spc getCurrentSecond], 1, @"After pressing end-game bomb, current second become 1");
    [spc getButton1].tag = 93;
    [spc pressButton1:self];
    GHAssertEquals([spc getCurrentMinute], 0, @"After pressing end-game bomb, current minute become 0");
    GHAssertEquals([spc getCurrentSecond], 1, @"After pressing end-game bomb, current second become 1");
    [spc getButton2].tag = 93;
    [spc pressButton2:self];
    GHAssertEquals([spc getCurrentMinute], 0, @"After pressing end-game bomb, current minute become 0");
    GHAssertEquals([spc getCurrentSecond], 1, @"After pressing end-game bomb, current second become 1");
    [spc getButton3].tag = 93;
    [spc pressButton3:self];
    GHAssertEquals([spc getCurrentMinute], 0, @"After pressing end-game bomb, current minute become 0");
    GHAssertEquals([spc getCurrentSecond], 1, @"After pressing end-game bomb, current second become 1");
    [spc getButton4].tag = 93;
    [spc pressButton4:self];
    GHAssertEquals([spc getCurrentMinute], 0, @"After pressing end-game bomb, current minute become 0");
    GHAssertEquals([spc getCurrentSecond], 1, @"After pressing end-game bomb, current second become 1");
    [spc getButton5].tag = 93;
    [spc pressButton5:self];
    GHAssertEquals([spc getCurrentMinute], 0, @"After pressing end-game bomb, current minute become 0");
    GHAssertEquals([spc getCurrentSecond], 1, @"After pressing end-game bomb, current second become 1");
    [spc getButton6].tag = 93;
    [spc pressButton6:self];
    GHAssertEquals([spc getCurrentMinute], 0, @"After pressing end-game bomb, current minute become 0");
    GHAssertEquals([spc getCurrentSecond], 1, @"After pressing end-game bomb, current second become 1");
    [spc getButton7].tag = 93;
    [spc pressButton7:self];
    GHAssertEquals([spc getCurrentMinute], 0, @"After pressing end-game bomb, current minute become 0");
    GHAssertEquals([spc getCurrentSecond], 1, @"After pressing end-game bomb, current second become 1");
    [spc getButton8].tag = 93;
    [spc pressButton8:self];
    GHAssertEquals([spc getCurrentMinute], 0, @"After pressing end-game bomb, current minute become 0");
    GHAssertEquals([spc getCurrentSecond], 1, @"After pressing end-game bomb, current second become 1");
}

- (void) testSingle_FreezeTimePress
{
    freezeTimeCounter = 3;
    [spc setCurrentMinute:0];
    [spc setCurrentSecond:42];
    
    [spc freezeTimePress:self];
    GHAssertEquals([spc getShopItem0].isEnabled, NO, @"shopItem[0] should be NO");
    GHAssertEquals([spc getShopItem1].isEnabled, NO, @"shopItem[1] should be NO");
    GHAssertEquals([spc getShopItem2].isEnabled, NO, @"shopItem[2] should be NO");
    GHAssertEquals(freezeTimeCounter, 2, @"freezeTimeCounter should decrease by 1 and becomes 2");
    GHAssertEquals([spc getIsFreeze], YES, @"isFreeze should be set to TRUE after using the power up");
    GHAssertEquals([[[spc getShopItemCounter0] string] isEqualToString:@"x2"], YES, @"The value of shopItemCounter[0] decreases by 1 and becomes 2");
    GHAssertEquals([spc getFreezeMinute], [spc getCurrentMinute], @"freezeMinute should be the same as curentMinute");
    GHAssertEquals([spc getFreezeSecond]+5, [spc getCurrentSecond], @"freezeSecond should be 5 seconds less than the actual curentSecond");
    GHAssertEquals([[[spc getClock] string] isEqualToString:@"Time : 0:42"], YES , @"Timer should be frozen at the current time");
    
}

- (void) testSingle_FreezeTimePress_InsufficientCounter
{
    [[spc getShopItemCounter0] setString:@"x0"];
    freezeTimeCounter = 0;
    
    [spc freezeTimePress:self];
    GHAssertEquals(freezeTimeCounter, 0, @"Nothing happens since freezeTimerCounter is less than 1");
    GHAssertEquals([[[spc getShopItemCounter0] string] isEqualToString:@"x0"], YES, @"The value of shopItemCounter[0] still remains as 0");
}

/*
- (void) testSingle_SlowdownTimePress
{
    slowdownTimeCounter = 3;
    [spc setCurrentMinute:0];
    [spc setCurrentSecond:42];
    
    [spc slowdownTimePress:self];
    GHAssertEquals([spc getShopItem0].isEnabled, NO, @"shopItem[0] should be NO");
    GHAssertEquals([spc getShopItem1].isEnabled, NO, @"shopItem[1] should be NO");
    GHAssertEquals([spc getShopItem2].isEnabled, NO, @"shopItem[2] should be NO");
    GHAssertEquals(slowdownTimeCounter, 2, @"freezeTimeCounter should decrease by 1 and becomes 2");
    GHAssertEquals([spc getIsSlowDown], YES, @"isFreeze should be set to TRUE after using the power up");
    GHAssertEquals([[[spc getShopItemCounter1] string] isEqualToString:@"x2"], YES, @"The value of shopItemCounter[1] decreases by 1 and becomes 2");
}
*/

- (void) testSingle_ExtraTimePress
{
    extraTimeCounter = 4;
    [spc setCurrentMinute:0];
    [spc setCurrentSecond:42];
    
    [spc extraTimePress:self];
    GHAssertEquals(extraTimeCounter, 3, @"extraTimeCounter should decrease by 1 and becomes 3");
    GHAssertEquals([[[spc getShopItemCounter2] string] isEqualToString:@"x3"], YES, @"The value of shopItemCounter[2] decreases by 1 and becomes 3");
    GHAssertEquals([spc getCurrentMinute], 0, @"currentMinute should be 0 since seconds did not exceed 60 seconds");
    GHAssertEquals([spc getCurrentSecond], 47, @"5 seconds should be added to currentSecond");
}


- (void) testSingle_ExtraTimePress_Exceed_60_Seconds
{
    extraTimeCounter = 4;
    [spc setCurrentMinute:0];
    [spc setCurrentSecond:59];
    
    [spc extraTimePress:self];
    GHAssertEquals(extraTimeCounter, 3, @"extraTimeCounter should decrease by 1 and becomes 3");
    GHAssertEquals([[[spc getShopItemCounter2] string] isEqualToString:@"x3"], YES, @"The value of shopItemCounter[2] decreases by 1 and becomes 3");
    GHAssertEquals([spc getCurrentMinute], 1, @"currentMinute should be 1 since seconds exceeded 60 seconds");
    GHAssertEquals([spc getCurrentSecond], 4, @"5 seconds should be added to currentSecond");
}

- (void) testSingle_ExtraTimePress_InsufficientCounter
{
    [[spc getShopItemCounter2] setString:@"x0"];
    extraTimeCounter = 0;
    
    [spc extraTimePress:self];
    GHAssertEquals(extraTimeCounter, 0, @"Nothing happens since extraTimerCounter is less than 1");
    GHAssertEquals([[[spc getShopItemCounter2] string] isEqualToString:@"x0"], YES, @"The value of shopItemCounter[2] still remains as 0");
}

- (void) testSingle_IncreasePress
{
    increaseCounter = 2;
    [spc increasePress:self];
    GHAssertEquals([spc getShopItem3].isEnabled, NO, @"Increasing the length of character holder by 5. It can only be used once so it should be disabled to prevent player from using it multiple times");
    GHAssertEquals(increaseCounter, 1, @"After using the powerup, the increaseCounter should decrease by 1 and becomes 1");
    GHAssertEquals([[[spc getShopItemCounter3] string] isEqualToString:@"x1"], YES, @"The value of shopItemCounter[3] decreases and becomes 1");
    GHAssertEquals([spc getMaxChar], 15, @"The increased length should be 15 after using powerup");
}

-(void) testSingle_getLetter
{
    int result =1;
    [spc getLetter];
    if ([spc get_l] == nil)
        result = 0;
    GHAssertEquals(result, 1, @"Letter can not be generated!");
}

-(void) testSingle_parseWord
{
    BOOL result = NO;
    NSString* str = @"letters";
    NSMutableDictionary* dict;
    dict = [[NSMutableDictionary alloc] init];
    [spc parseWord:str dictionary: dict];
    
    if ([dict[@"l"]isEqual:@"1"] && [dict[@"e"]isEqual:@"2"] && [dict[@"t"]isEqual:@"2"] && [dict[@"r"]isEqual:@"1"] && [dict[@"s"]isEqual:@"1"])
        result = YES;
    GHAssertEquals(result, YES, @"Words can not be parsed!");
}

-(void) testSingle_generateButton
{
    BOOL correct = YES;
    [spc generateButton];
    if ([spc getButton0].isEnabled==NO && [spc getButton1].isEnabled==NO && [spc getButton2].isEnabled==NO &&
        [spc getButton3].isEnabled==NO && [spc getButton4].isEnabled==NO && [spc getButton5].isEnabled==NO &&
        [spc getButton6].isEnabled==NO && [spc getButton7].isEnabled==NO && [spc getButton8].isEnabled==NO)
        correct = NO;
    GHAssertEquals(correct, YES, @"Button generation error!");
}

@end