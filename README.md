# DockerPester
Run Pester Tests in Linux containers locally and get PassThru Object back.

![Docker](IMG/Docker.png)                        ![Powershell](IMG/powershell.png)

## Experimental Module

This is basically just to play around with, but it could get to a cool state :) 

# Tested Docker Images

Up until now I tested it with the following Docker Images:

| OS        | Tag           | Pull  |
| ------------- |:-------------:| -----:|
| Alpine 3.8      | 7.0.0-rc.2-alpine-3.8 | docker pull mcr.microsoft.com/powershell:7.0.0-rc.2-alpine-3.8 |

 # How to use it

 ## Prereq

 ### Install Docker

 Install Docker on your System from here: 
 
 [Install Docker](https://docs.docker.com/install/)

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
    ContainerName = "DockerPester"
    Image = "mcr.microsoft.com/powershell:7.0.0-rc.2-alpine-3.8"
    InputFolder = "/Users/kevin/code/PSHarmonize"
    PathOnContainer = "/var"
    PathToTests = "Tests"
}

Invoke-DockerPester @Param
  ```

  ## Params

  ### ContainerName 

You can choose the name of your container freely. If entered nothing it will be Called "DockerPester"

  ### Image - REQUIRED

Add one of the Images you pulled here.

  ### InputFolder - REQUIRED

Point this to a Module you want to run your Tests for.

  ### PathOnContainer

This will be /var if entered nothing. This is the Path used in the Container.

  ### PathToTests - Partially REQUIRED

Add the Path to the Tests in your Module folder here. Not the whole Path, but only the Path in your Folder.

This will be set to "Tests" if nothing is passed here.
