# Retrieve the theme settings
export def main [] {
    return {
        separator: '#969896'
        leading_trailing_space_bg: { attr: 'n' }
        header: { fg: '#8c9440' attr: 'b' }
        empty: '#5f819d'
        bool: {|| if $in { '#8abeb7' } else { 'light_gray' } }
        int: '#969896'
        filesize: {|e|
            if $e == 0b {
                '#969896'
            } else if $e < 1mb {
                '#5e8d87'
            } else {{ fg: '#5f819d' }}
        }
        duration: '#969896'
        date: {|| (date now) - $in |
            if $in < 1hr {
                { fg: '#a54242' attr: 'b' }
            } else if $in < 6hr {
                '#a54242'
            } else if $in < 1day {
                '#de935f'
            } else if $in < 3day {
                '#8c9440'
            } else if $in < 1wk {
                { fg: '#8c9440' attr: 'b' }
            } else if $in < 6wk {
                '#5e8d87'
            } else if $in < 52wk {
                '#5f819d'
            } else { 'dark_gray' }
        }
        range: '#969896'
        float: '#969896'
        string: '#969896'
        nothing: '#969896'
        binary: '#969896'
        cell-path: '#969896'
        row_index: { fg: '#8c9440' attr: 'b' }
        record: '#969896'
        list: '#969896'
        block: '#969896'
        hints: 'dark_gray'
        search_result: { fg: '#a54242' bg: '#969896' }

        shape_and: { fg: '#85678f' attr: 'b' }
        shape_binary: { fg: '#85678f' attr: 'b' }
        shape_block: { fg: '#5f819d' attr: 'b' }
        shape_bool: '#8abeb7'
        shape_custom: '#8c9440'
        shape_datetime: { fg: '#5e8d87' attr: 'b' }
        shape_directory: '#5e8d87'
        shape_external: '#5e8d87'
        shape_externalarg: { fg: '#8c9440' attr: 'b' }
        shape_filepath: '#5e8d87'
        shape_flag: { fg: '#5f819d' attr: 'b' }
        shape_float: { fg: '#85678f' attr: 'b' }
        shape_garbage: { fg: '#FFFFFF' bg: '#FF0000' attr: 'b' }
        shape_globpattern: { fg: '#5e8d87' attr: 'b' }
        shape_int: { fg: '#85678f' attr: 'b' }
        shape_internalcall: { fg: '#5e8d87' attr: 'b' }
        shape_list: { fg: '#5e8d87' attr: 'b' }
        shape_literal: '#5f819d'
        shape_match_pattern: '#8c9440'
        shape_matching_brackets: { attr: 'u' }
        shape_nothing: '#8abeb7'
        shape_operator: '#de935f'
        shape_or: { fg: '#85678f' attr: 'b' }
        shape_pipe: { fg: '#85678f' attr: 'b' }
        shape_range: { fg: '#de935f' attr: 'b' }
        shape_record: { fg: '#5e8d87' attr: 'b' }
        shape_redirection: { fg: '#85678f' attr: 'b' }
        shape_signature: { fg: '#8c9440' attr: 'b' }
        shape_string: '#8c9440'
        shape_string_interpolation: { fg: '#5e8d87' attr: 'b' }
        shape_table: { fg: '#5f819d' attr: 'b' }
        shape_variable: '#85678f'

        background: '#141414'
        foreground: '#94a3a5'
        cursor: '#94a3a5'
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