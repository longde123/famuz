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

package famuz.compiler.theory;

@:using(famuz.compiler.theory.Key.KeyTools)
enum Key
{
    C;
    C_SHARP;
    D_FLAT;
    D;
    D_SHARP;
    E_FLAT;
    E;
    F;
    F_SHARP;
    G_FLAT;
    G;
    G_SHARP;
    A_FLAT;
    A;
    A_SHARP;
    B_FLAT;
    B;
}

class KeyTools
{
    public static function toString(key :Key) : String
    {
        return switch key {
            case C: "C";
            case C_SHARP: "C#";
            case D_FLAT: "Db";
            case D: "D";
            case D_SHARP: "D#";
            case E_FLAT: "Eb";
            case E: "E";
            case F: "F";
            case F_SHARP: "F#";
            case G_FLAT: "Gb";
            case G: "G";
            case G_SHARP: "G#";
            case A_FLAT: "Ab";
            case A: "A";
            case A_SHARP: "A#";
            case B_FLAT: "Bb";
            case B: "B";
        }
    }

    public static function toInt(key :Key) : Int
    {
        return switch key {
            case A: 21;
            case A_SHARP: 22;
            case B_FLAT: 22;
            case B: 23;
            case C: 24;
            case C_SHARP: 25;
            case D_FLAT: 25;
            case D: 26;
            case D_SHARP: 27;
            case E_FLAT: 27;
            case E: 28;
            case F: 29;
            case F_SHARP: 30;
            case G_FLAT: 30;
            case G: 31;
            case G_SHARP: 32;
            case A_FLAT: 32;
        }
    }
}