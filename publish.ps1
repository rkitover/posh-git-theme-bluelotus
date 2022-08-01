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

$sources | %{
    $dest = $prep_dir
    if ($dir = split-path -parent $_) {
        $dest = join-path $dest $dir
        mkdir $dest | out-null
    }
    cpi $_ $dest
}

$api_key = read-host -maskinput "Enter PSGallery API key"

import-module powershellget

publish-psresource -path $prep_dir -repo psgallery -apikey $api_key -verbose
