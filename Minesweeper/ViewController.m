//
//  ViewController.m
//  Minesweeper
//
//  Created by Jacob Schiftan on 9/14/14.
//  Copyright (c) 2014 Jacob Schiftan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0]];
    
    self.numberOfTileRows = 8;
    self.numberOfBombs = 10;
    
    [self loadGridWithTiles];
    [self addBombsToTiles:self.numberOfBombs];
    [self loadGridViewButtons];
}

-(void)loadGridViewButtons {
    self.cheatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cheatButton setFrame:CGRectMake((self.view.frame.size.width-145)/2, (self.view.frame.size.height-(30*self.numberOfTileRows+5*(self.numberOfTileRows-1))-100)/2, 60, 40)];
    [self.cheatButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.cheatButton setTitle:@"Cheat" forState:UIControlStateNormal];
    [self.cheatButton addTarget:self action:@selector(cheatButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.hideButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.hideButton setFrame:CGRectMake((self.view.frame.size.width-145)/2, (self.view.frame.size.height-(30*self.numberOfTileRows+5*(self.numberOfTileRows-1))-100)/2, 60, 40)];
    [self.hideButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.hideButton setTitle:@"Hide" forState:UIControlStateNormal];
    [self.hideButton addTarget:self action:@selector(hideButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.hideButton setHidden:YES];
    
    self.resetGridButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.resetGridButton setFrame:CGRectMake((self.view.frame.size.width+25)/2, (self.view.frame.size.height-(30*self.numberOfTileRows+5*(self.numberOfTileRows-1))-100)/2, 60, 40)];
    [self.resetGridButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.resetGridButton setTitle:@"Reset" forState:UIControlStateNormal];
    [self.resetGridButton addTarget:self action:@selector(resetGridButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.validateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.validateButton setFrame:CGRectMake((self.view.frame.size.width-150)/2, (self.view.frame.size.height+(30*self.numberOfTileRows+5*(self.numberOfTileRows-1))+20)/2, 60, 40)];
    [self.validateButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.validateButton setTitle:@"Validate" forState:UIControlStateNormal];
    [self.validateButton addTarget:self action:@selector(validateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.startNewGameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.startNewGameButton setFrame:CGRectMake((self.view.frame.size.width+20)/2, (self.view.frame.size.height+(30*self.numberOfTileRows+5*(self.numberOfTileRows-1))+20)/2, 80, 40)];
    [self.startNewGameButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.startNewGameButton setTitle:@"New Game" forState:UIControlStateNormal];
    [self.startNewGameButton addTarget:self action:@selector(startNewGameButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.cheatButton];
    [self.view addSubview:self.hideButton];
    [self.view addSubview:self.resetGridButton];
    [self.view addSubview:self.validateButton];
    [self.view addSubview:self.startNewGameButton];
}

-(IBAction)validateButtonPressed:(id)sender {
    NSMutableArray *validateTileArray = [[NSMutableArray alloc] initWithArray:[self.view subviews]];
    [validateTileArray removeObjectsInArray:[NSArray arrayWithObjects:self.cheatButton,self.resetGridButton,self.hideButton,self.validateButton,self.startNewGameButton, nil]];
    bool didWin = YES;
    bool missedTile = NO;
    bool hitBomb = NO;
    for (UITileButton *tileButton in validateTileArray) {
        if (tileButton.hasBomb && tileButton.hasBeenPressed) {
            didWin = NO;
            hitBomb = YES;
        }
        else if (!tileButton.hasBomb && !tileButton.hasBeenPressed) {
            didWin = NO;
            missedTile = YES;
        }
    }
    if (didWin) {
        self.victoryAlertView = [[UIAlertView alloc] initWithTitle:@"Hooray!" message:@"You won!" delegate:self cancelButtonTitle:@"Keep Playing" otherButtonTitles:@"Reset Grid",@"Start New Game", nil];
        [self.victoryAlertView performSelector:@selector(show) withObject:nil afterDelay:0.5];
    }
    else if (hitBomb) {
        [self.failureAlertView performSelector:@selector(show) withObject:nil afterDelay:0.5];
    }
    else if (missedTile) {
        self.missedBombAlert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"You missed a tile!" delegate:self cancelButtonTitle:@"Keep Playing" otherButtonTitles:@"Reset Grid",@"Start New Game", nil];
        [self.missedBombAlert performSelector:@selector(show) withObject:nil afterDelay:0.5];
        [self showBombs];
        [self.cheatButton setHidden:YES];
        [self.hideButton setHidden:NO];
    }
}

-(IBAction)startNewGameButton:(id)sender {
    [self startNewGame];
}

-(void)startNewGame {
    NewGameModalViewController *newGameModalView = [[NewGameModalViewController alloc] init];
    newGameModalView.delegate = self;
    newGameModalView.numberOfBombs = self.numberOfBombs;
    newGameModalView.numberOfTileRows = self.numberOfTileRows;
    newGameModalView.bombIndex = (self.numberOfBombs-10)/2;
    newGameModalView.tileRowIndex = (self.numberOfTileRows-8)/2;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:newGameModalView animated:YES  completion:nil];
}

-(void)setTiles:(int)numberOfTiles andBombs:(int)numberOfBombs {
    self.numberOfBombs = numberOfBombs;
    self.numberOfTileRows = numberOfTiles;
    NSLog(@"(Grid View) Number of bombs: %d, Number of tileRows: %d",self.numberOfBombs,self.numberOfTileRows);
    [self resetGrid];
}

-(IBAction)resetGridButtonPressed:(id)sender {
    [self resetGrid];
}

-(void)resetGrid {
    [self.hideButton setHidden:YES];
    [self.cheatButton setHidden:NO];
    [self loadGridViewButtons];
    [self loadGridWithTiles];
    [self addBombsToTiles:self.numberOfBombs];
}

-(IBAction)cheatButtonPressed:(id)sender {
    [self showBombs];
    [self.cheatButton setHidden:YES];
    [self.hideButton setHidden:NO];
}

-(IBAction)hideButtonPressed:(id)sender {
    [self hideBombs];
    [self.hideButton setHidden:YES];
    [self.cheatButton setHidden:NO];
}

- (void)touchDown:(id)sender
{
	NSLog(@"Touch Down");
	// give it 0.2 sec for second touch
	[self performSelector:@selector(tilePressed:) withObject:sender afterDelay:0.2];
}

- (void)touchDownRepeat:(id)sender
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tilePressed:) object:sender];
	NSLog(@"Touch Down Repeat");
	[self tileDoubleTapped:sender];
}

