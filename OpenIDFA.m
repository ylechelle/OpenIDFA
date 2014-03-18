//
//  OpenIDFA.m
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

#import "OpenIDFA.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/types.h>

@implementation OpenIDFA

+ (NSString*) sameDayOpenIDFA
{
    return [[OpenIDFA threeDaysOpenIDFAArray] objectAtIndex:0];
}

+ (NSArray*) threeDaysOpenIDFAArray {
    
    // The following list represents a rather large array of ids used to detect
    // the presence of a number of apps available on the device. The apps on this
    // list have been handpicked by Appsfire AppGenome engine; they each carry
    // a statistically significant weight to define and differentiate a user from
    // another. For the purpose of obfuscation inside the lib, we only used apps
    // with Facebook-related URLHanders typically starting with the string "fb"
    // then followed by a numerical string.
    //
    // RATIONALE: an "appmap" profile may vary over time, however, the likeness that it
    // evolves between two tracking events over a large proportion of the user
    // base is low.
    //
    // NOTICE: this list is the property of Appsfire and may not be extracted from
    // the context of OpenIDFA which is governed by a Creative Commons (No Derivatives)
    //
    NSArray* base = @[ @101015295179ll, @102443183283204ll, @105130332854716ll, @110633906966ll, @111774748922919ll, @112953085413703ll, @113174082133029ll, @113246946530ll, @114870218560647ll, @115829135094686ll, @115862191798713ll, @118506164848956ll, @118589468194837ll, @118881298142408ll, @120176898077068ll, @121848807893603ll, @123448314320ll, @123591657714831ll, @124024574287414ll, @127449357267488ll, @127995567256931ll, @132363533491609ll, @134841016914ll, @138326442889677ll, @138713932872514ll, @146348772076164ll, @147364571964693ll, @147712241956950ll, @148327618516767ll, @152777738124418ll, @154615291248069ll, @156017694504926ll, @158761204309396ll, @159248674166087ll, @160888540611569ll, @161500167252219ll, @161599933913761ll, @162729813767876ll, @165482230209033ll, @176151905794941ll, @177821765590225ll, @178508429994ll, @192454074134796ll, @194714260574159ll, @208559595824260ll, @209864595695358ll, @210068525731476ll, @239823722730183ll, @246290217488ll, @255472420580ll, @267160383314960ll, @292065597989ll, @99197768694ll, @342234513642ll, @349724985922ll, @99554596360ll, @40343401983ll, @500407959994978ll, @52216716219ll, @90376669494ll];
    

    // Playing with the prefix some more for the purpose of obfuscation
    //
    NSMutableString* _s_appmap = [NSMutableString stringWithString:@""];
    NSString* _s = @"/";
    NSString* _c = @":";
    NSString* _b = @"b";
    NSString* _f = @"f";
    
    // Computing the "appmap" profile string for this user
    // STRENGTH: potential of 2^61 distinct combinations
    //
    [_s_appmap appendString:[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@",_f,_b,_c,_s,_s]]]?@"|":@"-"];
    for (id baseid in base) {
        [_s_appmap appendString:[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@",_f,_b,[baseid stringValue],_c,_s,_s]]]?@"|":@"-"];
    }
    
    // Collecting the device boottime (Unix epoch) and turn it into a string
    //
    // RATIONALE: any reboot will cause former OpenIDFAs for this user to be
    // invalidated and useless. This is a built-in property of OpenIDFA that
    // wants to ensure that tokens expire regularly, and in this case, non-
    // determiniscally.
    //
    // COMPLEXITY: boottime is NOT stable. Few days after releasing the lib,
    // I realized that the clock was adjusted by 2 seconds per day on an actual
    // device probably due to real-time clock adjustments over NTP.
    //
    // SOLUTION: truncating the right hand side of the boottime by 4 digits
    // This allows the boottime to slide by up to 9999 seconds... many days!
    // Side benefits, reboots within a 2.77h window will NOT reset the IDFA
    //
    // STRENGTH: iOS devices do not reboot often (ahem, version 7.1+!)
    // Typical reboot occurs days if not weeks apart. Using one week,
    // gives us 600k distinct possibilities assuming a random distribution
    // of reboots across all devices
    //
    
    size_t size;
    struct timeval boottime;
    
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size = sizeof(boottime);
    NSString* _s_bt = @"";
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        _s_bt =[NSString stringWithFormat:@"%lu",boottime.tv_sec];
        _s_bt = [_s_bt substringToIndex:[_s_bt length]-4];
    }
    
    // Collecting the device "machine" identifier
    //
    // STRENGTH: 20+ combinations
    //
    // WEAKNESS: compared to Android, iOS pales here :) oh wait...
    //
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *_s_machine = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    // Collecting the device "model" identifier, for completition
    //
    // STRENGTH: adds little, helps in case of simulator
    //
    sysctlbyname("hw.model", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.model", model, &size, NULL, 0);
    NSString *_s_model = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);

    // Collecting the locale country code
    //
    // STRENGTH: its complicated, but at least 80 combinations not evenly distributed!
    // Check CLDR release 24 to know more: http://cldr.unicode.org/index/downloads/cldr-24
    //
	NSString *_s_ccode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
    // Collecting an ordered array of preferred languages
    //
    // RATIONALE: this is an ordered list of preferred languages, theoretically speaking
    // Most people only configure one and thefore the rest of the list remains unchanged
    // However, polyglots will impact this list deeply.
    // I've chosen to only mark up to 8 languages. Infiniglots don't pass the Turing test.
    //
    // STRENGTH: something like 8! but not evenly distributed.
    //
    NSArray* preferredLang = [NSLocale preferredLanguages];
    NSString* _s_langs;
    if (preferredLang == nil || ![preferredLang isKindOfClass:[NSArray class]] || [ preferredLang count ] == 0)
        _s_langs = @"en";
    else
        _s_langs =  [[preferredLang subarrayWithRange:NSMakeRange(0, MIN(8,[preferredLang count]))] componentsJoinedByString:@""];
    
    // Collecting a few more device specific discriminating strings
    //
    // RATIONALE: the goal is to reinfoce uniqueness / reduce collisions.
    // 1/ memory size: iOS devices come in variations of 8Gb, 16Gb, 32Gb, and 64Gb
    // 2/ OS version: unevenly distributed, most people tend to have the latest version
    //    in iOS world... which is good! distinctiveness value = close to zero
    // 3/ timezone: assuming equal distribution, 24 variations. Though we intuitively
    //    all know which 8 to 10 timezones represent 90% of all iOS devices!
    //
    // STRENGTH: say 50 combinations.
    //
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSString *_s_disk = [[fattributes objectForKey:NSFileSystemSize] stringValue];
    NSString* _s_osv = [[UIDevice currentDevice] systemVersion];
    NSString* _s_tmz = [[NSTimeZone systemTimeZone] name];

    // Marking the day, sameDay™, tomorrow or day after
    //
    // RATIONALE: this is another built-in and unique property of OpenIDFA
    // The token is only valid for today (and the next two days).
    // Tthe notion of day is pegged to the user himself, to their own
    // biological clock. Assumption and experience is that most transactions
    // occur within the same waking hours. So the notion of day was shifted
    // by 4 hours (i.e. day begins at 4am, ends at 4am next day).
    // The following study/graph by MixPanel illustrates this quite well:
    // http://tctechcrunch2011.files.wordpress.com/2014/02/day-in-mobile-california.png?w=1280
    // When tracking precision requires more than sameDay™, then tracker
    // can venture into getting 3 days worth of OpenIDFA tokens...
    //
    NSDateFormatter* dateFormatter = [ [ NSDateFormatter alloc ] init ];
    [ dateFormatter setDateFormat:@"yyMMdd" ];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *hourShift = [[NSDateComponents alloc] init];
    [hourShift setHour:-4];
    NSDate *currentDay= [calendar dateByAddingComponents:hourShift toDate:[NSDate date] options:0];
    NSDateComponents *dayShift = [[NSDateComponents alloc] init];
    [dayShift setDay:1];
    
    // Creating array of 3 OpenIDFAs
    //
    NSMutableArray* openIDFAs = [NSMutableArray arrayWithCapacity:3];
    for (int j=0; j<3; j++) {
        
        // Creating the fingerprint with the various elements
        // PART 1: Boot Time
        // PART 2: Mostly stable and unique elements over time
        // PART 3: Day Stamp
        //
        NSString* _s_day = [dateFormatter stringFromDate:currentDay];
        NSString* fingerprint = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@",
                                 _s_bt,               _s_disk,
                                 _s_machine,          _s_model,
                                 _s_osv,              _s_ccode,
                                 _s_langs,            _s_appmap,
                                 _s_tmz,              _s_day];
        
        const char* str = [fingerprint UTF8String];
        unsigned char result[CC_SHA256_DIGEST_LENGTH];
        CC_SHA256(str, (CC_LONG)strlen(str), result);
        
        // Creating a UUID-like formatting by only taking one byte out of two from
        // the SHA-256 Hash, and by inserting dashes where relevant.
        // Should anyone see benefits in better compliance with http://www.itu.int/rec/T-REC-X.667/en
        // especially perhaps the version number represented by bits 49 to 52, then raise your hand!
        //
        NSMutableString *hash = [NSMutableString stringWithCapacity:36];
        for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i+=2)
        {
            if (i==8 || i==12 || i==16 || i==20)
                [hash appendString:@"-"];
            [hash appendFormat:@"%02X",result[i]];
        }
        
        [openIDFAs addObject:hash];
        
        //NSLog(@"day[%d]%@",j,fingerprint);
        //NSLog(@"HASH%d: %@",j,hash);
 
        // Shifting day by one
        //
        currentDay = [calendar dateByAddingComponents:dayShift toDate:currentDay options:0];
    }
    
    //NSLog(@"OpenIDFAs: %@",openIDFAs);
    return openIDFAs;
}

@end
