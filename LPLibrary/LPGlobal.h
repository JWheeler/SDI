//
//  LPGlobal.h
//  LPLibrary
//
//  Created by Jong Pil Park on 10. 9. 2..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

// 매크로.
// [참고] http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/DrawColor/Concepts/AboutColorSpaces.html%23//apple_ref/doc/uid/20000758-BBCHACHA
// UIColor: RGB
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// UIColor: HSB
#define HSB(h, s, b) [UIColor colorWithHue:h/360.0saturation:s/100.0brightness:b/100.0alpha:1]
#define HSBA(h, s, b, a) [UIColor colorWithHue:h/360.0saturation:s/100.0brightness:b/100.0alpha:a]

// UIColor 값을 RGB로...
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// HSB 개별 변환용.
#define CH(h) (h / 360.0)
#define CS(s) (s / 100.0)
#define CB(b) (b / 100.0)

// 각도/라디안.
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(x) ((x) * 180.0 / M_PI)

// 로그.
#define LPLog(format, ...) NSLog(@"%s:%@", __PRETTY_FUNCTION__, [NSString stringWithFormat:format, ## __VA_ARGS__]);

// 사용법.
//LPLog(@"My iPhone is an %@, v %@", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion]);

// 벤치마킹.
#define START_TIMER NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
#define END_TIMER(msg) 	NSTimeInterval stop = [NSDate timeIntervalSinceReferenceDate]; LPLog([NSString stringWithFormat:@"%@ Time = %f", msg, stop-start]);

// 사용법.
//- (void)loadStockCodeMaster
//{
//    START_TIMER;
//    NSURL *url = [NSURL URLWithString:STOCK_CODE_MASTER_URL];
//    NSString *stringFile = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    END_TIMER(@"loadStockCodeMaster");
//}

// UIView frmae(CGRect).
#define width(a) a.frame.size.width
#define height(a) a.frame.size.height
#define top(a) a.frame.origin.y
#define left(a) a.frame.origin.x
#define FrameReposition(a,x,y) a.frame = CGRectMake(x, y, width(a), height(a))
#define FrameResize(a,w,h) a.frame = CGRectMake(left(a), top(a), w, h)

// 그라디언트 관련 메소드. ---------------------------------------------------------
CGRect rectFor1PxStroke(CGRect rect);

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);

void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

static inline double radians (double degrees) { return degrees * M_PI/180; }

CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);

// 버튼의 라운드 코너.
CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius);
// 그라디언트 관련 메소드. ---------------------------------------------------------
