// CMSC 430
// Duane J. Jarc

// This file contains function definitions for the evaluation functions

typedef char* CharPtr;
enum Operators {LESS, ADD, MULTIPLY, GREAT, EQUAL, NOT_EQUAL, GREAT_EQUAL,
LESS_EQUAL, SUB, DIVIDE, OR, NOT, ARROW_, REM, EXP, AND};

double evaluateReduction(Operators operator_, double head, double tail);
double evaluateRelational(double left, Operators operator_, double right);
double evaluateArithmetic(double left, Operators operator_, double right);
double evaluateAnd(double left, double right);
double evaluateIf(double expression, double statementOne, double statementTwo);
double evaluateOr(double left, double right);
double evaluateNot(double var);
