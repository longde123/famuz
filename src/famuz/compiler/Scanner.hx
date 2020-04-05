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

package famuz.compiler;

import famuz.compiler.lexer.LexerToken;
using famuz.compiler.Scanner.ScannerTools;

/**
 * 
 */
class Scanner
{
    public var content :String;
    public var filepath :String;
    public var curLine :Int;
    public var curIndex :Int;

    public function new(content :String, filepath :String) : Void
    {
        this.content = content;
        this.filepath = filepath;
        this.curLine = 1;
        this.curIndex = 0;
    }

    public function hasNext() : Bool
    {
        return this.curIndex < this.content.length;
    }

    public function next() : String
    {
        var c = this.content.charAt(this.curIndex++);
        if(c == '\n') {
            this.curLine += 1;
        }
        return c;
    }

    public function peek() : String
    {
        return this.content.charAt(this.curIndex);
    }

    public function peekDouble() : String
    {
        return this.content.charAt(this.curIndex + 1);
    }


    public function consumeWhitespace() : Void
    {
        while (this.hasNext() && this.peek().isWhitespace())
        {
            this.next();
        }
    }

    public function consumeComment() : Void
    {
        while (this.hasNext() && this.peek() != "\n")
        {
            this.next();
        }
    }

    public function consumeIdentifier() : String
    {
        var str = "";
        while(this.hasNext() && this.peek().isIdentifer()) {
            str += this.next();
        }
        return str;
    }

    public function consumeRhythm() : String
    {
        var str = "";
        while(this.hasNext() && (this.peek().isRhythm() || this.peek() == SPACE)) {
            var c = this.next();
            if(c != SPACE) {
                str += c;
            }
        }

        return str;
    }

    public function consumeNumber() : String
    {
        var str = "";
        while(this.hasNext() && this.peek().isDigit()) {
            str += this.next();
        }
        return str;
    }

    public function consumeString() : String
    {
        this.next(); //consume '"'
        var str = "";
        while(this.hasNext() && this.peek() != '"') {
            str += this.next();
        }
        this.next(); //consume '"'
        return str;
    }
}

class ScannerTools
{
    public static function isWhitespace(ch :String) : Bool
    {
        return ch == SPACE || ch == LINE || ch == TAB;
    }

    public static function isIdentifer(ch :String) : Bool
    {
        return isAlphaNumericUnderscore(ch);
    }

    public static function isRhythm(ch :String) : Bool
    {
        return ch.isDigit() || ch == DURATION || ch == REST;
    }

    public static function isDigit(ch :String) : Bool
    {
        var code = ch.charCodeAt(0);
        return code > 47 && code < 58;
    }

    public static function isAlphaNumericUnderscore(str :String) {
        var code :Int;
      
        code = str.charCodeAt(0);
        if (!(code == 95) && // _
        !(code > 47 && code < 58) && // numeric (0-9)
        !(code > 64 && code < 91) && // upper alpha (A-Z)
        !(code > 96 && code < 123)) { // lower alpha (a-z)
            return false;
        }
        return true;
      }
}