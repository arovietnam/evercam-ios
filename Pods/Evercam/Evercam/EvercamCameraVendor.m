//
//  EvercamCameraVendor.m
//  evercamPlay
//
//  Created by Zulqarnain on 6/1/16.
//  Copyright © 2016 evercom. All rights reserved.
//

#import "EvercamCameraVendor.h"
#import "EvercamApiUtility.h"

@implementation EvercamCameraVendor

-(void)getVendorName:(NSDictionary *)parameterDictionary withBlock:(void (^)(id details,NSError *error))block{
    NSString *mac_Address  = parameterDictionary[@"mac_address"];
    NSString *api_id    = parameterDictionary[@"api_id"];
    NSString *api_key   = parameterDictionary[@"api_Key"];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSString *jsonUrlString = [NSString stringWithFormat:@"%@vendors?mac=%@&api_id=%@&api_key=%@",KBASEURL,mac_Address,api_id,api_key];
        
        NSMutableURLRequest *request = [APIUtility createRequestWithUrl:jsonUrlString withType:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error              = nil;
        NSData *responseData        = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (!error) {
            if ([response statusCode] == 200){
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                if (block) {
                    block(responseDictionary,nil);
                }
            }else{
                [APIUtility createErrorFromApi:responseData withStatusCode:[response statusCode] withBlock:^(NSError *error) {
                    if (block) {
                        block(nil,error);
                    }
                }];
            }
        }else{
            if (block) {
                block(nil,error);
            }
        }
    });
}

@end
