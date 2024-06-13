def "nu-complete kw subcommands" [] {
    [
        [value description];
        ["init" "Initialize kworkflow config file"]
        ["build" "Build kernel"]
        ["deploy" "Deploy a new kernel image to a target machine"]
        ["bd" "Build and install kernel image/modules"]
        ["diff" "Diff files"]
        ["ssh" "SSH support"]
        ["codestyle" "Apply checkpatch on directory or file"]
        ["self-update" "kw self-update mechanism"]
        ["maintainers" "Get maintainers and mailing list"]
        ["kernel-config-manager" "Manage kernel .config files"]
        ["config" "Set kw config options"]
        ["remote" "Manage machines available via ssh"]
        ["explore" "Explore string patterns"]
        ["pomodoro" "kw pomodoro support"]
        ["report" "Show kw pomodoro reports and kw usage statistics"]
        ["device" "Show basic hardware information"]
        ["backup" "Save or restore kw data"]
        ["debug" "Linux kernel debug utilities"]
        ["mail" "Send patches via email"]
        ["env" "Handle kw envs"]
        ["patch-hub" "Interface to lore kernel"]
        ["clear-cache" "Clear files generated by kw"]
        ["drm" "Set of commands to work with DRM drivers"]
        ["vm" "Basic support for QEMU image"]
        ["version" "Show kw version"]
        ["man" "Show manual pages"]
        ["h" "Displays this help message"]
        ["help" "Show kw man page"]
    ]
}

def "nu-complete kw man pages" [] {
    nu-complete kw subcommands | where value != "bd" and value != "h" and value != "help" and value != "man"
}

def "nu-complete kw warnings" [] {
    [
        [value description]; 
        ["1" "not too often, may be relevant"] 
        ["2" "quite often, may still be relevant"] 
        ["3" "more obscure, likely ignorable"]
        ["12" "warns 1 and 2"]
        ["13" "warns 1 and 3"]
        ["23" "warns 2 and 3"]
        ["123" "all warnings"]
    ]
}

def "nu-complete kw target" [] {
    ["local", "remote"]
}

def "nu-complete kw init template" [] {
    ["x86-64", "rpi4-raspbian-32-cross-x86-arm", "rpi4-raspbian-64-cross-x86-arm"]
}

def "nu-complete kw init arch" [] {
    if ("arch" | path exists) {
        ls arch 
        | where type == "dir" 
        | get name 
        | each {|el| $el | str replace 'arch/' ''}
    } else {
        []
    }
}

def "nu-complete kw deploy alert" [] {
    ["s", "v", "sv", "vs", "n"]
}

def "nu-complete kw cores" [] {
    1..(sys cpu | length)
}

def "nu-complete kw configs" [] {
    ^kw config -s 
    | lines 
    | parse --regex '\[.*\] (?<value>[a-z_.]+)=(?<description>.+)$'
}

def "nu-complete kw remotes" [] {
    ^kw remote --list
    | lines
    | filter {|line| not ($line | str contains " ")}
}

# The inglorious kernel developer workflow tool
export extern "kw" [
    subcommand?: string@"nu-complete kw subcommands"  # Subcommand to run
    --help(-h)          # Shows help page
    --version(-v)       # Shows version
]

# Show kw manual pages
export extern "kw man" [
    page?: string@"nu-complete kw man pages"  # Manual page to show
]

# Show kw version
export extern "kw version" [
    ...args: string
]

# Initalize kworkflow config file
export extern "kw init" [
    --template: string@"nu-complete kw init template"   # Uses a template as the kworkflow.config
    --arch: string@"nu-complete kw init arch"           # Sets the variable arch from the newly created kworkflow.config
    --remote: string                                    # <user>@<host>:<port> set the variables ssh_user, ssh_ip, and ssh_port to <user>, <ip>, and <port>, respectively.
    --target: string@"nu-complete kw target"            # Sets default_deploy_target from kworkflow.config
    --help(-h)                                          # Shows help page
    --verbose                                           # Verbose mode
]

