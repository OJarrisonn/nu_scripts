# Retrieve the theme settings
export def main [] {
    return {
        separator: '#c7dbdd'
        leading_trailing_space_bg: { attr: 'n' }
        header: { fg: '#73d8ad' attr: 'b' }
        empty: '#46bddd'
        bool: {|| if $in { '#3fb2b9' } else { 'light_gray' } }
        int: '#c7dbdd'
        filesize: {|e|
            if $e == 0b {
                '#c7dbdd'
            } else if $e < 1mb {
                '#3fb2b9'
            } else {{ fg: '#46bddd' }}
        }
        duration: '#c7dbdd'
        date: {|| (date now) - $in |
            if $in < 1hr {
                { fg: '#fb6953' attr: 'b' }
            } else if $in < 6hr {
                '#fb6953'
            } else if $in < 1day {
                '#fce380'
            } else if $in < 3day {
                '#73d8ad'
            } else if $in < 1wk {
                { fg: '#73d8ad' attr: 'b' }
            } else if $in < 6wk {
                '#3fb2b9'
            } else if $in < 52wk {
                '#46bddd'
            } else { 'dark_gray' }
        }
        range: '#c7dbdd'
        float: '#c7dbdd'
        string: '#c7dbdd'
        nothing: '#c7dbdd'
        binary: '#c7dbdd'
        cell-path: '#c7dbdd'
        row_index: { fg: '#73d8ad' attr: 'b' }
        record: '#c7dbdd'
        list: '#c7dbdd'
        block: '#c7dbdd'
        hints: 'dark_gray'
        search_result: { fg: '#fb6953' bg: '#c7dbdd' }

        shape_and: { fg: '#756b8a' attr: 'b' }
        shape_binary: { fg: '#756b8a' attr: 'b' }
        shape_block: { fg: '#46bddd' attr: 'b' }
        shape_bool: '#3fb2b9'
        shape_custom: '#73d8ad'
        shape_datetime: { fg: '#3fb2b9' attr: 'b' }
        shape_directory: '#3fb2b9'
        shape_external: '#3fb2b9'
        shape_externalarg: { fg: '#73d8ad' attr: 'b' }
        shape_filepath: '#3fb2b9'
        shape_flag: { fg: '#46bddd' attr: 'b' }
        shape_float: { fg: '#756b8a' attr: 'b' }
        shape_garbage: { fg: '#FFFFFF' bg: '#FF0000' attr: 'b' }
        shape_globpattern: { fg: '#3fb2b9' attr: 'b' }
        shape_int: { fg: '#756b8a' attr: 'b' }
        shape_internalcall: { fg: '#3fb2b9' attr: 'b' }
        shape_list: { fg: '#3fb2b9' attr: 'b' }
        shape_literal: '#46bddd'
        shape_match_pattern: '#73d8ad'
        shape_matching_brackets: { attr: 'u' }
        shape_nothing: '#3fb2b9'
        shape_operator: '#fce380'
        shape_or: { fg: '#756b8a' attr: 'b' }
        shape_pipe: { fg: '#756b8a' attr: 'b' }
        shape_range: { fg: '#fce380' attr: 'b' }
        shape_record: { fg: '#3fb2b9' attr: 'b' }
        shape_redirection: { fg: '#756b8a' attr: 'b' }
        shape_signature: { fg: '#73d8ad' attr: 'b' }
        shape_string: '#73d8ad'
        shape_string_interpolation: { fg: '#3fb2b9' attr: 'b' }
        shape_table: { fg: '#46bddd' attr: 'b' }
        shape_variable: '#756b8a'

        background: '#0e3c46'
        foreground: '#c7dbdd'
        cursor: '#c7dbdd'
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