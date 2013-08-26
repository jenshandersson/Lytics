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

- (void)plot {
    [super plot];
    
    int length = self.data.rows.count;
    NSInteger maxValue = 0;
    
    for (NSArray *values in self.data.rows) {
        NSString *stringValue = [values lastObject];
        NSInteger value = [stringValue integerValue];
        maxValue = MAX(maxValue, value);
    }
    
    for (UIView *v in self.contentView.subviews) {
        if (v != self.titleLabel) [v removeFromSuperview];
    }
    
    CGFloat maxHeight = self.height - 10;
    CGFloat margin = 1;    
    CGFloat unitHeight = 1.0f * maxHeight / maxValue;
    CGFloat unitWidth = self.contentView.frame.size.width / length - margin;

    
    CGFloat x = 0;
    for (NSArray *values in self.data.rows) {
        NSString *stringValue = [values lastObject];
        NSInteger value = [stringValue integerValue];
        
        CGFloat barHeight = unitHeight * value;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, self.height, unitWidth, 0)];
        v.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        v.backgroundColor = self.color;
        [self.contentView addSubview:v];
        [UIView animateWithDuration:0.4 animations:^{
            v.frame = CGRectMake(x, self.height-barHeight, unitWidth, barHeight);
        }];
        
        x += unitWidth + margin;
    }
}

@end
