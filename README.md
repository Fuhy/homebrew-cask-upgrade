# homebrew-cask-upgrade
Upgrade the outdated apps installed by [Homebrew cask](https://caskroom.github.io).

**Update：**

[Homebrew cask](https://caskroom.github.io) now has supported `brew cask update` command. This script has no use now😁



## How it works

We can easily figure out whether an application is outdated by comparing its version with the latest one.

The `$CASKNAME.rb` in  `/usr/local/Homebrew/Library/Taps/caskroom/homebrew-cask/Casks` includes the information of its latest version. Also, it includes the "`auto_updates`" variable to tell if this cask will check the available latest version itself when processing.

In most cases, the folder where the cask is installed will indicate its current version by its name. But sometimes it just named **"latest''**. In this case, the status of the cask will be marked as <u>***UNKNOWN***</u>. Otherwise, it will be <u>***OK***</u> or <u>***OUTDATED***</u>. 



## Options

The tool provides the following options:

+ `-s`, `-skip`

  The command  `brew update` will be automatically performed to make sure the record of the latest-cask version is correct. The option will skip this process.


+ `-f`, `-force`

  Also update the casks in unknown status.

+ `-y`, `-yes`

  Update all outdated casks without asking.

+ `-n`

  By default, all status of the casks will be shown. The `-n` option suppresses these behavior by only showing the outdated ones.

  


## Sample


![demoBrew.png](https://i.loli.net/2019/03/11/5c8627a516f93.png)


