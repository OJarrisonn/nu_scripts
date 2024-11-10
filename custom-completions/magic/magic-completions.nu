def "nu-complete magic" [] {
  ^magic --help
  | str replace --regex --multiline '(magic[\s\S]*Commands:)' ''
  | str replace --regex --multiline '\n+Options:[\s\S]*' ''
  | lines
  | parse -r '\s*(?P<value>[^ ]+) \s*(?P<description>\w.*)'
}

def "nu-complete magic colors" [] {
    ["always", "never", "auto"]
}

def "nu-complete magic pypi-keyring" [] {
    ["disabled", "subprocess"]
}

def "nu-complete magic boolean" [] {
    ["true", "false"]
}

# magic - A high level package management tool by Modular for developing with Mojo and MAX.
export extern magic [
    command?: string@"nu-complete magic"
    --help(-h)        # Print help information
    --verbose(-v)     # Increase logging verbosity
    --quiet(-q)       # Decrease logging verbosity
    --color: string@"nu-complete magic colors" = "auto"   # Whether the log needs to be colored [env: MAGIC_COLOR=] [default: auto] [possible values: always, never, auto]
    --no-progress     # Hide all progress bars [env: MAGIC_NO_PROGRESS=]
    --version(-V)     # Print version
    ...args: string 
] 

# Creates a new project
export extern "magic init" [
    location?: path         # The location to create the project
    --channel(-c): string   # Channels to use in the project
    --platform(-p): string  # Platforms that the project supports
    --import(-i): path      # Environment.yml file to bootstrap the project
    --format: string        # The manifest format to create [possible values: pixi, pyproject, mojoproject]
    --help(-h)        # Print help information
    --verbose(-v)     # Increase logging verbosity
    --quiet(-q)       # Decrease logging verbosity
    --color: string@"nu-complete magic colors" = "auto"   # Whether the log needs to be colored [env: MAGIC_COLOR=] [default: auto] [possible values: always, never, auto]
    --no-progress     # Hide all progress bars [env: MAGIC_NO_PROGRESS=]
    ...args: string
]

# Adds dependencies to the project
export extern "magic add" [
    --manifest-path: path # The path to `pixi.toml` or `pyproject.toml`
    --host: string    # The specified dependencies are host dependencies. Conflicts with `build` and `pypi`
    --build           # The specified dependencies are build dependencies. Conflicts with `host` and `pypi`
    --pypi            # The specified dependencies are pypi dependencies. Conflicts with `host` and `build`
    --platform(-p): string # The platform(s) for which the dependency should be modified
    --feature(-f): string # The feature for which the dependency should be modified
    --no-lockfile-update # Don't update lockfile, implies the no-install as well
    --frozen          # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file [env: PIXI_FROZEN=]
    --locked          # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file [env: PIXI_LOCKED=]
    --no-install      # Don't modify the environment, only modify the lock-file
    --tls-no-verify   # Do not verify the TLS certificate of the server
    --auth-file: path # Path to the file containing the authentication token [env: RATTLER_AUTH_FILE=]
    --pypi-keyring-provider: string@"nu-complete magic pypi-keyring" # Specifies if we want to use uv keyring provider
    --editable        # Whether the pypi requirement should be editable
    --help(-h)        # Print help information
    --verbose(-v)     # Increase logging verbosity
    --quiet(-q)       # Decrease logging verbosity
    --color: string@"nu-complete magic colors" = "auto"   # Whether the log needs to be colored [env: MAGIC_COLOR=] [default: auto] [possible values: always, never, auto]
    --no-progress     # Hide all progress bars [env: MAGIC_NO_PROGRESS=]
    ...args: string
]

# Removes dependencies from the project
export extern "magic remove" [
    --manifest-path: path # The path to `pixi.toml` or `pyproject.toml`
    --host: string    # The specified dependencies are host dependencies. Conflicts with `build` and `pypi`
    --build           # The specified dependencies are build dependencies. Conflicts with `host` and `pypi`
    --pypi            # The specified dependencies are pypi dependencies. Conflicts with `host` and `build`
    --platform(-p): string # The platform(s) for which the dependency should be modified
    --feature(-f): string # The feature for which the dependency should be modified
    --no-lockfile-update # Don't update lockfile, implies the no-install as well
    --frozen          # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file [env: PIXI_FROZEN=]
    --locked          # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file [env: PIXI_LOCKED=]
    --no-install      # Don't modify the environment, only modify the lock-file
    --tls-no-verify   # Do not verify the TLS certificate of the server
    --auth-file: path # Path to the file containing the authentication token [env: RATTLER_AUTH_FILE=]
    --pypi-keyring-provider: string@"nu-complete magic pypi-keyring" # Specifies if we want to use uv keyring provider
    --editable        # Whether the pypi requirement should be editable
    --help(-h)        # Print help information
    --verbose(-v)     # Increase logging verbosity
    --quiet(-q)       # Decrease logging verbosity
    --color: string@"nu-complete magic colors" = "auto"   # Whether the log needs to be colored [env: MAGIC_COLOR=] [default: auto] [possible values: always, never, auto]
    --no-progress     # Hide all progress bars [env: MAGIC_NO_PROGRESS=]
    ...args: string
]

