//
//  Token.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 15/12/2024.
//


public enum Token {
    case error
    case eof
    case eol
    case `return`                 // return keyword
    case bitOr                    // bitwise OR
    case bitXor                   // bitwise XOR
    case bitAnd                   // bitwise AND
    case eq                       // equality
    case ne                       // not equal
    case lt                       // less than
    case le                       // less than or equal
    case gt                       // greater than
    case ge                       // greater than or equal
    case lsh                      // left shift
    case rsh                      // right shift
    case ursh                     // unsigned right shift
    case add                      // addition
    case sub                      // subtraction
    case mul                      // multiplication
    case div                      // division
    case mod                      // modulo
    case not                      // logical NOT
    case bitNot                   // bitwise NOT
    case new                      // new keyword
    case delProp                  // delete property
    case typeOf                   // typeof keyword
    case name
    case number
    case string
    case null                     // null keyword
    case this                     // this keyword
    case `false`                    // false keyword
    case `true`                     // true keyword
    case shEq                     // shallow equality (===)
    case shNe                     // shallow inequality (!==)
    case regexp
    case `throw`                    // throw keyword
    case `in`                     // in keyword
    case instanceof               // instanceof keyword
    case yield                    // JS 1.7 yield pseudo keyword
    case exp                      // Exponentiation Operator
    case bigInt                   // ES2020 BigInt
    case `try`                    // try keyword
    case semi                     // semicolon
    case lb                       // left bracket
    case rb                       // right bracket
    case lc                       // left curly brace
    case rc                       // right curly brace
    case lp                       // left parenthesis
    case rp                       // right parenthesis
    case comma                    // comma operator
    case assign                   // simple assignment (=)
    case assignBitOr              // |=
    case assignBitXor             // ^=
    case assignBitAnd             // |=
    case assignLsh                // <<=
    case assignRsh                // >>=
    case assignUrsh               // >>>=
    case assignAdd                // +=
    case assignSub                // -=
    case assignMul                // *=
    case assignDiv                // /=
    case assignMod                // %=
    case assignExp                // **=
    case hook                     // conditional (?:)
    case colon
    case or                       // logical OR (||)
    case and                      // logical AND (&&)
    case inc                      // increment
    case dec                      // decrement
    case dot                      // member operator (.)
    case function                 // function keyword
    case export                   // export keyword
    case `import`                 // import keyword
    case `if`                     // if keyword
    case `else`                   // else keyword
    case `switch`                 // switch keyword
    case `case`                   // case keyword
    case `default`                // default keyword
    case `while`                  // while keyword
    case `do`                     // do keyword
    case `for`                    // for keyword
    case `break`                  // break keyword
    case `continue`               // continue keyword
    case `var`                    // var keyword
    case `with`                   // with keyword
    case `catch`                  // catch keyword
    case `finally`                // finally keyword
    case void                     // void keyword
    case reserved                 // reserved keywords
    case `let`                    // JS 1.7 let pseudo keyword
    case `const`
    case debugger
    case comment
    case arrow                    // ES6 ArrowFunction
    case yieldStar                // ES6 "yield *"
    case templateLiteral          // template literal

    // Properties to mimic the Java enum's behavior
    public var isOp: Bool {
        switch self {
        case .bitOr, .bitXor, .bitAnd, .eq, .ne, .lt, .le, .gt, .ge,
             .lsh, .rsh, .ursh, .add, .sub, .mul, .div, .mod, .not,
             .bitNot, .new, .delProp, .typeOf, .throw, .`in`,
             .instanceof, .shEq, .shNe, .exp, .assign, .assignBitOr,
             .assignBitXor, .assignBitAnd, .assignLsh, .assignRsh,
             .assignUrsh, .assignAdd, .assignSub, .assignMul,
             .assignDiv, .assignMod, .assignExp, .hook, .colon,
             .or, .and:
            return true
        default:
            return false
        }
    }

    public var isPunct: Bool {
        switch self {
        case .semi, .lb, .rb, .lc, .rc, .lp, .rp, .comma, .assign,
             .assignBitOr, .assignBitXor, .assignBitAnd, .assignLsh,
             .assignRsh, .assignUrsh, .assignAdd, .assignSub,
             .assignMul, .assignDiv, .assignMod, .assignExp, .hook,
             .colon, .dot, .arrow:
            return true
        default:
            return false
        }
    }

    public var isKeyw: Bool {
        switch self {
        case .`return`, .new, .delProp, .typeOf, .null, .this, .false,
             .true, .throw, .`in`, .instanceof, .yield, .`try`,
             .function, .export, .`import`, .`if`, .`else`, .`switch`,
             .`case`, .`default`, .`while`, .`do`, .`for`, .`break`,
             .`continue`, .`var`, .`with`, .`catch`, .`finally`,
             .void, .reserved, .`let`, .`const`, .debugger,
             .yieldStar:
            return true
        default:
            return false
        }
    }

    public func isConditional() -> Bool {
        return self == .`if` || self == .`for` || self == .`while` || self == .`with`
    }
}
