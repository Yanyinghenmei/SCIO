//
//  CollectionViewController.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/6.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"

@interface CollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"collectionViewCell click");
}

@end
