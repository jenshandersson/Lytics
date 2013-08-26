//
//  MetricCell.m
//  Lytics
//
//  Created by Jens Andersson on 8/26/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "MetricCell.h"

@implementation MetricCell

- (id)initWithQuery:(GTLQueryAnalytics *)query andHeight:(NSInteger)height {
    self = [super initWithQuery:query andHeight:height];
    self.metricLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.metricLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.metricLabel.font = [UIFont systemFontOfSize:50];
    self.metricLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.metricLabel];
    return self;
}

- (void)plot {
    [super plot];
    
    NSInteger total = 0;
    
    for (NSArray *values in self.data.rows) {
        NSString *stringValue = [values lastObject];
        NSInteger value = [stringValue integerValue];
        total += value;
    }
    self.metricLabel.text = [NSString stringWithFormat:@"%d", total];
    self.metricLabel.textColor = self.color;
}

- (void)refreshData {
    self.data = nil;
    [self executeQuery];
}

@end
