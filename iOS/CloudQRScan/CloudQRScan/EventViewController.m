//
//  EventViewController.m
//  CloudQRScan
//
//  Created by Jimmy Jose (jimmy@varshyl.com) on 12/06/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "EventViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface EventViewController ()<EKEventViewDelegate,EKEventEditViewDelegate,UINavigationControllerDelegate>
@property(nonatomic,retain)EKEvent *event;
@property(nonatomic,retain)EKEventStore *eventStore;
@property(nonatomic,retain)UIBarButtonItem *back;
@property(nonatomic,retain)AppDelegate *app;
@end

@implementation EventViewController

-(id)init{

    self = [super init];
    
    return self;
}

-(void)displayEventViewForEvent:(EKEvent *)event withEventStore:(EKEventStore *)eventStore{

    _eventStore = eventStore;
    _event = event;
    
    //EKEventEditViewController *eventVC = [[EKEventEditViewController alloc] init];
    EKEventViewController *eventVC = [[EKEventViewController alloc] initWithNibName:nil bundle:nil];
    
    eventVC.event=event;
    //eventVC.eventStore = eventStore;
    //eventVC.allowsEditing = YES;
    eventVC.allowsCalendarPreview = NO;

    
    eventVC.delegate  = self;
    //eventVC.editViewDelegate = self;
    
    UIImage *backButtonImage = [UIImage imageByAppendingDeviceName:@"btn_back"];
    
    CGRect backButtonFrame = CGRectZero;
    backButtonFrame.origin.x += 5;
    backButtonFrame.size = backButtonImage.size;
    
    UIButton *button = [[UIButton alloc] initWithFrame:backButtonFrame];
    [button setImage:backButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
   
    _back = [[UIBarButtonItem alloc] initWithCustomView:button];
   
    _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _app.navigationController.delegate = self;
    
    [_app.navigationController pushViewController:eventVC animated:YES];
    
    eventVC.navigationItem.leftBarButtonItem = _back;
    eventVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
     eventVC.allowsCalendarPreview = NO;
    eventVC.delegate = self;
    //_app.navigationController.delegate = self;


}

-(void)backButtonPressed{
    
    
    [_app.navigationController popViewControllerAnimated:YES];
    
}


-(void)saveButtonPressed{

    [self saveEvent:_event];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[EKEventViewController class]]) {
        
        UITableView *tblView=((UITableViewController*)viewController).tableView;
       
        NSArray *idxArray = tblView.indexPathsForVisibleRows;

        for (NSIndexPath *indexPath in idxArray) {
            UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
            
            if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
                //cell.hidden = YES;
                //[cell removeFromSuperview];
                cell.userInteractionEnabled = NO;
                NSString *msg = [NSString stringWithFormat:@"%@ Disabled",cell.textLabel.text];
                cell.detailTextLabel.text = msg;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            }
        }
        

    }
}

