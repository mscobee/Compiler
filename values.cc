// CMSC 430
// Duane J. Jarc

// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

double evaluateReduction(Operators operator_, double head, double tail)
{
	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}


double evaluateRelational(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{	case LESS:
			result = left < right;
			break;
		case GREAT:
			result = left > right;
			break;
		case LESS_EQUAL:
			result = left <= right;
			break;
		case GREAT_EQUAL:
			result = left >= right;
			break;
		case EQUAL:
			result = left == right;
			break;
		case NOT_EQUAL:
			result = left != right;
			break;
	}
	return result;
}
double evaluateArithmetic(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
		case ADD:
			result = left + right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case SUB:
			result = left-right;
			break;
		case DIVIDE:
			result = left/right;
			break;
		case REM:
			result = int(left) % int(right);
			break;
	}
	return result;
}

double evaluateAnd(double left, double right) {
	return left && right;
}
double evaluateIf(double expression, double statementOne, double statementTwo){
	double result;
	if(expression) {
		result = statementOne;
	} else {
		result = statementTwo;
	}

	return result;
} 
double evaluateNot(double var) {
	return !var;
}
double evaluateOr(double left, double right) {
	return left || right;
}

