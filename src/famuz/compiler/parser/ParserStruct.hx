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
import famuz.compiler.expr.Expr;
import famuz.compiler.parser.Parser;

class ParserStruct
{
    public static function parse(scanner :TokenScanner, context :Context, imports :Map<String, Context>) : Expr
    {
        var dollar = scanner.next();
        scanner.next();
        var fields = new Map<String, Expr>();

        while (scanner.hasNext() && scanner.peek().isNotPunctuator(RIGHT_BRACE)) {
            var name = scanner.next();
            scanner.next(); //consume '='
            var expr = Parser.parse(0, scanner, context, imports, false);
            fields.set(name.getIdentifier(), expr);

            if(scanner.peek().isPunctuator(COMMA)) {
                scanner.next();
            }
        }
        var rightBrace = scanner.next();

        return new Expr(
            EObjectDecl(fields),
			TMono({ref: None}),
            Position.union(dollar.pos, rightBrace.pos)
        );
    }
}