//
//  ViewController.m
//  SQLiteDBSample
//
//  Created by Stefan Will on 05.05.15.
//  Copyright (c) 2015 Stefan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPeopleInfo;

-(void)loadData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tblPeople.delegate = self;
    self.tblPeople.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sampledb.db"];
    
    //load the data
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addNewRecord:(id)sender{
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}

-(void)loadData{
    //Form the query
    NSString *query = @"select * from peopleInfo";
    
    //get the results
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    //reload the table view
    [self.tblPeople reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrPeopleInfo.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Dequeue the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    /*
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
    NSInteger indexOfLastname = [self.dbManager.arrColumnNames indexOfObject:@"lastname"];
    NSInteger indexOfAge = [self.dbManager.arrColumnNames indexOfObject:@"age"];
    */
     
    NSInteger selectedRowIndex = indexPath.row;
    NSArray *selectedRow = [self.arrPeopleInfo objectAtIndex:selectedRowIndex];
    NSString *firstname = [selectedRow objectAtIndex:1];
    NSString *lastname = [selectedRow objectAtIndex:2];
    NSString *age = [selectedRow objectAtIndex:3];
    
    //Set the loaded data to the appropriate cell labels
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age %@", age];
    
    return cell;
}

-(void)editingInfoWasFinished{
    //Reload the data
    [self loadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EditInfoViewController *editInfoViewController = [segue destinationViewController];
    editInfoViewController.delegate = self;
}

@end
