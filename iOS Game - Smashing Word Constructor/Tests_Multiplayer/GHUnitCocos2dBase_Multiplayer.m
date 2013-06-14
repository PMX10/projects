//
//  GHUnitCocos2dBase_Multiplayer.m
//  SmashingWord_me
//
//  Created by Denny Winoto on 5/1/13.
//
//

#import "GHUnitCocos2dBase_Multiplayer.h"


@implementation GHUnitCocos2dBase_Multiplayer

- (BOOL) shouldRunOnMainThread
{
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
    return YES;
}

- (void) setUpClass
{
    
	CC_DIRECTOR_INIT();
    
    //mpc = [[MultiPlayerScene alloc] init];
    mpc = [[MultiPlayerScene alloc] init];
    ss = [[ShopScene alloc] init];
    lss = [[LevelSelectScene alloc] init];
    
}

- (void) tearDownClass
{
	CC_DIRECTOR_END();
	// You have to do this or the test window will not get the focus back
	[window_ release];
}

/*******************************************************************************/

// simple test to ensure building, linking,
// and running test case works in the project
- (void)testOCMockPass {
    id mock = [OCMockObject mockForClass:NSString.class];
    [[[mock stub] andReturn:@"mocktest"] lowercaseString];
    
    NSString *returnValue = [mock lowercaseString];
    GHAssertEqualObjects(@"mocktest", returnValue,
                         @"Should have returned the expected string.");
}

- (void)testMockGameCenterSendRandomNumber
{
    id mockGCHelper = [OCMockObject mockForClass:[GCHelper class]];
    mpc.helper = mockGCHelper;
    
    NSData *data;
    
    /******** TEST sendRandomNumber ***********/
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = 5;
    data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [[[mockGCHelper stub] andReturn:data] broadcastData:[OCMArg any]];
    [mpc sendRandomNumber];
    MessageRandomNumber *result = (MessageRandomNumber *) [mpc.result bytes];
    GHAssertEquals(message.randomNumber, result->randomNumber, @"Random number sent must be 5!");


}

- (void)testMockGameCenterSendGameBegin
{
    id mockGCHelper = [OCMockObject mockForClass:[GCHelper class]];
    mpc.helper = mockGCHelper;
    
    NSData *data;
    
    /******** TEST sendGameBegin ***********/
    MessageGameBegin message;
    message.message.messageType = kMessageTypeGameBegin;
    data = [NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];
    
    [[[mockGCHelper stub] andReturn:data] broadcastData:[OCMArg any]];
    [mpc sendGameBegin];
    MessageGameBegin *result = (MessageGameBegin *) [mpc.result bytes];
    GHAssertEquals(message.message.messageType, result->message.messageType, @"sendGameBegin: messageType must be the same!");
}


/*******************************************************************************/

