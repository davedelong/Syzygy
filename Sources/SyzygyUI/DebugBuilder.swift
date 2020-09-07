//
//  File.swift
//  
//
//  Created by Dave DeLong on 8/29/20.
//

import Foundation

@_functionBuilder
public struct DebugBuilder {
    public struct Call {
        fileprivate var method: Method
        fileprivate var location: SourceLoc
    }
    
    fileprivate indirect enum Method {
        case buildExpression(Any)
        case buildFinalResult(Call)
        case buildLimitedAvailability(Call)
        case buildEitherFirst(Call)
        case buildEitherSecond(Call)
        case buildOptional(Call?)
        case buildArray([Call])
        case buildBlock([Call])
        case buildDo([Call])
    }
    
    fileprivate struct SourceLoc: CustomStringConvertible {
        let file: String
        let line: Int
        let column: Int
        var description: String { "\(file):\(line):\(column)" }
    }
    
    public static func buildExpression(_ expression: Any, file: String = #file, line: Int = #line, column: Int = #column) -> Call {
        .init(method: .buildExpression(expression), location: .init(file: file, line: line, column: column))
    }
    
    public static func buildBlock(_ components: Call..., file: String = #file, line: Int = #line, column: Int = #column) -> Call {
        .init(method: .buildBlock(components), location: .init(file: file, line: line, column: column))
    }
    
    public static func buildFinalResult(_ component: Call, file: String = #file, line: Int = #line, column: Int = #column) -> Call {
        .init(method: .buildFinalResult(component), location: .init(file: file, line: line, column: column))
    }
    
    public static func buildDo(_ components: Call..., file: String = #file, line: Int = #line, column: Int = #column) -> Call {
        .init(method: .buildDo(components), location: .init(file: file, line: line, column: column))
    }
    
    public static func buildOptional(_ component: Call?, file: String = #file, line: Int = #line, column: Int = #column) -> Call {
        .init(method: .buildOptional(component), location: .init(file: file, line: line, column: column))
    }
    
    public static func buildEither(first component: Call, file: String = #file, line: Int = #line, column: Int = #column) -> Call {
        .init(method: .buildEitherFirst(component), location: .init(file: file, line: line, column: column))
    }
    
    public static func buildEither(second component: Call, file: String = #file, line: Int = #line, column: Int = #column) -> Call {
        .init(method: .buildEitherSecond(component), location: .init(file: file, line: line, column: column))
    }
    
    public static func buildArray(_ components: [Call], file: String = #file, line: Int = #line, column: Int = #column) -> Call {
        .init(method: .buildArray(components), location: .init(file: file, line: line, column: column))
    }
    
    public static func buildLimitedAvailability(_ component: Call, file: String = #file, line: Int = #line, column: Int = #column) -> Call {
        .init(method: .buildLimitedAvailability(component), location: .init(file: file, line: line, column: column))
    }
    
    public static func calls(@DebugBuilder in body: () -> Call) -> Call {
        body()
    }
}

fileprivate struct Line: CustomStringConvertible {
    var level: Int = 0
    var text: Substring
    
    func withAnotherLevel() -> Line {
        var copy = self
        copy.level += 1
        return copy
    }
    
    var description: String {
        String(repeating: "  ", count: level) + text
    }
}

fileprivate extension Array where Element == Line {
    init(from expression: Any) {
        let str = String(reflecting: expression)
        self = str.split(separator: "\n", omittingEmptySubsequences: false)
            .map { Line(text: $0) }
    }
    
    func wrappedBy(
        prefix: Substring,
        suffix: Substring
    ) -> [Line] {
        [ Line(text: prefix) ]
            + map { $0.withAnotherLevel() }
            + [ Line(text: suffix) ]
    }
    
    func mapFirstText(_ transform: (Substring) -> Substring) -> [Line] {
        var copy = self
        copy[0].text = transform(copy[0].text)
        return copy
    }
    
    func mapLastText(_ transform: (Substring) -> Substring) -> [Line] {
        var copy = self
        copy[endIndex - 1].text = transform(copy[endIndex - 1].text)
        return copy
    }
    
    func withLoc(_ loc: DebugBuilder.SourceLoc) -> [Line] {
        [Line](from: loc).mapFirstText { "// \($0)" } + self
    }
}

extension DebugBuilder.Method {
    func debugDescriptionLines() -> [Line] {
        switch self {
            case .buildExpression(let expression):
                return [Line](from: expression)
                    .wrappedBy(
                        prefix: "SampleFunctionBuilder.buildExpression(",
                        suffix: ")"
            )
            
            case .buildFinalResult(let component):
                return component.debugDescriptionLines()
                    .wrappedBy(
                        prefix: "SampleFunctionBuilder.buildFinalResult(",
                        suffix: ")"
            )
            
            case .buildLimitedAvailability(let component):
                return component.debugDescriptionLines()
                    .wrappedBy(
                        prefix: "SampleFunctionBuilder.buildLimitedAvailability(",
                        suffix: ")"
            )
            
            case .buildEitherFirst(let component):
                return component.debugDescriptionLines(label: "first: ")
                    .wrappedBy(
                        prefix: "SampleFunctionBuilder.buildEither(",
                        suffix: ")"
            )
            
            case .buildEitherSecond(let component):
                return component.debugDescriptionLines(label: "second: ")
                    .wrappedBy(
                        prefix: "SampleFunctionBuilder.buildEither(",
                        suffix: ")"
            )
            
            case .buildOptional(let component):
                return component.debugDescriptionLines()
                    .wrappedBy(
                        prefix: "SampleFunctionBuilder.buildOptional(",
                        suffix: ")"
            )
            
            case .buildArray(let components):
                return components.debugDescriptionLines()
                    .wrappedBy(prefix: "[", suffix: "]")
                    .wrappedBy(
                        prefix: "SampleFunctionBuilder.buildArray(",
                        suffix: ")"
            )
            
            case .buildBlock(let components):
                return components.debugDescriptionLines()
                    .wrappedBy(
                        prefix: "SampleFunctionBuilder.buildBlock(",
                        suffix: ")"
            )
            
            case .buildDo(let components):
                return components.debugDescriptionLines()
                    .wrappedBy(
                        prefix: "SampleFunctionBuilder.buildDo(",
                        suffix: ")"
            )
        }
    }
}

fileprivate extension Array where Element == DebugBuilder.Call {
    func debugDescriptionLines(label: String = "") -> [Line] {
        let lineGroups = [first!.debugDescriptionLines(label: label)] +
            dropFirst().map { $0.debugDescriptionLines() }
        
        return lineGroups.dropLast().flatMap { $0.mapLastText { "\($0)," } } +
            lineGroups.last!
    }
}

fileprivate extension Optional where Wrapped == DebugBuilder.Call {
    func debugDescriptionLines(label: String = "") -> [Line] {
        map { $0.debugDescriptionLines(label: label) } ?? [ Line(text: label + "nil") ]
    }
}

fileprivate extension DebugBuilder.Call {
    func debugDescriptionLines(label: String = "") -> [Line] {
        method
            .debugDescriptionLines()
            .mapFirstText { label + $0 }
            .withLoc(location)
    }
}

extension DebugBuilder.Call: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionLines().map(String.init(describing:)).joined(separator: "\n")
    }
}
