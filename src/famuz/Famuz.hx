package famuz;

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

import sys.io.File;
import haxe.ds.Option;
import famuz.compiler.Expr;
import famuz.compiler.Expr.ExprStack;
import famuz.compiler.Position;
import famuz.compiler.Context;
import famuz.compiler.Token.TokenScanner;
import famuz.compiler.lexer.Lexer;
import famuz.compiler.evaluate.Evaluate;
import famuz.compiler.parser.Parser;
import famuz.compiler.theory.NotedHit;

class Famuz
{
    public static function compile(filePath :String) : Evaluation
    {
        var content = File.getContent(filePath);
        var tokens = Lexer.lex(filePath, content);
        var tokenScanner = new TokenScanner(tokens);
        var env = new Context();
        var parser = new Parser();

        while(tokenScanner.hasNext()) {
            parser.parse(0, tokenScanner, env);
        }

        var main = env.getExpr("main");
        var music = switch main.def {
            case EFunction(identifier, params, body): {
                var stack = new ExprStack();
                Evaluate.evaluate(body, stack);
                var expr = stack.pop();
                parser.assert(expr.ret == TMusic, () -> {
                    parser.assert(stack.length == 0, () -> {
                        Some(getMusic(expr));
                    }, () -> None, "Compilation Error", expr.pos);
                }, () -> None, "Main function must produce music.", expr.pos);
            }
            case _: 
                throw None;
        }

        return {
            music: music,
            errors: parser.errors
        };
    }

    private static function getMusic(e :Expr) : Array<NotedHit>
    {
        return switch e.def {
            case EConstant(constant): switch constant {
                case CMusic(val): val;
                case _: throw "Expected Steps.";
            }
            case _: throw "Expected Steps.";
        }
    }
}

typedef Evaluation = {
    music: Option<Array<NotedHit>>,
    errors: Array<{msg :String, pos :Position}>
}