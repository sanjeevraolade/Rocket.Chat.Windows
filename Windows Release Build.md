---
description: Rocket.Chat Windows Release Build generation Guide
---

# Windows Release Build process



## How to Generate Windows Release Build 

***Recomended to have a machine with atleast 8GB of RAM***

The following guide will step through the various steps for generating Windows Release build for Rocket.Chat.

**Note**: The steps will include all dependencies. If a particular dependency has already been installed, please skip to any relevant configuration section.

---

### Binary Dependencies

Download and install each of the following **in order**:

1. [Python 2.7.3](https://www.python.org/ftp/python/2.7.3/python-2.7.3.msi) \(if you have Python 3.x already installed, just leave it, both can coexist\)
2. [Visual Studio 2017 ( Desktop development with C++ )](https://visualstudio.microsoft.com/vs/older-downloads/)

---

### Rocket.Chat files


1. Get the available latest version of Rocket.Chat from git repo(https://github.com/stealth-grid/Rocket.Chat.Windows).

    `git clone https://github.com/stealth-grid/Rocket.Chat.Windows`
2. Open the _Developer Command Prompt for VS 2017_ by pressing Start, typing its name, and clicking on it in the search results and _Run as Administrator_ and runn the following commands, replaceing the [Repo path] & [Build output path]
    ```cmd
    > npm config set python /Python27/python.exe --global
    > npm config set msvs_version 2017 --global
    > set NODE_OPTIONS=--max_old_space_size=8192
    > cd [Repo path]
    > meteor npm i
    > meteor build --directory [Build output path]
    ```
3. After the succecful build the Windows Release Build can be obtained from the [Build output path] provided in the above command.
 
---
For other refernces please check the [community supported installation document](https://docs.rocket.chat/installation/community-supported-installation/windows-server) 
