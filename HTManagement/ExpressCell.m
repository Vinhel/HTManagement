//
//  ExpressCell.m
//  HTManagement
//
//  Created by lyn on 14-1-3.
//  Copyright (c) 2014年 SFI-china. All rights reserved.
//

#import "ExpressCell.h"
#import "ExpressForm.h"


@implementation ExpressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setExpressForm:(ExpressForm *) expressForm
{
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand"]]];

    _expressForm = expressForm;
    
    _userLabel.text = [NSString stringWithFormat:@"收件人: %@   地址: %d 栋 %d 室",_expressForm.express_author,_expressForm.author_floor,_expressForm.author_room];
    _arriveTimeLabel.text = [NSString stringWithFormat:@"到达时间: %@",_expressForm.arrive_time];
    if ([_expressForm.get_express_type isEqualToString:@""] && isResident && (_expressForm.deal_status == 0)) {
        [_typeButton setTitle:@"点击选择" forState:UIControlStateNormal];
        [_typeButton addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [_typeButton setTitle:expressForm.get_express_type forState:UIControlStateNormal];
        _typeButton.enabled = NO;
    
    }
    
    if (![_expressForm.get_time isEqualToString:@"None"]) {
        UILabel *getTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 87, 320, 21)];
        getTimeLable.font = [UIFont systemFontOfSize:13];
        getTimeLable.text = [NSString stringWithFormat:@"领取时间: %@",_expressForm.get_time];
        [self addSubview:getTimeLable];
        
        UILabel *express_signer = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, 320, 21)];
        express_signer.font = [UIFont systemFontOfSize:13];
        express_signer.text = [NSString stringWithFormat:@"领取人: %@",_expressForm.express_signer];
        [self addSubview:express_signer];
        
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 143, 58, 21)];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"满意度";
        
        [self addSubview:label];
    
        UIButton *feedBack = [[UIButton alloc]initWithFrame:CGRectMake(74, 143, 60, 30)];
        feedBack.enabled = NO;
        
        NSString *string;
        
        switch (_expressForm.pleased) {
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
        
        [feedBack setTitle:string forState:UIControlStateNormal];
       
        [feedBack addTarget:self action:@selector(feedBack:) forControlEvents:UIControlEventTouchUpInside];
        feedBack.titleLabel.font = [UIFont systemFontOfSize:13];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"role"] isEqualToString:@"resident"]&&_expressForm.pleased ==0) {
            feedBack.enabled = YES;
        }
        [feedBack setBackgroundColor:RGBA(111, 235, 255, 1)];
        [self addSubview:feedBack];
    }
    if (!isResident &&_expressForm.deal_status ==0) {
        _finishButton.alpha = 1;
        [_finishButton addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)chooseType:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(chooseGetExpressType:)]) {
        [self.delegate chooseGetExpressType:_expressForm];
    }
   

}


- (void)finishButtonClick:(id) sender
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(finishExpress:)]) {
        [self.delegate finishExpress:_expressForm];
    }
}

- (void)feedBack:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedBack:)]) {
        [self.delegate feedBack:_expressForm];
    }

    
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
