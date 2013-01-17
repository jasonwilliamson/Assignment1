//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jason Williamson on 2013-01-13.
//  Copyright (c) 2013 Jason Williamson. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

@synthesize calculationDisplay = _calculationDisplay;
@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

#define MAX_DISPLAY_LENGTH 30

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)updateCalculationDisplay:(NSString *)newString
{
    self.calculationDisplay.text = [self.calculationDisplay.text stringByReplacingOccurrencesOfString:@" =" withString:@""];
    
    NSString *formattedString = [NSString stringWithFormat:@"%@ ", newString];
    NSString *appendedString = [self.calculationDisplay.text stringByAppendingString:formattedString];
    
    self.calculationDisplay.text = [self checkCalculationDisplayLength:appendedString];
}

- (NSString *)checkCalculationDisplayLength:(NSString *)checkString
{
    if (checkString.length > MAX_DISPLAY_LENGTH) {
        int minRange = checkString.length - MAX_DISPLAY_LENGTH;
        checkString = [checkString substringWithRange:NSMakeRange(minRange, MAX_DISPLAY_LENGTH)];
    }
    
    return checkString;
}
- (IBAction)backspacePressed
{
    if (self.display.text.length > 0){
        self.display.text = [self.display.text substringToIndex:self.display.text.length -1];
    }
    
    if ([self.display.text isEqualToString:@""]) {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (IBAction)clearPressed
{
    self.display.text = @"0";
    self.calculationDisplay.text = @"";
    [self.brain clearOperandStack];
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    [self updateCalculationDisplay:[sender.currentTitle stringByAppendingString:@" ="]];
    double result = [self.brain performOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)enterPressed
{
    [self updateCalculationDisplay:self.display.text];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)decimalPressed:(id)sender
{
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound) {
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
}

- (IBAction)plusMinusPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        double result = [self.display.text doubleValue];
        self.display.text = [NSString stringWithFormat:@"%g", result * -1];
    } else {
        [self operationPressed:sender];
    }
}

@end
