# README.md

## Overview
I have had to fork away (not from) the original project.  For some reason the github repo does not have artifacts matching what is available at BKcore' web page.  So, I used wget to pull down the content from:  
http://hexgl.bkcore.com/play/ 
specifically the following files in to the location below:  
bkcore/hexgl/HexGL.js  
bkcore/hexgl/ShipControls.js

## Deploy on OpenShift
```
## HexGL
### Create Your Project and Deploy App (HexGL)
# HexGL is a HTML5 video game resembling WipeOut from back in the day (Hack the Planet!)
MYPROJ="hexgl"
oc new-project $MYPROJ --description="HexGL Video Game" --display-name="HexGL Game" || { echo "ERROR: something went wrong"; sleep 5; exit 9; }
oc new-app php:7.3~https://github.com/cloudxabide/HexGL.git --image-stream="openshift/php:latest" --strategy=source

# Wait for the build to complete (CrashLoopBackoff is "normal" for this build)
oc get pods -w

# Add a route (hexgl.linuxrevolution.com)
echo '{ "kind": "List", "apiVersion": "v1", "metadata": {}, "items": [ { "kind": "Route", "apiVersion": "v1", "metadata": { "name": "hexgl", "creationTimestamp": null, "labels": { "app": "hexgl" } }, "spec": { "host": "hexgl.linuxrevolution.com", "to": { "kind": "Service", "name": "hexgl" }, "port": { "targetPort": 8080 }, "tls": { "termination": "edge" } }, "status": {} } ] }' | oc create -f -

# Add a route (hexgl.apps.ocp4-mwn.linuxrevolution.com)
#echo '{ "kind": "List", "apiVersion": "v1", "metadata": {}, "items": [ { "kind": "Route", "apiVersion": "v1", "metadata": { "name": "hexgl", "creationTimestamp": null, "labels": { "app": "hexgl" } }, "spec": { "host": "hexgl.apps.ocp4-mwn.linuxrevolution.com", "to": { "kind": "Service", "name": "hexgl" }, "port": { "targetPort": 8080 }, "tls": { "termination": "edge" } }, "status": {} } ] }' | oc create -f -

# Once the app is built (and running) update the deployment
oc scale deployment.apps/php --replicas=0
oc scale deployment.apps/hexgl --replicas=3

-- Or...
oc edit deployment.apps/php
spec:
  replicas: 0
```

At some point you will be able to browse to (depending on the route you enabled):
https://hexgl.linuxrevolution.com/

## Original Content Header
HexGL
=========

Source code of [HexGL](http://hexgl.bkcore.com), the futuristic HTML5 racing game by [Thibaut Despoulain](http://bkcore.com)

## Branches
  * **[Master](https://github.com/BKcore/HexGL)** - Public release (stable).

## License

Unless specified in the file, HexGL's code and resources are now licensed under the *MIT License*.

-- NOTE: I had to make some updates to the original instructions, as I do not run stuff as root (even on my workstation) and you cannot bind to a priv port (under 1024) as a non-root user

## Installation (local)
        yum -y install chromium-browser
	cd ~/
	git clone git://github.com/BKcore/HexGL.git
	cd HexGL
        case $(python --version) in 
          Python*3.*) python -m http.server ;;
          *) python -m SimpleHTTPServer ;;
        esac
        chromium-browser http://localhost:8000/index.html

## Run locally as a container

        yum -y install chromium-browser
        cd ~/
        git clone git://github.com/BKcore/HexGL.git
        cd HexGL
        podman build -t my-hexgl .
        podman run --name hexgl localhost/my-hexgl
        chromium-browser http://localhost:8000/index.html

As this is the ONLY pod running on my host, I can run: 
       podman stop $(podman ps | grep -v ^CONT | awk '{ print $1 }')


To use full size textures, swap the two textures/ and textures.full/ directories.

## Note

This was from the BKcore Developer
```
The development of HexGL is in a hiatus for now until I find some time and interest to work on it again.
That said, feel free to post issues, patches, or anything to make the game better and I'll gladly review and merge them.
```
