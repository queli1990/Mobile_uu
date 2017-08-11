//
//  SettingTableViewCell.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/27.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (44-20)/2, 120, 20)];
        _titleLabel.textColor = UIColorFromRGB(0x4A4A4A, 1.0);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xE6E6E6, 1.0);
        [self.contentView addSubview:lineView];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
