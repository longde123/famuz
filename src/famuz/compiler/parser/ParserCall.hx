package famuz.compiler.parser;

/*
 * Copyright (c) 2020 Jeremy Meltingtallow
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

import famuz.compiler.Token;
import famuz.util.Assert;
import famuz.compiler.parser.Precedence.*;
import famuz.compiler.parser.Parser;

class ParserCall
{
    public static function parse(parser :Parser, left :Expr, scanner :TokenScanner, context :Context) : Expr
    {
        var funcName = switch left.def {
            case EConstant(constant): {
                switch constant {
                    case CIdentifier(str): str;
                    case _: "Invalid funcName";
                }
            }
            case _: "Invalid funcName";
        }
        scanner.next(); //left parentheses

        var args :Array<Expr> = [];
        while (scanner.hasNext() && scanner.peek().type != RIGHT_PARENTHESES) {
            args.push(parser.parse(PRECEDENCE_CALL, scanner, context));
            if (scanner.peek().type == COMMA) {
                scanner.next(); //consume comma
            }
        }

        var rightParam = scanner.next();
        Assert.that(rightParam.type == RIGHT_PARENTHESES, "EXPECTED RIGHT PARAM");

        return {
            context: context,
            def: ECall(funcName, args),
            pos: Position.union(left.pos, rightParam.pos),
            ret: TInvalid
        };
    }
}