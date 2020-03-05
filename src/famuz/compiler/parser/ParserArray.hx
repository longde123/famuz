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
import famuz.compiler.parser.Parser;
using famuz.compiler.Type;

class ParserArray
{
    public static function parse(parser :Parser, scanner :TokenScanner, context :Context) : Expr
    {
        var token = scanner.next(); //[
        var exprs :Array<Expr> = [];

        while (scanner.hasNext() && scanner.peek().type != RIGHT_BRACKET) {
            exprs.push(parser.parse(0, scanner, context));
            if(scanner.peek().type == COMMA) {
                scanner.next();
            }
        }

        var rightBrace = scanner.next();
        Assert.that(rightBrace.type == RIGHT_BRACKET, "EXPECTED RIGHT BRACKET");
        var ret = exprs.length > 0 ? exprs[0].ret : TMonomorph;

        return {
            context: context,
            def: EArrayDecl(exprs),
            pos: Position.union(token.pos, rightBrace.pos), 
            ret: ret
        };
    }
}