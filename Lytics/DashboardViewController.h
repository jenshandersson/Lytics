//
//  DashboardViewController.h
//  Lytics
//
//  Created by Jens Andersson on 8/24/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *widgets;

@end
