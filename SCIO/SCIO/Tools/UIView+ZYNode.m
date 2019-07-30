//
//  UIView+ZYNode.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/4.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "UIView+ZYNode.h"

@implementation UIView (ZYNode)

// view所在的控制器
- (UIViewController*)viewController {
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

// 此view是否是控制器的view
- (BOOL)isViewOfViewController {
    return [[self nextResponder] isKindOfClass:[UIViewController class]];
}

- (NSString *)responderPath {
    NSMutableString *path = [NSMutableString string];
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        
        // 响应者链中不要混入view, 并且Apple未暴露的类并不通用, 不能插入viewPath
        if (![nextResponder isKindOfClass:[UIView class]]) {
            NSString *className = NSStringFromClass(nextResponder.class);
            if ([nextResponder isKindOfClass:UINavigationController.class]) {
                UINavigationController *nav = (UINavigationController *)nextResponder;
                [path insertString:[NSString stringWithFormat:@"%@[%zd]/",className,nav.viewControllers.count] atIndex:0];
            } else {
                [path insertString:[NSString stringWithFormat:@"%@/",className] atIndex:0];
            }
            
            if ([nextResponder isKindOfClass:UIViewController.class]) {
                break;
            }
        }
    }
    return path;
}

- (NSString *)viewPathWithlastPath:(NSString *)path {
    NSAssert([NSThread currentThread].isMainThread, @"需在主线程获取ViewPath");

    if (!path) {
        path = NSStringFromClass(self.class);
    }
    
    if ([self isViewOfViewController]) {
        return [NSString stringWithFormat:@"%@%@",[self responderPath],path];
    }
    
    if (self.superview) {
        NSString *superViewClass = NSStringFromClass([self.superview class]);
        
        // 如果是tabview上
        if ([self isKindOfClass:UITableViewCell.class] &&
            [self.superview isKindOfClass:UITableView.class]) {
            
            UITableView *tableView = (UITableView *)self.superview;
            UITableViewCell *cell = (UITableViewCell *)self;
            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
            
            return [self.superview viewPathWithlastPath:[path stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:[NSString stringWithFormat:@"%@(%zd,%zd)/",superViewClass,indexPath.section,indexPath.row]]];
        }
        
        // 如果在 collectionView 上
        else if ([self isKindOfClass:UICollectionViewCell.class] &&
                 [self.superview isKindOfClass:UICollectionView.class]) {
            UICollectionView *collectionView = (UICollectionView *)self.superview;
            UICollectionViewCell *cell = (UICollectionViewCell *)self;
            NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
            
            return [self.superview viewPathWithlastPath:[path stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:[NSString stringWithFormat:@"%@(%zd,%zd)/",superViewClass,indexPath.section,indexPath.row]]];
        }
        
        // 不在tableView/collectionView 上
        else {
            NSInteger index = [self.superview.subviews indexOfObject:self];
            NSString *indexStr = [NSString stringWithFormat:@"%zd",index];
            
            return [self.superview viewPathWithlastPath:[path stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:[NSString stringWithFormat:@"%@[%@]/",superViewClass,indexStr]]];
        }
        
    }
    // 基本上, 不可能走到这里
    else {
        return path;
    }
}

- (NSString *)elementPathWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath) {
        return [NSString stringWithFormat:@"%@(%zd,%zd)",[self viewPathWithlastPath:nil],indexPath.section,indexPath.row];
    } else {
        return [self viewPathWithlastPath:nil];
    }
}

- (NSIndexPath *)indexPathIfONListView {
    if ([self isKindOfClass:UITableViewCell.class]) {
        UITableView *tableView = [self superViewOrSelfWithClass:UITableView.class];
        NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)self];
        return indexPath;
    } else if ([self isKindOfClass:UICollectionViewCell.class]) {
        UICollectionView *collectionView = [self superViewOrSelfWithClass:UICollectionView.class];
        NSIndexPath *indexPath = [collectionView indexPathForCell:(UICollectionViewCell *)self];
        return indexPath;
    }
    return nil;
}

- (id)superViewOrSelfWithClass:(Class)cla {
    for (UIView *view = self; view; view = view.superview) {
        if ([view isKindOfClass:cla]) {
            return view;
        }
    }
    return nil;
}

- (UIResponder *)nextResponderWithClass:(Class)cla {
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:cla]) {
            return nextResponder;
        }
    }
    return nil;
}

@end
