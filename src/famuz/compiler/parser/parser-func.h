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

#include "./parser.h"
#include "../scanner.h"
#include "../reserved.h"
#include "../../util/assert.h"
#include "./parser-identifier.h"
#include "../environment.h"
#include "../stack.h"

void parse_func_params(TokenScanner *scanner, EFunction *func) {
    int args_length = 0;
    while (token_scanner_peek(scanner)->type != RIGHT_PARAM)
    {
        Token *param_name = token_scanner_next(scanner);
        strcpy(func->params[args_length].name, param_name->lexeme);

        if(token_scanner_peek((scanner))->type == COLON) {
            token_scanner_next(scanner); //consume colon
            Token *t = token_scanner_next(scanner);
            func->params[args_length].ret_type = type_get_type(t->lexeme);
        }
        else {
            func->params[args_length].ret_type = TYPE_MONOMORPH;
        }

        if(token_scanner_peek((scanner))->type == COMMA) {
            token_scanner_next(scanner); //consume comma
        }

        args_length++;
    }
    func->args_length = args_length;
    assert_that(token_scanner_next(scanner)->type == RIGHT_PARAM, "\nparse_func :NOT LEFT PARENTHESES!\n");
}

void parse_func_type(TokenScanner *scanner, Expr *expr) {
    if(token_scanner_peek((scanner))->type == COLON) {
        token_scanner_next(scanner); //consume colon
        Token *t = token_scanner_next(scanner);
        expr->ret_type = type_get_type(t->lexeme);
    }
}

/**
 * Parsing function "main(...)"
 */
Expr *parse_func(TokenScanner *scanner, Environments *environments, int parent_env_id, Stack *stack) {

    Token *token = token_scanner_next(scanner); //func
    Token *id = token_scanner_next(scanner); //id (ex: main)
    Expr *expr = expr_function(environment_create_expr(environments, parent_env_id), &token->pos, id->lexeme);
    token_scanner_next(scanner); //consume left parentheses

    parse_func_params(scanner, &expr->def.function);
    parse_func_type(scanner, expr);

    int env_id = environments_create_environment(environments, parent_env_id);
    expr->def.function.body_loc = &parse_expression(PRECEDENCE_CALL, scanner, environments, env_id, stack)->loc;

    Expr *body = environments_get_expr(environments, expr->def.function.body_loc);
    position_union(expr->pos, body->pos, expr->pos);
    return expr;
}