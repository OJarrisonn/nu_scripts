# Retrieve the theme settings
export def main [] {
    return {
        separator: '#654735'
        leading_trailing_space_bg: { attr: 'n' }
        header: { fg: '#6c782e' attr: 'b' }
        empty: '#45707a'
        bool: {|| if $in { '#4c7a5d' } else { 'light_gray' } }
        int: '#654735'
        filesize: {|e|
            if $e == 0b {
                '#654735'
            } else if $e < 1mb {
                '#4c7a5d'
            } else {{ fg: '#45707a' }}
        }
        duration: '#654735'
        date: {|| (date now) - $in |
            if $in < 1hr {
                { fg: '#c14a4a' attr: 'b' }
            } else if $in < 6hr {
                '#c14a4a'
            } else if $in < 1day {
                '#b47109'
            } else if $in < 3day {
                '#6c782e'
            } else if $in < 1wk {
                { fg: '#6c782e' attr: 'b' }
            } else if $in < 6wk {
                '#4c7a5d'
            } else if $in < 52wk {
                '#45707a'
            } else { 'dark_gray' }
        }
        range: '#654735'
        float: '#654735'
        string: '#654735'
        nothing: '#654735'
        binary: '#654735'
        cell-path: '#654735'
        row_index: { fg: '#6c782e' attr: 'b' }
        record: '#654735'
        list: '#654735'
        block: '#654735'
        hints: 'dark_gray'
        search_result: { fg: '#c14a4a' bg: '#654735' }

        shape_and: { fg: '#945e80' attr: 'b' }
        shape_binary: { fg: '#945e80' attr: 'b' }
        shape_block: { fg: '#45707a' attr: 'b' }
        shape_bool: '#4c7a5d'
        shape_custom: '#6c782e'
        shape_datetime: { fg: '#4c7a5d' attr: 'b' }
        shape_directory: '#4c7a5d'
        shape_external: '#4c7a5d'
        shape_externalarg: { fg: '#6c782e' attr: 'b' }
        shape_filepath: '#4c7a5d'
        shape_flag: { fg: '#45707a' attr: 'b' }
        shape_float: { fg: '#945e80' attr: 'b' }
        shape_garbage: { fg: '#FFFFFF' bg: '#FF0000' attr: 'b' }
        shape_globpattern: { fg: '#4c7a5d' attr: 'b' }
        shape_int: { fg: '#945e80' attr: 'b' }
        shape_internalcall: { fg: '#4c7a5d' attr: 'b' }
        shape_list: { fg: '#4c7a5d' attr: 'b' }
        shape_literal: '#45707a'
        shape_match_pattern: '#6c782e'
        shape_matching_brackets: { attr: 'u' }
        shape_nothing: '#4c7a5d'
        shape_operator: '#b47109'
        shape_or: { fg: '#945e80' attr: 'b' }
        shape_pipe: { fg: '#945e80' attr: 'b' }
        shape_range: { fg: '#b47109' attr: 'b' }
        shape_record: { fg: '#4c7a5d' attr: 'b' }
        shape_redirection: { fg: '#945e80' attr: 'b' }
        shape_signature: { fg: '#6c782e' attr: 'b' }
        shape_string: '#6c782e'
        shape_string_interpolation: { fg: '#4c7a5d' attr: 'b' }
        shape_table: { fg: '#45707a' attr: 'b' }
        shape_variable: '#945e80'

        background: '#fbf1c7'
        foreground: '#654735'
        cursor: '#654735'
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