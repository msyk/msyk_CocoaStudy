//
//  AppDelegate_iPad.m
//  BlockCheck
//
//  Created by Masayuki Nii on 10/11/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPad.h"

#define BLOCKPARAM (id x, int y, NSString *s)
typedef float(^MyBlock)BLOCKPARAM;

@interface TestClass : NSObject
{
	MyBlock f;
}
- (void) myMethod: (MyBlock)bf;
@end

@implementation TestClass
- (void) myMethod: (MyBlock)bf	{	}
@end



@implementation AppDelegate_iPad

@synthesize window;

void samplefunc( int, void (^)(NSString*, NSString*, NSArray*, NSMutableArray*, NSMutableDictionary*, int, int));
void samplefunc( int x, void (^func)(NSString* z1, NSString* z2, NSArray* z3, NSMutableArray* z4, NSMutableDictionary* z5, int s1, int s2))
{}

#define LONGPARAM (NSString* z1, NSString* z2, NSArray* z3, \
	NSMutableArray* z4, NSMutableDictionary* z5, int s1, int s2)

void samplefunc2( int, void (^)LONGPARAM);
void samplefunc2( int x, void (^func)LONGPARAM)
{}

void function1( int a, void (^b)(id,int))	{
	b(@"pack",a);
}

int function2( int, int (^)(id,int));

int function2( int a, int (^b)(id,int))	{
	int i=b(@"pack",a);
	return i;
}

#define PARAM (id x,int y)
typedef void (^func1param)PARAM;
typedef int (^func2param)PARAM;



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	NSLog( @"Start");
	void (^proc1)(void) = ^(void){ NSLog( @"==proc1=="); };
	proc1;
	proc1();
	
	int (^proc2)(id, int) = ^(id str, int c){ 
		for( int i=0 ; i < c; i++ )	{ 
			NSLog( @"%@",str );
		}
		return 99;
	};
//	proc2(); --> error: too few arguments to block 'proc2'
	int x = proc2( @"Song", 3 );
	NSLog( @"x=%d", x );
	
	__block int b = 100;
	int c = 200;
	void (^proc3)(void) = ^(void){ b=b+c; };
	proc3();	NSLog( @"b=%d", b );	// bの値は300
	proc3();	NSLog( @"b=%d", b );	// bの値は500
	//	void (^proc3)(void) = ^(void){ b++; c++; }; --> error: increment of read-only variable 'c'
	
	//
	samplefunc( 3, 
	^(NSString* z1, NSString* z2, NSArray* z3, NSMutableArray* z4, NSMutableDictionary* z5, int s1, int s2){});

	samplefunc2( 3, ^LONGPARAM{
		NSLog( @"%@",z2 );
	});
//	
	function1( 3, ^(id x,int y) { NSLog(@"%@,%d",x,y); } );
	
	void(^f1)(id,int) = ^(id x, int y){ NSLog(@"%@,%d",x,y); };
	function1( 3, f1 );
	
	func1param f1p = ^PARAM{ NSLog(@"%@,%d",x,y); } ;
	function1( 3, f1p );
	
	function2( 3, ^(id x,int y) { return 4; } );
/*	
	function2( 3, ^(id x,int y) { } ); //-->error: incompatible block pointer types initializing 'void (^)(struct objc_object *, int)', expected 'int (^)(struct objc_object *, int)'
	function2( 3, int ^(id x,int y) { return 4; } ); //-->expected expression before 'int'
	function2( 3, (int)^(id x,int y) { return 4; } ); //-->invalid conversion initializing integer 'int', expected block pointer
	function2( 3, int(^)(id x,int y) { return 4; } ); //-->expected expression before 'int'
	function2( 3, (int)(^)(id x,int y) { return 4; } ); //-->expected specifier-qualifier-list before ')' token
*/	
	
	func2param f2p;
	f2p = ^PARAM{ 
		NSLog(@"%@,%d",x,y);
		return 6;
	};
	function2( 3, f2p );
	
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end