- (void) testMulti_Button1
{
    //Initialize the buttons and select lists
    [mpc hideButtons];
    [mpc resetSelectArray];
    [[mpc getButton1] setNormalImage:[CCSprite spriteWithFile:@"B.png"]];
    [[mpc getButton1] setSelectedImage:[CCSprite spriteWithFile:@"B.png"]];
    [mpc getButton1].tag = 66;
    [mpc getButton1].isEnabled=YES;
    
    //Assume select[0] is occupied
    [mpc getSelect0].tag = 1;
    [mpc pressButton1:self];
    GHAssertEquals([mpc getButton1].tag, [mpc getSelect1].tag, @"button 0 and select 0 should have same tag values");
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


 - (void) testMulti_GetWords
 {
 [mpc getWords];
 GHAssertNotNil([mpc getWord1], @"Word1 should not be nil");
 }
 
 
 - (void) testMulti_RandomWords
 {
 [mpc getWords];
 GHAssertNotNil(word_1, @"Word1 should not be nil");
 GHAssertNotNil(word_2, @"Word2 should not be nil");
 GHAssertNotNil(word_3, @"Word3 should not be nil");
 
 }
 
 - (void) testMulti_Button0
 {
 //Initialize the buttons and select lists
 [mpc hideButtons];
 [mpc resetSelectArray];
 [[mpc getButton0] setNormalImage:[CCSprite spriteWithFile:@"A.png"]];
 [[mpc getButton0] setSelectedImage:[CCSprite spriteWithFile:@"A.png"]];
 [mpc getButton0].tag = 65;
 [mpc getButton0].isEnabled=YES;
 [mpc pressButton0:self];
 GHAssertEquals([mpc getButton0].tag, [mpc getSelect0].tag, @"button 0 and select 0 should have same tag values");
 
 }
 
 - (void) testMulti_Button0To8
 {
 //Initialize the buttons and select lists
 [mpc hideButtons];
 [mpc resetSelectArray];
 [[mpc getButton0] setNormalImage:[CCSprite spriteWithFile:@"A.png"]];
 [[mpc getButton0] setSelectedImage:[CCSprite spriteWithFile:@"A.png"]];
 [mpc getButton0].tag = 65;
 [mpc getButton0].isEnabled=YES;
 
 [[mpc getButton1] setNormalImage:[CCSprite spriteWithFile:@"B.png"]];
 [[mpc getButton1] setSelectedImage:[CCSprite spriteWithFile:@"B.png"]];
 [mpc getButton1].tag = 66;
 [mpc getButton1].isEnabled=YES;
 
 [[mpc getButton2] setNormalImage:[CCSprite spriteWithFile:@"C.png"]];
 [[mpc getButton2] setSelectedImage:[CCSprite spriteWithFile:@"C.png"]];
 [mpc getButton2].tag = 67;
 [mpc getButton2].isEnabled=YES;
 
 [[mpc getButton3] setNormalImage:[CCSprite spriteWithFile:@"D.png"]];
 [[mpc getButton3] setSelectedImage:[CCSprite spriteWithFile:@"D.png"]];
 [mpc getButton3].tag = 68;
 [mpc getButton3].isEnabled=YES;
 
 [[mpc getButton4] setNormalImage:[CCSprite spriteWithFile:@"E.png"]];
 [[mpc getButton4] setSelectedImage:[CCSprite spriteWithFile:@"E.png"]];
 [mpc getButton4].tag = 69;
 [mpc getButton4].isEnabled=YES;
 
 [[mpc getButton5] setNormalImage:[CCSprite spriteWithFile:@"F.png"]];
 [[mpc getButton5] setSelectedImage:[CCSprite spriteWithFile:@"F.png"]];
 [mpc getButton5].tag = 70;
 [mpc getButton5].isEnabled=YES;
 
 [[mpc getButton6] setNormalImage:[CCSprite spriteWithFile:@"G.png"]];
 [[mpc getButton6] setSelectedImage:[CCSprite spriteWithFile:@"G.png"]];
 [mpc getButton6].tag = 71;
 [mpc getButton6].isEnabled=YES;
 
 [[mpc getButton7] setNormalImage:[CCSprite spriteWithFile:@"H.png"]];
 [[mpc getButton7] setSelectedImage:[CCSprite spriteWithFile:@"H.png"]];
 [mpc getButton7].tag = 72;
 [mpc getButton7].isEnabled=YES;
 
 [[mpc getButton8] setNormalImage:[CCSprite spriteWithFile:@"I.png"]];
 [[mpc getButton8] setSelectedImage:[CCSprite spriteWithFile:@"I.png"]];
 [mpc getButton8].tag = 73;
 [mpc getButton8].isEnabled=YES;
 
 [mpc pressButton0:self];
 [mpc pressButton1:self];
 [mpc pressButton2:self];
 [mpc pressButton3:self];
 [mpc pressButton4:self];
 [mpc pressButton5:self];
 [mpc pressButton6:self];
 [mpc pressButton7:self];
 [mpc pressButton8:self];
 
 GHAssertEquals([mpc getButton0].tag, [mpc getSelect0].tag, @"button 0 and select 0 should have same tag values");
 GHAssertEquals([mpc getButton1].tag, [mpc getSelect1].tag, @"button 1 and select 1 should have same tag values");
 GHAssertEquals([mpc getButton2].tag, [mpc getSelect2].tag, @"button 2 and select 2 should have same tag values");
 GHAssertEquals([mpc getButton3].tag, [mpc getSelect3].tag, @"button 3 and select 3 should have same tag values");
 GHAssertEquals([mpc getButton4].tag, [mpc getSelect4].tag, @"button 4 and select 4 should have same tag values");
 GHAssertEquals([mpc getButton5].tag, [mpc getSelect5].tag, @"button 5 and select 5 should have same tag values");
 GHAssertEquals([mpc getButton6].tag, [mpc getSelect6].tag, @"button 6 and select 6 should have same tag values");
 GHAssertEquals([mpc getButton7].tag, [mpc getSelect7].tag, @"button 7 and select 7 should have same tag values");
 GHAssertEquals([mpc getButton8].tag, [mpc getSelect8].tag, @"button 8 and select 8 should have same tag values");
 
 }
 
 - (void) testMulti_Select9
 {
 //Initialize the buttons and select lists
 [mpc hideButtons];
 [mpc resetSelectArray];
 [[mpc getButton1] setNormalImage:[CCSprite spriteWithFile:@"B.png"]];
 [[mpc getButton1] setSelectedImage:[CCSprite spriteWithFile:@"B.png"]];
 [mpc getButton1].tag = 66;
 [mpc getButton1].isEnabled=YES;
 
 //Assume select[0] to select[8] is occupied
 [mpc getSelect0].tag = 1;
 [mpc getSelect1].tag = 1;
 [mpc getSelect2].tag = 1;
 [mpc getSelect3].tag = 1;
 [mpc getSelect4].tag = 1;
 [mpc getSelect5].tag = 1;
 [mpc getSelect6].tag = 1;
 [mpc getSelect7].tag = 1;
 [mpc getSelect8].tag = 1;
 
 [mpc pressButton1:self];
 GHAssertNotEquals([mpc getSelect9].tag, [mpc getSelect2].tag, @"select[9] and select[2] should have diff tags");
 GHAssertEquals([mpc getButton1].tag, [mpc getSelect9].tag, @"button 1 and select 9 should have same tag values");
 
 }
 
 - (void) testMulti_Button0BecomesDisabled
 {
 //Initialize the buttons and select lists
 [mpc hideButtons];
 [mpc resetSelectArray];
 [[mpc getButton0] setNormalImage:[CCSprite spriteWithFile:@"A.png"]];
 [[mpc getButton0] setSelectedImage:[CCSprite spriteWithFile:@"A.png"]];
 [mpc getButton0].tag = 65;
 [mpc getButton0].isEnabled=YES;
 
 [mpc pressButton0:self];
 GHAssertEquals([mpc getButton0].isEnabled, NO, @"After pressing button, button should be disabled");
 }
 
 - (void) testMulti_Button0To8_BecomesTransparent
 {
 //Initialize the buttons and select lists
 [mpc hideButtons];
 [mpc resetSelectArray];
 [[mpc getButton0] setNormalImage:[CCSprite spriteWithFile:@"A.png"]];
 [[mpc getButton0] setSelectedImage:[CCSprite spriteWithFile:@"A.png"]];
 [mpc getButton0].tag = 65;
 [mpc getButton0].isEnabled=YES;
 
 [[mpc getButton1] setNormalImage:[CCSprite spriteWithFile:@"B.png"]];
 [[mpc getButton1] setSelectedImage:[CCSprite spriteWithFile:@"B.png"]];
 [mpc getButton1].tag = 66;
 [mpc getButton1].isEnabled=YES;
 
 [[mpc getButton2] setNormalImage:[CCSprite spriteWithFile:@"C.png"]];
 [[mpc getButton2] setSelectedImage:[CCSprite spriteWithFile:@"C.png"]];
 [mpc getButton2].tag = 67;
 [mpc getButton2].isEnabled=YES;
 
 [[mpc getButton3] setNormalImage:[CCSprite spriteWithFile:@"D.png"]];
 [[mpc getButton3] setSelectedImage:[CCSprite spriteWithFile:@"D.png"]];
 [mpc getButton3].tag = 68;
 [mpc getButton3].isEnabled=YES;
 
 [[mpc getButton4] setNormalImage:[CCSprite spriteWithFile:@"E.png"]];
 [[mpc getButton4] setSelectedImage:[CCSprite spriteWithFile:@"E.png"]];
 [mpc getButton4].tag = 69;
 [mpc getButton4].isEnabled=YES;
 
 [[mpc getButton5] setNormalImage:[CCSprite spriteWithFile:@"F.png"]];
 [[mpc getButton5] setSelectedImage:[CCSprite spriteWithFile:@"F.png"]];
 [mpc getButton5].tag = 70;
 [mpc getButton5].isEnabled=YES;
 
 [[mpc getButton6] setNormalImage:[CCSprite spriteWithFile:@"G.png"]];
 [[mpc getButton6] setSelectedImage:[CCSprite spriteWithFile:@"G.png"]];
 [mpc getButton6].tag = 71;
 [mpc getButton6].isEnabled=YES;
 
 [[mpc getButton7] setNormalImage:[CCSprite spriteWithFile:@"H.png"]];
 [[mpc getButton7] setSelectedImage:[CCSprite spriteWithFile:@"H.png"]];
 [mpc getButton7].tag = 72;
 [mpc getButton7].isEnabled=YES;
 
 [[mpc getButton8] setNormalImage:[CCSprite spriteWithFile:@"I.png"]];
 [[mpc getButton8] setSelectedImage:[CCSprite spriteWithFile:@"I.png"]];
 [mpc getButton8].tag = 73;
 [mpc getButton8].isEnabled=YES;
 
 [mpc pressButton0:self];
 [mpc pressButton1:self];
 [mpc pressButton2:self];
 [mpc pressButton3:self];
 [mpc pressButton4:self];
 [mpc pressButton5:self];
 [mpc pressButton6:self];
 [mpc pressButton7:self];
 [mpc pressButton8:self];
     
    //mpc.button[0];
 
 GHAssertEquals([mpc getButton0].isEnabled, NO, @"After pressing button0, button0 should be disabled");
 GHAssertEquals([mpc getButton1].isEnabled, NO, @"After pressing button1, button1 should be disabled");
 GHAssertEquals([mpc getButton2].isEnabled, NO, @"After pressing button2, button2 should be disabled");
 GHAssertEquals([mpc getButton3].isEnabled, NO, @"After pressing button3, button3 should be disabled");
 GHAssertEquals([mpc getButton4].isEnabled, NO, @"After pressing button4, button4 should be disabled");
 GHAssertEquals([mpc getButton5].isEnabled, NO, @"After pressing button5, button5 should be disabled");
 GHAssertEquals([mpc getButton6].isEnabled, NO, @"After pressing button6, button6 should be disabled");
 GHAssertEquals([mpc getButton7].isEnabled, NO, @"After pressing button7, button7 should be disabled");
 GHAssertEquals([mpc getButton8].isEnabled, NO, @"After pressing button8, button8 should be disabled");
 }

- (void) testMultiple_saveScoreAndThenFetch{
    NSLog(@"diulamaAAA");
    NSDictionary * temp =[NSDictionary dictionaryWithObjectsAndKeys: nil];
    NSLog(@"22");
    /* Request backend to generate sample data. */
    [mpc request:@"diulama/emptydb" SecondParameter:temp];
    NSLog(@"33");
    NSNumber * tempNum = [NSNumber numberWithInt:11];
    NSLog(@"44");
    NSDictionary* temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score",@"Test1",@"user", nil];
    
    NSLog(@"A 1");
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    NSLog(@"A 2");
    tempNum = [NSNumber numberWithInt:10];
    NSLog(@"A 3");
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test2",@"user",nil];
    NSLog(@"A 4");
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    NSLog(@"A 5");
    
    tempNum = [NSNumber numberWithInt:9];
    NSLog(@"A 6");
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test3",@"user", nil];
    NSLog(@"A 7");
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:8];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test4",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:7];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score",@"Test5",@"user", nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:6];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test6",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:5];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test7",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:4];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test8",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    
    tempNum = [NSNumber numberWithInt:3];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test9",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:2];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test10",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:1];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test11",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    NSArray* result = [mpc request:@"users/Top10Scores/multiple" SecondParameter:temp];
    NSMutableArray *Expected = [NSMutableArray array];
    tempNum = [NSNumber numberWithInt:11];
    NSDictionary * tempResultDict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test1", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict1];
    tempNum = [NSNumber numberWithInt:10];
    NSDictionary * tempResultDict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test2", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict2];
    tempNum = [NSNumber numberWithInt:9];
    NSDictionary * tempResultDict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test3", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict3];
    
    tempNum = [NSNumber numberWithInt:8];
    NSDictionary * tempResultDict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test4", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict4];
    tempNum = [NSNumber numberWithInt:7];
    NSDictionary * tempResultDict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test5", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict5];
    
   tempNum = [NSNumber numberWithInt:6];
    NSDictionary * tempResultDict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test6", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict6];
    
    tempNum = [NSNumber numberWithInt:5];
    NSDictionary * tempResultDict7 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test7", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict7];
    
    tempNum = [NSNumber numberWithInt:4];
    NSDictionary * tempResultDict8 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test8", @"user", tempNum, @"score", nil];
    
    [Expected addObject:tempResultDict8];
    tempNum = [NSNumber numberWithInt:3];
    NSDictionary * tempResultDict9 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test9", @"user", tempNum, @"score", nil];
    
    [Expected addObject:tempResultDict9];
    tempNum = [NSNumber numberWithInt:2];
    NSDictionary * tempResultDict10 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test10", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict10];
    
    
    int length = [Expected count];
    BOOL PASS = YES;
    NSLog(@"before is %c",PASS);
    if (length!=10){
        PASS=NO;
    }
    else{
        for (int i=0; i<length; i++){
            if (!([[result objectAtIndex:i] isEqualToDictionary:[Expected objectAtIndex:i]])){
                PASS=NO;
            }
        }
    }
    GHAssertEquals(PASS, YES, @"Fetch Data fail. Inconsistent with expected Result");
    
}


