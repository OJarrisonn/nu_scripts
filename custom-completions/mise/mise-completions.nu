def "nu-complete mise parse-help" [] {
    $in
    | str replace --regex --multiline '([\s\S]*Commands:\n)' ''
    | str replace --regex --multiline '\n+Options:[\s\S]*' ''
    | lines 
    | filter {|line| not ($line | str starts-with "   ")}
    | str trim
    | parse -r '(?P<value>\S+) \s*(?P<description>\S.*)'
}

def "nu-complete mise commands" [] {    
    ^mise --help 
    | nu-complete mise parse-help
}

def "nu-complete mise alias commands" [] {
    ^mise alias --help 
    | nu-complete mise parse-help
}

def "nu-complete mise backends commands" [] {
    ^mise backends --help 
    | nu-complete mise parse-help
}

def "nu-complete mise cache commands" [] {
    ^mise cache --help 
    | nu-complete mise parse-help
}

def "nu-complete mise config commands" [] {
    ^mise config --help 
    | nu-complete mise parse-help
}

def "nu-complete mise direnv commands" [] {
    ^mise direnv --help 
    | nu-complete mise parse-help
}

def "nu-complete mise generate commands" [] {
    ^mise generate --help 
    | nu-complete mise parse-help
}

def "nu-complete mise plugins commands" [] {
    ^mise plugins --help 
    | nu-complete mise parse-help
}

def "nu-complete mise settings commands" [] {
    ^mise settings --help 
    | nu-complete mise parse-help
}

def "nu-complete mise sync commands" [] {
    ^mise sync --help 
    | nu-complete mise parse-help
}

def "nu-complete mise tasks commands" [] {
    ^mise tasks --help 
    | nu-complete mise parse-help
}

def "nu-complete mise activate shells" [] {
    ["bash", "fish", "nu", "xonsh", "zsh"]
}

def "nu-complete mise completion shells" [] {
    ["bash", "fish", "zsh"]
}

def "nu-complete mise sort-columns" [] {
    ["name", "alias", "description", "source"]
}

