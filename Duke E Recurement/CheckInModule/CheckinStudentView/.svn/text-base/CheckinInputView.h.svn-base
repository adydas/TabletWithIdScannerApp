//
//  CheckinInputView.h
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckinInputView : UIView<UITextFieldDelegate>{
    
    IBOutlet UITextField *studentIDTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *fNameTxt;
    IBOutlet UITextField *lNameTxt;
    
    IBOutlet UILabel *eventNameLbl;
    IBOutlet UIScrollView *scrollView;
    
    NSString *eventID;
    NSString *eventName;
    int sID;
    
    IBOutlet UIButton *keypadBtn;
    IBOutlet UIButton *qrCodeBtn;
    
    
}

+(CheckinInputView*)loadInstanceFromNib;

@property(nonatomic,retain)NSString *eventID;
@property(nonatomic,retain)NSString *eventName;


-(void)performCheckinbyStudentID;
-(void)performCheckinbyStudentName;
-(void)performCheckinbyEmail;
-(void)removeOverLay:(NSDictionary*) results;
-(void)populateData;
- (void)removeKeyBoard;
-(void)keyboardWillShow; 
-(void)keyboardWillHide;
@end
