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
#import "BaseCell.h"
#import "GraphAxisView.h"

@interface BarChartCell : BaseCell

@property (nonatomic) GraphAxisView *axis;

@end
