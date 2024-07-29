def "nu-complete mise commands" [] {    
    mise --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise alias commands" [] {
    mise alias --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise backends commands" [] {
    mise backends --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise cache commands" [] {
    mise cache --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise config commands" [] {
    mise config --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise direnv commands" [] {
    mise direnv --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise generate commands" [] {
    mise generate --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise activate shells" [] {
    ["bash", "fish", "nu", "xonsh", "zsh"]
}

def "nu-complete mise completion shells" [] {
    ["bash", "fish", "zsh"]
}

def "nu-complete mise plugins" [] {
    ^mise p ls --core --user
    | lines
    | str trim
}

def "nu-complete mise aliases" [] {
    ^mise a ls --no-header
    | lines
    | str trim
    | parse -r '(?P<plugin>\S+) \s*(?P<alias>\S+) \s*(?P<version>\S.*)'
    | each {|row| {value: $row.alias, description: $"($row.plugin) ($row.version)"} }
}

def "nu-complete mise tool-at-version" [] {
    ^mise p ls --core --user
    | lines
    | str trim
    | each {|line| $"($line)@" }
}

export extern "mise" [
    subcommand?: string@"nu-complete mise commands"
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
    --version(-V)           # Print version
]

export extern "mise activate" [
    shell?: string@"nu-complete mise activate shells"
    --shims                 # Use shims instead of modifying PATH
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
] 

export extern "mise alias" [
    subcommand?: string@"nu-complete mise alias commands"
    --plugin(-p): string@"nu-complete mise plugins"    # filter aliases by plugin
    --no-header             # Don't show table header
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]


export extern "mise alias get" [
    plugin?: string@"nu-complete mise plugins"    # filter aliases by plugin
    alias?: string@"nu-complete mise aliases"     # filter aliases by name
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise alias ls" [
    plugin?: string@"nu-complete mise plugins"    # filter aliases by plugin
    --no-header             # Don't show table header
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise alias set" [
    plugin?: string@"nu-complete mise plugins"    # filter aliases by plugin
    alias?: string@"nu-complete mise aliases"     # filter aliases by name
    value?: string          # value to set alias to
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise alias unset" [
    plugin?: string@"nu-complete mise plugins"    # filter aliases by plugin
    alias?: string@"nu-complete mise aliases"     # filter aliases by name
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise backends" [
    subcommand?: string@"nu-complete mise backends commands"
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise backends ls" [
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise bin-paths" [
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise cache" [
    subcommand?: string@"nu-complete mise cache commands"
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise cache clear" [
    ...plugin: string@"nu-complete mise plugins"        # Clear cache for a specific plugin
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise completion" [
    shell?: string@"nu-complete mise completion shells"
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise config" [
    subcommand?: string@"nu-complete mise config commands"
    --no-header             # Don't show table header
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise config ls" [
    --output(-o): path      # Output to file instead of stdout
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise config generate" [
    --output(-o): path      # Output to file instead of stdout
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise current" [
    plugin?: string@"nu-complete mise plugins"    # filter to show versions of
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise deactivate" [
    shell?: string@"nu-complete mise activate shells"
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise direnv" [
    subcommand?: string@"nu-complete mise direnv commands"
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise direnv activate" [
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise doctor" [
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise env" [
    ...tools: string@"nu-complete mise tool-at-version"
    --json(-J)              # Output in JSON format
    --shell(-s): string@"nu-complete mise activate shells" # Shell type to generate environment variables for
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise exec" [
    ...tools: string@"nu-complete mise tool-at-version"
    --command(-c): string   # Command to run
    --jobs(-j): int = 4     # Number of jobs to run in parallel [default: 4]
    --raw                   # Directly pipe stdin/stdout/stderr from plugin to user
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise generate" [
    subcommand?: string@"nu-complete mise generate commands"
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise generate git-pre-commit" [
    --hook: string = "pre-commit"       # Which hook to generate (saves to .git/hooks/$hook)
    --task(-t): string = "pre-commit"   # The task to run when the pre-commit hook is triggered
    --write(-w)                         # write to .git/hooks/pre-commit and make it executable
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise generate github-action" [
    --name(-n): string = "ci" # the name of the workflow to generate
    --task(-t): string = "ci" # The task to run when the workflow is triggered
    --write(-w)             # write to .github/workflows/$name.yml
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

# Aliases
export alias "mise a" = mise alias
export alias "mise b" = mise backends
export alias "mise cfg" = mise config
export alias "mise dr" = mise doctor
export alias "mise e" = mise env
export alias "mise x" = mise exec
export alias "mise gen" = mise generate