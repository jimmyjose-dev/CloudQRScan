//
//  UIView+Frame.h
//  VMCategories
//
//  Created by Jimmy on 14/06/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property(nonatomic,retain)NSString *tagName;

- (UIImage *)screenshot;

-(void)setTagName:(NSString *)aTagName;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)newOrigin;
- (CGSize)size;
- (void)setSize:(CGSize)newSize;

- (CGFloat)x;
- (void)setX:(CGFloat)newX;
- (CGFloat)y;
- (void)setY:(CGFloat)newY;

- (CGFloat)height;
- (void)setHeight:(CGFloat)newHeight;
- (CGFloat)width;
- (void)setWidth:(CGFloat)newWidth;

- (void)printSubViewAtLevel:(int)level;
- (void)printSubView;


-(BOOL)hasViewWithTag:(int)tag;
-(BOOL)hasViewWithTagName:(NSString *)tagName;
-(BOOL)hasViewWithKindOfClass:(NSString *)className;

-(id)subViewWithTag:(int)tag;
-(id)viewWithTagName:(NSString *)tagName;
-(id)viewWithKindOfClass:(NSString *)className;


-(BOOL)hasViewWithKindOfClass:(NSString *)className andTag:(int)tag;
-(BOOL)hasViewWithKindOfClass:(NSString *)className andTagName:(NSString *)tagName;
-(BOOL)hasViewWithKindOfClass:(NSString *)className tag:(int)tag andTagName:(NSString *)tagName;


-(id)viewWithKindOfClass:(NSString *)className andTag:(int)tag;
-(id)viewWithKindOfClass:(NSString *)className andTagName:(NSString *)tagName;
-(id)viewWithKindOfClass:(NSString *)className tag:(int)tag andTagName:(NSString *)tagName;

- (void)moveViewForInputField:(UIControl *)inputField withPadding:(float)padding animate:(BOOL)animate;
- (void)moveViewForInputField:(UIControl *)inputField withPadding:(float)padding;
- (void)resetView;

/*
 
 @property (nonatomic, assign) UIControl *currentControl;
 
 - (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
 currentControl = textField;
 return YES;
 }
 
 - (void) textFieldDidBeginEditing:(UITextField *)textField {
 [self.view moveViewForControl:textField offset:0.0f];
 }
 
 - (void)textFieldDidEndEditing:(UITextField *)textField {
 if (textField == currentControl) {
 //If the textfield is still the same one, we can reset the view animated
 [self.view resetView];
 }else {
 //However, if the currentControl has changed - that indicates the user has
 //gone into another control - so don't reset view, otherwise animations jump around
 }
 }

 
 */


@end
