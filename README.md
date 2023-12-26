# ExpressionParser

A Swift Package implementing a dead simple basic arithmetic expression parser.  

Operates on `Decimal`s. 

## Usage

### Basic 

```swift
import ExpressionParser

let x = try ExpressionParser.evaluate("(10 + 0.5 * 4 ) / 3") // x == Decimal(4)
```

### Error Handling

```swift
import ExpressionParser

func printEval(_ expression: String) {
    do {
        let result = try ExpressionParser.evaluate(expression)
        print("\(expression) = \(result)")
    }
    catch let evalError as ExpressionParser.EvaluationError {
        print(expression)
        print(String(repeating: "-", count: evalError.location) + "^ \(evalError)")
    }
    catch let otherError {
        print("Error: \(otherError)")
    }
    print()
}

// Valid

printEval("1 + (-2.345 * 1.678) + 10")
printEval("1'000'000 / 2 000")
printEval("1,000,000.5 - 0,5")

// Invalid

printEval("2 + 2 = 4")
printEval("x / 5")

printEval("2 * (*2)")
printEval("(2 + 2) / (1 + (3 * 3)")
```

Output: 

```
1 + (-2.345 * 1.678) + 10 = 7.06509

1'000'000 / 2 000 = 500

1,000,000.5 - 0,5 = 1000000

2 + 2 = 4
------^ Invalid character '='

x / 5
^ Invalid character 'x'

2 * (*2)
-----^ '*' is not a prefix unary operator

(2 + 2) / (1 + (3 * 3)
----------------------^ ')' expected
```

## License

Do whatever you want.
