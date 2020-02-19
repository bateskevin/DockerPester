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

| OS      | Pull  | Comment     |
| ------------- |:-------------:|  -----:|
| Windows servercore 2019   | docker pull mcr.microsoft.com/windows/servercore:ltsc2019 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=servercore_2019) |
| Windows servercore 1809   | docker pull mcr.microsoft.com/windows/servercore:ltsc2019 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=servercore_1809) |
| Alpine 3.8      | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-alpine-3.8 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=alpine_3_8) |
| Alpine 3.9      | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-alpine-3.9 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=alpine_3_9) |
| Alpine 3.10     | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-alpine-3.10 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=alpine_3_10) |
| Ubuntu Bionic    | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-arm32v7-ubuntu-bionic | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=ubuntu_Bionic) |
| Ubuntu Bionic   | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-arm32v7-ubuntu-18.04 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=ubuntu_Bionic_arm) |
| Centos 7    | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-centos-7 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=centos_7) |
| Centos 8    | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-centos-8 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=centos_8) |
| debian buster slim   | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-debian-buster-slim | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=debian_buster_slim) |
| debian 9    | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-debian-9 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=debian_9) |
| debian 10    | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-debian-10 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=debian_10) |
| debian 11    | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-debian-11 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=debian_11) |
| Fedora 28  | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-fedora-28 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=fedora_28) |
| Fedora 29   | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-fedora-29 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=fedora_29) |
| Fedora 30   | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-fedora-30 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=fedora_30) |
| OpenSuse 42.3    | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-opensuse-42.3 | ![Build Status](https://dev.azure.com/KevinBates0726/DockerPester/_apis/build/status/bateskevin.DockerPester?branchName=master&jobName=opensuse_42_3) |



 # How to use it

 ## Prereq

 ### Install Docker

 Install Docker on your System from here: 
 
 [Install Docker](https://docs.docker.com/install/)

 You can install it using Chocolatey with this Script:

 [Install Docker with Chocolatey](Examples/Install_Docker_win.ps1)

 ! Installs Chocolatey and Docker. If you already have Chocolatey installed just run the second line.

   ## Blog Post on how to set up and use:

   [DockerPester on BatesBase](https://bateskevin.github.io/batesbase/Powershell/2020/02/19/DockerPester.md/)
 
   
   ## Run a Test - TLDR

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