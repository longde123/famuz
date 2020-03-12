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

package famuz.compiler.parser;

import famuz.compiler.Token;
import famuz.compiler.parser.Precedence.*;
import famuz.compiler.parser.Parser;
import famuz.compiler.expr.Expr;

class ParserVar
{
    public static function parse(left :Expr, scanner :TokenScanner, context :Context) : Expr
    {
        scanner.next(); //consume "="
        var identifier = switch left.def {
            case EConstant(constant): switch constant {
                case CIdentifier(str): str;
                case _: throw "invalid";
            }
            case _: throw "invalid";
        }

        var expr = Parser.parse(PRECEDENCE_ASSIGNMENT, scanner, context, false).evaluate();
        left.def = EVar(identifier, expr.evaluate());
        left.pos = Position.union(left.pos, expr.pos);

        context.addVarFunc(identifier, left);
        return left;
    }
}