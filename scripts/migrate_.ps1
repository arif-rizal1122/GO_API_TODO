Get-content .env | Foreach-Object {
    if ($_ -match '^([^#][^=]+)=(.+)$') {
        
        Set-Item -Path "env:$($matches[1])" -Value "$($matches[2])"  
    }
}

$command = $args[0]
$name = $args[1]

switch ($command) {
    "up" {
        migrate -path migrations -database $env:DATABASE_URL up
    }
    "down" {
        if ($name) {
    $count = $name
} else {
    $count = "1"
}

        write-Host "Rolling back $count migration(s). Continue [y/n]"
        $confirm = Read-Host

        if ($confirm -eq 'y'){
            migrate -path migrations -database $env:DATABASE_URL down $count
        }
        else {
            write-Host "Migration cancelled"
        }
    }
    "create" {migrate create -ext sql -dir migrations -seq $name}
    "status" {migrate -path migrations -database $env:DATABASE_URL status}
    default {
        write-Host "Unknown command: $command"
    }
}