def "nu-complete mise sort-directions" [] {
    ["asc", "desc"]
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

def "nu-complete mise plugins all" [] {
    ^mise p ls-remote
    | lines 
    | each {|l| {
        value: ($l | str replace "*" "" | str trim), 
        description: (if ($l | str contains "*") { "installed" } else { "" }) }
    }
}

def "nu-complete mise tasks all" [] {
    ^mise t --no-header --hidden
    | lines
    | str trim
    | parse -r '(?P<name>\S+) \s*(?P<description>\S.*) \s*(?P<source>\S.*)'
    | each {|row| {value: $row.name, description: $"[($row.source)] ($row.description)"} }
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
    subcommand?: string@"nu-complete mise plugins commands"
    --core(-c)              # The built-in plugins only
    --user                  # List installed plugins
    --urls(-u)              # Show the git url for each plugin
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise plugins install" [
    ...plugin: string@"nu-complete mise plugins all"
    --force(-f)             # Reinstall even if plugin exists
    --all(-a)               # Install all missing plugins
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise plugins link" [
    name?: string
    path?: path
    --force(-f)             # Overwrite existing plugin
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise plugins ls" [
    --core(-c)              # The built-in plugins only
    --user                  # List installed plugins
    --urls(-u)              # Show the git url for each plugin
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise plugins ls-remote" [
    --only-names            # Only show the name of each plugin
    --urls(-u)              # Show the git url for each plugin
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise plugins uninstall" [
    ...plugin: string@"nu-complete mise plugins"
    --purge(-p)             # Also remove the plugin's installs, downloads, and cache
    --all(-a)               # Remove all plugins
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise plugins update" [
    ...plugin: string@"nu-complete mise plugins"
    --jobs(-j): int = 4     # Number of jobs to run in parallel [default: 4]
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise prune" [
    ...plugin: string@"nu-complete mise plugins"
    --dry-run(-n)           # Do not actually delete anything
    --configs               # Prune only tracked and trusted configuration links that point to non-existent configurations
    --tools                 # Prune only unused versions of tools
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise reshim" [
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise run" [
    task?: string@"nu-complete mise tasks all"
    ...args: string
    --dry-run(-n)           # Don't actually run the tasks(s), just print them in order of execution
    --force(-f)             # Force the tasks to run even if outputs are up to date
    --prefix(-p)            # Print stdout/stderr by line, prefixed with the tasks's label
    --interleave(-i)        # Print directly to stdout/stderr instead of by line
    --tool(-t): string@"nu-complete mise plugins"  # Tool(s) to also add
    --jobs(-j): int = 4     # Number of jobs to run in parallel [default: 4]
    --raw(-r)               # Read/write directly to stdin/stdout/stderr instead of by line
    --timings               # Shows elapsed time after each tasks
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise self-update" [
    --force                 # Update even if already up to date
    --no-plugins # Disable auto-updating plugins
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise set" [
    --file: path            # The TOML file to update
    --global(-g)            # Set the environment variable in the global config file
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise settings" [
    subcommand?: string@"nu-complete mise settings commands"
    --keys                  # Only display key names for each setting
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise settings get" [
    setting?: string
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise settings ls" [
    --keys                  # Only display key names for each setting
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise settings set" [
    setting?: string
    value?: string
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise settings unset" [
    setting?: string
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise shell" [
    ...tools: string@"nu-complete mise plugins"
    --jobs(-j): int = 4     # Number of jobs to run in parallel [default: 4]
    --raw                   # Directly pipe stdin/stdout/stderr from plugin to user
    --unset(-u)             # Removes a previously set version    
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise sync" [
    subcommand?: string@"nu-complete mise sync commands"
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise sync node" [
    --brew                  # Get tool versions from Homebrew
    --nvm                   # Get tool versions from NVM
    --nodenv                # Get tool versions from nodenv
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise sync python" [
    --pyenv                  # Get tool versions from pyenv
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise tasks" [
    subcommand?: string@"nu-complete mise tasks commands"
    --no-header             # Don't show table header
    --extended(-x)          # Show all columns
    --hidden                # Show hidden tasks
    --sort: string@"nu-complete mise sort-columns" = "name" # Sort by column
    --sort-order: string@"nu-complete mise sort-directions" = "asc" # Sort order
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise tasks deps" [
    ...tasks: string@"nu-complete mise tasks all"
    --hidden                # Show hidden tasks
    --dot                   # Display dependencies in DOT format
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise tasks edit" [
    task?: string@"nu-complete mise tasks all"
    --path(-p)              # Display the path to the tasks instead of editing it
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise tasks ls" [
    --no-header             # Don't show table header
    --extended(-x)          # Show all columns
    --hidden                # Show hidden tasks
    --sort: string@"nu-complete mise sort-columns" = "name" # Sort by column
    --sort-order: string@"nu-complete mise sort-directions" = "asc" # Sort order
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise tasks run" [
    task?: string@"nu-complete mise tasks all"
    ...args: string
    --dry-run(-n)           # Don't actually run the tasks(s), just print them in order of execution
    --force(-f)             # Force the tasks to run even if outputs are up to date
    --prefix(-p)            # Print stdout/stderr by line, prefixed with the tasks's label
    --interleave(-i)        # Print directly to stdout/stderr instead of by line
    --tool(-t): string@"nu-complete mise plugins"  # Tool(s) to also add
    --jobs(-j): int = 4     # Number of jobs to run in parallel [default: 4]
    --raw(-r)               # Read/write directly to stdin/stdout/stderr instead of by line
    --timings               # Shows elapsed time after each tasks
    --cd(-C): path          # Change directory before running command
    --quiet(-q)             # Suppress non-error messages
    --verbose(-v)           # Show extra output (use -vv for even more)
    --yes(-y)               # Answer yes to all confirmation prompts
    --help(-h)              # Print help (see a summary with '-h')
]

export extern "mise trust" [
    config_file?: path
    --all(-a)               # Trust all config files in the current directory and its parents    
    --untrust               # No longer trust this config
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
export alias "mise r" = mise run
export alias "mise sh" = mise shell
export alias "mise t" = mise tasks