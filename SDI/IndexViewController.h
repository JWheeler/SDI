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
@property (nonatomic, retain) IBOutlet UIImageView *beforeImageView;    // 장 전, 후.
@property (nonatomic, retain) IBOutlet UIImageView *afterImageView;     // 장 중.

// 장 전, 후 인덱스별 백그라운드.
@property (nonatomic, retain) IBOutlet UIView *indexBg11;
@property (nonatomic, retain) IBOutlet UIView *indexBg21;
@property (nonatomic, retain) IBOutlet UIView *indexBg31;
@property (nonatomic, retain) IBOutlet UIView *indexBg41;
@property (nonatomic, retain) IBOutlet UIView *indexBg51;

// 장 중 인덱스별 백그라운드.
@property (nonatomic, retain) IBOutlet UIView *indexBg12;               // 라인 차트.
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

// 업종테마흐름 값/제목 라벨.
@property (nonatomic, retain) IBOutlet UILabel *val1;
@property (nonatomic, retain) IBOutlet UILabel *val2;
@property (nonatomic, retain) IBOutlet UILabel *val3;
@property (nonatomic, retain) IBOutlet UILabel *val4;
@property (nonatomic, retain) IBOutlet UILabel *val5;
@property (nonatomic, retain) IBOutlet UILabel *title1;
@property (nonatomic, retain) IBOutlet UILabel *title2;
@property (nonatomic, retain) IBOutlet UILabel *title3;
@property (nonatomic, retain) IBOutlet UILabel *title4;
@property (nonatomic, retain) IBOutlet UILabel *title5;

// 매매동향 가로 바 차트 출력용 데이터.
@property (nonatomic, retain) NSDictionary *hBarChartData;

// 매매동향 파이 차트 출력용 데이터.
@property (nonatomic, retain) NSDictionary *pieChartDataForKospi;
@property (nonatomic, retain) NSDictionary *pieChartDataForKosdaq;

// 업종테마흐름 세로 바 차트 출력용 데이터.
@property (nonatomic, retain) NSDictionary *vBarChartDataForTheme;

- (void)registerGestureForRibbon;
- (void)closeDaily:(UISwipeGestureRecognizer *)recognizer;
- (BOOL)isViewChangeTime;
- (NSDictionary *)fetchData:(NSString *)trCode;
- (NSMutableArray *)genDataForHBarChartKospi:(NSDictionary *)data;
- (NSMutableArray *)genDataForHBarChartKosdaq:(NSDictionary *)data;
- (NSMutableArray *)genDataForPieChartKospi:(NSDictionary *)data;
- (NSMutableArray *)genDataForPieChartKosdaq:(NSDictionary *)data;
- (NSMutableArray *)genDataForVBarChartTheme:(NSDictionary *)data;
- (void)settingRealForKospi;
- (void)drawHBarChartForKospi;
- (void)drawHBarChartForKosdaq;
- (void)drawPieChartForKospi;
- (void)drawPieChartForKosdaq;
- (void)drawVBarChartForTheme;

@end
