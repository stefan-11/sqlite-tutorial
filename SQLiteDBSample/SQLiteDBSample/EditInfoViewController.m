//
//  EditInfoViewController.m
//  SQLiteDBSample
//
//  Created by Stefan Will on 08.05.15.
//  Copyright (c) 2015 Stefan. All rights reserved.
//

#import "EditInfoViewController.h"
#import "DBManager.h"

@interface EditInfoViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
    
    //Make self the delegate of the textfields
    self.txtAge.delegate = self;
    self.txtFirstname.delegate = self;
    self.txtLastname.delegate = self;
    
    //initialize the DB Manager object
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sampledb.db"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)saveInfo:(id)sender{
    //prepare the query string
    NSString *query = [NSString stringWithFormat:@"insert into peopleInfo values(null, '%@', '%@', %d)",
                       self.txtFirstname.text,
                       self.txtLastname.text,
                       [self.txtAge.text intValue]];
    NSLog(query);
    
    //execute the query
    [self.dbManager executeQuery:query];
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfull. Affected rows = %d", self.dbManager.affectedRows);
        
        //Inform the delegate that the editing was finished
        [self.delegate editingInfoWasFinished];
        
        //pop the view controller
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"Could not execute query");
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
