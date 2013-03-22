//
//  MainViewController.h
//  Smarthome
//
//  Created by Nguyen Huynh on 3/11/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iData.h"

enum {
    FLOOR_TABLE = 0,
    ITEM_TABLE
};

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITableView* _floorTable;
    UITableView* _itemTable;
    NSMutableArray* _floorViewArr;
    NSArray* _floorArr;
    NSMutableArray* _itemArr;
    NSMutableArray* _iconArr;
    UIView* _currentView;
    NSMutableArray* _iconAddInScreen;
    UIImageView* _currentTouch;
    int _viewState;
    
    iData* data;
    NSArray* _colorTmp;
    int iColor;
}
@property (weak, nonatomic) IBOutlet UITextField *floorField;
@property (weak, nonatomic) IBOutlet UIButton *floorAdd;
- (IBAction)AddFloor:(id)sender;

@end
