//
//  DropDownList.m
//  HTManagement
//
//  Created by lyn on 14-1-6.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "DropDownList.h"

@interface DropDownList()

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation DropDownList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showDropDownList:(UIButton *)sender withContentArray:(NSArray *)array withHeight:(CGFloat)height
{
    _button = sender;
    
    CGRect frame = sender.frame;
    _array = [NSArray arrayWithArray:array];
    
    self.frame = CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, frame.size.width, 0);
    self.layer.shadowOffset = CGSizeMake(-5, 5);
    
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8;
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.cornerRadius = 1;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor grayColor];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    
    self.frame = CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, frame.size.width, height);
    
    [UIView commitAnimations];
    [self addSubview:_tableView];

    [_button.superview addSubview:self];

}

- (void)hideDropDownList:(UIButton *)sender;
{
    CGRect frame = sender.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    
    self.frame = CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, frame.size.width, 0);
    
    [UIView commitAnimations];
    
    [self removeFromSuperview];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }

    cell.textLabel.text =[_array objectAtIndex:indexPath.row];
    //cell.textLabel.textColor = [UIColor whiteColor];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideDropDownList:_button];
    _chooseString = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if ([self.delegate respondsToSelector:@selector(dropDownListDelegateMethod:WithIndex:)]) {
        [self.delegate dropDownListDelegateMethod:_chooseString WithIndex:indexPath];

    }


    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
