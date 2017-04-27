# OpenIDFA: the sustainable and privacy friendly tracking identifier for iOS
### "The Snapchat of Device IDs"

![](http://f.cl.ly/items/0T0k2u0G3g3Z0o2D1f1A/OpenIDFAsupporters.jpg)

## Synopsis
[Apple is wreaking havoc by rejecting apps using IDFA for non advertising purposes][4]. While this is a legitimate intent, enforcement by way of app rejection will penalize those who use it correctly, and yet, fall on the wrong side of interpretation. OpenIDFA offers a compelling alternative that does not depend on Apple’s own frameworks and guidelines, while at the same time helping with general privacy concerns.

## Introduction
Some people never learn! On one side you had people using UDID when clearly they shoudn’t have. And so Apple deprecated UDID, just like that. Hence came [OpenUDID][2]. And then Apple did the right thing one iOS release later by introducing a pair of identifiers: VendorID and [IDforAvertisers][6] (IDFA or IFA). But then again, some were using the IDFA when clearly they shouldn’t have; only to hear the sound of rejection much later, just like that. Some people never learn! [But who’s to blame?][5]

Just like with industrial design, the form of an API should follow its function.

##### Here comes [OpenIDFA][7]!

OpenIDFA is an alternative to IDFA that strives to achieve the Yin and the Yang:
- lets mobile ad professionals do their job by allowing cross-app event attribution
- protects end user privacy concerns by expiring and resetting tokens automatically


## HIGH LEVEL FAQ

#### What’s the problem with IDFA in the first place?
As always, we don’t know for sure. Apple communicates by way of rejection and guidelines… so it’s up for interpretation. In any case, IDFA allegedly is ok for its initial intent: ad conversion tracking. Advanced advertising techniques however need to start tracking earlier, and therefore need the actual IDFA despite not showing an ad then and there. Will Apple reject on that basis? Recent interpretations seem to indicate that this is the case. So IDFA is a hot-potato subject again. We can’t rely on it because it appears to be a moving target. Furthermore, someone will need to explain how Apple intends to enforce the “limit tracking” option… if it can’t be enforced systematically and fairly, why is it there?

#### Why OpenIDFA?
Well, much like we did with [OpenUDID][2], the idea is to offer an alternative (or complementary solution) to IDFA-in-turmoil, and at least for a while bring peace of mind to those working the Yin. Hopefully, the Yang will be fulfilled at the same time in new and radical ways.

#### How does it work?
Well, there is a little bit of code jujitsu, a lot of common sense, and plenty of love.
The OpenIDFA uses a combination of anti-collision fingerprinting, cryptographic hashing with built-in self-expiring properties and at the same time cross-application persistence over a number of days. Most importantly, OpenIDFA has built-in properties that are explicit and not subject to interpretation or evolving guidelines; form follows function.

#### Comparison table
| | IDFA | OpenIDFA |
|:-----------|:-----------|:------------|
| **Uniqueness**      |        Typically unique |     Quasi unique >100%-10^-5     
| **Expiration**       |        Explicit reset by user (rare, but still non-deterministic for developers/advertisers) |     Implicit reset, non-deterministic but fairly rare     
| **Tracking Limitation**         | User toggle/developer driven (enforcement unknown) |      Long term tracking impossible  (3 days at best)      
| **Framework dependencies**         | AdSupport framework |      none specific      
| **Good for…**   |       frequency capping, conversion events |    frequency capping, conversion events, all purpose cross-application event attribution (e.g. for re-engagement or re-targeting)
| **Bad for…** (use vendorID instead)    |     Long term tracking, LTV (at least not alone), analytics, estimating the number of unique users, security and fraud detection, and debugging - basically not good for non-advertising purposes |   Long term tracking, LTV (at least not alone), analytics, estimating the number of unique users, security and fraud detection, and debugging - basically not good for non-advertising purposes
| **Sustainability** | Unknown. Could be deprecated, evolved, interpreted... | Who knows? Nothing lasts forever, but at least, Apple didn’t write this piece of code...

#### Where’s the twist?
To make room for the Yang, something had to give. As such, OpenIDFA is not a drop-in replacement for all use cases, although it might just work like that! (see low level FAQ below).

#### Does OpenIDFA replace my current attribution solution? 
You decide. If Apple is fine with your use of IDFA, then why change? Reversely, what prevents you from also logging OpenIDFA in case Apple changes its mind? Complementary or alternative. Your call. If you’re using a 3rd party attribution solution, engage with your provider and invite them to consider OpenIDFA, instead of their own proprietary spin which will effectively allow them to lock you in. In addition, attribution solutions can be very expensive and they tend to prefer proprietary solutions (which recreate silos and prevent interoperability).

#### How is that different from fingerprinting?
Fingerprinting is a technique that typically aims to recreate a unique device or user identifier that is persistent forever, thereby ignoring privacy concerns; at the same time, fingerprinting identifiers are often not so unique (80%-90% range) so they fail to measure accurately conversion rates. OpenIDFA uses advanced fingerprinting techniques combined with other properties to achieve maximum uniqueness (99.99%+), while at the same time having built-in expiration to prevent data hoarding and long term tracking (cf. the Yin and the Yang).

#### Why can't I just use vendorID again?
VendorID is no good for advertising. Attribution via VendorID is impossible between the publisher app and the advertised app (typically two distinct vendors) since the IDs will be guaranteed to be different. On the other hand, VendorID is perfect for endogenous vendor Analytics, A/B testing, fraud detection, etc…

#### Privacy concerns
- *Who has access to OpenIDFA ids?* Only those that call for it within a day. It’s a shared identifier, but only lasts a day, very much like IDFA. It is not owned by anyone in particular, it is decentralized by nature.
Is it compliant with the law? Certainly. If anything, OpenIDFA is more ephemereal than the formal IDFA and thefore further in line with the spirit of privacy protection.
- *Is OpenIDFA compliant with the App Store terms of services?* Certainly, the OpenIDFA uses strictly public APIs.
- *Is OpenIDFA bound to a user or the device?* OpenIDFA is bound to the device itself much like IDFA (and therefore to the user using the device)
- *Is OpenIDFA anonymized?* The identifier itself is anonymous. But as with any identifier, we rely on developer best practice to anonymize data they collect. Luckily, OpenIDFA expires within a day, so it won’t be of much use after 24h!

#### What are typical use cases for OpenIDFA?
- *Server-side frequency capping:* use OpenIDFA to minimize exposure of a given ad by counting how many times a given identifier (or a trio, see below) has been exposed to it...
- *Conversion tracking:* use OpenIDFA to record an impression, a click event (a tap really!), and then once the advertised app is installed and launched, match the current OpenIDFA to attribute the source... 
- *Pre-impression event tracking for re-engagement and re-targeting:* use OpenIDFA to track e-commerce events inside the advertiser app; then match the OpenIDFA on the publisher’s side to present a higher impact advertisement...

#### How open is OpenIDFA?
First there was OpenUDID, now OpenIDFA. Seemed fitting no?
OpenIDFA was initially provided as a static library to somewhat protects the inherent properties that limit long term persistent. Today, OpenIDFA is open source and free to be reviewed and used by all, in a decentralized fashion, as was the case for OpenUDID. OpenIDFA is interoperable and not proprietary to any vendor. It’s part of the commons now. In fact, it is distributed under the Creative Commons license (Attribution BY + NoDerivatives ND).

About the srouce code: again, the essence lies in the acceptance that tracking tokens MUST expire, sooner rather than later (instead of explicit reset or limitations enacted by the user as is the case with the current IDFA system). Once that baseline is secured, the code follows the function and vice-versa. 



#### How much does it cost? When is it available?
OpenIDFA will cost you zero bitcoin, available on Feb 7th 2014.

#### Who’s the maker?
OpenIDFA is brought to you by [Appsfire][3], conceived over a few sleepless nights by Appsfire’s co-founder and CTO [Yann Lechelle][1] (also author of [OpenUDID][2] back in 2011). As with our own native ad technologies, OpenIDFA strives to raise the bar in terms of best practice. Feel free to reach out with questions directly on Github!

## LOW LEVEL FAQ
#### Where’s my drop-in replacement?
Apple’s way:

	// add the AdSupport framework
	#import <AdSupport/AdSupport.h>
	NSString* idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

The High Way:

	// add the OpenIDFA.h and OpenIDFA.m to your project
	#import "OpenIDFA.h"
	NSString* OpenIDFA = [OpenIDFA sameDayOpenIDFA];

#### Wait, what does “sameDay” mean?
Fedex is not involved. It means that the OpenIDFA returned is typically persistent over two sessions that occur on the same day. Wait 24h, request [OpenIDFA sameDayOpenIDFA] and you’ll get a different OpenIDFA.

It’s limiting, but think about it. It’s a good and common use case.
User clicks on an ad, and if compelled to act, will download and launch the app, all within a 10mn timespan in most cases, hours at best. “sameDayIDFA” solves that problem.

*(we’re working to bring you stats on this notion of same day conversion: typically well above 75%)*

#### I need longer persistence, how do I extend my tracking to 2 or more days?
No problem, there is another method for this:

	NSArray* OpenIDFAs = [OpenIDFA threeDaysOpenIDFAArray];

Here is the part where it’s a little trickier than a drop-in replacement. Essentially, if you want to track over multiple days, you need to register 3 events with 3 distinct OpenIDFAs, one valid today (array index 0), one valid tomorrow (array index 1), and one valid 2 days from now (array index 2). On the reconciliation side, which in most cases occurs within 3 days, all you need to do is to find a match with the “sameDayIDFA”; if you do, it means the conversion was effective within a time-span of 3 days. 

#### How do I get more than 3 days worth of tracking?
You don’t. That’s enough. Remember the Yang. And by the way, do you know anyone in the fast-paced mobile advertising industry who considers tracking beyond 3 days? Thought so.

#### Side benefits?
You can now breathe easy. You can purge your databases daily (remember, those OpenIDFA tokens are only good for one day at a time). It’s a good day for you mr privacy trampler... you just saved a terabyte of storage!

## MISCELLANEOUS

##### Version History
- Feb 04 2014: birth of the OpenIDFA project
- Feb 07 2014: release of static library GitHub
- Feb 12 2014: source released to a selection of early adopters for peer review
- Mar 18 2014: source released to the greater community
 
#### Follow OpenIDFA on Twitter
http://twitter.com/OpenIDFA

#### Message to Apple
Why do we find out about important evolutions in the way the iOS APIs are to be used via blogs, apps being rejected and the likes? It would be immensely useful if the eco-system’s needs were considered prior to such unilateral decisions. Again, we love your iDevices, we’re happy to help you sell more of them… but consider this: reciprocity will go a long way…

[1]: http://twitter.com/ylechelle  "Yann LECHELLE"
[2]: http://openudid.org/  "OpenUDID.org"
[3]: http://appsfire.com/  "appsfire.com"
[4]: http://techcrunch.com/2014/02/03/apples-latest-crackdown-apps-pulling-the-advertising-identifier-but-not-showing-ads-are-being-rejected-from-app-store/ "TechCrunch"
[5]: https://developer.apple.com "apple.com developer"
[6]: https://developer.apple.com/library/ios/documentation/AdSupport/Reference/ASIdentifierManager_Ref/ASIdentifierManager.html "IDFA"
[7]: http://OpenIDFA.org "OpenIDFA"
