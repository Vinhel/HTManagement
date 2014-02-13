//
//  HouseKeepingCell.m
//  HTManagement
//
//  Created by lyn on 14-1-15.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "HouseKeepingCell.h"

@implementation HouseKeepingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _cellHeight = 134;

    }
    return self;
}

- (void)setForm:(HouseKeepingForm *)form
{
    _form = form;
    
    _contentLabel.text = [NSString stringWithFormat:@"内容: %@",form.content] ;
    _handlerLabel.text = [NSString stringWithFormat:@"工作人员: %@",form.handler];
    // cell.typeLabel.text = form.item;
    // cell.statusLabel.text = [NSString stringWithFormat:@"%d", form.deal_status ];
    // NSLog(@"%d",form.deal_status);
    _timeLabel.text = form.time;
    _itemLabel.text = [NSString stringWithFormat:@"项目: %@",form.item];
    _priceLabel.text = [NSString stringWithFormat:@"价格: %@",form.price_description];
    _remarksLabel.text = [NSString stringWithFormat:@"备注: %@",form.remarks];
    _authorLabel.text = [NSString stringWithFormat:@"业主: %@",form.author];
    
    if (_form.deal_status == 3) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(7, 153, 58, 21)];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"满意度";
        
        [self addSubview:label];
        
        _cellHeight = 168;
        UIButton *feedBack = [[UIButton alloc]initWithFrame:CGRectMake(74, 153, 60, 30)];
        feedBack.enabled = NO;
        [feedBack setTitle:form.pleased ? [NSString stringWithFormat:@"%ld",(long)form.pleased]:@"点击评价" forState:UIControlStateNormal];
        [feedBack addTarget:self action:@selector(feedBack:) forControlEvents:UIControlEventTouchUpInside];
        feedBack.titleLabel.font = [UIFont systemFontOfSize:13];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"role"] isEqualToString:@"resident"]&&form.pleased ==0) {
            feedBack.enabled = YES;
        }
        [feedBack setBackgroundColor:[UIColor greenColor]];
        [self addSubview:feedBack];
    }
    
    if (_form.deal_status ==2 &&[[[NSUserDefaults standardUserDefaults] objectForKey:@"role"] isEqualToString:@"worker"]) {
        UIButton *finishButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 105, 60, 29)];
        [finishButton setTitle:@"完成" forState:UIControlStateNormal];
        finishButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [finishButton setBackgroundColor:[UIColor greenColor]];
        [finishButton addTarget:self action:@selector(finishHouseKeepingItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finishButton];
    }
    
    if (_form.deal_status ==1&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"role"] isEqualToString:@"admin"]) {
        UIButton *assignButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 105, 60, 29)];
        [assignButton setTitle:@"分配人员" forState:UIControlStateNormal];
        assignButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [assignButton setBackgroundColor:[UIColor greenColor]];
        [assignButton addTarget:self action:@selector(chooseHouseKeepingWorker:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:assignButton];
    }

}

#pragma mark - Button click methods
- (void)feedBack:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedBack:)]) {
        [self.delegate feedBack:_form];
    }
}

- (void)finishHouseKeepingItem:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishHouseKeepingItem:)]) {
        [self.delegate finishHouseKeepingItem:_form];
    }

}

- (void)chooseHouseKeepingWorker:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseHouseKeepingWorker:)]) {
        [self.delegate chooseHouseKeepingWorker:_form];
    }

}

#pragma mark -
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
