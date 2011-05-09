//
//  SectionHeader.h
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol SectionHeaderViewDelegate;

@interface SectionHeaderView : UIView 
{
    
}

@property (nonatomic, retain) NSString *imageName;

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *headerIcon;
@property (nonatomic, retain) UIButton *disclosureButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) id <SectionHeaderViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame headerIconName:(NSString *)headerIconName title:(NSString *)title section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)aDelegate;
- (void)toggleOpenWithUserAction:(BOOL)userAction;

@end


// 섹션 헤더 델리게이트.
@protocol SectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderView:(SectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section;
- (void)sectionHeaderView:(SectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section;

@end