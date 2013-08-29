//
//  BarChartCell.m
//  Lytics
//
//  Created by Jens Andersson on 8/26/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "BarChartCell.h"
#import "GTLServiceAnalytics+Public.h"
#import <HexColors/HexColor.h>

@implementation BarChartCell

- (id)initWithQuery:(GTLQueryAnalytics *)query andHeight:(NSInteger)height {
    self = [super initWithQuery:query andHeight:2*height];
    
    return self;
}

- (void)plot {
    [super plot];
    
    int length = self.data.rows.count;
    NSInteger maxValue = 0;
    
    for (NSArray *values in self.data.rows) {
        NSString *stringValue = [values lastObject];
        NSInteger value = [stringValue integerValue];
        maxValue = MAX(maxValue, value);
    }
    
    for (UIView *v in self.graphView.subviews) {
        if (v != self.titleLabel) [v removeFromSuperview];
    }
    
    CGFloat graphHeight = self.graphView.bounds.size.height;
    CGFloat margin = 1;    
    CGFloat unitHeight = 1.0f * graphHeight / maxValue;
    CGFloat unitWidth = self.graphView.frame.size.width / length - margin;
    
    
    CGFloat x = 0;
    uint i = 0;
    for (NSArray *values in self.data.rows) {
        NSString *stringValue = [values lastObject];
        NSInteger value = [stringValue integerValue];
        
        CGFloat barHeight = unitHeight * value;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, graphHeight, unitWidth, 0)];
        v.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        v.backgroundColor = self.color;
        [self.graphView addSubview:v];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            v.frame = CGRectMake(x, graphHeight-barHeight, unitWidth, barHeight);
        } completion:nil];
        
        i++;
        x += unitWidth + margin;
    }
}

@end