# Builds the kernel
export extern "kw build" [
    ...flags: string                                 
    --info(-i)                                          # Displays build information
    --menu(-n)                                          # Invokes the kernel menuconfig
    --doc(-d)                                           # Builds the documentation
    --cpu-scaling(-S): int@"nu-complete kw cores"       # Sets the number of jobs to use for building the kernel (the -j flag)    
    --ccache                                            # Enable ccache  
    --warnings(-w): string@"nu-complete kw warnings"    # Sets the warning level for the kernel build
    --save-log-to(-s): string                           # Saves the build log to a file
    --llvm                                              # Uses LLVM toolchain during compilation and linking
    --clean(-c)                                         # Removes build files (keeps the configuration)
    --full-cleanup(-f)                                  # Runs make distclean to reset the tree to the default state
    --cflags                                            # Allow passing of flags to the compiler
    --alert: string
    --help(-h)                                          # Shows help page
    --verbose                                           # Verbose mode
]

export alias "kw b" = kw build


# Deploy the kernel
export extern "kw deploy" [
  --remote: string,                                  # deploy to a machine in the network
  --local                                            # deploy to the host machine
  --reboot(-r)                                       # reboot machine after deploy
  --no-reboot                                        # do not reboot machine after deploy
  --setup                                            # run basic setup in the target machine
  --modules(-m)                                      # only install/update modules
  --list(-l)                                         # list available kernels in a single column
  --list-all(-a)                                     # list all available kernels
  --ls-line(-s)                                      # list available kernels separated by comma
  --uninstall(-u): string                            # remove a single or multiple kernels
  --force(-f)                                        # remove kernels not installed by kw
  --create-package(-p)                               # create a kw package without deploying
  --from-package(-F)                                 # deploy a custom kernel from kw package
  --alert: string@"nu-complete kw deploy alert"      # set alert behaviour upon command completion
  --help(-h)                          # Shows help page
]


export alias "kw d" = kw deploy

# Useful wrapper to the diff command to compare files or directories
export extern "kw diff" [
    ...files: string
    --no-interactive                                # Displays all diff in two columns at once
    --help(-h)                          # Shows help page
    --verbose                                       # Verbose mode
]

export alias "kw df" = kw diff

# Ssh access into any network accessible machine
export extern "kw ssh" [
    --command(-c): string                               # Bash command to run on the remote machine
    --script(-s): string                                # Bash script to run on the remote machine
    --remote(-r): string                                # <user>@<host>:<port> parameters to ssh into the target machine
    --send: string                                      # Sends a local file to the remote. Needs to use --to after it
    --get: string                                       # Gets a remote file to the local. Needs to use --to after it
    --to: string                                        # The destination path. On the remote if --send. On the local if --get
    --help(-h)                          # Shows help page
    --verbose                                           # Verbose mode
]

export alias "kw s" = kw ssh

export extern "kw codestyle" [
    path?: string                       # Which files to run checkpatch on. Defaults to the cwd
    --help(-h)                          # Shows help page
    --verbose                           # Verbose mode      
]

export alias "kw c" = kw codestyle

export extern "kw self-update" [
    --unstable(-u)                      # Update kw based on the unstable branch
    --help(-h)                          # Shows help page    
    --verbose                           # Verbose mode
]

export alias "kw u" = kw self-update

export extern "kw maintainers" [
    path?: string                       # Path to the folder to show the maintainers of
    --authors(-a)                       # Prints (non-recursively) the authors of the top-level target files
    --update-patch(-u)                  # Include a `To:` field in the patch header
    --help(-h)                          # Shows help page
    --verbose                           # Verbose mode
]

export alias "kw m" = kw maintainers

export extern "kw kernel-config-manager" [
    --save: string                      # Creates a snapshot of the .config file with the given name
    -d: string                          # Sets the description when using --save
    --force(-f)                         # Supress warnings
    --get: string                       # Gets the config with the given name and overwrites the current .config file
    --remove(-r): string                # Removes the config with the given name                               
    --list(-l)                          # Lists all the configs being managed
    --fetch                             # Fetches a .config from a target machine
    --output(-o): string                # Sets the output file when using --fetch
    --optimize                          # Runs make localmodconfig to procude a config optimized for the target machine when using --fetch
    --remove: string                    # Sets the remote <user>@<host>:<port> when using --fetch
    --help(-h)                          # Shows help page
    --verbose                           # Verbose mode
]

