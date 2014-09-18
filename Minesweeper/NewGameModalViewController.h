//
//  NewGameModalViewController.h
//  Minesweeper
//
//  Created by Jacob Schiftan on 9/16/14.
//  Copyright (c) 2014 Jacob Schiftan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol settingsProtocolDelegate <NSObject>

-(void)setTiles:(int)numberOfTiles andBombs:(int)numberOfBombs;

@end

@interface NewGameModalViewController : UIViewController

@property id <settingsProtocolDelegate> delegate;

@property (nonatomic,strong) UISegmentedControl *bombControl;
@property (nonatomic,strong) UISegmentedControl *tileControl;

@property (nonatomic,strong) UIButton *exitButton;
@property (nonatomic,strong) UIButton *startButton;

@property (nonatomic,strong) UILabel *headerLabel;
@property (nonatomic,strong) UILabel *bombLabel;
@property (nonatomic,strong) UILabel *tileLabel;

@property int numberOfBombs;
@property int bombIndex;
@property int numberOfTileRows;
@property int tileRowIndex;

-(IBAction)resign:(id)sender;
-(IBAction)startGame:(id)sender;

@end
