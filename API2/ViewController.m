//
//  ViewController.m
//  API2
//
//  Created by Ramiro Gerardo Perez on 16/12/14.
//  Copyright (c) 2014 Ramiro Perez. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url =[NSURL URLWithString:@"http://mejorandoios.herokuapp.com/api/courses/all"];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    
    self.sessionConfiguration =[NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration];
    
    NSURLSessionTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *) response;
        
        if (urlResponse.statusCode ==200) {
            
            NSLog(@"Codigo 200");
            [self dataHandler:data];
            
        }
        
        
    }];
    
    [task resume];
    
}

-(void)dataHandler:(NSData *)data{
    
    NSError *jsonError;
    
    NSDictionary *urlDictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    
    if (urlDictionary){
    
    for (NSDictionary *dict in urlDictionary[@"data"]) {
        
        NSLog(@"%@", dict);
        
        [self.items addObject:dict];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.collectionView reloadData];
            
        });
        
    }
    
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    
    return [self.items count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier =@"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
   UIImageView *imageView = (UIImageView *) [cell viewWithTag:10];
    
    if ([self.items count] > 0) {
        
        NSDictionary *cellDirectory = [self.items objectAtIndex:indexPath.row];
        NSString *imageURLString = [cellDirectory objectForKey:@"image_url"];
        
        NSURL *imageUrl = [NSURL URLWithString:imageURLString];
        
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageUrl];
        
        
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:imageRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           
            NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *) response;
            
            if (urlResponse.statusCode == 200) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = [UIImage imageWithData:data];
                });
                
                
            }
            else{
                NSLog(@"error");
            }
            
            
        }];
        
        [task resume];
    }
    
    
    return cell;



}



@end