# Install all dependencies
export extern "magic install" [
    --manifest-path: path # The path to `pixi.toml` or `pyproject.toml`
    --frozen          # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file [env: PIXI_FROZEN=]
    --locked          # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file [env: PIXI_LOCKED=]
    --environment(-e): string # The environment to install
    --tls-no-verify   # Do not verify the TLS certificate of the server
    --auth-file: path # Path to the file containing the authentication token [env: RATTLER_AUTH_FILE=]
    --pypi-keyring-provider: string@"nu-complete magic pypi-keyring" # Specifies if we want to use uv keyring provider
    --all(-a)
    --help(-h)        # Print help information
    --verbose(-v)     # Increase logging verbosity
    --quiet(-q)       # Decrease logging verbosity
    --color: string@"nu-complete magic colors" = "auto"   # Whether the log needs to be colored [env: MAGIC_COLOR=] [default: auto] [possible values: always, never, auto]
    --no-progress     # Hide all progress bars [env: MAGIC_NO_PROGRESS=]
    ...args: string
]

# Update dependencies as recorded in the local lock file
export extern "magic update" [
    --tls-no-verify   # Do not verify the TLS certificate of the server
    --auth-file: path # Path to the file containing the authentication token [env: RATTLER_AUTH_FILE=]
    --pypi-keyring-provider: string@"nu-complete magic pypi-keyring" # Specifies if we want to use uv keyring provider
    --manifest-path: path # The path to `pixi.toml` or `pyproject.toml`
    --no-install      # Don't modify the environment, only modify the lock-file
    --dry-run(-n)     # Don't actually write the lockfile or update any environment
    --environment(-e): string # The environment to install
    --platform(-p): string # The platform(s) for which the dependency should be modified
    --json            # Output the changes in JSON format
    --help(-h)        # Print help information
    --verbose(-v)     # Increase logging verbosity
    --quiet(-q)       # Decrease logging verbosity
    --color: string@"nu-complete magic colors" = "auto"   # Whether the log needs to be colored [env: MAGIC_COLOR=] [default: auto] [possible values: always, never, auto]
    --no-progress     # Hide all progress bars [env: MAGIC_NO_PROGRESS=]
    ...args: string
]

# Runs task in project
export extern "magic run" [
    task?: string      # The pixi task or a task shell command you want to run in the project's environment, which can be an executable in the environment's PATH
    --manifest-path: path # The path to `pixi.toml` or `pyproject.toml`
    --no-lockfile-update # Don't update lockfile, implies the no-install as well
    --frozen          # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file [env: PIXI_FROZEN=]
    --locked          # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file [env: PIXI_LOCKED=]
    --no-install      # Don't modify the environment, only modify the lock-file
    --tls-no-verify   # Do not verify the TLS certificate of the server
    --auth-file: path # Path to the file containing the authentication token [env: RATTLER_AUTH_FILE=]
    --pypi-keyring-provider: string@"nu-complete magic pypi-keyring" # Specifies if we want to use uv keyring provider
    --environment(-e): string # The environment to install
    --clean-env       # Use a clean environment to run the task
    --help(-h)        # Print help information
    --verbose(-v)     # Increase logging verbosity
    --quiet(-q)       # Decrease logging verbosity
    --color: string@"nu-complete magic colors" = "auto"   # Whether the log needs to be colored [env: MAGIC_COLOR=] [default: auto] [possible values: always, never, auto]
    --no-progress     # Hide all progress bars [env: MAGIC_NO_PROGRESS=]
    ...args: string
]

# Start a shell in the pixi environment of the project
export extern "magic shell" [
    --manifest-path: path # The path to `pixi.toml` or `pyproject.toml`
    --no-lockfile-update # Don't update lockfile, implies the no-install as well
    --frozen          # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file [env: PIXI_FROZEN=]
    --locked          # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file [env: PIXI_LOCKED=]
    --no-install      # Don't modify the environment, only modify the lock-file
    --tls-no-verify   # Do not verify the TLS certificate of the server
    --auth-file: path # Path to the file containing the authentication token [env: RATTLER_AUTH_FILE=]
    --pypi-keyring-provider: string@"nu-complete magic pypi-keyring" # Specifies if we want to use uv keyring provider
    --environment(-e): string # The environment to install
    --change-ps1: string@"nu-complete magic boolean" # Do not change the PS1 variable when starting a prompt [possible values: true, false]
    --help(-h)        # Print help information
    --verbose(-v)     # Increase logging verbosity
    --quiet(-q)       # Decrease logging verbosity
    --color: string@"nu-complete magic colors" = "auto"   # Whether the log needs to be colored [env: MAGIC_COLOR=] [default: auto] [possible values: always, never, auto]
    --no-progress     # Hide all progress bars [env: MAGIC_NO_PROGRESS=]
    ...args: string
]


export alias "magic a" = magic add
export alias "magic rm" = magic remove
export alias "magic i" = magic install
export alias "magic r" = magic run
export alias "magic s" = magic shell
export alias "magic ls" = magic list
export alias "magic t" = magic tree
export alias "magic g" = magic global
