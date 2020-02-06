#pragma once

/*
 * Copyright (c) 2019 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include <string.h>
#include "./parser.h"
#include "../scanner.h"
#include "../../util/assert.h"

/**
 * Parsing blocks "{...}"
 */
Expr *parse_left_bracket_prefix(TokenScanner *scanner, Exprs *exprs)
{
    Token token = token_scanner_next(scanner);
    Expr *expr = get_expr(exprs, E_BLOCK, &token);

    expr->def.block.exprs = parse_expression(0, scanner, exprs);
    Expr *last_expr = expr->def.block.exprs;

    int exprs_length = 1;
    while (token_scanner_has_next(scanner) && token_scanner_peek(scanner).type != RIGHT_BRACKET)
    {
        parse_expression(0, scanner, exprs);
        exprs_length++;
    }
    expr->def.block.exprs_length = exprs_length;

    assert_that(token_scanner_has_next(scanner) && token_scanner_next(scanner).type == RIGHT_BRACKET, "EXPECTED RIGHT BRACKET");
    expr->ret_type = last_expr->ret_type;
    return expr;
}