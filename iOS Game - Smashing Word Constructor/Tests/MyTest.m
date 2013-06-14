//
//  MyTest.m
//  SmashingWord_me
//
//  Created by Denny Winoto on 4/18/13.
//
//




# import "GHUnitCocos2dBase.h"

#import "SinglePlayerScene.h"


@implementation MyTest

- (void)testStrings {
    NSString *string1 = @"a string";
    GHTestLog(@"I can log to the GHUnit test console: %@", string1);
    
    // Assert string1 is not NULL, with no custom error description
    GHAssertNotNil(string1, nil);
    
    // Assert equal objects, add custom error description
    NSString *string2 = @"a string";
    GHAssertEqualObjects(string1, string2, @"A custom error message. string1 should be equal to: %@.", string2);
}

- (void) testCCSprite
{
    CCSprite *sprite = [CCSprite spriteWithFile:@"Icon.png"];
    GHAssertNotNil(sprite, @"sprite is nil");
}

@end