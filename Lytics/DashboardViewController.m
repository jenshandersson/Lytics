//
//  DashboardViewController.m
//  Lytics
//
//  Created by Jens Andersson on 8/24/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "DashboardViewController.h"
#import <iOSPlot/PCLineChartView.h>
#import <GTMOAuth2ViewControllerTouch.h>
#import <GTLAnalytics.h>
#import <KoaPullToRefresh.h>
#import "GTLServiceAnalytics+Public.h"
#import "BarChartCell.h"
#import "BaseCell.h"
#import "MetricCell.h"
#import <HexColors/HexColor.h>
#import <UIColor+MLPFlatColors.h>

static NSString *const kKeychainItemName = @"OAuth2 Sample: Google+";

NSString *kMyClientID = @"419458561839.apps.googleusercontent.com";     // pre-assigned by service
NSString *kMyClientSecret = @"SzcR6l8QpWszJ_srvZP62Lh3"; // pre-assigned by service

NSString *scope = @"https://www.googleapis.com/auth/plus.me https://www.googleapis.com/auth/analytics.readonly"; // scope for Google+ API

@interface DashboardViewController () {
    GTMOAuth2Authentication *_auth;
}

@end

@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName clientID:kMyClientID clientSecret:kMyClientSecret];
    if (![_auth canAuthorize]) {
        [self signIn];
    } else {
        [self setupCells];
    }
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F0F1F5"];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self.widgets makeObjectsPerformSelector:@selector(refreshData)];
    } withBackgroundColor:[UIColor clearColor]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView.pullToRefreshView selector:@selector(stopAnimating) name:@"stopLoading" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView.pullToRefreshView];
}

- (void)setupCells {
    [GTLServiceAnalytics shared].authorizer = _auth;
    
    NSDateComponents *dc = [NSDateComponents new];
    dc.month = -3;
    
    NSString *profileIdMobile = @"ga:68216181";
    NSString *profileId = @"ga:64735439";
    
    GTLQueryAnalytics *q = [GTLQueryAnalytics queryForDataRealtimeGetWithIds:profileId metrics:@"ga:activeVisitors"];
    MetricCell *realTimeCell = [[MetricCell alloc] initWithQuery:q andHeight:80];
    realTimeCell.title = @"Service Real-Time";
    realTimeCell.color = [UIColor colorWithHexString:@"44BBFF"];
    
    
    
    q = [GTLQueryAnalytics queryForDataGaGetWithIds:profileId startDate:nil endDate:nil metrics:@"ga:visitors"];
    q.dimensions = @"ga:month,ga:day";
    BarChartCell *cell = [[BarChartCell alloc] initWithQuery:q andHeight:100];
    cell.title = @"Visitors Last Year";
    cell.color = [UIColor colorWithHexString:@"66CC99"];
    cell.dateComponents = dc;
    
    
    q = [GTLQueryAnalytics queryForDataGaGetWithIds:profileId startDate:nil endDate:nil metrics:@"ga:visits"];
    q.dimensions = @"ga:month,ga:day";
    BarChartCell *cell2 = [[BarChartCell alloc] initWithQuery:q andHeight:100];
    dc.month = -1;
    cell2.dateComponents = dc;
    cell2.title = @"Visits Last Month";
    cell2.color = [UIColor colorWithHexString:@"FC575E"];
    
    q = [GTLQueryAnalytics queryForDataRealtimeGetWithIds:profileIdMobile metrics:@"ga:activeVisitors"];
    MetricCell *realTimeCell2 = [[MetricCell alloc] initWithQuery:q andHeight:80];
    realTimeCell2.title = @"iOS Real-Time";
    realTimeCell2.color = [UIColor colorWithHexString:@"115566"];
    
    
    q = [GTLQueryAnalytics queryForDataGaGetWithIds:profileIdMobile startDate:nil endDate:nil metrics:@"ga:totalEvents"];
    q.dimensions = @"ga:month,ga:day";
    q.filters = @"ga:eventAction==User created a new conversation";
    BarChartCell *filtered = [[BarChartCell alloc] initWithQuery:q andHeight:100];
    filtered.dateComponents = dc;
    filtered.title = @"# Created Posts";
    filtered.color = [UIColor colorWithHexString:@"FF9E09"];
    
    self.widgets = @[realTimeCell, cell, cell2, realTimeCell2, filtered]    ;
    [self.tableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.widgets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseCell *cell = [self.widgets objectAtIndex:indexPath.row];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseCell *cell = [self.widgets objectAtIndex:indexPath.row];
    [cell executeQuery];
    return cell;
}

- (void)signIn {
    GTMOAuth2ViewControllerTouch *viewController;
    viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
                                                                clientID:kMyClientID
                                                            clientSecret:kMyClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    if (error != nil) {
        // Authentication failed
    } else {
        // Authentication succeeded
        _auth = auth;
        [self dismissViewControllerAnimated:NO completion:nil];
        [self setupCells];
    }
}

@end
