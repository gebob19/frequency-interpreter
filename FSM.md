# States

| State | Value | Description       |
|-------|-------|-------------------|
| LO3   | 0000  | Lowest Pitch      |
| LO2   | 0001  | 2nd Lowest Pitch  |
| LO1   | 0011  | 3rd Lowest Pitch  |
| MEL   | 0010  | Medium-Low Pitch  |
| ME    | 0110  | Medium Pitch      |
| MEH   | 0100  | Medium-High       |
| HI1   | 1100  | 3rd Highest Pitch |
| HI2   | 1000  | 2nd Highest Pitch |
| HI3   | 1001  | Highest Pitch     |

# Transitions

| Transition | Value | Description        |
|------------|-------|--------------------|
| OFF        | 00    | No Sound           |
| HI         | 01    | High Pitch Sound   |
| ME         | 10    | Medium Pitch Sound |
| LO         | 11    | Low Pitch Sound    |

# Frequency to Transition

| Frequency | Transition |
|-----------|------------|
| 4'b0000   | OFF        |
| 4'b0001   | LO         |
| 4'b0010   | LO         |
| 4'b0011   | LO         |
| 4'b0100   | LO         |
| 4'b0101   | LO         |
| 4'b0110   | ME         |
| 4'b0111   | ME         |
| 4'b1000   | ME         |
| 4'b1001   | ME         |
| 4'b1010   | ME         |
| 4'b1011   | HI         |
| 4'b1100   | HI         |
| 4'b1101   | HI         |
| 4'b1110   | HI         |
| 4'b1111   | HI         |

`x` is the frequency

`y` is the state

`y = floor((x + 4) / 5)`

| x  | y |
|----|---|
|  0 | 0 |
|  1 | 1 |
|  2 | 1 |
|  3 | 1 |
|  4 | 1 |
|  5 | 1 |
|  6 | 2 |
|  7 | 2 |
|  8 | 2 |
|  9 | 2 |
| 10 | 2 |
| 11 | 3 |
| 12 | 3 |
| 13 | 3 |
| 14 | 3 |
| 15 | 3 |


# State-Transition Table

| State | Transition | Next State |
|-------|------------|------------|
| `s`   | OFF        | `s`        |
| LO1   | LO         | LO1        |
| LO1   | ME         | LO2        |
| LO1   | HI         | LO2        |
| LO2   | LO         | LO1        |
| LO2   | ME         | LO3        |
| LO2   | HI         | LO3        |
| LO3   | LO         | LO2        |
| LO3   | ME         | MEH        |
| LO3   | HI         | MEH        |
| MEH   | LO         | LO1        |
| MEH   | ME         | ME         |
| MEH   | HI         | ME         |
| ME    | LO         | MEH        |
| ME    | ME         | ME         |
| ME    | HI         | MEL        |
| MEL   | LO         | ME         |
| MEL   | ME         | ME         |
| MEL   | HI         | HI3        |
| HI3   | LO         | MEL        |
| HI3   | ME         | MEL        |
| HI3   | HI         | HI2        |
| HI2   | LO         | HI3        |
| HI2   | ME         | HI3        |
| HI2   | HI         | HI1        |
| HI1   | LO         | HI2        |
| HI1   | ME         | HI2        |
| HI1   | HI         | HI1        |
