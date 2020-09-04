# Rocket.Chat.Windows Server

Rocket Chat 3.6.0 Modified to support Windows build

## How to install Rocket.Chat on Windows Server 2016/2019

The following guide will step through the various steps for installing Rocket.Chat on Windows Server 2016/2019.

**Note**: The steps will include all dependencies. If a particular dependency has already been installed, please skip to any relevant configuration section.

---

### Binary Dependencies

Download and install each of the following **in order**:

1. [Python 2.7.3](https://www.python.org/ftp/python/2.7.3/python-2.7.3.msi) \(if you have Python 3.x already installed, just leave it, both can coexist\)
2. [Visual Studio 2017 ( Desktop development with C++ )](https://visualstudio.microsoft.com/vs/older-downloads/)

---

### MongoDB


* Download [MongoDB](https://www.mongodb.org/downloads#production). \(Note: This can be done on a separate computer\)
* Run the installer and choose `Custom`
* Click the `Browse` button to select desired install path, such as `C:\MongoDB`
* Continue through the rest of the installer.
* Now open NotePad and enter the following, replacing \[Installation Path\] with where the database will be stored, such as for dbPath `C:\MongoDB\data`

```text
systemLog:
    destination: file
    path: [Installation Path]\data\logs\mongod.log
storage:
    dbPath: [Installation Path]\data
replication:
    replSetName: rs01
```

* Save the file as `[Installation Path]\mongod.cfg` where \[Installation Path\] is the location you installed Mongo
* Open the Command Prompt by pressing `Windows Key + R` and then entering `cmd`, right click on Command Prompt and select `Run as administrator`
* Now enter the following:

```text
> mkdir [Installation Path]\data 
> cd [Installation Path]\data
> mkdir [Installation Path]\data\db
> mkdir [Installation Path]\data\logs

> cd [Installation Path]\bin
> mongod.exe --config "[Installation Path]\mongod.cfg" --install
> net start MongoDB

> mongo.exe
> rs.initiate()
> exit
```

> _Note: Do not include the `>`_

---

### Rocket.Chat files

1. Get the available latest version of Rocket.Chat Windows Build
2. Using an archive utility such as [7zip](http://www.7-zip.org/), extract the  file
3. Place the files in the desired install path, such as `C:\RocketChat`

### Node.js

Current Rocket.Chat is built on top of Node.js v12.18.3. So we need to install this first.

1. Download [Node.js v12.18.3](https://nodejs.org/dist/v12.18.3/node-v12.18.3-x64.msi)
2. Run the installer with all default option.

### Node Packages


1. Open the _Developer Command Prompt for VS 2017_ by pressing Start, typing its name, and clicking on it in the search results and _Run as Administrator_
2. Now enter the following, replacing:
   * \[Installation Path\] with the location you placed the Rocket.Chat files
   * \[Port to Use\] with the port for the Rocket.Chat server to use, such as `3000`
   * \[Rocket.Chat URL\] with the URL you will use for Rocket.Chat, such as `rocketchat.example.com`
   * \[Address to MongoDB\] with the IP Address of your MongoDB. \(NOTE: If you didn't install Mongo on another computer, use `localhost`\)
   * \[MongoDB Database\] with the name of the database you would like to use, such as `rocketchat`

```text
> cd [Installation Path]
> npm install nave -g
> npm install node-windows

> npm config set python /Python27/python.exe --global
> npm config set msvs_version 2017 --global

> set PORT=[Port to Use]
> set ROOT_URL=[Rocket.Chat URL]
> set MONGO_URL=mongodb://[Address to Mongo]:27017/[MongoDB Database]
> set MONGO_OPLOG_URL=mongodb://[Address to Mongo]:27017/local
> set SCRIPT_PATH=[Installation Path]\main.js

> cd programs\server
> npm install

> cd ../..
> node rocket.service.js install
> net start Rocket.Chat
```

> Note: If missing, rocket.service.js can be found [here](https://github.com/Sing-Li/bbug/blob/master/images/rocket.service.js) _Note: Do not include the `>`_

---

### Verifying the Install

1. View the installed services by pressing `Windows Key + R` and then entering `services.msc`
2. Find `Rocket.Chat` in the list. Its status should be `Running`
3. Open a browser and, in the address bar, enter `http://localhost:[Port Used]`
4. Rocket.Chat should load.

---

### Mobile Support

In order to use Rocket.Chat on mobile devices, you must also configure your installation to support SSL with a valid certificate.

---

### Reverse Proxy unsing nginx windows

1. Download [nginx for windows](http://nginx.org/download/nginx-1.18.0.zip)
2. Extarct the contents to `C:\nginx-1.18.0`
3. Replace the content of `nginx.conf` in  [Installation Path]\conf\nginx.conf with the below content, by replacing the [your_hostname.com], [Path to certificate], [backend], [port] with your RocketChat configed values.

    ```conf
    worker_processes  1;

    events {
        worker_connections  1024;
    }

    http {
        include       mime.types;
        default_type  application/octet-stream;

        sendfile        on;
        keepalive_timeout  65;

        ssl_session_cache   shared:SSL:10m;
        ssl_session_timeout 10m;
        server {
            listen 80;
            listen 443 ssl;
            server_name [your_hostname.com];
            ssl_certificate [Path to certificate]/ssl_certificate.crt;
            ssl_certificate_key [Path to certificate key]/ssl_certificate.rsa;
            ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
            ssl_prefer_server_ciphers on;
            ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
            root /usr/share/nginx/html;
            index index.html index.htm;
            client_max_body_size 100M;

            # Make site accessible from http://localhost/
            server_name [backend];
            location / {
                    proxy_pass http://[backend]:[port];
                    proxy_http_version 1.1;
                    proxy_set_header Upgrade $http_upgrade;
                    proxy_set_header Connection "upgrade";
                    proxy_set_header Host $http_host;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
                    proxy_set_header X-Forward-Proto http;
                    proxy_set_header X-Nginx-Proxy true;
                    proxy_redirect off;
            }
        }
    } 
    ```
4. Open command prompt and enter the following replacing [nginx installation path], such as `C:\nginx-1.18.0`
    ```cmd
    > cd [nginx installation path]
    > start nginx
    ```

    Now to verify, open the webbrowser and enter [your_hostname.com] 


---
For other refernces please check the [community supported installation document](https://docs.rocket.chat/installation/community-supported-installation/windows-server) 