- (void) testMultiple_saveScoreUpdateAndThenFetch{
    NSDictionary * temp =[NSDictionary dictionaryWithObjectsAndKeys: nil];
    /* Request backend to generate sample data. */
    [mpc request:@"diulama/emptydb" SecondParameter:temp];
    NSNumber * tempNum = [NSNumber numberWithInt:11];
    NSDictionary* temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score",@"Test1",@"user", nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    tempNum = [NSNumber numberWithInt:10];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test2",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    tempNum = [NSNumber numberWithInt:9];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test3",@"user", nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    tempNum = [NSNumber numberWithInt:8];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test4",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:7];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score",@"Test5",@"user", nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:6];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test6",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:5];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test7",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:4];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test8",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    
    tempNum = [NSNumber numberWithInt:3];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test9",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:2];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test10",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:1];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test11",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];
    
    tempNum = [NSNumber numberWithInt:20];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test11",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];

    tempNum = [NSNumber numberWithInt:19];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test10",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];

    tempNum = [NSNumber numberWithInt:18];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test9",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];

    tempNum = [NSNumber numberWithInt:17];
    temp2 = [NSDictionary dictionaryWithObjectsAndKeys:tempNum,@"score", @"Test8",@"user",nil];
    [mpc request:@"users/SaveScores/multiple" SecondParameter:temp2];

    
    
    NSArray* result = [mpc request:@"users/Top10Scores/multiple" SecondParameter:temp];
    NSMutableArray *Expected = [NSMutableArray array];
    tempNum = [NSNumber numberWithInt:20];
    NSDictionary * tempResultDict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test11", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict1];
    tempNum = [NSNumber numberWithInt:19];
    NSDictionary * tempResultDict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test10", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict2];
    tempNum = [NSNumber numberWithInt:18];
    NSDictionary * tempResultDict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test9", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict3];
    
    tempNum = [NSNumber numberWithInt:17];
    NSDictionary * tempResultDict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test8", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict4];
    tempNum = [NSNumber numberWithInt:11];
    NSDictionary * tempResultDict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test1", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict5];
    
    tempNum = [NSNumber numberWithInt:10];
    NSDictionary * tempResultDict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test2", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict6];
    
    tempNum = [NSNumber numberWithInt:9];
    NSDictionary * tempResultDict7 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test3", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict7];
    
    tempNum = [NSNumber numberWithInt:8];
    NSDictionary * tempResultDict8 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test4", @"user", tempNum, @"score", nil];
    
    [Expected addObject:tempResultDict8];
    tempNum = [NSNumber numberWithInt:7];
    NSDictionary * tempResultDict9 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test5", @"user", tempNum, @"score", nil];
    
    [Expected addObject:tempResultDict9];
    tempNum = [NSNumber numberWithInt:6];
    NSDictionary * tempResultDict10 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test6", @"user", tempNum, @"score", nil];
    [Expected addObject:tempResultDict10];
    
    
    int length = [Expected count];
    BOOL PASS = YES;
    NSLog(@"before is %c",PASS);
    if (length!=10){
        PASS=NO;
    }
    else{
        for (int i=0; i<length; i++){
            if (!([[result objectAtIndex:i] isEqualToDictionary:[Expected objectAtIndex:i]])){
                PASS=NO;
            }
        }
    }
    GHAssertEquals(PASS, YES, @"Fetch Data fail. Inconsistent with expected Result");
}

