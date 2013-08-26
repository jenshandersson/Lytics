//
//  BarChartCell.h
//  Lytics
//
//  Created by Jens Andersson on 8/26/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GTLQueryAnalytics.h>
#import <GTLAnalyticsGaData.h>

@interface BaseCell : UITableViewCell

@property (nonatomic, copy) GTLQueryAnalytics *query;
@property (nonatomic) GTLAnalyticsGaData *data;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSString *title;
@property (nonatomic) UIColor *color;

@property (nonatomic) UILabel *titleLabel;


- (id)initWithQuery:(GTLQueryAnalytics *)query andHeight:(NSInteger)height;
- (void)plot;
- (void)executeQuery;
- (void)refreshData;
@end
