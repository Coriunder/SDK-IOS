//
//  DownloadView.m
//  Mahala
//
//  Created by Vitaliy Stepanov on 14.08.14.
//  Copyright (c) 2014 Udi Azulay. All rights reserved.
//

#import "DownloadView.h"
#import "DownloadViewCell.h"
#import "HistoryActivityIndicatorCell.h"
#import "DownloadViewPlayer.h"
#import "ShopSDKDownloads.h"
#import "CartItem.h"
#import "AudioConstants.h"

#define PRODUCTS_ON_PAGE 1
#define ROW_HEIGHT 88

@interface DownloadView () {
    NSMutableArray *musicArray;
    int currentPage;
    int sectionsAmount;
    BOOL isLoading;
}

@end

@implementation DownloadView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Downloads", @"");
    
    self.emptyView.hidden = YES;
    self.tableView.hidden = NO;
    
    self.tableView.bounces = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    currentPage = 0;
    sectionsAmount = 2;
    isLoading = NO;
    musicArray = [NSMutableArray new];
    [self loadNextPage];
}

- (void)loadNextPage {
    isLoading = YES;
    [[ShopSDKDownloads getInstance] getDownloadsOnPage:1 pageSize:10 callback:^(BOOL success, NSMutableArray *downloads, NSString *message) {
        if (success) {
            if (currentPage == 0 && downloads.count == 0) {
                // Returned empty result while loading first page; means that we have no downloads
                isLoading = NO;
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
                
            } else if (downloads.count == 0) {
                // Returned empty result while loading NOT first page; means that all downloads were loaded
                sectionsAmount = 1;
                [self.tableView reloadData];
                isLoading = NO;
                
            } else {
                // Returned downloadable item
                currentPage = currentPage + 1;
                
                NSMutableArray *indexPathes = [NSMutableArray new];
                NSMutableArray *tempDataArray = [NSMutableArray new];
                for (int i=0; i<downloads.count; i++) {
                    // Add product data to a temporary array
                    CartItem *item = [downloads objectAtIndex:i];
                    if ([item.downloadMediaType.lowercaseString isEqualToString:@"mp3"]) {
                        // Add indexPath for inserting rows
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:musicArray.count+i inSection:0];
                        [indexPathes addObject:indexPath];
                        
                        NSMutableDictionary *data = [NSMutableDictionary new];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"dd.MM.yyyy"];
                        [data setValue:item.name forKey:KEY_PRODUCT_NAME];
                        [data setValue:[formatter stringFromDate:item.insertDate] forKey:KEY_DATE];
                        [data setValue:@(item.productId) forKey:KEY_PRODUCT_ID];
                        [tempDataArray addObject:data];
                    }
                }
                
                isLoading = NO;
                if (tempDataArray.count > 0) {
                    [musicArray addObjectsFromArray:tempDataArray];
                    
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                    
                    [indexPathes removeAllObjects];
                    [tempDataArray removeAllObjects];
                    [downloads removeAllObjects];
                } else {
                    [downloads removeAllObjects];
                    [self loadNextPage];
                }
            }
            
        } else {
            isLoading = NO;
            [self processErrorWithMessage:message];
        }
    }];
}

- (void)processErrorWithMessage:(NSString*)message {
    self.emptyView.hidden = NO;
    self.tableView.hidden = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

/********************* UITABLEVIEW DELEGATE AND METHODS *********************/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return ROW_HEIGHT;
    else return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionsAmount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return musicArray.count;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"DownloadViewCell";
        DownloadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:NULL];
            cell = [nibContents firstObject];
        }
        NSDictionary *data = [musicArray objectAtIndex:[indexPath row]];
        [cell.productNameLabel setText:[data objectForKey:KEY_PRODUCT_NAME]];
        [cell.merchantNameLabel setText:[data objectForKey:KEY_DATE]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        static NSString *cellIdentifier = @"HistoryActivityIndicatorCell";
        HistoryActivityIndicatorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:NULL];
            cell = [nibContents firstObject];
        }
        [cell.indicator startAnimating];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *data = [musicArray objectAtIndex:[indexPath row]];
    NSString *itemID = [NSString stringWithFormat:@"%@", [data objectForKey:KEY_PRODUCT_ID]];
    
    //Check whether file exists
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject]
                          stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", itemID, @"mp3"]];
    
    [self viewFile:fileName item:[indexPath row] streamer:![fileManager fileExistsAtPath:fileName]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (!isLoading) [self loadNextPage];
    }
}

-(void)viewFile:(NSString*)fileName item:(long)item streamer:(BOOL)streamer {
    
    if (!streamer) {
        //get real file size
        NSDictionary *fileDict = [[NSFileManager defaultManager] fileAttributesAtPath:fileName traverseLink:YES];
        long realSize = [fileDict fileSize];
        
        //get required file size
        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:[musicArray objectAtIndex:item]];
        if (value && value != nil && ![value isEqual:@""]) {
            if (!(([value intValue] - realSize) < 10000 && ([value intValue] - realSize) > -10000)) {
                streamer = YES;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error;
                [fileManager removeItemAtPath:fileName error:&error];
            }
        }
    }
    
    DownloadViewPlayer *player = [DownloadViewPlayer new];
    player.str_FilePath = fileName;
    player.Array_PathPlayingFiles = musicArray;
    player.itemNumber = item;
    player.streaming = streamer;
    player.downloaded = NO;
    if (!streamer) [player setAudioToPlay];
    [self.navigationController pushViewController:player animated:YES];
}

@end
