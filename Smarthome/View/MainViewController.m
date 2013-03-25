//
//  MainViewController.m
//  Smarthome
//
//  Created by Nguyen Huynh on 3/11/13.
//  Copyright (c) 2013 Nguyen Huynh. All rights reserved.
//

#import "MainViewController.h"
#import "floor.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [iData shareInstance];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)init
{
    self = [super init];
    _floorTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, 150, self.view.frame.size.height - 100)];
    _floorTable.delegate = self;
    _floorTable.dataSource = self;
    _floorTable.tag = FLOOR_TABLE;
    [self.view addSubview:_floorTable];
    
    _itemTable = [[UITableView alloc]initWithFrame:CGRectMake(170, 10, 320, self.view.frame.size.height)];
    _itemTable.delegate = self;
    _itemTable.dataSource = self;
    _itemTable.tag = ITEM_TABLE;
    [self.view addSubview:_itemTable];
    
    _floorArr = [data getFloorList];
    _itemArr = [data getItemList];
    _iconArr = [[NSMutableArray alloc]initWithObjects:@"lighthub.png",@"light.png",@"fan.png",@"door.png", nil];
    _floorViewArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < _floorArr.count; ++i) {
        [self AddViewForFloor:[_floorArr objectAtIndex:i]];
    }
    NSLog(@"count: %d", [_floorViewArr count]);
    //_currentView = [_floorViewArr objectAtIndex:0];
    //[self.view addSubview:_currentView.view];
    _iconAddInScreen = [[NSMutableArray alloc]init];
    _viewState = 0;
    _currentTouch = nil;
    [_floorAdd setEnabled:NO];
    
    //_colorTmp = [[NSArray alloc]initWithObjects:[UIColor blackColor],[UIColor blueColor], [UIColor whiteColor], nil];
    iColor = 0;
    return self;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == ITEM_TABLE)
    {
        return [_itemArr count];
    }
    return [[data getFloorList] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (tableView.tag == FLOOR_TABLE)
    {
        cell.textLabel.text = [_floorArr objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [_itemArr objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[_iconArr objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)AddViewForFloor:(NSString*) floorName;
{
    UISwipeGestureRecognizer* leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(LeftSwipeAction)];
    [leftSwipe setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    UISwipeGestureRecognizer* rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(RightSwipeAction)];
    [rightSwipe setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    Floor* floor = [[Floor alloc]initFloorWithFrame:(CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height)) ImageBackground:nil Name:floorName Gesture:[NSArray arrayWithObjects:leftSwipe, rightSwipe, nil]];
    if (_currentView.view)
    {
        [_currentView.view removeFromSuperview];
    }
    [_floorViewArr addObject:floor];
    _currentView = [_floorViewArr objectAtIndex:(_floorViewArr.count - 1) ];
    [self.view addSubview:_currentView.view];
}

-(void)LeftSwipeAction
{
    _currentTouch = nil;
    if (_viewState == 1)
        return;
        ++_viewState;
    [self MoveView];
}

-(void)RightSwipeAction
{
    _currentTouch = nil;
    if (_viewState == -1)
        return;
    --_viewState;
    [self MoveView];
}

-(void)MoveView
{
    NSLog(@"current View State: %d",_viewState);
    CGPoint _centerViewPoint = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2+20);
    switch (_viewState) {
        case -1:
            _centerViewPoint = CGPointMake(self.view.frame.size.width/2 + 150, self.view.frame.size.height/2+20);
            break;
        case 0:
            
            break;
        case 1:
            
            _centerViewPoint = CGPointMake(self.view.frame.size.width/2 - 150, self.view.frame.size.height/2+20);
            break;            
        default:
            break;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _currentView.view.center = _centerViewPoint;
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == ITEM_TABLE)
    {
        iCon* icon = [[iCon alloc]init];
        icon.img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_iconArr objectAtIndex:indexPath.row]]];
        icon.img.center = CGPointMake(100, 100);
        //icon.name =
        [_currentView.view addSubview:icon.img];
        [_iconAddInScreen addObject:icon];
        [data addNewIcon:icon.name toFloor:_currentView.name atPosition:icon.img.center];
        _viewState = 0;
        [self MoveView];
    }
    else
    {
        [_currentView.view removeFromSuperview];
        _currentView = [_floorViewArr objectAtIndex:indexPath.row];
        _viewState = 0;
        [self MoveView];
        [self.view addSubview:_currentView.view];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch began");
    //[_floorField resignFirstResponder];
    UITouch* touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
    for (iCon* iconView in _iconAddInScreen)
    {
        if (CGRectContainsPoint([iconView.img frame], touchPoint))
        {
            _currentTouch = iconView;
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_currentTouch)
    {
        UITouch* touch = [[event allTouches] anyObject];
        CGPoint touchPoint = [touch locationInView:touch.view];
        _currentTouch.img.center = touchPoint;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //data addNewIcon:<#(NSString *)#> toFloor:<#(NSString *)#> atPosition:<#(CGPoint)#>
    _currentTouch = nil;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.center = CGPointMake(320/2, 480/2-216);
    }];
    [_floorAdd setEnabled:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.center = CGPointMake(320/2, 480/2);
    }];
}



- (IBAction)AddFloor:(id)sender {
    [_floorField resignFirstResponder];
    [data insertToFloorWithName:_floorField.text];
    _floorArr = [data getFloorList];
    [self AddViewForFloor:_floorField.text];
    [_floorField setText:@""];
    [_floorAdd setEnabled:NO];
    [_floorTable reloadData];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == FLOOR_TABLE && editingStyle == UITableViewCellEditingStyleDelete)
    {
        [data removeFloorWithName:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_floorViewArr removeObjectAtIndex:indexPath.row];
    }
}
@end
