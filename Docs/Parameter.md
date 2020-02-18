 # Params

  ## ContainerName 

You can choose the name of your container freely. If entered nothing it will be Called "DockerPester"

  ## Image - REQUIRED

Add one of the Images you pulled here.

  ## InputFolder - REQUIRED

Point this to a Module you want to run your Tests for.

  ## PathOnContainer

This will be /var if entered nothing. This is the Path used in the Container.

  ## PathToTests - Partially REQUIRED

Add the Path to the Tests in your Module folder here. Not the whole Path, but only the Path in your Folder.

This will be set to "Tests" if nothing is passed here.

  ## PrerequisiteModule 

Add this Parameter to download prerequisite Module from the gallery.
