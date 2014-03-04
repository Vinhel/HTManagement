//
//  ComplainCell.m
//  HTManagement
//
//  Created by lyn on 14-1-15.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "ComplainCell.h"
#import "WorkerInfo.h"

#define marginHeight 5.0f


@implementation ComplainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setComplainForm:(ComplainForm *)complainForm
{
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand"]]];
    _complainForm = complainForm;
    CGRect cellFrame = [self frame];
    
    CGFloat cellHeight = 70;
    cellHeight += marginHeight;
    
    _typeLabel.text = [NSString stringWithFormat:@"投诉类型: %@",_complainForm.complainType] ;
    _handlerLabel.text = [NSString stringWithFormat:@"处理人员: %@",_complainForm.handler];
    _handlerLabel.alpha = [_complainForm.handler isEqualToString:@"None"] ? 0 : 1;
    _ownerLabel.text = [NSString stringWithFormat:@"投诉人员: %@",_complainForm.complain_author];
   
    CGRect rect = _contentLabel.frame;
    rect.origin.y = cellHeight;
    [_contentLabel setFrame:rect];

    _contentLabel.text = [NSString stringWithFormat:@"内容描述: %@",[_complainForm.content isEqualToString:@""]?@"无":_complainForm.content];
    [_contentLabel sizeToFit];
    
    cellHeight += _contentLabel.frame.size.height;
    cellHeight += marginHeight;
    
    if (![_complainForm.imgSrc isEqualToString:@""]) {
        NSLog(@"imgsrc %@",[imagePath stringByAppendingString:_complainForm.imgSrc]);
        CGRect rect = _imgView.frame;
        rect.origin.y = cellHeight;
        rect.origin.x = 0;
        [_imgView setFrame:rect] ;
        cellHeight += _imgView.frame.size.height;
        
        [_imgView setImageWithURL:[NSURL URLWithString:[imagePath stringByAppendingString:_complainForm.imgSrc]] placeholderImage:[UIImage imageNamed:@"投诉"]];
        
        
        cellHeight += marginHeight;
    }

    _timeLabel.text = [NSString stringWithFormat:@"时间:%@",_complainForm.time];
    rect = _timeLabel.frame;
    rect.origin.y = cellHeight;
    [_timeLabel setFrame:rect];
    
    rect = _satisfactionLabel.frame;

   
    if (_complainForm.deal_status ==1 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"role"] isEqualToString:@"admin"]) {
        
        rect.origin.y = cellHeight;
        rect.origin.x = 173;
       
        UIButton *button = [[UIButton alloc]initWithFrame:rect];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:@"分配人员" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseComplainWorkerClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    if (_complainForm.deal_status == 4 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"role"] isEqualToString:@"worker"]) {
        
        rect.origin.y = cellHeight;
        rect.origin.x = 173;
        UIButton *button = [[UIButton alloc]initWithFrame:rect];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:@"接受受理" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(acceptComplainClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    if (_complainForm.deal_status == 2 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"role"] isEqualToString:@"worker"]) {
       
        rect.origin.y = cellHeight;
        rect.origin.x = 173;
        UIButton *button = [[UIButton alloc]initWithFrame:rect];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(finishComplainItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    if (_complainForm.deal_status == 3 )
    {
        _satisfactionLabel.alpha = 1;
        rect.origin.y = cellHeight;
        [_satisfactionLabel setFrame:rect];
        
        //_feedbackButton.alpha = 1;
     
        rect.origin.x = 241;
        UIButton *button = [[UIButton alloc]initWithFrame:rect];
        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(feedBackClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button.enabled = NO;
        [button setTitle:_complainForm.pleased ?[NSString stringWithFormat:@"%d",_complainForm.pleased]:@"评价" forState:UIControlStateNormal];
        
        
        if (_complainForm.pleased == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"role"] isEqualToString:@"resident"]) {
            
            button.enabled = YES;
        }
    }
    
    cellHeight += _timeLabel.frame.size.height;
    cellFrame.size.height = cellHeight;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor redColor]CGColor];
    self.layer.cornerRadius = 5;
    [self setFrame:cellFrame];
    
}

#pragma mark - button click

- (void)chooseComplainWorkerClick:(id)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseComplainWorker:)]) {
        [self.delegate chooseComplainWorker:_complainForm];
    }
    
}

- (void)finishComplainItemClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishComplainItem:)]) {
        [self.delegate finishComplainItem:_complainForm];
    }}

- (void)feedBackClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedBack:)]) {
        [self.delegate feedBack:_complainForm];
    }
}


- (void)acceptComplainClick:(id)sender
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(acceptComplain:)]) {
        [self.delegate acceptComplain:_complainForm];
    }

}

#pragma mark
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
