//
//  GraphAxesView.m
//  Lytics
//
//  Created by Jens Andersson on 2013-08-29.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "GraphAxisView.h"

@interface GraphAxisView () {
}

@property (nonatomic) UILabel *maxLabel;
@property (nonatomic) UILabel *medianLabel;

@end

@implementation GraphAxisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        self.medianLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height / 2)-10, frame.size.width, 20)];
        self.medianLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self configureLabel:self.maxLabel];
        [self addSubview:self.maxLabel];
        
        [self configureLabel:self.medianLabel];
        [self addSubview:self.medianLabel];
    }
    return self;
}

- (void)configureLabel:(UILabel *)label {
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    label.minimumScaleFactor = 0.5;
    label.numberOfLines = 1;
    label.adjustsFontSizeToFitWidth = YES;
    label.backgroundColor = [UIColor clearColor];
}

- (void)setMaxValue:(NSNumber *)maxValue {;
    _maxValue = maxValue;
    self.maxLabel.text = [self stringForValue:maxValue.integerValue];
    self.medianLabel.text = [self stringForValue:maxValue.integerValue / 2];
}

- (NSString *)stringForValue:(NSInteger)value {
    if (value > 10000) {
        return [NSString stringWithFormat:@"%.0fk", value / 1000.0];
    }
    return [NSString stringWithFormat:@"%d", value];
}

@end
