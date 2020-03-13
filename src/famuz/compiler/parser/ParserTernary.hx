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

import famuz.compiler.Error;
import famuz.compiler.Token;
import famuz.compiler.expr.Expr;

class ParserTernary
{
    public static function parse(left :Expr, scanner :TokenScanner, context :Context, error :Error) : Expr
    {
        var question = scanner.next(); //?
        if(!question.isPunctuator(QUESTION_MARK)) {
            error.addError("Expected a question mark", question.pos);
        }
        var eif = Parser.parse(new Precedence(0), scanner, context, error, false).evaluate();
        var colon = scanner.next(); //:
        if(!colon.isPunctuator(COLON)) {
            error.addError("Expected a colon", colon.pos);
        }
        var eelse = Parser.parse(new Precedence(0), scanner, context, error, false).evaluate();

        return new Expr(
            context,
            ETernary(left, eif, eelse),
            Position.union(question.pos, eelse.pos)
        );
    }
}