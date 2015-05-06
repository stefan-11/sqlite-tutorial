//
//  DBManager.m
//  SQLiteDBSample
//
//  Created by Stefan Will on 06.05.15.
//  Copyright (c) 2015 Stefan. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        //Set the documents directory path to the documentsDirectory property
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        //keep the database filename
        self.databaseFilename = dbFilename;
        
        //Copy the database file into the documents directory if necessary
        [self copyDatabaseIntoDocumentsDirectory];
        
    }
    
    return self;
}

-(void)copyDatabaseIntoDocumentsDirectory{
    //Check if database file exists in the documents directory
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (! [[NSFileManager defaultManager] fileExistsAtPath:destinationPath]){
        //the database file does not exist in the documents directory, so copy it from the main bundle now
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        //check if any error occured during copying and display it
        if (error != nil){
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    //create a sqlite object
    sqlite3 *sqlite3Database;
    
    //set the database file path
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    //initialize the results array
    if (self.arrResults != nil){
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    //initialize the column name array
    if (self.arrColumnNames != nil){
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    //open the database
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if (openDatabaseResult == SQLITE_OK){
        //Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement
        sqlite3_stmt *compiledStatement;
        
        //Load all data from database to memory
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if (prepareStatementResult == SQLITE_OK){
            
            //check if the query is non-executable
            if (!queryExecutable){
                //in this case data must be loaded from the database
                
                //Declare an array to keep the data for each fetched row
                NSMutableArray *arrDataRow;
                
                //loop through the results and add them to the results array row by row
                while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    //initialize the mutable array that will contain the data of a fetched row
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    //get the total number of columns
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    //go through all columns and fetch each column data
                    for (int i=0; i<totalColumns; i++) {
                        //convert the column data to text (characters)
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        //if there are contents in the current column (field) then add them to the current row array
                        if (dbDataAsChars != NULL){
                            //convert characters to string
                            [arrDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        //keep the current column name
                        if (self.arrColumnNames.count != totalColumns){
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    //store each fetched data row, but first check if there is actually data
                    if (arrDataRow.count != 0){
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            } else {
                //this is the case of an executable query
                
                //execute the query
                BOOL executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults ==SQLITE_DONE){
                    //keep the affected rows
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    //keep the inserted row id
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                } else {
                    //if could not execute the query show the error message on the debugger
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
                
            }
            
            //release the compiled statement from memory
            sqlite3_finalize(compiledStatement);
        }
    

    
        
        //close database
        sqlite3_close(sqlite3Database);
    }
    
    
}
































@end
