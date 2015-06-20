//
//  ViewController.h
//  API2
//
//  Created by Ramiro Gerardo Perez on 16/12/14.
//  Copyright (c) 2014 Ramiro Perez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *items;

@end

