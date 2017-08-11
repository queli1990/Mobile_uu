//
//  LeftVCTableViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/5.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "LeftVCTableViewCell.h"

@implementation LeftVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, (44-30)/2, 30, 30)];
        _iconImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_iconImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame), _iconImageView.frame.origin.y, 120, 30)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleLabel];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
