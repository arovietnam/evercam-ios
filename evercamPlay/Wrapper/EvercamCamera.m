//
//  EvercamCamera.m
//  evercamPlay
//
//  Created by jw on 3/22/15.
//  Copyright (c) 2015 evercom. All rights reserved.
//

#import "EvercamCamera.h"
#import "AFEvercamAPIClient.h"

@implementation EvercamCamera

/**
 * Get camera list by requesting a specified URL and parameters as a map
 */
+ (void) getByUrl:(NSString*) url Parameters:(NSDictionary *) parameters WithBlock:(void (^)(NSArray *cameras, NSError *error))block
{
    if ([parameters valueForKeyPath:@"api_id"] == nil || [parameters valueForKeyPath:@"api_key"] == nil)
    {
        NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : MSG_USER_API_KEY_REQUIRED };
        NSError *error  = [NSError errorWithDomain:@"api.evercam.io"
                                              code:CODE_ERROR userInfo:errorDictionary];
        if (block)
            block(nil, error);
        return;
    }
    
    NSURLSessionDataTask *task= [[AFEvercamAPIClient sharedClient] GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
        NSHTTPURLResponse* r = (NSHTTPURLResponse*)task.response;
        NSLog( @"%@", JSON );
        
        if (r.statusCode == CODE_OK)
        {
            NSArray *cameraArray = [JSON valueForKeyPath:@"cameras"];
            if (block)
                block(cameraArray, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil, error);
    }];
    
    [task resume];
}


@end
