//
//  AppDelegate.m
//  TextFieldBlurrDemo
//
//  Created by Shaadi_mac1 on 07/02/15.
//  Copyright (c) 2015 Ashish. All rights reserved.
//

#import "AppDelegate.h"
#import <AddressBook/AddressBook.h>

@interface AppDelegate ()
{
    NSMutableArray *contactList;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self showAddressBook];
    return YES;
}

-(void)showAddressBook
{
    
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self sendContactToServer:addressBookRef];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be fetched
                
                UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Access Denied" message: @"Unable to fetch contacts" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                [cantAddContactAlert show];
                
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self sendContactToServer:addressBookRef];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        
        UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot fetch Contact" message: @"You must give the app permission to fetch the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [cantAddContactAlert show];
    }
}

-(void)sendContactToServer:(ABAddressBookRef )addressBookRef
{
    [self retrievePeopleFromAddressBook:addressBookRef];
    
    // send to server request and connection starts here
    
    
}

- (void)retrievePeopleFromAddressBook:(ABAddressBookRef)addressBook
{
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 if (error || !granted)
                                                 {
                                                     // handle error
                                                     NSLog(@"ERROR: %@", error);
                                                 }
                                                 else
                                                 {
                                                     CFArrayRef peopleFromAddressBook = ABAddressBookCopyArrayOfAllPeople(addressBook);
                                                     CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
                                                     
                                                     // using Magical Record to get all the people from CoreData
                                                     contactList=[[NSMutableArray alloc] init];
                                                     
                                                     for (int i = 0; i < numberOfPeople; i++)
                                                     {
                                                         
                                                         ABRecordRef personRecord = CFArrayGetValueAtIndex(peopleFromAddressBook, i);
                                                         
                                                         [self addPerson:personRecord];
                                                         
                                                     }
                                                     NSLog(@"Your Contacts %@",contactList);
                                                     
                                                 }
                                                 
                                             });
}

- (void)addPerson:(ABRecordRef)person
{
    
    NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
    
    // getting Contact Name
    
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                         kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
    
    //    NSLog(@"\nname %@ %@", firstName, lastName);
    
    // getting phone number
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,kABPersonPhoneProperty);
    NSMutableArray *phoneArray = [[NSMutableArray alloc]init];
    
    if (ABMultiValueGetCount(phoneNumbers) > 0)
    {
        for (int i = 0; i < ABMultiValueGetCount(phoneNumbers); i++)
        {
            phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            
            [phoneArray addObject:phone];
        }
    }
    else
    {
        phone = @"[None]";
        [phoneArray addObject:phone];
    }
    [dOfPerson setObject:phoneArray forKey:@"phone"];
    CFRelease(phoneNumbers);
    // NSLog(@"phone %@", phone);
    
    // getting emailIds
    
    NSString* email = nil;
    ABMultiValueRef emailIds = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSMutableArray * emailArray = [[NSMutableArray alloc]init];
    if (ABMultiValueGetCount(emailIds) > 0)
    {
        for (int i = 0; i < ABMultiValueGetCount(emailIds); i++)
        {
            email = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(emailIds, i);
            [emailArray addObject:email];
        }
    }
    else
    {
        email = @"[None]";
        [emailArray addObject:email];
    }
    [dOfPerson setObject:emailArray forKey:@"email"];
    CFRelease(emailIds);
    //  NSLog(@"email %@", email);
    
    // get modification date
    NSDate *modificationDate = (__bridge_transfer NSDate*)ABRecordCopyValue(person , kABPersonModificationDateProperty);
    [dOfPerson setObject:modificationDate forKey:@"modification_date"];
    
    [contactList addObject:dOfPerson];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