export alias "kw k" = kw kernel-config-manager

#config manager
export extern "kw config" [
    option?: string@"nu-complete kw configs"  # Config options to set
    value?: string                           # Value to set the option to
    --global(-g)                            # Set the option globally
    --local(-l)                             # Set the option locally
    --show(-s)                              # Show the current configurations for a given target
    --help(-h)                              # Shows help page
    --verbose                               # Verbose mode
]

export alias "kw g" = kw config

# Manage set of tracked test machines
export extern "kw remote" [
    --global                                            # Force use global config file instead of the local one
    --add: string                                       # Adds a remote named <name> for the machine at <remote-address>
    --remove: string@"nu-complete kw remotes"           # Remove the remote named <name>
    --rename: string@"nu-complete kw remotes"           # Rename the remote named <old-name> to <new-name>
    --list                                              # List all available remotes.
    --set-default(-s)                                   # Set the default remote
    --verbose(-v)                                       # Verbose mode
]

# Git grep wrapper
export extern "kw explore" [
    expr?: string                                        # Expression to search for
    --log(-l)                                           # Search using git log with the given string
    --grep(-g)                                          # Search using grep with the given string
    --all(-a)                                           # Search using git grep with the given string      
    --only-source(-c)                                   # Show only results from source code
    --only-header(-H)                                   # Show only results from header
    -p: string                                          # Path to where to start the search
    --help(-h)                                          # Shows help page
    --verbose                                           # Verbose mode
]

export alias "kw e" = kw explore

#pomodoro style time management
export extern "kw pomodoro" [
    --set-timer(-t): string                             # Define a timer for the pomodoro (h | m | s)
    --tag(-g): string                                   # Tag the pomodoro
    --description(-d): string                           # Describe the pomodoro task
    --check-timer(-c)                                   # Check the current timer
    --show-tags(-s)                                     # Show all tags used in pomodoros      
    --help(-h)                                          # Shows help page
    --verbose                                           # Verbose mode
]

export alias "kw p" = kw pomodoro

# User data report support
export extern "kw report" [
    --year: string=""                                   # Shows the report for the current year if not specified <year>
    --month: string=""                                  # Shows the report for the current month if not specified <year>/<month>
    --week: string=""                                   # Shows the report for the current week if not specified <year>/<week>
    --day: string=""                                    # Shows the report for the current day if not specified <year>/<month>/<day> 
    --all                                               # Shows all the data in the report
    --statistics(-s)                                    # Shows the statistics of the report
    --pomodoro                                          # Shows the pomodoro data in the report
    --output: string                                    # Output the report to a file
    --help(-h)                                          # Shows help page
    --verbose                                           # Verbose mode
]

export alias "kw r" = kw report

# Retrieve basic hardware information from a target machine
export extern "kw device" [
    --local                                             # Show local device information
    --remote: string                                    # Show remote device information <remote>:<port>
    --help(-h)                                          # Shows help page
    --verbose                                           # Verbose mode
]

# kernel debug
export extern "kw debug" [ 
    --dmesg(-g)                                          # Collect dmesg log.
    --event(-e): string=""                               # Enable specific events to be traced. If no event is specified, all events will be enabled.
    --ftrace(-t)                                         # Enable ftrace.
    --reset
    --disable(-d)                                        # Disable all events specified inside --event "" and --ftrace.
    --list(-l): string=""                                # List all available events. If a specific event is informed via --events "<event>", this option will only list specific events related to the "<event>". This feature does not apply to --dmesg option.
    --history(-k)                                        # Create a debug directory that keeps track of all debugs made by the users. It creates a directory and organizes it based on an ID and date.
    --follow(-f)                                         # Real time output.
    --cmd(-c)                                            # If this parameter is used combined with --event or --ftrace, the following sequence will happen: (1) Enable specific trace, (2) collect trace in background, (3) run the command, (4) disable traces. When used with --dmesg, kw will (1) clean the dmesg log, (2) run the command, (3) and collect the log.
    --verbose                                            # Verbose mode is an option that causes the kw program to display debug messages to track its steps. This functionality is very useful during the debugging process, allowing you to identify possible errors more easily.
    --help(-h)                                           # Shows help page
]




