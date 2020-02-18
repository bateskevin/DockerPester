# DockerPester
Run Pester Tests in containers locally and get PassThru Object back.

![Docker](IMG/Docker.png)                        ![Powershell](IMG/powershell.png) 

# Azure Pipelines

## Module Functionality

| OS        | Tag           |
| ------------- |:-------------:|
| Base Functionalty     | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=BaseTests) |

# Tested Docker Images

Up until now I tested it with the following Docker Images:

| OS        | Tag           | Pull  | Comment     |
| ------------- |:-------------:| -----:| -----:|
| Alpine 3.8      | 7.0.0-rc.2-alpine-3.8 | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-alpine-3.8 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=alpine_3_8) |
| Alpine 3.10      | 7.0.0-rc.2-alpine-3.10 | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-alpine-3.10 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=alpine_3_10) |
| Ubunti Bionic    | 7.0.0-rc.2-arm32v7-ubuntu-bionic | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-arm32v7-ubuntu-bionic | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=ubuntu_Bionic) |
| servercore 2019   | mcr.microsoft.com/windows/servercore:ltsc2019 | docker pull mcr.microsoft.com/windows/servercore:ltsc2019 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=servercore_2019) |
| servercore 1809   | mcr.microsoft.com/windows/servercore:1809 | docker pull mcr.microsoft.com/windows/servercore:ltsc2019 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=servercore_1809) |


 # How to use it

 ## Prereq

 ### Install Docker

 Install Docker on your System from here: 
 
 [Install Docker](https://docs.docker.com/install/)

 You can install it using Chocolatey with this Script:

 [Install Docker with Chocolatey](Examples/Install_Docker_win.ps1)

 ! Installs Chocolatey and Docker. If you already have Chocolatey installed just run the second line.

 ### Windows Containers on Macbook

 If you are using a macbook and want to run Windows Containers check out [windows-docker-machine](https://github.com/StefanScherer/windows-docker-machine/blob/master/) by Stefan Scherer.

 Follow the Instructions in the Readme [here](https://github.com/StefanScherer/windows-docker-machine/blob/master/README.md#working-on-macos)

 ### Pull Powershell Docker Images

 You can find all the Images with Powershell on them, provided by Microsoft, here: 
  [Powershell Docker Images](https://hub.docker.com/_/microsoft-powershell)

  Pull these images like this for example:

  ```
  docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-alpine-3.8
  ```

  ## Run a Test

  ```
$Param = @{
    ContainerName = "DockerPester" #Name of the Container used to Test.
    Image = "mcr.microsoft.com/powershell:7.0.0-rc.2-alpine-3.8" #Image used for the Container
    InputFolder = "/Users/kevin/code/PSHarmonize"#Module or Folder you pass with your Tests in them
    PathOnContainer = "/var" #Path you want to copy to in your container
    PathToTests = "Tests" #Path in 'InputFolder' where your Tests are located
    PrerequisiteModule = "PSHTML" #Pass Modules that are prerequisites to your tests to download from gallery in container.
}

Invoke-DockerPester @Param
  ```

Parameters are described in Detail here: [Parameters](Docs/Parameter.md)

# Set DockerPester up for your Module to use locally

Find the Documentation to set up DockerPester for your module [here](Docs/Setup_for_your_Module.md) - NOT FINISHED