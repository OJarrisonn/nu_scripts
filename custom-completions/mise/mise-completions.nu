def "nu-complete mise commands" [] {    
    ^mise --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise alias commands" [] {
    ^mise alias --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise backends commands" [] {
    ^mise backends --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise cache commands" [] {
    ^mise cache --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise config commands" [] {
    ^mise config --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise direnv commands" [] {
    ^mise direnv --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise generate commands" [] {
    ^mise generate --help 
    | str replace --regex --multiline '([\s\S]*Commands:\n)' '' 
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise plugins commands" [] {
    ^mise plugins --help 
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
    ...tools: string@"nu-complete mise plugins"
    --json(-J)              # Output in JSON format
    --shell(-s): string@"nu-complete mise activate shells" # Shell type to generate environment variables for
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise exec" [
    ...tools: string@"nu-complete mise plugins"
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

export extern "mise implode" [
    --config                # Also remove config directory
    --dry-run(-n)           # List directories that would be removed without actually removing them
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise install" [
    ...tools: string
    --force(-f)             # Force reinstall even if already installed
    --jobs(-j): int = 4     # Number of jobs to run in parallel [default: 4]
    --raw                   # Directly pipe stdin/stdout/stderr from plugin to user
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise latest" [
    tool?: string
    --installed(-i)         # Show latest installed instead of available version
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise link" [
    tool?: string
    path?: path
    --force(-f)             # Overwrite an existing tool version if it exists
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise ls" [
    ...plugin: string@"nu-complete mise plugins"    # Only show versions of 
    --current(-c)           # Only show tool versions currently specified in a .tool-versions/.mise.toml
    --global(-g)            # Only show tool versions currently specified in a the global .tool-versions/.mise.toml
    --installed(-i)         # Only show tool versions that are installed
    --json(-J)              # Output in JSON format
    --missing(-m)           # Display missing tool versions
    --no-header             # Don't show table header
    --prefix: string        # Display versions matching this prefix
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise ls-remote" [
    tool?: string
    prefix?: string
    --all # Show all installed plugins and versions
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise outdated" [
    ...tool: string@"nu-complete mise plugins"
    --json(-J)              # Output in JSON format
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise plugins" [
    --core(-c)              # The built-in plugins only
    --user                  # List installed plugins
    --urls(-u)              # Show the git url for each plugin
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
export alias "mise i" = mise install
export alias "mise ln" = mise link
export alias "mise list" = mise ls
export alias "mise p" = mise plugins