-(void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action{

    switch (action) {
            
         case EKEventEditViewActionSaved:
            [self saveEvent:controller.event];
            break;
            
        case EKEventEditViewActionCanceled:
            [controller dismissModalViewControllerAnimated:YES];
            
            break;
            
        default:
            break;
    }
    
}
-(void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action{

    switch (action) {
        case EKEventViewActionDone:
            [self saveEvent:controller.event];
            break;
    case EKEventViewActionDeleted:
            
        default:
            break;
    }
    
    

}

-(void)saveEvent:(EKEvent *)event{

    
    DLog(@"%s",__func__);
    
    __block EKEvent *eve = event;
    __block EKEventStore *store = _eventStore;
    __block NSString *title = nil;
    __block NSString *msg = nil;
    
    if([_eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // iOS 6 and later
        // This line asks user's permission to access his calendar
        [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             if (granted) // user user is ok with it
             {
                 DLog(@"granted");
                 
                 
                 NSDate *startDate = event.startDate;
                 
                 // endDate is 1 day = 60*60*24 seconds = 86400 seconds from startDate
                 NSDate *endDate = event.endDate;
                 NSError *err = nil;
                 
                 /*
                 
                 // Create the predicate. Pass it the default calendar.
                 NSArray *calendarArray = [NSArray arrayWithObject:[_eventStore defaultCalendarForNewEvents]];
                 NSPredicate *predicate = [_eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendarArray];
                 
                 // Fetch all events that match the predicate.
                 NSArray *events = [_eventStore eventsMatchingPredicate:predicate];
                                  NSError *err;
                  __block NSError *error = nil;
                
                 [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                     [_eventStore removeEvent:obj span:EKSpanThisEvent error:&error];
                 }];
                */
                 
                 [event setCalendar:[_eventStore defaultCalendarForNewEvents]];


                 [_eventStore saveEvent:event span:EKSpanThisEvent error:&err];
//                 [_eventStore removeEvent:event span:(event.isDetached ? EKSpanFutureEvents : desiredSpan) commit:YES error:nil];
                // [store saveEvent:eve span:EKSpanThisEvent error:&err];
                 /*
                 @try {
                    // [_eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                     
                 }
                 @catch (NSException *exception) {
                     NSLog(@"exception %@",[exception debugDescription]);
                 }
                 @finally {
                     NSLog(@"finally");
                 }
                 
                 */
                 if(err){
                     
                     DLog(@"unable to save event to the calendar!: Error= %@", err);
                   
                     __block BlockAlertView *alert = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *title = @"Error saving to calendar";
                        NSString *msg = [NSString stringWithFormat:@"%@",[err localizedDescription]];
                        
                         alert = [BlockAlertView alertWithTitle:title message:msg];
                         [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
                         [alert show];
                     });
                    
                    
                     
                     
                 }
                 else{
                     
                      DLog(@"saved");
                     
                     msg = @"Event saved to calendar successfully";
                    
                     __block BlockAlertView *alert = nil;
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                     //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                      
                         alert = [BlockAlertView alertWithTitle:nil message:@"Event saved to calendar successfully"];
                         
                         [alert setOKButtonWithBlock:^{
                             // [self backButtonPressed];
                         }];
                         [alert show];
                     });
                        // NSString *msg = @"Event saved to calendar successfully";
                       
                         
                      //  alert = [BlockAlertView alertWithTitle:nil message:@"Event saved to calendar successfully"];
                      
                        // [alert setDestructiveButtonWithTitle:@"Dismiss" block:^{
                            // [self backButtonPressed];
                        // }];
                        // [alert show];
                         
                    // });
                     
                     
                     
                 }
                 
             }
             else // if he does not allow
             {
                 DLog(@"if he does not allow");
                 __block BlockAlertView *alert = nil;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     NSString *msg = @"Please permit the app to save to calendar";
                     
                     alert = [BlockAlertView alertWithTitle:nil message:msg];
                     [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
                     [alert show];
                 });
                 
                 return;
             }
         }];
    }
    
    // iOS < 6
    else
    {
        [event setCalendar:[_eventStore defaultCalendarForNewEvents]];
        NSError *err;
        
        [_eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        
        DLog(@"ios <6");
        
        if(err){
            DLog(@"error <6");
            __block BlockAlertView *alert = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *title = @"Error saving to calendar";
                NSString *msg = [NSString stringWithFormat:@"%@",[err localizedDescription]];

                alert = [BlockAlertView alertWithTitle:title message:msg];
                [alert setDestructiveButtonWithTitle:@"Dismiss" block:NULL];
                [alert show];
            });
            
            
        }
        else{
            DLog(@"saved second else");
            __block BlockAlertView *alert = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *msg = @"Event saved to calendar successfully";
                
                alert = [BlockAlertView alertWithTitle:nil message:msg];
                [alert setOKButtonWithBlock:^{
                    [self backButtonPressed];
                }];
                [alert show];
                
            });
            
        }
    }
   
    /*
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:msg];
    [alert setDestructiveButtonWithTitle:@"Dismiss" block:^{
        [self backButtonPressed];
    }];
    [alert show];
     */
    
    //[_app.navigationController popViewControllerAnimated:YES];
    
}

@end
