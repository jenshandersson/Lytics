//
//  BarChartCell.m
//  Lytics
//
//  Created by Jens Andersson on 8/26/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "BaseCell.h"
#import "GTLServiceAnalytics+Public.h"
#import <HexColors/HexColor.h>
#import <KoaPullToRefresh.h>

@implementation BaseCell

- (id)initWithQuery:(GTLQueryAnalytics *)query andHeight:(NSInteger)height
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        // Initialization code
        CGFloat xPadding = IS_IPAD()?50:10;
        CGFloat labelHeight = IS_IPAD() ? 34 : 30;
        self.height = IS_IPAD() ? 2 * height : height;
        self.query = query;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGRect frame = CGRectInset(self.contentView.bounds, xPadding, 0);
        frame.origin.y = labelHeight + 10;
        frame.size.height -= frame.origin.y;
        self.graphView = [[UIView alloc] initWithFrame:frame];
        
        self.graphView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, 0, 320, labelHeight)];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:IS_IPAD()?24 : 16];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
        
        [self.contentView addSubview:self.graphView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (NSDateComponents *)dateComponents {
    /** Fall back to last month if nothing set */
    if (!_dateComponents) {
        _dateComponents = [NSDateComponents new];
        _dateComponents.month = -1;
    }
    return _dateComponents;
}

- (NSString *)startDate {
    NSString *_startDate;
    NSDate *date = [NSDate new];
    date = [[NSCalendar currentCalendar] dateByAddingComponents:self.dateComponents toDate:date options:0];
    _startDate = [self stringFromDate:date];
    
    return _startDate;
}

- (NSString *)endDate {
    NSString *_endDate;
    
    NSDate *date = [NSDate new];
    _endDate = [self stringFromDate:date];
    
    return _endDate;
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"YYYY-MM-dd";
    return [df stringFromDate:date];
}

- (void)executeQuery {
    if (self.data) return [self plot];
    self.query.startDate = [self startDate];
    self.query.endDate = [self endDate];
    [[GTLServiceAnalytics shared] executeQuery:self.query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        self.data = object;
        [self plot];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLoading" object:nil];
    }];
}

- (void)refreshData {
    
}


- (void)plot {
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = self.color;
}

@end
