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
    
    NSString *startDate = @"2013-08-01";
    NSString *endDate = @"2013-08-25";
    
    GTLQueryAnalytics *q = [GTLQueryAnalytics queryForDataRealtimeGetWithIds:@"ga:68216181" metrics:@"ga:activeVisitors"];
    MetricCell *realTimeCell = [[MetricCell alloc] initWithQuery:q andHeight:100];
    realTimeCell.title = @"Real-Time Visitors";
    realTimeCell.color = [UIColor colorWithHexString:@"44BBFF"];
    
    
    
    q = [GTLQueryAnalytics queryForDataGaGetWithIds:@"ga:64735439" startDate:startDate endDate:endDate metrics:@"ga:visitors"];
    q.dimensions = @"ga:day";
    BarChartCell *cell = [[BarChartCell alloc] initWithQuery:q andHeight:100];
    cell.title = @"Visitors";
    cell.color = [UIColor colorWithHexString:@"66CC99"];
    
    
    
    q = [GTLQueryAnalytics queryForDataGaGetWithIds:@"ga:64735439" startDate:startDate endDate:endDate metrics:@"ga:visits"];
    q.dimensions = @"ga:day";
    BarChartCell *cell2 = [[BarChartCell alloc] initWithQuery:q andHeight:100];
    cell2.title = @"Visits";
    cell2.color = [UIColor colorWithHexString:@"FC575E"];
    
    
    
    self.widgets = @[realTimeCell, cell, cell2];
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

/*
- (void)callAPI {
    [self visitors];
    return;
    
    GTLQuery *query = [GTLQueryAnalytics queryForManagementAccountsList];
    [self.service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        [self profilesForAccount:@"310453"];
    }];
}

- (void)profilesForAccount:(NSString *)accountId {
    GTLQuery *query = [GTLQueryAnalytics queryForManagementWebpropertiesListWithAccountId:accountId];
    [self.service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        ;
    }];
}


- (void)visitors {
    //68216181 app
    //64735439 service
    GTLQueryAnalytics *query = [GTLQueryAnalytics queryForDataRealtimeGetWithIds:@"ga:68216181" metrics:@"ga:activeVisitors"];
    [self.service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        NSString *visitors = [[[object rows] lastObject] lastObject];
        self.activeUsersLabel.text = visitors;
    }];
    [self visitorsChart];
}

- (void)visitorsChart {
    GTLQueryAnalytics *query = [GTLQueryAnalytics queryForDataGaGetWithIds:@"ga:64735439" startDate:@"2013-08-01" endDate:@"2013-08-24" metrics:@"ga:visitors"];
    query.dimensions = @"ga:day";
    [self.service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        
    }];
}

 */
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
        [self dismissViewControllerAnimated:NO completion:nil];
        [self setupCells];
    }
}

@end
