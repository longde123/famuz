<img src="./famous.png" height="200"  align="right">

# Famuz

> A Modular Music Format for famous compositions.

Famuz is a programming language that compiles to Midi. The goal of this project is to create music from atomic musical definitions.

## Simple Example

``` javascript
basicRhythm =
    x~~~ x--- x~~~ x~--

//this is a comment
simpleSteps =
    0 1 2 3

c = TRIAD

robot = {
    woah = x~~~ x--- x~~~ x~--
    x~~~
    x~~~ x~--
    0 1 2 3
    c
}

simpleMelody =
    simpleSteps + basicRhythm

simpleLoop = 
   arp(chord(c, simpleMelody))

main(((((simpleLoop)))) + (C# + harmonic-minor))
```

## Famuz Types

    - rhythm -> "x~~~ x--- x~~~ x~--"
    - melody -> "rhythm + steps"
    - harmony -> fn(melody)
    - steps -> "0 1 2 3"
    - scale -> "harmonic-minor"
    - key -> "c#"
    - scaled-key -> scale + key
    - music -> scaled-key + (melody | harmony)