-(IBAction)tileDoubleTapped:(id)sender {
    NSLog(@"Tile double tapped");
    UITileButton *tileButton = (UITileButton *)sender;
    if ([tileButton.backgroundColor isEqual:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0]]) {
        NSLog(@"turn red");
        [tileButton setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0]];
        [tileButton setImage:[UIImage imageNamed:@"icon_18472"] forState:UIControlStateNormal];
    }
    else if ([tileButton.backgroundColor isEqual:[UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0]]) {
        if (tileButton.hasBomb) {
            [tileButton setImage:[UIImage imageNamed:@"icon_54644"] forState:UIControlStateNormal];
        }
        else {
            [tileButton setImage:nil forState:UIControlStateNormal];
        }
        NSLog(@"turn blue");
        [tileButton setBackgroundColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0]];
    }
}

-(IBAction)tilePressed:(id)sender {
    UITileButton *tileButton = (UITileButton *)sender;
    tileButton.hasBeenPressed = YES;
    if (tileButton.hasBomb) {
        [self showBombs];
        [tileButton setBackgroundColor:[UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0]];
        [tileButton setImage:[UIImage imageNamed:@"icon_2348"] forState:UIControlStateNormal];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Boom!" message:@"You hit a bomb!" delegate:self cancelButtonTitle:@"Keep Playing" otherButtonTitles:@"Reset Grid",@"Start New Game", nil];
        self.failureAlertView = alert;
        [self.failureAlertView performSelector:@selector(show) withObject:nil afterDelay:.2];
//        [self.victoryAlertView show];
    }
    else {
        [tileButton setBackgroundColor:[UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0]];
        [tileButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [tileButton setTitle:[self adjacentBombsWithTile:tileButton] forState:UIControlStateNormal];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView==self.failureAlertView) {
        if (buttonIndex==0) {
            NSLog(@"Keep Playing");
            [self.cheatButton setHidden:YES];
            [self.hideButton setHidden:NO];
        }
        else if (buttonIndex==1) {
            NSLog(@"Reset Grid");
            [self performSelector:@selector(resetGrid) withObject:nil afterDelay:0.5];
        }
        else {
            NSLog(@"Start New Game");
            [self startNewGame];
        }
    }
    if (alertView==self.victoryAlertView) {
        if (buttonIndex==0) {
            NSLog(@"Keep Playing");
            [self.cheatButton setHidden:YES];
            [self.hideButton setHidden:NO];
        }
        else if (buttonIndex==1) {
            NSLog(@"Reset Grid");
            [self performSelector:@selector(resetGrid) withObject:nil afterDelay:0.5];
        }
        else {
            NSLog(@"Start New Game");
            [self startNewGame];
        }
    }
    if (alertView==self.missedBombAlert) {
        if (buttonIndex==0) {
            NSLog(@"Keep Playing");
            [self.cheatButton setHidden:YES];
            [self.hideButton setHidden:NO];
        }
        else if (buttonIndex==1) {
            NSLog(@"Reset Grid");
            [self performSelector:@selector(resetGrid) withObject:nil afterDelay:0.5];
        }
        else {
            NSLog(@"Start New Game");
            [self startNewGame];
        }
    }
}

-(void)clearSurroundingTilesWithTile:(UITileButton *)tileButton {
    tileButton.hasBeenPressed = YES;
    [tileButton setBackgroundColor:[UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0]];
    [tileButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [tileButton setTitle:[self adjacentBombsWithTile:tileButton] forState:UIControlStateNormal];
}

-(void)clearSurroundingTilesWithTiles:(NSArray *)tileButtonArray{
    for (UITileButton *tileButton in tileButtonArray) {
        tileButton.hasBeenPressed = YES;
        [tileButton setBackgroundColor:[UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0]];
        [tileButton setImage:nil forState:UIControlStateNormal];
        [tileButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [tileButton setTitle:[self adjacentBombsWithTile:tileButton] forState:UIControlStateNormal];
    }
}

-(NSString *)adjacentBombsWithTile:(UITileButton *)tileButton {
    //Find limits of Y index
    int iFirst;
    int iLast;
    if (tileButton.yIndex<1) {
        iFirst = tileButton.yIndex;
    }
    else {
        iFirst = tileButton.yIndex-1;
    }
    if (tileButton.yIndex>self.numberOfTileRows-2) {
        iLast = tileButton.yIndex;
    }
    else {
        iLast = tileButton.yIndex+1;
    }
    
    //Find limits of X index
    int jFirst;
    int jLast;
    if (tileButton.xIndex<1) {
        jFirst = tileButton.xIndex;
    }
    else {
        jFirst = tileButton.xIndex-1;
    }
    if (tileButton.xIndex>6) {
        jLast = tileButton.xIndex;
    }
    else {
        jLast = tileButton.xIndex+1;
    }
    NSLog(@"Calculating adjacent bombs for tile (%d,%d), with range [%d,%d;%d,%d]",tileButton.yIndex,tileButton.xIndex,iFirst,iLast,jFirst,jLast);
    //Calulate adjacent Bombs
    int bombs = 0;
    for (int i = iFirst; i <= iLast; i++) {
        for (int j = jFirst; j <= jLast; j++) {
            UITileButton *tileButton = self.tileArray[i][j];
            if (tileButton.hasBomb==YES) {
                bombs++;
            }
        }
    }
    
    // No adjacent bombs, clear adjacent tiles
    if (bombs==0) {
        NSMutableArray *tileButtonArray = [[NSMutableArray alloc] init];
        NSLog(@"Bombs == 0");
        for (int i = iFirst; i <= iLast; i++) {
            for (int j = jFirst; j <= jLast; j++) {
                if (!(i==tileButton.yIndex && j==tileButton.xIndex)) {
                    UITileButton *adjacentTileButton = self.tileArray[i][j];
                    if (adjacentTileButton.hasBeenPressed==NO) {
                        //[self clearSurroundingTilesWithTile:adjacentTileButton];
                        [tileButtonArray addObject:adjacentTileButton];
                        NSLog(@"tileButtonArray: %@",tileButtonArray);
                    }
                }
            }
        }
        [self clearSurroundingTilesWithTiles:tileButtonArray];
        NSLog(@"tileButtonArray: %@",tileButtonArray);
    }
    return [NSString stringWithFormat:@"%d",bombs];
}

-(void)showBombs {
    for (int i=0; i<self.numberOfTileRows; i++) {
        for (int j=0; j<8; j++) {
            UITileButton *tileButton = self.tileArray[i][j];
            if (tileButton.hasBomb) {
                NSLog(@"Found bomb on tile %d,%d.",i,j);
                [tileButton setImage:[UIImage imageNamed:@"icon_54644"] forState:UIControlStateNormal];
            } else {
                NSLog(@"No bomb on tile %d,%d.",i,j);
            }
        }
    }
}

-(void)hideBombs {
    for (int i=0; i<self.numberOfTileRows; i++) {
        for (int j=0; j<8; j++) {
            UITileButton *tileButton = self.tileArray[i][j];
            if (tileButton.hasBomb) {
                if ([tileButton.imageView.image isEqual:[UIImage imageNamed:@"icon_18472"]]) {
                    NSLog(@"Removed bomb on tile %d,%d.",i,j);
                }
                else {
                NSLog(@"Removed bomb on tile %d,%d.",i,j);
                [tileButton setImage:nil forState:UIControlStateNormal];
                }
            } else {
                NSLog(@"No bomb on tile %d,%d.",i,j);
            }
        }
    }
}

-(void)loadGridWithTiles {
    NSMutableArray *subviewArray = [[NSMutableArray alloc] initWithArray:[self.view subviews]];
    [subviewArray removeObjectsInArray:[NSArray arrayWithObjects:self.cheatButton,self.resetGridButton,self.hideButton,self.validateButton,self.startNewGameButton, nil]];
    [subviewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.tileArray = [[NSMutableArray alloc] init];
    NSMutableArray* tileArray = [[NSMutableArray alloc] init];
    for (int i=0; i<self.numberOfTileRows; i++) {
        NSMutableArray* tileRow = [[NSMutableArray alloc] init];
        for (int j=0; j<8; j++) {
            UITileButton *tileButton = [[UITileButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-275)/2+35*j, (self.view.frame.size.height-(30*self.numberOfTileRows+5*(self.numberOfTileRows-1)))/2+35*i, 30, 30)];
            [tileButton setBackgroundColor:[UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0]];
            [self.view addSubview:tileButton];
            tileButton.xIndex = j;
            tileButton.yIndex = i;
            tileButton.hasBomb = NO;
            tileButton.hasBeenPressed = NO;
            [tileButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
            [tileButton addTarget:self action:@selector(touchDownRepeat:) forControlEvents:UIControlEventTouchDownRepeat];
            [tileRow addObject:tileButton];
        }
        NSLog(@"Tile Row: %@", tileRow);
        [tileArray addObject:tileRow];
        NSLog(@"tileArray: %@",tileArray);
        self.tileArray = tileArray;
        NSLog(@"self.tileArray: %@",self.tileArray);
    }
    NSLog(@"self.tileArray: %@",self.tileArray);
}

-(void)addBombsToTiles:(int)numberOfBombs {
    for (int b = 0; b<numberOfBombs; b++) {
        int i = arc4random_uniform(self.numberOfTileRows);
        int j = arc4random_uniform(8);
        UITileButton *tileButton = self.tileArray[i][j];
        if (!tileButton.hasBomb) {
            tileButton.hasBomb = YES;
            NSLog(@"Added bomb to tile %d,%d.",i,j);
        } else {
            b = b - 1;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
