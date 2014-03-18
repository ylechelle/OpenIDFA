//
//  OpenIDFA.h
//
//  NON PRODUCTION RELEASE VERSION 0.9
//
//  Authored by Yann Lechelle on 07 Feb 2014.
//  Open sourced to early adopters for private peer-review on 12 Feb 2014.
//  Updated for stability on 19 Feb 2014.
//  Open sourced to the wider community on 18 March 2014.
//  Copyright (c) 2014 APPSFIRE.
//
//  Homepage: http://OpenIDFA.org
//  Twitter: @openIDFA
//
//  This piece of code is released under the Creative Commons licence with "Attribution + No Derivatives" (CC BY-ND) http://creativecommons.org/licenses/by-nd/3.0/#
//
//  Disclaimer:
//  - using OpenIDFA requires understanding the difference between IDFA and OpenIDFA (see full comparison on http://OpenIDFA.org)
//  - software is provided as is, comes with no guarantee
//  - the author or APPSFIRE may not be held liable in any way for any issue arising from the use of OpenIDFA
//

#import <Foundation/Foundation.h>

@interface OpenIDFA : NSObject

+ (NSString*) sameDayOpenIDFA;
+ (NSArray*) threeDaysOpenIDFAArray;

@end
