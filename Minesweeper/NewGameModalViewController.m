//
//  NewGameModalViewController.m
//  Minesweeper
//
//  Created by Jacob Schiftan on 9/16/14.
//  Copyright (c) 2014 Jacob Schiftan. All rights reserved.
//

#import "NewGameModalViewController.h"

@interface NewGameModalViewController ()

@end

@implementation NewGameModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:0.9]];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, 30, 200, 40)];
    [self.headerLabel setTextColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0]];
    [self.headerLabel setTextAlignment:NSTextAlignmentCenter];
    [self.bombLabel setFont:[UIFont systemFontOfSize:26]];
    [self.headerLabel setText:@"New Game Settings"];
    [self.view addSubview:self.headerLabel];
    
    self.bombControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"10",@"12",@"14", nil]];
    [self.bombControl setFrame:CGRectMake((self.view.frame.size.width-200)/2, (self.view.frame.size.height-30)/2, 200, 30)];
    [self.bombControl setTintColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0]];
    [self.bombControl addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    [self.bombControl setSelectedSegmentIndex:self.bombIndex];
    [self.view addSubview:self.bombControl];
    
    self.bombLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2,self.bombControl.frame.origin.y-25, 200, 20)];
    [self.bombLabel setTextColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0]];
    [self.bombLabel setTextAlignment:NSTextAlignmentCenter];
    [self.bombLabel setFont:[UIFont systemFontOfSize:14]];
    [self.bombLabel setText:@"Number of Bombs"];
    [self.view addSubview:self.bombLabel];
    
    self.tileControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"64",@"80",@"96", nil]];
    [self.tileControl setFrame:CGRectMake(self.bombControl.frame.origin.x,self.bombControl.frame.origin.y-80, 200, 30)];
    [self.tileControl setTintColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0]];
    [self.tileControl addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    [self.tileControl setSelectedSegmentIndex:self.tileRowIndex];
    [self.view addSubview:self.tileControl];
    
    self.tileLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2,self.tileControl.frame.origin.y-25, 200, 20)];
    [self.tileLabel setTextColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0]];
    [self.tileLabel setTextAlignment:NSTextAlignmentCenter];
    [self.tileLabel setFont:[UIFont systemFontOfSize:14]];
    [self.tileLabel setText:@"Number of Tiles"];
    [self.view addSubview:self.tileLabel];
    
    self.exitButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-180)/2,self.view.frame.size.height/2+70, 80, 40)];
    [self.exitButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.exitButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.exitButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.exitButton addTarget:self action:@selector(resign:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exitButton];
    
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width+20)/2,self.view.frame.size.height/2+70, 80, 40)];
    [self.startButton setTitle:@"Start Game" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.startButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.startButton addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)resign:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)startGame:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setTiles:andBombs:)]) {
        [self.delegate setTiles:self.numberOfTileRows andBombs:self.numberOfBombs];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)segmentSelected:(UISegmentedControl *)sender {
    NSLog(@"Segment Selected");
    if (sender==self.bombControl) {
        switch (self.bombControl.selectedSegmentIndex)
        {
            case 0:
                self.numberOfBombs = 10;
                break;
            case 1:
                self.numberOfBombs = 12;
                break;
            case 2:
                self.numberOfBombs = 14;
                break;
            default:
                break; 
        }
        NSLog(@"Number of bombs: %d",self.numberOfBombs);
    }
    else if (sender==self.tileControl) {
        switch (self.tileControl.selectedSegmentIndex)
        {
            case 0:
                self.numberOfTileRows = 8 ;
                break;
            case 1:
                self.numberOfTileRows = 10;
                break;
            case 2:
                self.numberOfTileRows = 12;
                break;
            default:
                break;
        }
        NSLog(@"Number of tile rows: %d",self.numberOfTileRows);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
