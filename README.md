# homebrew-cask-upgrade
Upgrade the outdated apps installed by [Homebrew cask](https://caskroom.github.io).

Actually there is a tool already supported the same function upgrading the outdated cask (And it is even better than this one🙃). To get more information, see the page:[buo / homebrew-cask-upgrade](https://github.com/buo/homebrew-cask-upgrade).



## How it works

We can easily know whether an application is outdated or not by comparing its version with the latest version.

The command `brew cask info $caskname` will display the latest version of the cask and also the directory where the cask is installed. 

In most cases, the folder name will indicate its current version. But sometimes it just named ***"latest''***. In this case the status of the cask will be marked as <u>***UNKNOWN***</u>. Otherwise, it will be <u>***OK***</u> or <u>***OUTDATED***</u>. 



## Options

The tool will provide the following options:

+ `-s` `-skip`

  The command  `brew update` will be automatically performed to make sure the record of the latest-cask version is correct. The option will skip this process.


+ `-f` `-force`

  Also update the casks in unknown status.

+ `-y` `-yes`

  Update all outdated casks without asking.

+ `-n`

  By default, all status of the casks will be shown. The `-n` option suppresses these behavior by only showing the outdated ones.

