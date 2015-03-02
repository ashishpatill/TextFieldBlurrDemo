//
//  ViewController.m
//  TextFieldBlurrDemo
//
//  Created by Shaadi_mac1 on 07/02/15.
//  Copyright (c) 2015 Ashish. All rights reserved.
//

#import "ViewController.h"
#import "Contact.h"

@interface ViewController ()
{
    NSMutableArray *contactList;
    
    UIView *loadingMoreDataView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.visual = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    [self.visual setFrame:CGRectMake(20, 230, 280, 100)];
//    [self.visual setBackgroundColor:[UIColor darkGrayColor]];
//    [self.view addSubview:self.visual];
    
//    [self.visual setHidden:YES];

    self.blurView1.blurTintColor = [UIColor clearColor];
    
    self.blurView2.dynamic = YES;
    self.blurView2.blurRadius = 8.0;
    [self.blurView2 setTintColor:[UIColor clearColor]];
    
    [self showLoadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)blurrAction:(id)sender {
    
    if(self.blurrBtn.selected == YES)
    {
        [sender setSelected:NO];
        [self.blurView1 setHidden:NO];
    }
    else
    {
        [sender setSelected:YES];
        [self.blurView1 setHidden:YES];
    }
}

#pragma mark Fetch Contacts

- (IBAction)displayContactList:(UIButton *)sender
{
    [self showAddressBook];
}

-(void)showLoadingView
{
    
    loadingMoreDataView = [[UIView alloc] initWithFrame:CGRectMake(0.0,100 ,320,200)];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activity.color = UIColorFromRGB(0x817B71);
    activity.frame = CGRectMake((loadingMoreDataView.frame.size.width/2) - (15.0/2),0.0, 15.0, 15.0);
    [loadingMoreDataView addSubview:activity];
    [activity startAnimating];
    
    
    UILabel *lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0.0,30.0,loadingMoreDataView.frame.size.width,15.0)];
//    lblLoading.font = [UIFont customFontWithSize:13.0];
//    lblLoading.textColor = UIColorFromRGB(0x817B71);
    lblLoading.textAlignment = NSTextAlignmentCenter;
    lblLoading.text = @"Loading More Profiles";
    [lblLoading setBackgroundColor:[UIColor redColor]];
    [loadingMoreDataView addSubview:lblLoading];
    
    [loadingMoreDataView setBackgroundColor:[UIColor yellowColor]];
    
    [self.view insertSubview:loadingMoreDataView atIndex:4];
    //    [self.view bringSubviewToFront:loadingMoreDataView];
    
}



-(NSArray *)getUpdatedContacts:(ABRecordRef)person:(NSArray *)allContacts
{
//    if(ABRecordGetRecordType(record) ==  kABPersonType) // this check execute if it is person group
//    {
//        ABRecordID recordId = ABRecordGetRecordID(record); // get record id from address book record
//        
//        recordIdString = [NSString stringWithFormat:@"%d",recordId]; // get record id string from record id
//        
//        NSDate *modificationDate = (__bridge NSDate*) ABRecordCopyValue(record, kABPersonModificationDateProperty);
//        NSLog(@"modificationDate %@",modificationDate);
//        
//        firstNameString = (__bridge NSString*)ABRecordCopyValue(record,kABPersonFirstNameProperty); // fetch contact first name from address book
//        lastNameString = (__bridge NSString*)ABRecordCopyValue(record,kABPersonLastNameProperty); // fetch contact last
//        
//    }
    
    // Build a predicate that searches for contacts with at least one phone number starting with (408).
    NSPredicate* predicate = [NSPredicate predicateWithBlock: ^(id record, NSDictionary* bindings)
    {
        NSDate *modificationDate = (__bridge_transfer NSDate*)ABRecordCopyValue((__bridge ABRecordRef)(record) , kABPersonModificationDateProperty);
        
        if ([[NSDate date] compare:modificationDate] == NSOrderedDescending) {
            
        }
        BOOL result = NO;
        
       
        NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty); // fetch contact first name from address book
        NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty); // fetch contact last name from address book

        
        return result;
    }];
    NSArray* filteredContacts = [allContacts filteredArrayUsingPredicate:predicate];
    return filteredContacts;
}

@end
