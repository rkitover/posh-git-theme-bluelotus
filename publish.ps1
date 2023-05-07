param(
    [string]$ApiKey,
    [validatescript({
        if (-not (test-path -pathtype leaf $_)) {
            throw "File containing API key '$_' does not exist."
        }
        $true
    })]
    [system.io.fileinfo]$ApiKeyFile,
    [validatescript({
        if (-not (test-path -pathtype leaf $_)) {
            throw "Certificate file '$_' does not exist."
        }
        $true
    })]
    [system.io.fileinfo]$Certificate
)

$erroractionpreference = 'stop'

$module = split-path -leaf $psscriptroot

$prep_dir = join-path $psscriptroot $module

$sources =
    "${module}.psd1",
    "${module}.psm1",
    "en/about_${module}.help.txt"

if (test-path $prep_dir) {
    ri -r $prep_dir
}
mkdir $prep_dir | out-null

# Copy the sources.
$sources | %{
    $dest = $prep_dir
    if ($dir = split-path -parent $_) {
        $dest = join-path $dest $dir
        mkdir $dest | out-null
    }
    # Also convert from UNIX to DOS line endings.
    gc -encoding utf8bom $_ | set-content -encoding utf8bom (join-path $dest (split-path -leaf $_))
}

if ($certificate) {
    'Please enter the password for your codesigning certificate when prompted.'
    $cert = get-pfxcertificate $certificate

    $sources | ?{ $_ -match '\.ps[md]?1$' } | %{
        $signing = set-authenticodesignature `
            -filepath (join-path $prep_dir $_) `
            -cert $cert `
            -hash 'SHA256' `
            -includechain 'all' `
            -timestampserver 'http://timestamp.sectigo.com'

        if ($signing.status -ne 'Valid') {
            throw "Failed to sign file '$_'.`n  status: $($signing.status)`n  message: $($signing.statusmessage)"
        }
    }
}

import-module powershellget

if ($apikeyfile) {
    $apikey = gc $apikeyfile
}

if (-not $apikey) {
    $apikey = read-host -maskinput "Enter PSGallery API key"
}

publish-psresource -path $prep_dir -repo psgallery -apikey $apikey -verbose
