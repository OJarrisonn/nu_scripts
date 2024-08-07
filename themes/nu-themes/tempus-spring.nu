# Retrieve the theme settings
export def main [] {
    return {
        separator: '#96aca7'
        leading_trailing_space_bg: { attr: 'n' }
        header: { fg: '#5cbc4d' attr: 'b' }
        empty: '#39b6ce'
        bool: {|| if $in { '#3cbaa6' } else { 'light_gray' } }
        int: '#96aca7'
        filesize: {|e|
            if $e == 0b {
                '#96aca7'
            } else if $e < 1mb {
                '#36bd84'
            } else {{ fg: '#39b6ce' }}
        }
        duration: '#96aca7'
        date: {|| (date now) - $in |
            if $in < 1hr {
                { fg: '#ff855a' attr: 'b' }
            } else if $in < 6hr {
                '#ff855a'
            } else if $in < 1day {
                '#a6af1a'
            } else if $in < 3day {
                '#5cbc4d'
            } else if $in < 1wk {
                { fg: '#5cbc4d' attr: 'b' }
            } else if $in < 6wk {
                '#36bd84'
            } else if $in < 52wk {
                '#39b6ce'
            } else { 'dark_gray' }
        }
        range: '#96aca7'
        float: '#96aca7'
        string: '#96aca7'
        nothing: '#96aca7'
        binary: '#96aca7'
        cell-path: '#96aca7'
        row_index: { fg: '#5cbc4d' attr: 'b' }
        record: '#96aca7'
        list: '#96aca7'
        block: '#96aca7'
        hints: 'dark_gray'
        search_result: { fg: '#ff855a' bg: '#96aca7' }

        shape_and: { fg: '#e69092' attr: 'b' }
        shape_binary: { fg: '#e69092' attr: 'b' }
        shape_block: { fg: '#39b6ce' attr: 'b' }
        shape_bool: '#3cbaa6'
        shape_custom: '#5cbc4d'
        shape_datetime: { fg: '#36bd84' attr: 'b' }
        shape_directory: '#36bd84'
        shape_external: '#36bd84'
        shape_externalarg: { fg: '#5cbc4d' attr: 'b' }
        shape_filepath: '#36bd84'
        shape_flag: { fg: '#39b6ce' attr: 'b' }
        shape_float: { fg: '#e69092' attr: 'b' }
        shape_garbage: { fg: '#FFFFFF' bg: '#FF0000' attr: 'b' }
        shape_globpattern: { fg: '#36bd84' attr: 'b' }
        shape_int: { fg: '#e69092' attr: 'b' }
        shape_internalcall: { fg: '#36bd84' attr: 'b' }
        shape_list: { fg: '#36bd84' attr: 'b' }
        shape_literal: '#39b6ce'
        shape_match_pattern: '#5cbc4d'
        shape_matching_brackets: { attr: 'u' }
        shape_nothing: '#3cbaa6'
        shape_operator: '#a6af1a'
        shape_or: { fg: '#e69092' attr: 'b' }
        shape_pipe: { fg: '#e69092' attr: 'b' }
        shape_range: { fg: '#a6af1a' attr: 'b' }
        shape_record: { fg: '#36bd84' attr: 'b' }
        shape_redirection: { fg: '#e69092' attr: 'b' }
        shape_signature: { fg: '#5cbc4d' attr: 'b' }
        shape_string: '#5cbc4d'
        shape_string_interpolation: { fg: '#36bd84' attr: 'b' }
        shape_table: { fg: '#39b6ce' attr: 'b' }
        shape_variable: '#e69092'

        background: '#283a37'
        foreground: '#b5b8b7'
        cursor: '#b5b8b7'
    }
}

# Update the Nushell configuration
export def --env "set color_config" [] {
    $env.config.color_config = (main)
}

# Update terminal colors
export def "update terminal" [] {
    let theme = (main)

    # Set terminal colors
    let osc_screen_foreground_color = '10;'
    let osc_screen_background_color = '11;'
    let osc_cursor_color = '12;'
        
    $"
    (ansi -o $osc_screen_foreground_color)($theme.foreground)(char bel)
    (ansi -o $osc_screen_background_color)($theme.background)(char bel)
    (ansi -o $osc_cursor_color)($theme.cursor)(char bel)
    "
    # Line breaks above are just for source readability
    # but create extra whitespace when activating. Collapse
    # to one line
    | str replace --all "\n" ''
    | print $in
}

export module activate {
    export-env {
        set color_config
        update terminal
    }
}

# Activate the theme when sourced
use activate