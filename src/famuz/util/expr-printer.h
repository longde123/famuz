#pragma once

/*
 * MIT License
 *
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

#include "../compiler/expr/expr.h"
#include "../compiler/type/type.h"

#define SET_COLOR_ERROR printf("\033[0;31m");
#define SET_COLOR_CONST printf("\033[1;32m");
#define SET_COLOR_VAR printf("\033[01;33m");
#define SET_COLOR_CALL printf("\033[1;34m");
#define SET_COLOR_BINOP printf("\033[1;35m");
#define SET_COLOR_PAREN printf("\033[1;36m");
#define SET_COLOR_RESET printf("\033[0m");

#define create_spacer                   \
    char spacer[spaces + 1];            \
    for (size_t i = 0; i < spaces; i++) \
    {                                   \
        spacer[i] = ' ';                \
    }                                   \
    spacer[spaces] = '\0';

void expr_print(Expr *expr, int spaces);

void expr_print_var(Expr *expr, int spaces)
{
    create_spacer;
    char *name = expr->def.var.identifier;
    Expr *e = expr->def.var.e;
    Type ret_type = expr->ret_type;
    printf("{\n%s  type: var;\n%s  ret: %i;\n%s  name:%s;\n%s  e: ", spacer, spacer, ret_type, spacer, name, spacer);
    expr_print(e, spaces + 2);
    SET_COLOR_VAR
    printf("\n%s}", spacer);
}

void expr_print_call(Expr *expr, int spaces)
{
    create_spacer;
    char *identifier = expr->def.call.identifier;
    Expr *params = expr->def.call.params;
    int params_length = expr->def.call.params_length;
    Type ret_type = expr->ret_type;
    printf("{\n%s  type: call;\n%s  ret: %i;\n%s  name: %s", spacer, spacer, ret_type, spacer, identifier);
    SET_COLOR_CALL
    printf("\n%s  params:", spacer);
    printf("\n%s    [", spacer);
    for (size_t i = 0; i < params_length; i++)
    {
        expr_print(&params[i], spaces + 4);
        SET_COLOR_CALL
        if (i == params_length - 1)
        {
            printf("]");
        }
        else
        {
            printf(", ");
        }
    }

    printf("\n%s}", spacer);
}

void expr_print_paren(Expr *expr, int spaces)
{
    create_spacer;
    Expr *e = expr->def.parentheses.e;
    Type ret_type = expr->ret_type;
    printf("{\n%s  type: parentheses;\n%s  ret: %i;\n%s  e: ", spacer, spacer, ret_type, spacer);
    expr_print(e, spaces + 2);
    SET_COLOR_PAREN
    printf("\n%s}", spacer);
}

void expr_print_block(Expr *expr, int spaces)
{
    create_spacer;
    Expr *exprs = expr->def.block.exprs;
    int exprs_length = expr->def.block.exprs_length;
    Type ret_type = expr->ret_type;
    printf("{\n%s  type: block;\n%s  ret: %i;\n%s  e: ", spacer, spacer, ret_type, spacer);
    printf("\n%s    [", spacer);
    for (size_t i = 0; i < exprs_length; i++)
    {
        expr_print(&exprs[i], spaces + 4);
        SET_COLOR_PAREN
        if (i == exprs_length - 1)
        {
            printf("]");
        }
        else
        {
            printf(", ");
        }
    }
    SET_COLOR_PAREN
    printf("\n%s}", spacer);
}

void expr_print_binop(Expr *expr, int spaces)
{
    create_spacer;
    char *name = expr->def.var.identifier;
    Expr *e1 = expr->def.binop.e1;
    BinopType type = expr->def.binop.type;
    Expr *e2 = expr->def.binop.e2;
    Type ret_type = expr->ret_type;
    printf("{\n%s  type: binop;\n%s  ret: %i;\n%s  e1: ", spacer, spacer, ret_type, spacer);
    expr_print(e1, spaces + 2);
    SET_COLOR_BINOP
    printf("\n%s  e2: ", spacer);
    expr_print(e2, spaces + 2);
    SET_COLOR_BINOP
    printf("\n%s}", spacer);
}

void expr_print_hit(Hit *hit)
{
    int start = hit->start;
    int duration = hit->duration;
    printf("(%i,%i) ", start, duration);
}

void expr_print_rhythm(Rhythm *rhythm)
{
    int length = rhythm->length;
    printf("[ ");
    for (size_t i = 0; i < length; i++)
    {
        expr_print_hit(&rhythm->hits[i]);
    }
    printf("]");
}

void expr_print_step(int step)
{
    printf("%d ", step);
}

void expr_print_steps(Steps *steps)
{
    int length = steps->length;
    printf("[ ");
    for (size_t i = 0; i < length; i++)
    {
        int step = steps->steps[i];
        expr_print_step(step);
    }
    printf("]");
}

void expr_print_melody(Melody *melody)
{
    int length = melody->length;
    printf("[");
    for (size_t i = 0; i < length; i++)
    {
        Note *note = &(melody->notes[i]);
        printf("{hit:");
        expr_print_hit(note->hit);
        printf("step:");
        expr_print_step(note->step);
        printf("}");
        if (i != (length - 1))
        {
            printf(",");
        }
    }
    printf("]");
}

void expr_print_harmony(Harmony *harmony, int spaces)
{
    create_spacer;
    int length = harmony->length;
    printf("[");
    for (size_t i = 0; i < length; i++)
    {
        Melody *melody = harmony->Melody[i];
        printf("\n%s%s", spacer, spacer);
        expr_print_melody(melody);
        if (i != (length - 1))
        {
            printf(",");
        }
    }
    printf("\n%s]", spacer);
}

void expr_print_const(Expr *expr, int spaces)
{
    create_spacer;
    Type type = expr->def.constant.type;
    Type ret_type = expr->ret_type;

    switch (type)
    {
    case TYPE_IDENTIFIER:
    {
        char *identifier = expr->def.constant.value.identifier;
        printf("{\n%s  type: identifier;\n%s  ret: %i;\n%s  value: %s\n%s}", spacer, spacer, ret_type, spacer, identifier, spacer);
        break;
    }
    case TYPE_RHYTHM:
    {
        Rhythm *rhythm = &(expr->def.constant.value.rhythm);
        printf("{\n%s  type: rhythm;\n%s  ret: %i;\n%s  value: ", spacer, spacer, ret_type, spacer);
        expr_print_rhythm(rhythm);
        printf("\n%s}", spacer);
        break;
    }
    case TYPE_MELODY:
    {
        Melody *melody = &(expr->def.constant.value.melody);
        printf("{\n%s  type: melody;\n%s  ret: %i;\n%s  value: ", spacer, spacer, ret_type, spacer);
        expr_print_melody(melody);
        printf("\n%s}", spacer);
        break;
    }
    case TYPE_HARMONY:
    {
        Harmony *harmony = &(expr->def.constant.value.harmony);
        printf("{\n%s  type: harmony;\n%s  ret: %i;\n%s  value: ", spacer, spacer, ret_type, spacer);
        expr_print_harmony(harmony, spaces + 2);
        printf("\n%s}", spacer);
        break;
    }
    case TYPE_STEPS:
    {
        Steps *steps = &(expr->def.constant.value.steps);
        printf("{\n%s  type: steps;\n%s  ret: %i;\n%s  value: ", spacer, spacer, ret_type, spacer);
        expr_print_steps(steps);
        printf("\n%s}", spacer);
        break;
    }
    case TYPE_SCALE:
    {
        Scale scale = expr->def.constant.value.scale;
        printf("{\n%s  type: scale;\n%s  ret: %i;\n%s  value: %i\n%s}", spacer, spacer, ret_type, spacer, scale, spacer);
        break;
    }
    case TYPE_KEY:
    {
        Key key = expr->def.constant.value.key;
        printf("{\n%s  type: key;\n%s  ret: %i;\n%s  value: %i\n%s}", spacer, spacer, ret_type, spacer, key, spacer);
        break;
    }
    case TYPE_SCALED_KEY:
    {
        ScaledKey scaled_key = expr->def.constant.value.scaled_key;
        printf("{\n%s  type: key;\n%s  ret: %i;\n%s  value: %i, %i\n%s}", spacer, spacer, ret_type, spacer, *scaled_key.scale, *scaled_key.key, spacer);
        printf("SCALED KEY!");
        break;
    }
    case TYPE_MUSIC:
    {
        // char *key = expr->def.constant.value.key;
        // printf("{\n%s  type: music;\n%s  ret: %i;\n%s  value: %s\n%s}", spacer, spacer, ret_type, spacer, key, spacer);
        printf("MUSIC!");
        break;
    }
    case TYPE_CHORD:
    {
        Chord chord = expr->def.constant.value.chord;
        printf("{\n%s  type: chord;\n%s  ret: %i;\n%s  value: %i\n%s}", spacer, spacer, ret_type, spacer, chord, spacer);
        break;
    }
    }
}

void expr_print(Expr *expr, int spaces)
{
    if (expr == NULL)
        return;
    switch (expr->def_type)
    {
    case E_CONST:
    {
        SET_COLOR_CONST
        expr_print_const(expr, spaces);
        break;
    }
    case E_VAR:
    {
        SET_COLOR_VAR
        expr_print_var(expr, spaces);
        break;
    }
    case E_CALL:
    {
        SET_COLOR_CALL
        expr_print_call(expr, spaces);
        break;
    }
    case E_BINOP:
    {
        SET_COLOR_BINOP
        expr_print_binop(expr, spaces);
        break;
    }
    case E_PAREN:
    {
        SET_COLOR_PAREN
        expr_print_paren(expr, spaces);
        break;
    }
    case E_BLOCK:
    {
        SET_COLOR_PAREN
        expr_print_block(expr, spaces);
        break;
    }
    case E_FUNC:
    {
        printf("WE ARE PRINTING A FUNCTION!");
        // SET_COLOR_PAREN
        // expr_print_paren(expr, spaces);
        break;
    }
    }
    SET_COLOR_RESET
}