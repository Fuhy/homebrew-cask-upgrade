# homebrew-cask-upgrade
Upgrade the outdated apps installed by [Homebrew cask](https://caskroom.github.io).

Actually there is a tool already supported the same function upgrading the outdated cask (And it is even better than this one🙃). To get more information, see the page: [buo / homebrew-cask-upgrade](https://github.com/buo/homebrew-cask-upgrade).



## How it works

We can easily figure out whether an application is outdated by comparing its version with the latest.

The command `brew cask info $caskname` will display the latest version of the cask and also the directory where the cask is installed. 

In most cases, the folder name will indicate its current version. But sometimes it just named **"latest''**. In this case, the status of the cask will be marked as <u>***UNKNOWN***</u>. Otherwise, it will be <u>***OK***</u> or <u>***OUTDATED***</u>. 



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

  ​


## Sample

![UI](http://ox1e3odx6.bkt.clouddn.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202017-11-23%20%E4%B8%8B%E5%8D%887.18.58.png)

