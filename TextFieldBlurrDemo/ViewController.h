//
//  ViewController.h
//  TextFieldBlurrDemo
//
//  Created by Shaadi_mac1 on 07/02/15.
//  Copyright (c) 2015 Ashish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCRBlurView.h"
#import "FXBlurView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *blurrBtn;
- (IBAction)blurrAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIVisualEffectView *visual;
@property (weak, nonatomic) IBOutlet JCRBlurView *blurView1;
@property (weak, nonatomic) IBOutlet FXBlurView *blurView2;

@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)displayContactList:(UIButton *)sender;

// AddressBook
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;

-(void)showAddressBook;

@end

