# Exported settings variable.
$gitprompt_theme_bluelotus = @{}

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

$path_color     = 0xC4A000
$suffix_color   = 0xDC143C

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
    -f @('PWSH';
        ("${bright_black}{0}${reset}"            -f '{'),
        $(if ($islinux) {
            "${bold}${linux_color}{0}${reset}"   -f 'L'
        }
        else { # windows
            "${bold}${windows_color}{0}${reset}" -f 'W'
        }),
        ("${bright_black}{0}${reset}"            -f '}')
    )
}
elseif ($ismacos) {
    "${mac_grey}{0}{1}{2}{3}${reset}" `
        -f 'PWSH',
            ("${bright_black}{0}${reset}"    -f '{'),
            ("${bold}${mac_blue}{0}${reset}" -f 'M'),
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

$gitpromptsettings.defaultpromptprefix.text = '{0} {1} ' `
    -f '$(prompt_error_indicator)',$env_indicator

$gitpromptsettings.defaultpromptbeforesuffix.text =
    ("`n${reset}${light_blue}{0}${reset}" `
    + "${bright_white}{1}${reset}" `
    + "${light_blue}{2}${reset} ") `
        -f $username,'@',$hostname

$gitpromptsettings.defaultpromptabbreviatehomedirectory = $true
$gitpromptsettings.defaultpromptwritestatusfirst        = $false

$gitpromptsettings.defaultpromptpath.foregroundcolor =
    $path_color

$gitpromptsettings.defaultpromptsuffix.foregroundcolor =
    $suffix_color

$gitprompt_theme_bluelotus.OriginalWindowTitle =
    $gitpromptsettings.windowtitle

$gitpromptsettings.windowtitle = $null

$host.ui.rawui.windowtitle = $hostname

export-modulemember -var 'gitprompt_theme_bluelotus'
