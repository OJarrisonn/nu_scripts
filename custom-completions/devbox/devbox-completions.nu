def "nu-complete devbox subcommands" [] {
  ^devbox --help
  | str replace --regex --multiline '([\s\S]*(?=Available Commands:))' '' 
  | str replace --regex --multiline '\n+Flags:[\s\S]*' ''
  | lines 
  | where $it starts-with "  " 
  | parse -r '\s*(?P<value>[^ ]+) \s*(?P<description>\w.*)'
}

def "nu-complete devbox add environment" [] {
    ["dev", "prod", "preview"]
}

def "nu-complete devbox add patch" [] {
    ["auto", "always", "never"]
}

def "nu-complete devbox auth subcommands" [] {
  ^devbox auth --help
  | str replace --regex --multiline '([\s\S]*(?=Available Commands:))' '' 
  | str replace --regex --multiline '\n+Flags:[\s\S]*' ''
  | lines 
  | where $it starts-with "  " 
  | parse -r '\s*(?P<value>[^ ]+) \s*(?P<description>\w.*)'
}

def "nu-complete devbox auth tokens subcommands" [] {
  ^devbox auth tokens --help
  | str replace --regex --multiline '([\s\S]*(?=Available Commands:))' '' 
  | str replace --regex --multiline '\n+Flags:[\s\S]*' ''
  | lines 
  | where $it starts-with "  " 
  | parse -r '\s*(?P<value>[^ ]+) \s*(?P<description>\w.*)'
}

# Instant, easy, predictable development environments
export extern devbox [
    command?: string@"nu-complete devbox subcommands",
    --help(-h)                      # help for devbox
    --quiet(-q)                     # suppresses logs
    ...args
]

# Add a new package to your devbox
export extern "devbox add" [
    --allow-insecure: string        # allow adding packages marked as insecure.
    --config(-c): path              # path to directory containing a devbox.json config file
    --disable-plugin                # disable plugin (if any) for this package.
    --environment: string@"nu-complete devbox add environment"="dev"           # environment to use, when supported (e.g.secrets support dev, prod, preview.) (default "dev")
    --exclude-platform(-e): string  # exclude packages from a specific platform.
    --outputs(-o): string           # specify the outputs to select for the nix package
    --patch: string@"nu-complete devbox add patch"="auto"                 # allow Devbox to patch the package to fix known issues (auto, always, never) (default "auto")
    --platform(-p): string          # add packages to run on only this platform.  
    --help(-h)                      # help for add
    --quiet(-q)                     # suppresses logs
    ...args
]

# Devbox auth commands
export extern "devbox auth" [
    command?: string@"nu-complete devbox auth subcommands",
    --help(-h)                      # help for auth
    --quiet(-q)                     # suppresses logs
    ...args
]

# Login to devbox
export extern "devbox auth login" [
    --help(-h)                      # help for login
    --quiet(-q)                     # suppresses logs
    ...args
]

# Logout from devbox
export extern "devbox auth logout" [
    --help(-h)                      # help for login
    --quiet(-q)                     # suppresses logs
    ...args
]

# Manage devbox auth tokens
export extern "devbox auth tokens" [
    command?: string@"nu-complete devbox auth tokens subcommands",
    --help(-h)                      # help for login
    --quiet(-q)                     # suppresses logs
    ...args
]

# Create a new token
export extern "devbox auth tokens new" [
    --help(-h)                      # help for login
    --quiet(-q)                     # suppresses logs
    ...args
]