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
import famuz.util.Assert;
import famuz.compiler.parser.Precedence.*;
import famuz.compiler.parser.Parser;
import famuz.compiler.expr.Expr;
import famuz.compiler.expr.ExprDef;

class ParserFunc
{
    public static function parse(scanner :TokenScanner, context :Context) : Expr
    {
        var token = scanner.next(); //func
        var identifier = scanner.next().getIdentifier(); //id (ex: main)
        scanner.next(); //consume left parentheses

        var params = parseParams(scanner);

        var body = Parser.parse(PRECEDENCE_CALL, scanner, context, true);

        var func = new Expr(
            context,
            EFunction(identifier, params, body),
            Position.union(token.pos, body.pos)
        );
        context.addVarFunc(identifier, func);

        return func;
    }

    private static function parseParams(scanner :TokenScanner) : Array<String>
    {
        var params :Array<String> = [];
        while (scanner.peek().isNotPunctuator(RIGHT_PARENTHESES)) {
            var name = scanner.next();
    
            params.push(name.getIdentifier());
    
            if(scanner.peek().isPunctuator(COMMA)) {
                scanner.next(); //consume comma
            }
        }

        Assert.that(scanner.next().isPunctuator(RIGHT_PARENTHESES), "\nparse_func :NOT LEFT PARENTHESES!\n");
        return params;
    }
}