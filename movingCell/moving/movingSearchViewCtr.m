//
//  movingSearchViewCtr.m
//  movingCell
//
//  Created by Apple on 2018/12/11.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "movingSearchViewCtr.h"
#import "Cell/movingCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface movingSearchViewCtr ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UIImageView *snapView;
@property (nonatomic, strong) UICollectionViewCell *originalCell;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSIndexPath *nextIndexPath;

@end

@implementation movingSearchViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialData];
    [self setUpSubViews];
}

#pragma mark - lazy load
- (UIImageView *)snapView {
    if (!_snapView) {
        _snapView = [[UIImageView alloc] init];
    }
    return _snapView;
}

#pragma mark - initial
- (void)initialData {
    self.array = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42"]];
}

- (void)setUpSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat safeTop = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat safeBottom = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    // 搜索头部
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, safeTop + 44)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, safeTop, SCREEN_WIDTH - 60, 40)];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, safeTop, 60, 40)];
    [headerView addSubview:searchBar];
    [headerView addSubview:cancelBtn];
    [self.view addSubview:headerView];
    self.searchBar = searchBar;
    self.cancelBtn = cancelBtn;
    
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [searchBar setBackgroundImage:[UIImage new]];
    UITextField *textF = [searchBar valueForKey:@"searchField"];
    if (textF) {
        textF.layer.cornerRadius = searchBar.frame.size.height * 0.48;
        textF.layer.masksToBounds = YES;
    }
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.56 green:0.87 blue:0.35 alpha:1.00] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    // 分割线
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, SCREEN_WIDTH - 1, 1)];
    [headerView addSubview:separator];
    
    //布局
    CGFloat numberInLine = 5;
    CGFloat itemSpace = 10;
    CGFloat itemW = (SCREEN_WIDTH - (numberInLine * itemSpace)) / numberInLine;
    CGFloat itemH = 30;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumInteritemSpacing = itemSpace;
    layout.minimumLineSpacing = 20;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(15, itemSpace, 0, itemSpace);
    // collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - headerView.frame.size.height - safeBottom) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[movingCell class] forCellWithReuseIdentifier:@"moving"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
}


- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    movingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moving" forIndexPath:indexPath];
    UILabel *label;
    if (cell.contentView.subviews.count > 0) {
        label = [cell.contentView viewWithTag:[@"label" hash]];
    } else {
        
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.tag = [@"label" hash];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = YES;
        
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.56 green:0.87 blue:0.35 alpha:1.00];
        
        // 手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
        [cell addGestureRecognizer:longPress];
    }

    label.text = [NSString stringWithFormat:@"No.%@", self.array[indexPath.item]];
    return cell;
}

- (void)cellLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    static CGPoint startPoint;
    movingCell *cell = (movingCell *)longPressGestureRecognizer.view;
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        UIImage *image = [cell snapshotView];
        self.snapView.image = image;
        
        CGRect frame = self.snapView.frame;
        frame.size = image.size;
        self.snapView.frame = frame;
        
        self.snapView.center = cell.center;
        
        [self.collectionView addSubview:self.snapView];
        _indexPath = [self.collectionView indexPathForCell:cell];
        _originalCell = cell;
        _originalCell.hidden = YES;
        startPoint = [longPressGestureRecognizer locationInView:_collectionView];
    } else if (longPressGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //移动
        CGFloat tranX = [longPressGestureRecognizer locationOfTouch:0 inView:self.collectionView].x - startPoint.x;
        CGFloat tranY = [longPressGestureRecognizer locationOfTouch:0 inView:self.collectionView].y - startPoint.y;
        _snapView.center = CGPointApplyAffineTransform(_snapView.center, CGAffineTransformMakeTranslation(tranX, tranY));
        startPoint = [longPressGestureRecognizer locationOfTouch:0 inView:_collectionView];
        
        //计算位置
        for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
            if ([self.collectionView indexPathForCell:cell] == _indexPath) {
                continue;
            }
            //计算中心距离
            CGFloat space = sqrt(pow(self.snapView.center.x - cell.center.x, 2));
            if (space <= self.snapView.bounds.size.width * 0.5 && (fabs(self.snapView.center.y - cell.center.y)) <= (self.snapView.bounds.size.height * 0.5)) {
                _nextIndexPath = [self.collectionView indexPathForCell:cell];
                if (_nextIndexPath.item > _indexPath.item) {
                    for (NSUInteger i = _indexPath.item; i < _nextIndexPath.item; i ++) {
                        [self.array exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
                    }
                } else {
                    for (NSUInteger i = _indexPath.item; i > _nextIndexPath.item; i --) {
                        [self.array exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
                    }
                }
                [self.collectionView moveItemAtIndexPath:_indexPath toIndexPath:_nextIndexPath];
                _indexPath = _nextIndexPath;
            }
            
        }
        
    } else if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.snapView removeFromSuperview];
        _originalCell.hidden = NO;
    }
}

@end