-(void) testMulti_SendRandomNumber{
    [mpc sendRandomNumber];
    NSData* tempData = [mpc getNSData];
    Message *message = (Message *) [tempData bytes];
    GHAssertEquals(message->messageType, kMessageTypeRandomNumber, @"message type should be kMessageTypeRandomNumber");
}

-(void) testMulti_SendGameBegin{
    [mpc sendGameBegin];
    NSData* tempData = [mpc getNSData];
    Message *message = (Message *) [tempData bytes];
    GHAssertEquals(message->messageType, kMessageTypeGameBegin, @"message type should be kMessageTypeGameBegin");
}

-(void) testMulti_SendGenerateButton{
    [mpc sendGenerateButton:5 :10];
    NSData* tempData = [mpc getNSData];
    Message *message = (Message *) [tempData bytes];
    GHAssertEquals(message->messageType, kMessageTypeGenerateButton, @"message type should be kMessageTypeGenerateButton");
    MessageGenerateButton *tempMessage = (MessageGenerateButton*) [tempData bytes];
    GHAssertEquals(tempMessage->buttonPosition, 5, @"button position should be 5");
    GHAssertEquals(tempMessage->letterTag, 10, @"letter tag should be 10");
}

-(void) testMulti_SendStartButton{
    [mpc sendStartButton];
    NSData* tempData = [mpc getNSData];
    Message *message = (Message *) [tempData bytes];
    GHAssertEquals(message->messageType, kMessageTypeStartButton, @"message type should be kMessageTypeStartButton");
}

