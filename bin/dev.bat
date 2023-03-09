@echo off

:: Create the default settings.env if it does not exist
if NOT EXIST conf\settings.env (
  echo settings.env not found, using defaults.
  copy conf\settings.default.env conf\settings.env
)

:: Load container setup variables
for /F "eol=# usebackq" %%i in (conf\settings.env) do set %%i

:: Define the image source
set IMAGE_SOURCE=%IMAGE_NAME%
if DEFINED PRIVATE_REGISTRY (
  set IMAGE_SOURCE=%PRIVATE_REGISTRY%/%IMAGE_NAME%
)

docker run ^
-it ^
--rm ^
-v %CONTAINER_ROOT%\volumes\web:/opt/web ^
-v %CONTAINER_ROOT%\volumes\api:/opt/api ^
-p 7080:80 ^
-p 8080:8080 ^
-p 8081:8081 ^
--name %CONTAINER_NAME%-dev ^
%IMAGE_SOURCE%:%IMAGE_TAG% /bin/bash
