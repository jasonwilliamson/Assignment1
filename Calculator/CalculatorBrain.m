//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jason Williamson on 2013-01-13.
//  Copyright (c) 2013 Jason Williamson. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if (!_operandStack) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (void)pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

-(void)clearOperandStack
{
    [self.operandStack removeAllObjects];
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"+"]){
        result = [self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]){
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]){
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"/"]){
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    } else if ([operation isEqualToString:@"sin"]){
        double operand = [self popOperand];
        if (operand) result = sin(operand);
    } else if ([operation isEqualToString:@"cos"]){
        double operand = [self popOperand];
        if (operand) result = cos(operand);
    } else if ([operation isEqualToString:@"sqrt"]){
        double operand = [self popOperand];
        if (operand) result = sqrt(operand);
    } else if ([operation isEqualToString:@"π"]){
        result = M_PI;
    } else if ([operation isEqualToString:@"+/-"]){
        double operand = [self popOperand];
        if (operand) result = operand * -1;
    }
    
    [self pushOperand:result];
    
    return result;
}

@end
