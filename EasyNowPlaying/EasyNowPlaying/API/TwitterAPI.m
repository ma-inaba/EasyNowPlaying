//
//  TwitterAPI.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "TwitterAPI.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@implementation TwitterAPI
{
    ACAccountStore *acStore;
}

- (void)tapedTwitterButton
{
    if(acStore == nil) acStore = [[ACAccountStore alloc] init];
    ACAccountType *acType = [acStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [acStore requestAccessToAccountsWithType:acType options:nil completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //ユーザがTwitterを許可
            if (granted) {
                NSArray *twiiterAccounts = [acStore accountsWithAccountType:acType];
                if (twiiterAccounts.count > 0) {
                    //複数アカウントの場合があるため、アカウントを選択
                    
                    UIAlertController *actionSheet = nil;
                    actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                      message:@"Twitterのアカウントを選択"
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
                    [twiiterAccounts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        ACAccount *account = obj;
                        
                        [actionSheet addAction:[UIAlertAction actionWithTitle:[account username] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            [self selectedTwitterAccount:account];
                        }]];
                    }];
                    [actionSheet addAction:[UIAlertAction actionWithTitle:@"キャンセル"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
//                    [self presentViewController:actionSheet animated:YES completion:nil];
                }
                
            }else{
                if ([error code] == ACErrorAccountNotFound) {
                    //iOSに登録されているTwitterアカウントがない。
                    NSLog(@"iOSにTwitterアカウントが登録されていません。");
                }else{
                    //ユーザが許可しない
                    NSLog(@"Twitterが有効になっていません。");
                }
            }
            
            
        });
    }];
}

- (void)selectedTwitterAccount:(ACAccount *)ac
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[ac username],@"screen_name",nil];
    
    SLRequest *req = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                        requestMethod:SLRequestMethodGET
                                                  URL:url
                                           parameters:params];
    [req setAccount:ac];
    [req performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSUInteger statusCode = urlResponse.statusCode;
            if (200 <= statusCode && statusCode < 300) {
                // JSONをパース
                NSDictionary *tweets = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                [self getTwitterToken:ac];
                [tweets objectForKey:@"profile_image_url"];
                [tweets objectForKey:@"screen_name"];
            }else{
                NSLog(@"error");
            }
            
        });
        
    }];
}

- (void)getTwitterToken:(ACAccount *)ac
{
    STTwitterAPI *twtr = [STTwitterAPI twitterAPIWithOAuthConsumerName:nil
                                                           consumerKey:@"tz4VEtoryWgeV3fFEDxooQ11M"
                                                        consumerSecret:@"t29BF666mXLeHsC6lMVzWgZarKwlnQxBHi1GHYa0Xinb69Nsta"];
    [twtr postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
        STTwitterAPI *twtrAPIOS = [STTwitterAPI twitterAPIOSWithAccount:ac delegate:self];
        [twtrAPIOS verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
            [twtrAPIOS postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
                                                             successBlock:^(NSString *oAuthToken,
                                                                            NSString *oAuthTokenSecret,
                                                                            NSString *userID,
                                                                            NSString *screenName) {
                                                                 
                                                                 NSLog(@"Token %@ secret %@ userId %@ screenName %@",oAuthToken,oAuthTokenSecret, userID, screenName);
                                                                 
                                                             } errorBlock:^(NSError *error) {
                                                                 NSLog(@"error %@",[error description]);
                                                             }];
        } errorBlock:^(NSError *error) {
            NSLog(@"error %@",[error description]);
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"error %@",[error description]);
    }];
}

- (void)twitterAPI:(STTwitterAPI *)twitterAPI accountWasInvalidated:(ACAccount *)invalidatedAccount {
    
}


@end
