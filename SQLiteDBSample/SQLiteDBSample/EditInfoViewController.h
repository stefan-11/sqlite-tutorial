//
//  EditInfoViewController.h
//  SQLiteDBSample
//
//  Created by Stefan Will on 08.05.15.
//  Copyright (c) 2015 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditInfoViewControllerDelegate
-(void)editingInfoWasFinished;
@end

@interface EditInfoViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;
@property (weak, nonatomic) IBOutlet UITextField *txtLastname;
@property (weak, nonatomic) IBOutlet UITextField *txtAge;

@property (nonatomic, strong) id<EditInfoViewControllerDelegate> delegate;

-(IBAction)saveInfo:(id)sender;



@end
