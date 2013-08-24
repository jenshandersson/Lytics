#import "AFHTTPClient.h"

@interface LyticsAPIClient : AFHTTPClient

+ (LyticsAPIClient *)sharedClient;

@end