-(void) testMulti_SendWord1{
    [mpc sendWord1:"shabi"];
    NSData* tempData = [mpc getNSData];
    Message *message = (Message *) [tempData bytes];
    GHAssertEquals(message->messageType, kMessageTypeWord1, @"message type should be kMessageTypeWord1");
    MessageWord1 *tempMessage = (MessageWord1*) [tempData bytes];
    GHAssertEquals(strcmp(tempMessage->word,"shabi"), 0,@"tempMessage->word should be shabi");
}

-(void) testMulti_SendWord2{
    [mpc sendWord2:"shabi"];
    NSData* tempData = [mpc getNSData];
    Message *message = (Message *) [tempData bytes];
    GHAssertEquals(message->messageType, kMessageTypeWord2, @"message type should be kMessageTypeWord2");
    MessageWord2 *tempMessage = (MessageWord2*) [tempData bytes];
    GHAssertEquals(strcmp(tempMessage->word,"shabi"), 0,@"tempMessage->word should be shabi");
}

-(void) testMulti_SendWor3{
    [mpc sendWord3:"shabi"];
    NSData* tempData = [mpc getNSData];
    Message *message = (Message *) [tempData bytes];
    GHAssertEquals(message->messageType, kMessageTypeWord3, @"message type should be kMessageTypeWord3");
    MessageWord3 *tempMessage = (MessageWord3*) [tempData bytes];
    GHAssertEquals(strcmp(tempMessage->word,"shabi"), 0,@"tempMessage->word should be shabi");
}

