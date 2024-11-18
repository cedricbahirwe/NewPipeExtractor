//
//  JavaScript.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//


import JavaScriptCore

public enum JavaScript {
    /**
     * Compiles the given JavaScript function and throws an error if the compilation fails.
     *
     * - Parameter function: The JavaScript function to compile.
     * - Throws: An error if the compilation fails.
     */
    public static func compileOrThrow(_ function: String) throws {
        let context = JSContext()!
        // Attempt to evaluate the function; if it fails, an error will be thrown
        guard context.evaluateScript(function) != nil else {
            throw NSError(domain: "JavaScriptError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to compile JavaScript function."])
        }
    }

    /**
     * Runs a JavaScript function with the given parameters.
     *
     * - Parameters:
     *   - function: The JavaScript code containing the function definition.
     *   - functionName: The name of the JavaScript function to call.
     *   - parameters: The parameters to pass to the JavaScript function.
     * - Returns: The result of the JavaScript function as a String.
     * - Throws: An error if the execution fails or the function does not exist.
     */
    public static func run(function: String, functionName: String, parameters: [String]) throws -> String {
        let context = JSContext()!
        
        // Evaluate the script
        guard context.evaluateScript(function) != nil else {
            throw NSError(domain: "JavaScriptError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to evaluate JavaScript function."])
        }
        
        // Retrieve the JavaScript function by name
        guard let jsFunction = context.objectForKeyedSubscript(functionName) else {
            throw NSError(domain: "JavaScriptError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Function \(functionName) not found in JavaScript context."])
        }
        
        // Call the function with the provided parameters
        let result = jsFunction.call(withArguments: parameters)
        
        // Ensure the result is valid and return it as a String
        guard let stringResult = result?.toString() else {
            throw NSError(domain: "JavaScriptError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to execute JavaScript function \(functionName)."])
        }
        
        return stringResult
    }
}
