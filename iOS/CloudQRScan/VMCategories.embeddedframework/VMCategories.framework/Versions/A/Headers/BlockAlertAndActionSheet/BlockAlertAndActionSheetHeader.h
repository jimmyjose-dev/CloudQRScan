
//
//  Header.h
//  VMCategories
//
//  Created by Jimmy on 29/06/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import "BlockAlertView.h"
#import "BlockActionSheet.h"
#import "BlockTextPromptAlertView.h"

/*

 - (IBAction)showAlert:(id)sender
 {
 BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:@"This is a very long message, designed just to show you how smart this class is"];
 
 
 
 [alert setCancelButtonWithTitle:@"Cancel" block:nil];
 [alert setDestructiveButtonWithTitle:@"Kill!" block:nil];
 [alert addButtonWithTitle:@"Show Action Sheet on top" imageIdentifier:@"yellow" block:^{
 [self showActionSheet:nil];
 }];
 [alert addButtonWithTitle:@"Show another alert" imageIdentifier:@"green" block:^{
 [self showAlert:nil];
 }];
 [alert show];
 }
 
 - (IBAction)showActionSheet:(id)sender
 {
 BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"This is a sheet title that will span more than one line"];
 [sheet setCancelButtonWithTitle:@"Cancel Button" block:nil];
 [sheet setDestructiveButtonWithTitle:@"Destructive Button" block:nil];
 [sheet addButtonWithTitle:@"Show Action Sheet on top" block:^{
 [self showActionSheet:nil];
 }];
 [sheet addButtonWithTitle:@"Show another alert" block:^{
 [self showAlert:nil];
 }];
 [sheet showInView:self.view];
 }
 
 - (IBAction)showAlertPlusActionSheet:(id)sender
 {
 [self showAlert:nil];
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
 [self showActionSheet:nil];
 });
 }
 
 - (IBAction)showActionSheetPlusAlert:(id)sender
 {
 [self showActionSheet:nil];
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
 [self showAlert:nil];
 });
 }
 
 - (IBAction)goNuts:(id)sender
 {
 for (int i=0; i<6; i++)
 {
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * i * NSEC_PER_SEC);
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
 if (arc4random() % 2 == 0)
 [self showAlert:nil];
 else
 [self showActionSheet:nil];
 });
 }
 }
 
 - (IBAction)showTextPrompt:(id)sender
 {
 UITextField *textField;
 BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:@"Encrypted QRcode from Jimmy" message:@"Please enter password" textField:&textField block:^(BlockTextPromptAlertView *alert){
 [alert.textField resignFirstResponder];
 return YES;
 }];
 
 
 [alert setCancelButtonWithTitle:@"Cancel" block:nil];
 [alert addButtonWithTitle:@"Verify" block:^{
 NSLog(@"Text: %@", textField.text);
 }];
 
 [alert addButtonWithTitle:@"Device Authorize" block:^{
 NSLog(@"Text: %@", textField.text);
 }];
 
 [alert show];
 }

*/