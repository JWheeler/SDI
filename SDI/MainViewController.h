//
//  MainViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL isReal;            // 리얼 시세가 들어 오는지 여부.
    int changeField;        // 마지막 필드 데이터 종류 변경.
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *realArray;
@property (nonatomic, retain) NSMutableArray *responseArray;
@property (nonatomic, retain) NSString *currentStockCode;
@property (nonatomic, retain) NSNumber *currentPrice;           // 현재가.
@property (nonatomic, retain) NSString *currentSymbol;          // 전일대비구분: 상한(1), 상승(2), 보합(3), 하한(4), 하락(5).
@property (nonatomic, retain) NSNumber *currentFluctuation;     // 등락.
@property (nonatomic, retain) NSNumber *currentFluctuationRate; // 등락율.
@property (nonatomic, retain) NSNumber *currentTradeVolume;     // 거래량.

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *stockTableView;

@property (nonatomic, retain) IBOutlet UIButton *mikeButton;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;

// 검색결과 출력 용.
@property (nonatomic, retain) IBOutlet UIView *searchResultView;
@property (nonatomic, retain) NSMutableArray *stockList;
@property (nonatomic, retain) IBOutlet UILabel *resultStockName;
@property (nonatomic, retain) IBOutlet UILabel *resultCurrentPrice;
@property (nonatomic, retain) IBOutlet UIImageView *resultImageView;
@property (nonatomic, retain) IBOutlet UILabel *resultFluctuation;

- (NSFetchedResultsController *)fetchedResultsController;

- (void)setSearchBar;
- (void)initRealArray;
- (void)initIRStocks;
- (void)viewText:(NSNotification *)notification;
- (void)refreshTableForAdd:(NSNotification *)notification;
- (void)refreshTableForDelete :(NSNotification *)notification;
- (void)setupSearchResultView:(NSDictionary *)searchResult withStockName:(NSString *)stockName;
- (void)closeSearchResultView:(UITapGestureRecognizer *)recognizer;

@end
