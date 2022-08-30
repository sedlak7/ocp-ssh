# Run OpenSSH Server inside OpenShift Pods

This repository provides 2 different approaches to running an OpenSSH server within an OpenShift Pod. The existance of this repository does not imply a recommendation for running OpenSSH or any other SSH services within an OpenShift environment, but does provide examples of how to achieve this if the SSH service is required. 

### Tested environment:

These examples were deployed and tested within the following version of OpenShift, but should work in all prior/future versions as the features used version agnostic.
```bash
sshd-examples|master ⇒ oc version
Client Version: 4.10.30
Server Version: 4.10.22
Kubernetes Version: v1.23.5+3afdacb
```

*Versions prior to OCP 4.4 will not work as the SCC binding process has changed since then. These versions are deprecated/unsupported now so should not be of concern.*

### Getting Started

*The SSH serer has been configured to allow key-based authentication. It is recommended to add the desired SSH public keys to the `./resources/authorized_keys` file before continuing.*

To deploy the examples, the following command can be used:
```bash
sshd-examples|master ⇒ oc apply -k .
```

### Accessing the SSH Server
Accessing the Anyuid configuration can be performed as below:
```bash
sshd-examples|master⚡ ⇒ oc port-forward svc/sshd-anyuid-service 2022:2022 &
Forwarding from 127.0.0.1:2022 -> 2022
Forwarding from [::1]:2022 -> 2022

sshd-examples|master⚡ ⇒ ssh -p 2022 1000@localhost
Handling connection for 2022
Warning: Permanently added '[localhost]:2022' (ED25519) to the list of known hosts.
bash: warning: setlocale: LC_ALL: cannot change locale (en_AU.UTF-8)
bash: warning: setlocale: LC_ALL: cannot change locale (en_AU.UTF-8)

bash-5.1$ whoami
1000
```

Accessing the `/sbin/nologin` overridden deployment can be performed as below:
```bash
sshd-examples|master⚡ ⇒ oc port-forward svc/sshd-service 2023:2022 &
Forwarding from 127.0.0.1:2023 -> 2022
Forwarding from [::1]:2023 -> 2022

sshd-examples|master⚡ ⇒ POD=$(kgp  -l pod=sshd-label -o name | cut -f 2 -d "/")
sshd-examples|master⚡ ⇒ USER=$(oc exec -t $POD -- id -u)
sshd-examples|master⚡ ⇒ echo "Running SSH Command: ssh -p 2023 ${USER}@localhost"
sshd-examples|master⚡ ⇒ ssh -p 2023 ${USER}@localhost
Handling connection for 2023
nologin: warning: setlocale: LC_ALL: cannot change locale (en_AU.UTF-8)
bash: warning: setlocale: LC_ALL: cannot change locale (en_AU.UTF-8)

bash-5.1$ whoami
1000770000
```

### Details / Drawbacks
As OpenShift overwrites the user inside the Pod (UIDs) and CRI-O sets the default login shell for any new users to `/sbin/nologin`, this file must be set to a usable shell or link when the defualt UID configuration is used in OpenSHift.

An alternative approach to this would be to use the `anyuid` SCC, which runs the container with the UID defined in the image manifest.
