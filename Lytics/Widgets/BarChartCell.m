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

@implementation UIColor (LightAndDark)

- (UIColor *)darkerColor
{
    float h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.75
                               alpha:a];
    return nil;
}
@end

@implementation UIView (TableView)

- (UITableView *)recursiveTableView {
    if ([self.superview isKindOfClass:[UITableView class]])
        return (UITableView *)self.superview;
    else if (!self.superview) return nil;
    else
        return [self.superview recursiveTableView];
}

@end

@interface BarChartCell () {
    UIView *line;
}

@end

@implementation BarChartCell

- (id)initWithQuery:(GTLQueryAnalytics *)query andHeight:(NSInteger)height {
    self = [super initWithQuery:query andHeight:height];
    
    if (self) {
        CGFloat scaleWidth = 40;
        
        CGRect frame = self.graphView.frame;
        frame.origin.x += scaleWidth;
        frame.size.width -= scaleWidth;
        self.graphView.frame = frame;
        self.axis = [[GraphAxisView alloc] initWithFrame:CGRectMake(-scaleWidth, 0, scaleWidth, self.contentView.frame.size.height)];
        self.axis.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.graphView addSubview:self.axis];
    }
    
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
    
    self.axis.maxValue = @(maxValue);
    
    for (UIView *v in self.graphView.subviews) {
        if (v.tag) [v removeFromSuperview];
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
        v.tag = value;
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

- (UITableView *)tableView {
    return [self recursiveTableView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouch:touches withEvent:event];
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (line)
            [self tableView].scrollEnabled = NO;
    });
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    [self handleTouch:touches withEvent:event];
}

- (void)handleTouch:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        [self handleTouch:t];
    }
    
}

- (void)handleTouch:(UITouch *)touch {
    if (!line) {
        line = [[UIView alloc] initWithFrame:CGRectMake(-10, 0, 0, 1)];
        [self.graphView addSubview:line];
    }
    
    CGPoint p = [touch locationInView:self.graphView];
    p.y = self.graphView.bounds.size.height - 2;
    UIView *view = [self.graphView hitTest:p withEvent:nil];
    if (view.tag) {
        [self resetColors];
        view.backgroundColor = [view.backgroundColor darkerColor];
        CGRect lf = line.frame;
        lf.size.width = view.frame.origin.x + 10;
        lf.origin.y = view.frame.origin.y;
        line.frame = lf;
    }
}

- (void)resetColors {
    for (UIView *v in self.graphView.subviews) {
        if (v.tag)
            v.backgroundColor = self.color;
    }
    line.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self tableView].scrollEnabled = YES;
    [line removeFromSuperview];
    line = nil;
    [self resetColors];
}

@end
