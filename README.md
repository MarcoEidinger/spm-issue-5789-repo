# spm-issue-5789-repo

Simple Reproducer for https://github.com/apple/swift-package-manager/issues/5789

// Simplified code of https://github.com/apple/swift-package-manager/blob/main/Sources/Commands/SwiftPackageTool.swift

## How

- Run `swift run Example --generate-completion-script zsh > ~/.oh-my-zsh/completions/_swift`
  - Output file stored in this repo `./_swift` 
- Try tab completion for `swift` in terminal

Error `_swift:89: parse error near `()'`

## Potential fix

Use `nil` as commandName in `DefaultCommand` instead of empty string

```Swift
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
```
