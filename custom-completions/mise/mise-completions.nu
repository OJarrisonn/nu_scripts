def "nu-complete mise subcommands" [] {
    ^mise --help
    | str replace --regex --multiline '(mise[\s\S]*(?=Commands:))' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | parse -r '\s\s(?P<value>([a-z]|-)+) \s*(?P<description>\w.*)'
    | reject capture1
}

def "nu-complete mise alias subcommands" [] {
    ^mise alias --help
    | str replace --regex --multiline '(mise[\s\S]*(?=Commands:))' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | parse -r '\s\s(?P<value>([a-z]|-)+) \s*(?P<description>\w.*)'
    | reject capture1
}

def "nu-complete mise available-shells" [] {
    [bash fish nu xonsh zsh]
}

# mise is a tool for managing runtime versions. 
export extern "mise" [
    subcommand?: string@"nu-complete mise subcommands"
    --cd(-C): string                        # Change directory before running command
    --quiet(-q)                             # Suppress non-error messages
    --yes(-y)                               # Automatically say yes to all prompts
    --version(-V)                           # Print version information
    --help(-h)                              # Print this help message
    --verbose(-v)                           # Use verbose output (-vv for more output)
]

# Initializes mise in the current shell session
export extern "mise activate" [
    shell?: string@"nu-complete mise available-shells"
    --cd(-C): string                        # Change directory before running command
    --shims                                 # Use shims instead of modifying PATH
    --quiet(-q)                             # Suppress non-error messages
    --yes(-y)                               # Automatically say yes to all prompts
    --help(-h)                              # Print this help message
    --verbose(-v)                           # Use verbose output (-vv for more output)
]

# Manage aliases
export extern "mise alias" [
    subcommand?: string@"nu-complete mise alias subcommands"
    --cd(-C): string                        # Change directory before running command
    --quiet(-q)                             # Suppress non-error messages
    --plugin(-p): string                    # Filter aliases by plugin
    --no-header                             # Don't show table header
    --yes(-y)                               # Automatically say yes to all prompts
    --help(-h)                              # Print this help message
    --verbose(-v)                           # Use verbose output (-vv for more output)
]

export extern "mise alias ls" [
    plugin?: string                         # Filter aliases by plugin
    --cd(-C): string                        # Change directory before running command
    --quiet(-q)                             # Suppress non-error messages
    --plugin(-p): string                    # Filter aliases by plugin
    --no-header                             # Don't show table header
    --yes(-y)                               # Automatically say yes to all prompts
    --help(-h)                              # Print this help message
    --verbose(-v)                           # Use verbose output (-vv for more output)
]