-(void) testMulti_SendTime{
    [mpc sendTime:"5"];
    NSData* tempData = [mpc getNSData];
    Message *message = (Message *) [tempData bytes];
    GHAssertEquals(message->messageType, kMessageTypeTime, @"message type should be kMessageTypeTime");
    MessageTime *tempMessage = (MessageTime*) [tempData bytes];
    GHAssertEquals(strcmp(tempMessage->time, "5"),0, @"tempMessage->time should be 5");
}

-(void) testMulti_SendEndGame{
    [mpc sendEndGame];
    NSData* tempData = [mpc getNSData];
    Message *message = (Message *) [tempData bytes];
    GHAssertEquals(message->messageType, kMessageTypeEndGame, @"message type should be kMessageTypeEndGame");
}

-(void) testMulti_SendScore{
    [mpc sendScore:5];
    NSData* tempData = [mpc getNSData];
    Message *message = (Message *) [tempData bytes];
    GHAssertEquals(message->messageType, kMessageTypeScore, @"message type should be kMessageTypeScore");
    MessageScore *tempMessage = (MessageScore*) [tempData bytes];
    GHAssertEquals(tempMessage->score, 5, @"score should be 5");
}

-(void) testMulti_SendUseCloud{
    [mpc sendUseCloud];
    NSData* tempData = [mpc getNSData];
    Message *message = (Message *) [tempData bytes];
    GHAssertEquals(message->messageType, kMessageTypeUseCloud, @"message type should be kMessageTypeUseCloud");
}

-(void) testMulti_SendGameOver{
    [mpc sendGameOver:YES];
    NSData* tempData = [mpc getNSData];
    Message *message = (Message *) [tempData bytes];
    GHAssertEquals(message->messageType, kMessageTypeGameOver, @"message type should be kMessageTypeGameOver");
    MessageGameOver *tempMessage = (MessageGameOver*) [tempData bytes];
    GHAssertEquals(tempMessage->player1Won, YES, @"isPlayer1 should be YES");
}



