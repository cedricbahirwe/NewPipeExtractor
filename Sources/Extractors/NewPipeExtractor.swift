// The Swift Programming Language
// https://docs.swift.org/swift-book

public class NewPipeExtractors {
    private let param: String
    public init(param: String) {
        self.param = param
    }

    public func extract() {
        print(param, param, terminator: "-")
        let service = LinkHandler("www.google.come", "www.google.com", "google")
        print(service.getOriginalUrl())
    }
}
