//
//  GHUnitCocos2dbase_Highscore.m
//  SmashingWord_me
//
//  Created by Denny Winoto on 5/2/13.
//
//

#import "GHUnitCocos2dbase_Highscore.h"

@implementation GHUnitCocos2dbase_Highscore




- (BOOL) shouldRunOnMainThread
{
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
    return YES;
}

- (void) setUpClass
{
    
	CC_DIRECTOR_INIT();
    
    //spc = [[SinglePlayerScene alloc] init];
    hss = [[HighestScoreScene alloc] init];
    
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

- (void)testMockHighScore
{
    id mockGlobalVar = [OCMockObject mockForClass:[globalVar class]];
    hss.gv = mockGlobalVar;
    
    NSDictionary *input1 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"value1", @"score",
                            @"value2", @"user",
                            nil];
    NSDictionary *input2 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"value3", @"score",
                            @"value4", @"user",
                            nil];
    /*
    NSArray *testResponse = [NSArray arrayWithObject:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"value1", @"score",
                                     @"value2", @"user",
                                     nil],
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"value3", @"score",
                                     @"value4", @"user",
                                     nil],
                                    nil];
    */
    NSArray *testResponse = [NSArray arrayWithObjects: input1, input2, nil];
    NSLog(@"testResponse: %@", testResponse);
    
    [[[mockGlobalVar stub] andReturn:testResponse] requestData:[OCMArg any]];
    [hss requestScore];
    
    GHAssertEqualStrings(@"value1", [hss.single[0] objectForKey:@"score"], @"hss.single[0] should be \"value1\"");
    GHAssertEqualStrings(@"value4", [hss.single[1] objectForKey:@"user"], @"hss.single[1] should be \"value4\"");
    
    GHAssertEqualStrings(@"value1", [hss.multi[0] objectForKey:@"score"], @"hss.multi[0] should be \"value1\"");
    GHAssertEqualStrings(@"value4", [hss.multi[1] objectForKey:@"user"], @"hss.multi[1] should be \"value4\"");
}

/*******************************************************************************/

- (void)testStrings {
    NSString *string1 = @"a string";
    GHTestLog(@"I can log to the GHUnit test console: %@", string1);
    
    // Assert string1 is not NULL, with no custom error description
    GHAssertNotNil(string1, nil);
    
    // Assert equal objects, add custom error description
    NSString *string2 = @"a string";
    GHAssertEqualObjects(string1, string2, @"A custom error message. string1 should be equal to: %@.", string2);
}

@end