//
//  KBKeyboardHandler.h
//  VMCategories
//
//  Created by Jimmy on 29/06/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KBKeyboardHandlerDelegate

@optional
- (void)keyboardSizeChanged:(CGSize)delta;
- (void)keyboardWillAppear;
- (void)keyboardWillDisappear;

@end

@interface KBKeyboardHandler : NSObject

- (id)init;

@property(nonatomic, weak) id<KBKeyboardHandlerDelegate> delegate;
@property(nonatomic) CGRect frame;

@end

/*

 keyboard = [[KBKeyboardHandler alloc] init];
 keyboard.delegate = self;
 
 - (void)keyboardWillAppear{
 
 }
 
 - (void)keyboardWillDisappear{
 
 }
 
 - (void)keyboardSizeChanged:(CGSize)delta
 {
 // Resize / reposition your views here. All actions performed here
 // will appear animated.
 // delta is the difference between the previous size of the keyboard
 // and the new one.
 // For instance when the keyboard is shown,
 // delta may has width=768, height=264,
 // when the keyboard is hidden: width=-768, height=-264.
 // Use keyboard.frame.size to get the real keyboard size.
 
 // Sample:
 CGRect frame = self.view.frame;
 frame.size.height -= delta.height;
 self.view.frame = frame;
 }
 
*/