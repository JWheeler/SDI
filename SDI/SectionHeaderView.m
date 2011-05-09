//
//  SectionHeader.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "SectionHeaderView.h"


@implementation SectionHeaderView

@synthesize imageName;
@synthesize titleLabel;
@synthesize headerIcon;
@synthesize disclosureButton;
@synthesize delegate;
@synthesize section;

+ (Class)layerClass 
{    
    return [CAGradientLayer class];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage *image = [[UIImage imageNamed:self.imageName] retain];
    [image drawInRect:rect];
    [image release];
}

- (void)dealloc
{
    [imageName release];
    [titleLabel release];
    [headerIcon release];
    [disclosureButton release];
    [super dealloc];
}

#pragma mark - 커스텀 헤더

- (id)initWithFrame:(CGRect)frame headerIconName:(NSString *)headerIconName title:(NSString *)title section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)aDelegate 
{    
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    if (self != nil) 
    {        
        // 탭 제스처 설정.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        delegate = aDelegate;        
        self.userInteractionEnabled = YES;
        
        section = sectionNumber;
        
        // 헤더 아이콘 생성.
        headerIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:headerIconName]];
        headerIcon.frame = CGRectMake(16.0, 8.0, 20.0, 20.0);
        [self addSubview:headerIcon];
        
        // 헤더 타이틀 생성.
        CGRect titleLabelFrame = CGRectMake(40.0, 0.0, 100.0, 36.0);
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.textColor = RGB(237, 237, 237);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:titleLabel];
        
        // 토글 버튼 생성 및 설정.
        disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        disclosureButton.frame = CGRectMake(160.0, 10.5, 14.0, 14.0);
        [disclosureButton setImage:[UIImage imageNamed:@"icon_plus.png"] forState:UIControlStateNormal];
        [disclosureButton setImage:[UIImage imageNamed:@"icon_minus.png"] forState:UIControlStateSelected];
        [disclosureButton addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disclosureButton];
    }
    
    return self;
}

- (IBAction)toggleOpen:(id)sender 
{    
    [self toggleOpenWithUserAction:YES];
}


- (void)toggleOpenWithUserAction:(BOOL)userAction 
{    
    // 토글 버튼 상태.
    disclosureButton.selected = !disclosureButton.selected;

    // 만약 사용자 액션이 일어나면, 델리게이트에 메시지 전달.
    if (userAction) 
    {
        if (disclosureButton.selected) 
        {
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) 
            {
                self.imageName = @"m_header_minus.png";
                [delegate sectionHeaderView:self sectionOpened:section];
            }
        }
        else 
        {
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) 
            {
                self.imageName = @"m_header_plus.png";
                [delegate sectionHeaderView:self sectionClosed:section];
            }
        }
    }
}

@end
