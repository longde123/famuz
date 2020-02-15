package famuz.compiler;

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

enum Key
{
    KEY_C;
    KEY_C_SHARP;
    KEY_D_FLAT;
    KEY_D;
    KEY_D_SHARP;
    KEY_E_FLAT;
    KEY_E;
    KEY_F;
    KEY_F_SHARP;
    KEY_G_FLAT;
    KEY_G;
    KEY_G_SHARP;
    KEY_A_FLAT;
    KEY_A;
    KEY_A_SHARP;
    KEY_B_FLAT;
    KEY_B;
    INVALID;
}

enum abstract ReservedKey(String) from String {
    var C = "C";
    var C_SHARP = "C#";
    var Db = "Db";
    var D = "D";
    var D_SHARP = "D#";
    var Eb = "Eb";
    var E = "E";
    var F = "F";
    var F_SHARP = "F#";
    var Gb = "Gb";
    var G = "G";
    var G_SHARP = "G#";
    var Ab = "Ab";
    var A = "A";
    var A_SHARP = "A#";
    var Bb = "Bb";
    var B = "B";
}

class KeyTools
{
    public static function getKey(reserved :ReservedKey) : Key
    {
        return switch reserved {
            case C: KEY_C;
            case C_SHARP: KEY_C_SHARP;
            case Db: KEY_D_FLAT;
            case D: KEY_D;
            case D_SHARP: KEY_D_SHARP;
            case Eb: KEY_E_FLAT;
            case E: KEY_E;
            case F: KEY_F;
            case F_SHARP: KEY_F_SHARP;
            case Gb: KEY_G_FLAT;
            case G: KEY_G;
            case G_SHARP: KEY_G_SHARP;
            case Ab: KEY_A_FLAT;
            case A: KEY_A;
            case A_SHARP: KEY_A_SHARP;
            case Bb: KEY_B_FLAT;
            case B: KEY_B;
        }
        return INVALID;
    }
}