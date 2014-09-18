//
//  ViewController.h
//  Minesweeper
//
//  Created by Jacob Schiftan on 9/14/14.
//  Copyright (c) 2014 Jacob Schiftan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITileButton.h"
#import "NewGameModalViewController.h"
#include <stdlib.h>

@interface ViewController : UIViewController <settingsProtocolDelegate>

@property (nonatomic, strong) NSMutableArray *tileArray;
@property (nonatomic, strong) NSMutableArray *adjacentTilesToRemove;

@property int numberOfBombs;
@property int numberOfTileRows;

@property (nonatomic, strong) UIButton *cheatButton;
@property (nonatomic, strong) UIButton *hideButton;
@property (nonatomic, strong) UIButton *resetGridButton;
@property (nonatomic, strong) UIButton *validateButton;
@property (nonatomic, strong) UIButton *startNewGameButton;
@property (nonatomic, strong) UIAlertView *victoryAlertView;
@property (nonatomic, strong) UIAlertView *failureAlertView;
@property (nonatomic, strong) UIAlertView *missedBombAlert;

-(IBAction)cheatButtonPressed:(id)sender;
-(IBAction)hideButtonPressed:(id)sender;
-(IBAction)validateButtonPressed:(id)sender;
-(IBAction)startNewGameButton:(id)sender;
-(IBAction)resetGridButtonPressed:(id)sender;
-(IBAction)tilePressed:(id)sender;

@end
