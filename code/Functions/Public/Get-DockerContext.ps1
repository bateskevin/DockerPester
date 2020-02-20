Function Get-Dockercontext {
    $Images = docker context ls

    $count = 0

    Foreach($Line in $Images){
        if($count -eq 0){
            $Arr = @()
        }else{

            $SplitLine = $Line.Split(" ")

            $PropertyCount = 0
            Foreach($Object in $SplitLine){
                if($Object.Length -gt 2){
                    Switch ($PropertyCount) {
                        0 {$Repository = $Object;$PropertyCount++}
                        1 {$Tag = $Object;$PropertyCount++}
                        2 {$ImageID = $Object;$PropertyCount++}
                        3 {$Created = $Object;$PropertyCount++}
                        4 {$Size = $Object;$PropertyCount++}
                    }                
                }
            }

            $Obj = [PSCustomObject]@{
                Repository = $Repository
                Tag = $Tag
                ImageID = $ImageID
                Created = $Created
                Size = $Size
            }

            $Arr += $Obj

        }

        $count++
    }
    Return $Arr
}