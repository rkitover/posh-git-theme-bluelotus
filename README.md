<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [posh-git-theme-bluelotus](#posh-git-theme-bluelotus)
  - [installation](#installation)
  - [configuration](#configuration)
  - [miscellaneous](#miscellaneous)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## posh-git-theme-bluelotus

This module is a theme for the [posh-git](https://github.com/dahlbyk/posh-git)
[PowerShell](https://github.com/PowerShell/PowerShell) prompt.

It shows a last command success/error indicator, the Git branch and status when
in a Git repository, and your current username and hostname. This is what it
looks like:

<img src="/screenshots/prompt-demo.png?raw=true" width="100%" />

. I also maintain a POSIX shell (bash, busybox, etc.) prompt with a design
similar to this one [here](https://github.com/rkitover/sh-prompt-simple).

### installation

You can install the latest published version from the [PowerShell
Gallery](https://www.powershellgallery.com/).

Make sure the Gallery repository is enabled, to enable it for [PowerShell
Core](https://github.com/PowerShell/PowerShell) (7.x) run:

```powershell
set-psrepository psgallery -installationpolicy trusted
```
, this is not necessary for [Windows
PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-7.2)
(5.x), just follow the prompts.

Then install the module:

```powershell
install-module posh-git-theme-bluelotus
```
, and add:

```powershell
import-module posh-git-theme-bluelotus
```
to your `$profile`.

You can also use [posh-git](https://github.com/dahlbyk/posh-git) and this module
from Git, first clone the repositories:

```powershell
mkdir ~/source/repos -ea ignore
sl ~/source/repos
git clone git@github.com:dahlbyk/posh-git
git clone git@github.com:rkitover/posh-git-theme-bluelotus
```
, then in your `$profile` add:

```powershell
import-module ~/source/repos/posh-git/src/posh-git.psd1
import-module ~/source/repos/posh-git-theme-bluelotus/posh-git-theme-bluelotus.psd1
```
.

### configuration

This module has no configuration currently, but it only changes [posh-git
settings](https://github.com/dahlbyk/posh-git/wiki/Customizing-Your-PowerShell-Prompt)
which you can further modify/override after loading the module. Look at the
[source code](/posh-git-theme-bluelotus.psm1) to see what is changed.

The default [posh-git](https://github.com/dahlbyk/posh-git) values are
preserved in the `$gitprompt_theme_bluelotus` exported hash table as follows:

| Original Value                                          | Key For Preserved Value                      |
|---------------------------------------------------------|----------------------------------------------|
| $GitPromptSettings.DefaultPromptPrefix.Text             | OriginalDefaultPromptPrefixText              |
| $GitPromptSettings.DefaultPromptBeforeSuffix.Text       | OriginalDefaultPromptBeforeSuffixText        |
| $GitPromptSettings.WindowTitle                          | OriginalWindowTitle                          |
| $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory | OriginalDefaultPromptAbbreviateHomeDirectory |
| $GitPromptSettings.DefaultPromptWriteStatusFirst        | OriginalDefaultPromptWriteStatusFirst        |
| $GitPromptSettings.DefaultPromptPath.ForegroundColor    | OriginalDefaultPromptPathForegroundColor     |
| $GitPromptSettings.DefaultPromptSuffix.ForegroundColor  | OriginalDefaultPromptSuffixForegroundColor   |
| $GitPromptSettings.BeforeStatus.ForegroundColor         | OriginalBeforeStatusForegroundColor          |
| $GitPromptSettings.AfterStatus.ForegroundColor          | OriginalAfterStatusForegroundColor           |
| $GitPromptSettings.BranchColor.ForegroundColor          | OriginalBranchColorForegroundColor           |
| $GitPromptSettings.BranchIdenticalStatusSymbol          | OriginalBranchIdenticalStatusSymbol          |
| $GitPromptSettings.BranchGoneStatusSymbol               | OriginalBranchGoneStatusSymbol               |
| $GitPromptSettings.BranchAheadStatusSymbol              | OriginalBranchAheadStatusSymbol              |
| $GitPromptSettings.BranchBehindStatusSymbol             | OriginalBranchBehindStatusSymbol             |
| $GitPromptSettings.BranchBehindAndAheadStatusSymbol     | OriginalBranchBehindAndAheadStatusSymbol     |

It also changes the
[`$host.ui.rawui.windowtitle`](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.host.pshostrawuserinterface.windowtitle?view=powershellsdk-7.0.0#system-management-automation-host-pshostrawuserinterface-windowtitle)
property to set the window title to the current hostname. If you would prefer to
have [posh-git](https://github.com/dahlbyk/posh-git) set the window title,
override this property in your `$profile` after importing this module:

```powershell
$gitpromptsettings.windowtitle =
  $gitprompt_theme_bluelotus.originalwindowtitle
```

### miscellaneous

Here are also some [PSReadLine](https://github.com/PowerShell/PSReadLine)
command-line editing settings that you may like, add this to your `$profile`:

```powershell
import-module psreadline

set-psreadlineoption -editmode emacs
set-psreadlineoption -historysearchcursormovestoend
set-psreadlineoption -bellstyle none

set-psreadlinekeyhandler -key tab       -function complete
set-psreadlinekeyhandler -key uparrow   -function historysearchbackward
set-psreadlinekeyhandler -key downarrow -function historysearchforward
```
.
