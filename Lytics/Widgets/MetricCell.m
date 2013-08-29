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
        self.metricLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:IS_IPAD()?60:50];
        self.metricLabel.textAlignment = NSTextAlignmentCenter;
        self.metricLabel.backgroundColor = [UIColor clearColor];
        self.metricLabel.format = @"%d";
        [self.contentView addSubview:self.metricLabel];
        
        
        if (IS_IPAD()) {
            self.height -= 20;
            CGRect titleFrame = self.graphView.frame;
            titleFrame.origin.y = 0;
            titleFrame.size.height = self.contentView.frame.size.height;
            titleFrame.size.width = titleFrame.size.width * 0.45;
            self.titleLabel.frame = titleFrame;
            self.titleLabel.minimumScaleFactor = 0.5;
            self.titleLabel.numberOfLines = 1;
            self.titleLabel.adjustsFontSizeToFitWidth = YES;
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:40];
            
            self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            [self.contentView addSubview:self.titleLabel];
        }
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