- (void) testMulti_unSelect
{
    //int my_penalty = [mpc getPenalty];
    //my_penalty = 0;
    [mpc setPenalty:0];
    [mpc getSelect0].tag = 1;
    [mpc getSelect1].tag = 1;
    [mpc getSelect2].tag = 1;
    [mpc getSelect3].tag = 1;
    [mpc getSelect4].tag = 1;
    [mpc getSelect5].tag = 1;
    [mpc getSelect6].tag = 1;
    [mpc getSelect7].tag = 1;
    [mpc getSelect8].tag = 1;
    [mpc getSelect9].tag = 1;
    [mpc getSelect10].tag = 1;
    [mpc getSelect11].tag = 1;
    [mpc getSelect12].tag = 1;
    [mpc getSelect13].tag = 1;
    [mpc getSelect14].tag = 1;
    
    [mpc unSelect0:self];
    GHAssertEquals([mpc getPenalty], 1, @"After unselecting button0, my_penalty should be 1.");
    [mpc unSelect1:self];
    GHAssertEquals([mpc getPenalty], 2, @"After unselecting button1, my_penalty should be 2.");
    [mpc unSelect2:self];
    GHAssertEquals([mpc getPenalty], 3, @"After unselecting button2, my_penalty should be 3.");
    [mpc unSelect3:self];
    GHAssertEquals([mpc getPenalty], 4, @"After unselecting button3, my_penalty should be 4.");
    [mpc unSelect4:self];
    GHAssertEquals([mpc getPenalty], 5, @"After unselecting button4, my_penalty should be 5.");
    [mpc unSelect5:self];
    GHAssertEquals([mpc getPenalty], 6, @"After unselecting button5, my_penalty should be 6.");
    [mpc unSelect6:self];
    GHAssertEquals([mpc getPenalty], 7, @"After unselecting button6, my_penalty should be 7.");
    [mpc unSelect7:self];
    GHAssertEquals([mpc getPenalty], 8, @"After unselecting button7, my_penalty should be 8.");
    [mpc unSelect8:self];
    GHAssertEquals([mpc getPenalty], 9, @"After unselecting button8, my_penalty should be 9.");
    [mpc unSelect9:self];
    GHAssertEquals([mpc getPenalty], 10, @"After unselecting button9, my_penalty should be 10.");
    [mpc unSelect10:self];
    GHAssertEquals([mpc getPenalty], 11, @"After unselecting button10, my_penalty should be 11.");
    [mpc unSelect11:self];
    GHAssertEquals([mpc getPenalty], 12, @"After unselecting button11, my_penalty should be 12.");
    [mpc unSelect12:self];
    GHAssertEquals([mpc getPenalty], 13, @"After unselecting button12, my_penalty should be 13.");
    [mpc unSelect13:self];
    GHAssertEquals([mpc getPenalty], 14, @"After unselecting button13, my_penalty should be 14.");
    [mpc unSelect14:self];
    GHAssertEquals([mpc getPenalty], 15, @"After unselecting button14, my_penalty should be 15.");
    [mpc setPenalty:0];
}

-(void) testMulti_penaltyScoreBomb
{
    //int my_penalty = [mpc getPenalty];
    //my_penalty = 0;
    [mpc setPenalty:0];
    
    [mpc getButton0].tag = 91;
    [mpc getSelect0].tag=0;
    [mpc pressButton0:self];
    NSLog(@"%i", [mpc getPenalty]);
    GHAssertEquals([mpc getPenalty], 10, @"After pressing my_penalty bomb, my_penalty should be 10");
    [mpc getButton1].tag = 91;
    [mpc pressButton1:self];
    GHAssertEquals([mpc getPenalty], 20, @"After pressing my_penalty bomb 2 times, my_penalty should be 20");
    [mpc getButton2].tag = 91;
    [mpc pressButton2:self];
    GHAssertEquals([mpc getPenalty], 30, @"After pressing my_penalty bomb 3 times, my_penalty should be 30");
    [mpc getButton3].tag = 91;
    [mpc pressButton3:self];
    GHAssertEquals([mpc getPenalty], 40, @"After pressing my_penalty bomb 4 times, my_penalty should be 40");
    [mpc getButton4].tag = 91;
    [mpc pressButton4:self];
    GHAssertEquals([mpc getPenalty], 50, @"After pressing my_penalty bomb 5 times, my_penalty should be 50");
    [mpc getButton5].tag = 91;
    [mpc pressButton5:self];
    GHAssertEquals([mpc getPenalty], 60, @"After pressing my_penalty bomb 6 times, my_penalty should be 60");
    [mpc getButton6].tag = 91;
    [mpc pressButton6:self];
    GHAssertEquals([mpc getPenalty], 70, @"After pressing my_penalty bomb 7 times, my_penalty should be 70");
    [mpc getButton7].tag = 91;
    [mpc pressButton7:self];
    GHAssertEquals([mpc getPenalty], 80, @"After pressing my_penalty bomb 8 times, my_penalty should be 80");
    [mpc getButton8].tag = 91;
    [mpc pressButton8:self];
    GHAssertEquals([mpc getPenalty], 90, @"After pressing my_penalty bomb 9 times, my_penalty should be 90");
    [mpc setPenalty:0];
}


