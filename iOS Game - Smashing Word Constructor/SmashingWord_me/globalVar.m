//
//  globalVar.m
//  SmashingWord_me
//
//  Created by Edward on 4/7/13.
//
//

#import "globalVar.h"

@implementation globalVar
NSInteger score = 0;
NSInteger score_p1 = 0;
NSInteger score_p2 = 0;
NSInteger penalty_score = 0;
NSString* scorePageMessage = @"";
double BUTTON_APPEAR_DURATION = 0;
BOOL isPlayer1 = YES;

BOOL TEST_MODE = NO;

BOOL TEST_MUL = YES;

//shop features
int money =500;
int extraTimeCounter =0;
int freezeTimeCounter =0;
int slowdownTimeCounter =0;
int cloudCounter =0;
int increaseCounter =0;

//- (NSArray*) requestData:(NSString*) path SecondParameter:(NSDictionary*) parameter{
- (NSArray*) requestData:(NSString*) path{
    NSDictionary *jsonDict;
    if ([path isEqualToString:@"users/Top10Scores/single"]){
        jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    }
    else if ([path isEqualToString:@"users/Top10Scores/multiple"]){
        jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    }
    else{
        jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    nil];
    }
    NSLog(@"1");
    //[jsonDictionaryResponse objectForKey:@"data"];
    NSError *tempError;
    NSLog(@"2");
    NSData *jsonRequest = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&tempError];
    NSLog(@"3");
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", @"http://enigmatic-everglades-8004.herokuapp.com/", path];
    NSLog(@"4");
    NSURL *url = [NSURL URLWithString:fullPath];
    NSLog(@"5");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSLog(@"6");
    
    [request setHTTPMethod:@"POST"];
    NSLog(@"7");
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonRequest length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonRequest];
    NSLog(@"8");
    
    NSURLResponse *tempResponse =[[NSURLResponse alloc]init];
    NSLog(@"9");
    NSData *jsonResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&tempResponse error:&tempError];
    NSLog(@"%@",jsonResponse);
    NSLog(@"10");
    NSDictionary *jsonDictionaryResponse = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&tempError];
    NSLog(@"11");
    
    NSLog(@"Dictionary: %@", [jsonDictionaryResponse objectForKey:@"data"]);
    //NSDictionary *test = {{1,2},3,4};
    //NSLog(@"TEST: %@", test);
    return [jsonDictionaryResponse objectForKey:@"data"];
    
}

@end
