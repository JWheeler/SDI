//
//  IndexViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 25..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: 리본 애니메이션 세부 조정.
//

#import <UIKit/UIKit.h>


@interface IndexViewController : UIViewController 
{
    
}

// 리본과 백그라운드.
@property (nonatomic, retain) IBOutlet UIImageView *ribbonImageView;
@property (nonatomic, retain) IBOutlet UIImageView *beforeImageView;    // 장전.
@property (nonatomic, retain) IBOutlet UIImageView *afterImageView;     // 장중.

// 인덱스별 백그라운드.
@property (nonatomic, retain) IBOutlet UIView *indexBg1;
@property (nonatomic, retain) IBOutlet UIView *indexBg2;
@property (nonatomic, retain) IBOutlet UIView *indexBg3;
@property (nonatomic, retain) IBOutlet UIView *indexBg4;
@property (nonatomic, retain) IBOutlet UIView *indexBg5;

// 실시간지수(k: 코스피, q:코스닥, f:선물, c:화폐(원/달러)).
@property (nonatomic, retain) IBOutlet UILabel *kIndex;
@property (nonatomic, retain) IBOutlet UIImageView *kArrow;
@property (nonatomic, retain) IBOutlet UILabel *kFluctuation;
@property (nonatomic, retain) IBOutlet UILabel *kFluctuationRate;
@property (nonatomic, retain) IBOutlet UILabel *qIndex;
@property (nonatomic, retain) IBOutlet UIImageView *qArrow;
@property (nonatomic, retain) IBOutlet UILabel *qFluctuation;
@property (nonatomic, retain) IBOutlet UILabel *qFluctuationRate;
@property (nonatomic, retain) IBOutlet UILabel *fIndex;
@property (nonatomic, retain) IBOutlet UIImageView *fArrow;
@property (nonatomic, retain) IBOutlet UILabel *fFluctuation;
@property (nonatomic, retain) IBOutlet UILabel *fFluctuationRate;
@property (nonatomic, retain) IBOutlet UILabel *cIndex;
@property (nonatomic, retain) IBOutlet UIImageView *cArrow;
@property (nonatomic, retain) IBOutlet UILabel *cFluctuation;
@property (nonatomic, retain) IBOutlet UILabel *cFluctuationRate;

- (void)registerGestureForRibbon;
- (void)closeDaily:(UISwipeGestureRecognizer *)recognizer;
- (NSDictionary *)fetchData;
- (void)drawHBarChartForKospi;
- (void)drawHBarChartForKosdaq;
- (void)drawPieChartForKospi;
- (void)drawPieChartForKosdaq;
- (void)drawVBarChartForTheme;

@end
