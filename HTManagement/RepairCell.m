//
//  RepairCell.m
//  HTManagement
//
//  Created by lyn on 13-12-31.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import "RepairCell.h"
#import "WorkerInfo.h"

#define marginHeight 5.0f


@implementation RepairCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // Initialization code
      
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setRepairForm:(RepairForm *)repairForm
{
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand"]]];

    _repairForm = repairForm;
    CGRect cellFrame = [self frame];
    
    CGFloat cellHeight = 62;
    cellHeight += marginHeight;
    
    _typeLabel.text = [NSString stringWithFormat:@"报修类型: %@",_repairForm.repair_type];
    _workerLabel.text = [NSString stringWithFormat:@"处理人员: %@",_repairForm.handler];
    //_workerLabel.alpha = [_repairForm.handler isEqualToString:@"None"] ? 0 : 1;
    _workerLabel.alpha = 0;
    _ownerLabel.text = [NSString stringWithFormat:@"报修人员: %@    地址: %d 栋 %d 室",_repairForm.repair_author,_repairForm.author_floor,_repairForm.author_room];
    
    CGRect rect = _contentLabel.frame;
    rect.origin.y = cellHeight;
    [_contentLabel setFrame:rect];
    
    _contentLabel.text = [NSString stringWithFormat:@"内容描述: %@",[_repairForm.content isEqualToString:@""]?@"无":_repairForm.content];
    [_contentLabel sizeToFit];
    
    cellHeight += _contentLabel.frame.size.height;
    cellHeight += marginHeight;
    
    NSLog(@"repair imgsrc %@",_repairForm.imgSrc);
    if (![_repairForm.imgSrc isEqualToString:@""]&& _repairForm.imgSrc) {
        CGRect rect = _imgView.frame;
        rect.origin.y = cellHeight;
        rect.origin.x = 0;
        [_imgView setFrame:rect] ;
        
        cellHeight += _imgView.frame.size.height;
        
        [_imgView setImageWithURL:[NSURL URLWithString:[imagePath stringByAppendingString:_repairForm.imgSrc]] placeholderImage:[UIImage imageNamed:@"报修"]];
        NSLog(@"downloaded %f",_imgView.frame.size.height);
        cellHeight += marginHeight;
    }
    
    rect = _timeLabel.frame;
    _timeLabel.text = [NSString stringWithFormat:@"时间:%@",_repairForm.time];
    rect.origin.y = cellHeight;
    [_timeLabel setFrame:rect];
    rect = _satisfactionLabel.frame;
    
    
    if (_repairForm.deal_status ==1 && isAdmin) {
        
        rect.origin.y = cellHeight;
        rect.origin.x = 173;
        
        UIButton *button = [[UIButton alloc]initWithFrame:rect];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.backgroundColor = RGBA(111, 235, 255, 1);
        [button setTitle:@"分配人员" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseRepairWorkerClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    if (_repairForm.deal_status == 2 && isWorker) {
        
        rect.origin.y = cellHeight;
        rect.origin.x = 173;
        UIButton *button = [[UIButton alloc]initWithFrame:rect];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.backgroundColor = RGBA(111, 235, 255, 1);
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(finishRepairItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    if (_repairForm.deal_status ==4 && isWorker) {
        rect.origin.y = cellHeight;
        rect.origin.x = 173;
        UIButton *button = [[UIButton alloc]initWithFrame:rect];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.backgroundColor = RGBA(111, 235, 255, 1);
        [button setTitle:@"接受受理" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(acceptRepairClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    if (_repairForm.deal_status == 3 )
    {
        _satisfactionLabel.alpha = 1;
        rect.origin.y = cellHeight;
        [_satisfactionLabel setFrame:rect];
        
       // _feedbackButton.alpha = 1;
        
        rect.origin.x = 241;
        UIButton *button = [[UIButton alloc]initWithFrame:rect];
        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(feedBackClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button.enabled = NO;
        NSString *string;
        
        switch (_repairForm.pleased) {
            case 0:
                string = @"待评价";
                break;
            case 1:
                string = @"差";
                break;
            case 2:
                string = @"一般";
                break;
                
            default:
                string = @"满意";
                break;
        }
        
        [button setTitle:string forState:UIControlStateNormal];
        if (_repairForm.pleased == 0 && isResident) {
            
            button.enabled = YES;
        }
    }
    
    cellHeight += _timeLabel.frame.size.height;
    cellFrame.size.height = cellHeight;

    [self setFrame:cellFrame];
    
}

#pragma mark - button click

- (void)chooseRepairWorkerClick:(id)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseRepairWorker:)]) {
        [self.delegate chooseRepairWorker:_repairForm];
    }
    
}

- (void)finishRepairItemClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishRepairItem:)]) {
        [self.delegate finishRepairItem:_repairForm];
    }}

- (void)feedBackClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedBack:)]) {
        [self.delegate feedBack:_repairForm];
    }
}

- (void)acceptRepairClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(acceptRepair:)]) {
        [self.delegate acceptRepair:_repairForm];
    }


}

@end
