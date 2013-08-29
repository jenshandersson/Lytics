//
//  MetricCell.m
//  Lytics
//
//  Created by Jens Andersson on 8/26/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "MetricCell.h"
#import "UICountingLabel.h"

@implementation MetricCell

- (id)initWithQuery:(GTLQueryAnalytics *)query andHeight:(NSInteger)height {
    self = [super initWithQuery:query andHeight:height];
    
    if (self) {
        self.metricLabel = [[UICountingLabel alloc] initWithFrame:self.contentView.bounds];
        self.metricLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.metricLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:60];
        self.metricLabel.textAlignment = NSTextAlignmentCenter;
        self.metricLabel.backgroundColor = [UIColor clearColor];
        self.metricLabel.format = @"%d";
        [self.contentView addSubview:self.metricLabel];
        
        CGRect titleFrame = self.graphView.frame;
        titleFrame.origin.y = 0;
        titleFrame.size.height = self.contentView.frame.size.height;
        self.titleLabel.frame = titleFrame;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:32];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.titleLabel];
    }
    
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
    [self.metricLabel countFrom:[self.metricLabel.text integerValue] to:total withDuration:1];
    self.metricLabel.textColor = self.color;
}

- (void)executeQuery {
    self.data = nil;
    [super executeQuery];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(executeQuery) withObject:nil afterDelay:5];
}

- (void)refreshData {
    [self executeQuery];
}

@end