# git send-email wrapper
export extern "kw mail" [
    ...args: string
    --send(-s): string                                   # Send a patch by email using git send-email to the email addresses specified with --to and --cc.
    --to: string                                         # Specify the recipients that will receive the patch via e-mail.
    --cc: string                                         # Specify the recipients that will receive a copy of the patch via e-mail.
    --simulate                                           # Do everything without actually sending the e-mail.
    --private                                            # Suppress auto generation of recipients.
    --rfc                                                # Add a request for comment prefix to the e-mail's subject.
    --setup(-t): string                                  # Initialize and configure mail functionality. Each argument specifies a <config> to be set with the corresponding <value>.
    --interactive(-i)                                    # Interactively prompt the user for the values of the options.
    --no-interactive(-n)                                 # Inhibits interactive properties, particularly from the template option.
    --local                                              # Forces the commands to be run at a local scope. If nothing is passed all changes will be applied locally, but the listing and verification will happen in all scopes.
    --global                                             # Same as --local but in the global scope.
    --force(-f)                                          # Forces the configurations to be added, regardless of conflicts with the current values already set in the system.
    --verify                                             # Verify that all the settings needed are set and valid.
    --template: string                                   # Loads the default configuration values based on the given <template>. If no template is given the user will be shown the available templates to choose from.
    --list(-l)                                           # Lists the settings that mail uses.
    --verbose                                            # Verbose mode is an option that causes the kw program to display debug messages to track its progress.
    --help(-h)                                           # Shows help page
]



# kw env manager
export extern "kw env" [
    --create(-c): string                                  # The create parameter expects a string to be used as an env name. When kw creates a new env it instantiates the current kw configurations to the new env.
    --use(-u): string                                     # Change from one env to another previously created.
    --destroy(-d): string                                 # The destroy parameter expects a string with the name of the env you want to destroy.
    --list(-l)                                            # It shows all envs created via --create option.
    --exit-env(-e)                                        # Allow users to "exit" the env feature. If the user is using a specific env and doesn't want to use it anymore, the --exit-env option will remove all symbolic links and copy the current env's configuration files to the .kw.
    --verbose                                             # Verbose mode is an option that causes the kw program to display debug messages to track its progress.
    --help(-h)                                            # Shows help page
]



# UI with lore.kernel.org archives
export extern "kw patch-hub" [
    --help(-h)                                           # Shows help page
]

# clear files generated by kw
export extern "kw clear-cache" []

# drm subsystem support
export extern "kw drm" [
    --local                                                # Show all DRM drivers available in the local machine.                                                   
    --remote: string                                       # Specify the target device for the drm action, can be a remote or local machine.
    --load-module: string                                  # Allow user to specify one or more modules to load with or without parameters.
    --unload-module: string                                # Allow users to unload one or more DRM drivers.
    --gui-on                                               # Provide a mechanism for turning on the GUI.
    --gui-off                                              # Turn off the target GUI in the specified target.
    --conn-available                                       # Show all connectors available in the target machine.
    --modes                                                # Show all available modes per card.
    --verbose                                              # Verbose mode that causes the kw program to display debug messages to track its progress.
    --help(-h)                                             # Shows help page
]

# commands to work with QEMU VMs
export extern "kw vm" [
    --mount(-m)                                           # This mounts the QEMU image in a specific directory, based on the data available in the kworkflow.config file. Only run this command after you turn off your VM.
    --umount(-n)                                          # This unmounts the previously mounted QEMU image, based on the parameters available in the kworkflow.config file.
    --up(-u)                                              # This starts the QEMU VM based on parameters in the kworkflow.config file.
    --alert: string                                       # Defines the alert behaviour upon the command completion. Options: s (sound notification), v (visual notification), sv or vs (both), n (or any other option) disables notifications.
]

    
# Show kw man page
export extern "kw help" []

export alias "kw h" = kw help   
