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

import famuz.compiler.theory.Key;

@:enum
@:using(famuz.compiler.theory.Scale.ScaleTools)
abstract Scale(Int)
{
    var MAJOR = 0;
    var NATURAL_MINOR = 1;
    var HARMONIC_MINOR = 2;
    var MELODIC_MINOR = 3;
    var CHROMATIC = 4;
}

class ScaleTools
{
    private static var MAJOR_SEMITONES (default, null) = [0,2,4,5,7,9,11];
    private static var NATURAL_MINOR_SEMITONES (default, null) = [0,2,3,5,7,8,10];
    private static var MELODIC_MINOR_SEMITONES (default, null) = [0,2,3,5,7,8,11];
    private static var HARMONIC_MINOR_SEMITONES (default, null) = [0,2,3,5,7,9,11];
    private static var CHROMATIC_SEMITONES (default, null) = [0,1,2,3,4,5,6,7,8,9,10,11];

    public static function toString(scale :Scale) : String
    {
        return switch scale {
            case MAJOR: "major";
            case NATURAL_MINOR: "natural-minor";
            case MELODIC_MINOR: "melodic-minor";
            case HARMONIC_MINOR: "harmonic-minor";
            case CHROMATIC: "chomatic";
        }
    }

    public static function length(scale :Scale) : Int
    {
        return switch scale {
            case MAJOR: MAJOR_SEMITONES.length;
            case NATURAL_MINOR: NATURAL_MINOR_SEMITONES.length;
            case MELODIC_MINOR: MELODIC_MINOR_SEMITONES.length;
            case HARMONIC_MINOR: HARMONIC_MINOR_SEMITONES.length;
            case CHROMATIC: CHROMATIC_SEMITONES.length;
        }
    }

    public static function steppedValue(scale :Scale, root :Key, index :Int) : Int
    {
        return switch scale {
            case MAJOR: MAJOR_SEMITONES[index] + root.toInt();
            case NATURAL_MINOR: NATURAL_MINOR_SEMITONES[index] + root.toInt();
            case MELODIC_MINOR: MELODIC_MINOR_SEMITONES[index] + root.toInt();
            case HARMONIC_MINOR: HARMONIC_MINOR_SEMITONES[index] + root.toInt();
            case CHROMATIC: CHROMATIC_SEMITONES[index] + root.toInt();
        }
    }
}