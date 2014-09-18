//
//  UITileButton.h
//  Minesweeper
//
//  Created by Jacob Schiftan on 9/15/14.
//  Copyright (c) 2014 Jacob Schiftan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITileButton : UIButton

@property int xIndex;
@property int yIndex;
@property BOOL hasBomb;
@property BOOL hasBeenPressed;

@end
