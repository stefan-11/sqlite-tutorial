//
//  ViewController.h
//  SQLiteDBSample
//
//  Created by Stefan Will on 05.05.15.
//  Copyright (c) 2015 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "EditInfoViewController.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EditInfoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblPeople;

- (IBAction)addNewRecord:(id)sender;

@end

