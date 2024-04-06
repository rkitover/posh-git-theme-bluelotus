# Windows PowerShell does not support the `e special character
# sequence for Escape, so we use a variable $e for this.
$e = [char]27

$reset          = "$e[0m"
$bold           = "$e[1m"

# Tango colors.
$bright_white   = "$e[38;2;238;238;236m"
$green          = "$e[38;2;078;154;006m"
$bright_magenta = "$e[38;2;173;127;168m"
$bright_black   = "$e[38;2;085;087;083m"

# Other colors.
$red            = "$e[38;2;220;020;060m"
$light_blue     = "$e[38;2;140;206;250m"
$linux_color    = "$e[38;2;175;095;000m"
$windows_color  = "$e[38;2;032;178;170m"
$mac_blue       = "$e[38;2;098;137;213m"
$mac_grey       = "$e[38;2;196;205;239m"

$path_color         = 0xC4A000
$suffix_color       = 0xDC143C
$branch_color       = 0x75507B
$bracket_color      = 0x06989A

$branch_sep_color   = "$e[0;97m"

function global:prompt_error_indicator() {
    if ($gitpromptvalues.dollarquestion) {
        "${green}{0}${reset}" -f 'v'
    }
    else {
        "${red}{0}${reset}"   -f 'x'
    }
}

$env_indicator = if ($islinux -or $iswindows) {
    "${bright_magenta}{0}{1}{2}{3}${reset}" `
    -f @('pwsh';
        ("${bright_black}{0}${reset}"            -f '{'),
        $(if ($islinux) {
            "${bold}${linux_color}{0}${reset}"   -f 'lin'
        }
        else { # windows
            "${bold}${windows_color}{0}${reset}" -f 'win'
        }),
        ("${bright_black}{0}${reset}"            -f '}')
    )
}
elseif ($ismacos) {
    "${mac_grey}{0}{1}{2}{3}${reset}" `
        -f 'pwsh',
            ("${bright_black}{0}${reset}"    -f '{'),
            ("${bold}${mac_blue}{0}${reset}" -f 'mac'),
            ("${bright_black}{0}${reset}"    -f '}')
}

if ($iswindows) {
    $username = $env:USERNAME
    $hostname = $env:COMPUTERNAME.tolower()
}
else {
    $username = whoami
    $hostname = (hostname) -replace '\..*',''
}

# Save original values to exported var in case the user wants to restore any of
# them.

$gitprompt_theme_bluelotus = $gitpromptsettings | %{ [ordered]@{
    OriginalDefaultPromptPrefixText              = $_.defaultpromptprefix.text
    OriginalDefaultPromptBeforeSuffixText        = $_.defaultpromptbeforesuffix.text
    OriginalWindowTitle                          = $_.windowtitle
    OriginalDefaultPromptAbbreviateHomeDirectory = $_.defaultpromptabbreviatehomedirectory
    OriginalDefaultPromptWriteStatusFirst        = $_.defaultpromptwritestatusfirst
    OriginalDefaultPromptPathForegroundColor     = $_.defaultpromptpath.foregroundcolor
    OriginalDefaultPromptSuffixForegroundColor   = $_.defaultpromptsuffix.foregroundcolor
    OriginalBeforeStatusForegroundColor          = $_.beforestatus.foregroundcolor
    OriginalAfterStatusForegroundColor           = $_.afterstatus.foregroundcolor
    OriginalBranchColorForegroundColor           = $_.branchcolor.foregroundcolor
    OriginalBranchIdenticalStatusSymbol          = $_.branchidenticalstatussymbol
    OriginalBranchGoneStatusSymbol               = $_.branchgonestatussymbol
    OriginalBranchAheadStatusSymbol              = $_.branchaheadstatussymbol
    OriginalBranchBehindStatusSymbol             = $_.branchbehindstatussymbol
    OriginalBranchBehindAndAheadStatusSymbol     = $_.branchbehindandaheadstatussymbol
}}

# Set the theme.

$gitpromptsettings.defaultpromptprefix.text = '{0} {1} ' `
    -f '$(prompt_error_indicator)',$env_indicator

$gitpromptsettings.defaultpromptbeforesuffix.text =
    ("`n${reset}${light_blue}{0}${reset}" `
    + "${bright_white}{1}${reset}" `
    + "${light_blue}{2}${reset} ") `
        -f $username,'@',$hostname

$gitpromptsettings.defaultpromptabbreviatehomedirectory = $true
$gitpromptsettings.defaultpromptwritestatusfirst        = $false

$gitpromptsettings.defaultpromptpath.foregroundcolor    = $path_color
$gitpromptsettings.defaultpromptsuffix.foregroundcolor  = $suffix_color

$gitpromptsettings.beforestatus.foregroundcolor         = $bracket_color
$gitpromptsettings.afterstatus.foregroundcolor          = $bracket_color

$gitpromptsettings.branchcolor.foregroundcolor                      = $branch_color
$gitpromptsettings.branchidenticalstatussymbol.foregroundcolor      = $branch_color
$gitpromptsettings.branchgonestatussymbol.foregroundcolor           = $branch_color
$gitpromptsettings.branchaheadstatussymbol.foregroundcolor          = $branch_color
$gitpromptsettings.branchbehindstatussymbol.foregroundcolor         = $branch_color
$gitpromptsettings.branchbehindandaheadstatussymbol.foregroundcolor = $branch_color

$gitpromptsettings.branchidenticalstatussymbol.text                 = "${branch_sep_color}|${green}v"
$gitpromptsettings.branchgonestatussymbol.text                      = "${branch_sep_color}|${red}×"
$gitpromptsettings.branchaheadstatussymbol.text                     = "${branch_sep_color}|${red}↑"
$gitpromptsettings.branchbehindstatussymbol.text                    = "${branch_sep_color}|${red}↓"
$gitpromptsettings.branchbehindandaheadstatussymbol.text            = "${branch_sep_color}|${red}↕"

$gitpromptsettings.windowtitle = $null

$host.ui.rawui.windowtitle = $hostname

# Exports.

export-modulemember -var 'gitprompt_theme_bluelotus'

# vim:fileencoding=utf8 bomb sw=4 sts=4 et:
