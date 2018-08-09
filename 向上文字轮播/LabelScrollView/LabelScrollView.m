
//
//  LabelScrollView.m
//  向上文字轮播
//
//  Created by bug neo on 2018/8/9.
//  Copyright © 2018年 bug neo. All rights reserved.
//

#import "LabelScrollView.h"

/** 动画时间 */
static CGFloat const AniDuration = 1.0;

@interface LabelScrollView ()
/** 初始化时上面的label */
@property (nonatomic, weak) UILabel *upLabel;
/** 初始化时下面的label */
@property (nonatomic, weak) UILabel *downLabel;
/** 初始化时在上面的label是否在上面,YES:在上面, (每次动画移出去,会交换两个label的位置) */
@property (nonatomic, assign) BOOL upLabelIsUP;
/** 是否正在动画中,YES:是正在动画 */
@property (nonatomic, assign) BOOL isAni;
/** 当前展示的数据源中的index */
@property (nonatomic, assign) NSInteger currentIndex;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LabelScrollView

#pragma mark - public method
- (void)showNext {
    [self showNext:nil];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)addTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:AniDuration target:self selector:@selector(showNext:) userInfo:nil repeats:YES];
    }
}
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.upLabelIsUP = YES;
        self.isAni = NO;
        self.clipsToBounds = YES;
        self.currentIndex = 0;
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

#pragma mark - setter
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    if (self.dataSource.count == 0) {
        return;
    }
    if (dataSource.count%2 == 1) {
        //个数为奇数时,乘以2,总个数就是偶数了,ojbk
        [dataSource addObjectsFromArray:dataSource];
    }
    
    [self setLabelTxt];
    [self setLabelTxt];
    [self addTimer];
}

#pragma mark - private method
/** 设置label文字 */
- (void)setLabelTxt {
    if (self.currentIndex == self.dataSource.count) {
        self.currentIndex = 0;
    }
    if (self.currentIndex % 2 == 0) {
        self.upLabel.text = [self.dataSource objectAtIndex:self.currentIndex];
    }else {
        self.downLabel.text = [self.dataSource objectAtIndex:self.currentIndex];
    }
    self.currentIndex ++;
}
//展示下一段文字
- (void)showNext:(id)sender {
    if (self.isAni) {
        return;
    }
    self.isAni = YES;
    [UIView animateWithDuration:AniDuration animations:^{
        if (self.upLabelIsUP == YES) {
            self.upLabel.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
            self.downLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }else {
            self.downLabel.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
            self.upLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (self.upLabelIsUP == YES) {
            //upLabel在downLabel上面的时候
            self.upLabel.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            self.upLabelIsUP = NO;
        }else {
            //downLabel在upLabel上面的时候
            self.downLabel.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            self.upLabelIsUP = YES;
        }
        self.isAni = NO;
        //结束时设置下一段文字
        [self setLabelTxt];
    }];
}

//点击当前文字
- (void)tap:(UITapGestureRecognizer *)tap {
    NSLog(@"text = %@",[tap.view valueForKey:@"text"]);
}

#pragma mark - getter
- (UILabel *)upLabel {
    if (!_upLabel) {
        UILabel *up = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:up];
        _upLabel = up;
        up.textColor = [UIColor blackColor];
        up.textAlignment = NSTextAlignmentCenter;
        up.userInteractionEnabled = YES;
        [up addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }
    return _upLabel;
}

- (UILabel *)downLabel {
    if (!_downLabel) {
        UILabel *down = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        [self addSubview:down];
        _downLabel = down;
        down.textColor = [UIColor blackColor];
        down.textAlignment = NSTextAlignmentCenter;
        down.userInteractionEnabled = YES;
        [down addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }
    return _downLabel;
}


@end
