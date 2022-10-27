import ArgumentParser

// Simplified code that originates from https://github.com/apple/swift-package-manager/blob/main/Sources/Commands/SwiftPackageTool.swift

@main
struct SwiftCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swift",
        abstract: "The Swift compiler",
        subcommands: [
            SwiftRunTool.self,
            SwiftPackageTool.self,
        ]
    )
}

public struct SwiftPackageTool: ParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "package",
        _superCommandName: "swift",
        abstract: "Perform operations on Swift packages",
        discussion: "SEE ALSO: swift build, swift run, swift test",
        version: "SwiftVersion.current.completeDisplayString",
        subcommands: [
            Clean.self,
            DefaultCommand.self
        ],
        defaultSubcommand: DefaultCommand.self,
        helpNames: [.short, .long, .customLong("help", withSingleDash: true)])
    
    @OptionGroup()
    var globalOptions: GlobalOptions
    
    public init() {}
}

public struct SwiftRunTool: ParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "run",
        _superCommandName: "swift",
        abstract: "Build and run an executable product",
        discussion: "SEE ALSO: swift build, swift package, swift test",
        version: "SwiftVersion.current.completeDisplayString",
        helpNames: [.short, .long, .customLong("help", withSingleDash: true)])
    
    @OptionGroup()
    var globalOptions: GlobalOptions
    
    public init() {}
    
    public func run() throws {}
}

struct GlobalOptions: ParsableArguments {
    init() {}
    
    @OptionGroup()
    var locations: LocationOptions
}

struct LocationOptions: ParsableArguments {
    init() {}
    
    @Option(name: .customLong("package-path"), help: "Specify the package path to operate on (default current directory). This changes the working directory before any other operation", completion: .directory)
    var _packageDirectory: AbsolutePath?
    
    @Option(name: .customLong("cache-path"), help: "Specify the shared cache directory path", completion: .directory)
    var cacheDirectory: AbsolutePath?
    
    @Option(name: .customLong("config-path"), help: "Specify the shared configuration directory path", completion: .directory)
    var configurationDirectory: AbsolutePath?
    
    @Option(name: .customLong("security-path"), help: "Specify the shared security directory path", completion: .directory)
    var securityDirectory: AbsolutePath?
    
    @Option(name: [.long, .customShort("C")], help: .hidden)
    var _deprecated_chdir: AbsolutePath?
    
    var packageDirectory: AbsolutePath? {
        self._packageDirectory ?? self._deprecated_chdir
    }
    
    /// The custom .build directory, if provided.
    @Option(name: .customLong("scratch-path"), help: "Specify a custom scratch directory path (default .build)", completion: .directory)
    var _scratchDirectory: AbsolutePath?
    
    @Option(name: .customLong("build-path"), help: .hidden)
    var _deprecated_buildPath: AbsolutePath?
    
    var scratchDirectory: AbsolutePath? {
        self._scratchDirectory ?? self._deprecated_buildPath
    }
    
    /// The path to the file containing multiroot package data. This is currently Xcode's workspace file.
    @Option(name: .customLong("multiroot-data-file"), help: .hidden, completion: .directory)
    var multirootPackageDataFile: AbsolutePath?
    
    /// Path to the compilation destination describing JSON file.
    @Option(name: .customLong("destination"), help: .hidden, completion: .directory)
    var customCompileDestination: AbsolutePath?
}

public struct AbsolutePath: Hashable {
    /// Check if the given name is a valid individual path component.
    ///
    /// This only checks with regard to the semantics enforced by `AbsolutePath`
    /// and `RelativePath`; particular file systems may have their own
    /// additional requirements.
    static func isValidComponent(_ name: String) -> Bool {
        return true
    }
    
    /// Private implementation details, shared with the RelativePath struct.
    private let _impl: String
    
    /// Private initializer when the backing storage is known.
    init() {
        _impl = "Dummy"
    }
}

extension AbsolutePath: ExpressibleByArgument {
    public init?(argument: String) {
        self.init()
    }
    
    public static var defaultCompletionKind: CompletionKind {
        // This type is most commonly used to select a directory, not a file.
        // Specify '.file()' in an argument declaration when necessary.
        .directory
    }
}

struct Clean: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Delete build artifacts")
    
    @OptionGroup(_hiddenFromHelp: true)
    var globalOptions: GlobalOptions
    
    func run() throws {
    }
}

struct DefaultCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "", // zsh completion script generation does not work with "" but using nil apparently works
        shouldDisplay: false)
    
    @OptionGroup(_hiddenFromHelp: true)
    var globalOptions: GlobalOptions
    
    @Argument(parsing: .unconditionalRemaining)
    var remaining: [String] = []
    
    init() {}
    
    func run() throws {
    }
}
