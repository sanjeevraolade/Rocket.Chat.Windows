
REM meteor npm i
REM meteor build

SET NODE_ENV="production"
SET LIVECHAT_DIR="public\\livechat\\"
SET LIVECHAT_ASSETS_DIR="private\\livechat"

rmdir /q /s %LIVECHAT_DIR%
mkdir %LIVECHAT_DIR%

rmdir /q /s %LIVECHAT_ASSETS_DIR%
mkdir %LIVECHAT_ASSETS_DIR%

echo "Installing Livechat %LATEST_LIVECHAT_VERSION%..."
REM cd %LIVECHAT_DIR%

SET BUILD_ASSETS_DIR="node_modules\\@rocket.chat\\livechat\\build\\"

REM xcopy /E /Y %BUILD_ASSETS_DIR% %LIVECHAT_DIR%
xcopy /E /Y node_modules\@rocket.chat\livechat\build\* public\livechat\
REM copy /Y ..\\..\\node_modules\\\@rocket.chat\\livechat\\build\\ \\
REM mkdir assets
REM copy /Y ..\\..\\node_modules\\\@rocket.chat\\livechat\\build\\assets\\ \\assets\\
node -e "fs.writeFileSync('public\\livechat\\index.html', fs.readFileSync('public\\livechat\\index.html').toString().replace('<!DOCTYPE', '<!doctype'));"

REM SET LIVECHAT_ASSETS_DIR_REL_PATH="../../private/livechat"
REM cd %LIVECHAT_ASSETS_DIR_REL_PATH%

xcopy /E /Y public\livechat\index.html private\livechat\