- (void) testMulti_IncreasePress
{
    increaseCounter = 2;
    [mpc increasePress:self];
    GHAssertEquals([mpc getShopItem0].isEnabled, NO, @"Increasing the length of character holder by 5. It can only be used once so it should be disabled to prevent player from using it multiple times");
    GHAssertEquals(increaseCounter, 1, @"After using the powerup, the increaseCounter should decrease by 1 and becomes 1");
    GHAssertEquals([[[mpc getShopItemCounter0] string] isEqualToString:@"x1"], YES, @"The value of shopItemCounter[0] decreases and becomes 1");
    GHAssertEquals([mpc getMaxChar], 15, @"The increased length should be 15 after using powerup");
}

-(void) testMulti_getLetter
{
    int result =1;
    [mpc getLetter];
    if ([mpc get_l] == nil)
        result = 0;
    GHAssertEquals(result, 1, @"Letter can not be generated!");
}

-(void) testSingle_generateButton
{
    BOOL correct = YES;
    [mpc generateButton];
    if ([mpc getButton0].isEnabled==NO && [mpc getButton1].isEnabled==NO && [mpc getButton2].isEnabled==NO &&
        [mpc getButton3].isEnabled==NO && [mpc getButton4].isEnabled==NO && [mpc getButton5].isEnabled==NO &&
        [mpc getButton6].isEnabled==NO && [mpc getButton7].isEnabled==NO && [mpc getButton8].isEnabled==NO)
        correct = NO;
    GHAssertEquals(correct, YES, @"Button generation error!");
}

- (void) testMulti_CloudPress
{
    cloudCounter = 2;
    [mpc cloudPress:self];
    GHAssertEquals([mpc getShopItem1].isEnabled, NO, @"It can only be used once so it should be disabled to prevent player from using it multiple times");
    GHAssertEquals(cloudCounter, 1, @"After using the powerup, the cloudCounter should decrease by 1 and becomes 1");
    GHAssertEquals([[[mpc getShopItemCounter1] string] isEqualToString:@"x1"], YES, @"The value of shopItemCounter[1] decreases and becomes 1");
    cloudCounter = 0;
    
}
/*
-(void) testMulti_StartPress{
    [mpc start:self];
    GHAssertEquals([mpc getStartButton].isEnabled, NO, @"after pressing starting button, it should be disabled");
    
}*/
-(void) testShopScene{
    
    freezeTimeCounter = 0;
    extraTimeCounter = 0;
    slowdownTimeCounter = 0;
    cloudCounter =0;
    increaseCounter = 0;
    money = 99999;
    [ss freezeTimePress:self];
    [ss extraTimePress:self];
    [ss slowdownTimePress:self];
    [ss cloudPress:self];
    [ss increasePress:self];
    
    GHAssertEquals(freezeTimeCounter, 1, @"freezeTimeCounter should be 1");
    GHAssertEquals(extraTimeCounter, 1, @"extraTimeCounter should be 1");
    GHAssertEquals(slowdownTimeCounter, 1, @"slowdownTimeCounter should be 1");
    GHAssertEquals(cloudCounter, 1, @"cloudCounter should be 1");
    GHAssertEquals(increaseCounter, 1, @"increaseCounter should be 1");
    GHAssertEquals(money, 99999-650 , @"money should be 99340");
}
/*
-(void) testLevelSelectScene{
    [lss Level1Chosen:self];
    GHAssertEquals(BUTTON_APPEAR_DURATION, 1.6, @"button appear duration should be 1.6");
    [lss Level2Chosen:self];
    GHAssertEquals(BUTTON_APPEAR_DURATION, 1.4, @"button appear duration should be 1.4");
    [lss Level3Chosen:self];
    GHAssertEquals(BUTTON_APPEAR_DURATION, 1.2, @"button appear duration should be 1.2");
    [lss Level4Chosen:self];
    GHAssertEquals(BUTTON_APPEAR_DURATION, 1.0, @"button appear duration should be 1.0");
    [lss Level5Chosen:self];
    GHAssertEquals(BUTTON_APPEAR_DURATION, 0.8, @"button appear duration should be 0.8");
    
}*/
@end
