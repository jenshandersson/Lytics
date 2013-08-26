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
        self.height = height;
        self.query = query;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)executeQuery {
    if (self.data) return [self plot];
    
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
