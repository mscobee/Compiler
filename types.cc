// Compiler Theory and Design
// Duane J. Jarc

// This file contains the bodies of the type checking functions

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
	// printf("\nleft: %d\tright: %d\n", lValue, rValue);
	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	
	if ((left == INT_TYPE && right == REAL_TYPE) || (left == REAL_TYPE &&
	right == INT_TYPE))
	{
		appendError(GENERAL_SEMANTIC, "Illegal Narrowing Function Return");
		return MISMATCH;
	}

	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Numeric Type Required");
		return MISMATCH;
	}

	return INT_TYPE;
}


Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	else if(left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}	
	return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}
Types checkIf(Types expression, Types left, Types right) {
	printf("wtf\n");
	if (expression != BOOL_TYPE) {
		appendError(GENERAL_SEMANTIC, "If expression must be boolean.");
		return MISMATCH;
	} 
	if(left != BOOL_TYPE || right != BOOL_TYPE) {
		appendError(GENERAL_SEMANTIC, "If-then type mismatch.");
		return MISMATCH;
	}
	return BOOL_TYPE;
}
Types checkRem(Types left, Types right) {
	if (left == INT_TYPE ^ right != INT_TYPE) {
		appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operands.");
		return MISMATCH;
	}
	return INT_TYPE;
}
