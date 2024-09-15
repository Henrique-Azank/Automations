
# Simple Script for starting an Debian Python container with Docker Desktop using PowerShell

# Used to mount a local directory to the container as a volume when you need to work with files in the container
# or for when you just want to use bash in your Windows machine

# Try to get the docker desktop service
$dockerDesktopServiceName = "Docker Desktop"
$dockerDesktopPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# Check if the service is running
$retries = 0
while ($retries -lt 3) {
    Write-Output "Checking if Docker Desktop is running"
    try {
        # If the service is up, the loop is ended
        Get-Process -Name $dockerDesktopServiceName -ErrorAction Stop | Out-Null
        Write-Output "Docker Desktop is already running"
        break
    }
    catch {
        # Trying to activate the service
        Write-Output "Docker Desktop is not running ... activating it"
        Start-Process -FilePath $dockerDesktopPath
        Start-Sleep -Seconds 5
        Write-Output "Docker Desktop is now running"
    }
    $retries++
}

# Define the local Windows directory and the container directory
$localDir = "C:/Henrique"
$containerDir = "/mnt/henrique"

# Define the container name
$containerName = "my-ubuntu-container"
$dockerImage = "python:3"

# Check if the container already exists
$containerExists = docker ps -a --filter "name=$containerName" --format "{{.Names}}" | ForEach-Object { $_ -eq $containerName }

# If the container exists, we need to either start it or attach to it
if ($containerExists) {
    Write-Output "The container $containerName already exists"

    # Check if the container is running
    $containerRunning = docker ps --filter "name=$containerName" --format "{{.Names}}" | ForEach-Object { $_ -eq $containerName }

    # If the contyainer is alrerady running, attach to it
    if ($containerRunning) {
        # Attach to the running container
        docker exec -it $containerName bash
    } else {
        # Start the stopped container and attach to it
        docker start $containerName
        docker exec -it $containerName bash
    }

}
# If the container does not exist, we need to create it and attach to it
else {
    Write-Output "The container $containerName does not exist"
    Write-Output "Creating the container $containerName"
    docker run -it --name $containerName --mount type=bind,source="$localDir",target="$containerDir" $dockerImage bash
}


