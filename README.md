# Vagrant-Consul-Nomad Local Cluster

Nomad cluster (3 masters + 3 slaves) running inside VirtualBox on a single host.

## What's this?

HashiCorp's [Nomad](https://www.nomadproject.io/) is a workload orchestrator
much like [Kubernetes](https://kubernetes.io/), but more flexible, since it 
allows running more than just containers on a cluster. Furthermore, Nomad
is multi-cloud able, which can be useful in some contexts requiring cloud
vendor independence.

In order to experiment developing and deploying containers and other 
applications on a Nomad cluster, the traditional way is to spawn VMs in
the cloud, e.g. using [Terraform](https://www.terraform.io/), and provision
these VMs with the necessary daemons such as [Consul](https://www.consul.io/),
[Vault](https://www.vaultproject.io/),  Nomad, ...

While this works great, not every developer has 24/7/365 internet connectivity,
and running many VMs on the cloud costs money too. Wouldn't it be great to have
the whole cluster on the developer's machine, so it could be used while on the
move and off the grid? What if all those VMs were running as guests in VirtualBox
on the developer's host machine, whatever that host may be? As long as that
host is beefy enough (RAM and CPU) to handle the load of 6+ VMs, this is indeed
a viable alternative to traditional cloud-based Nomad development / deployment.

This repository aims at spawing and configuring a Nomad cluster locally. The
VMs will thus be created using [Vagrant](https://www.vagrantup.com) as VirtualBox guests.

Using this `Vagrantfile`, a 6 nodes cluster will be created as VMs in
VirtualBox:

- master0
- master1
- master2
- slave0
- slave1
- slave2

The master nodes will run both Consul and Nomad agents in server mode,
and the slave nodes will run Consul and Nomad agents in client mode. Workload will be run by the Nomad servers on the slave nodes.

All VMs will be provisioned not only with 
- consul
- nomad

but also with
- docker

so that Nomad can immediately schedule container workloads when needed.

> Work in progress! While this Repo basically works, work remains to be done. In particular, ACLs are not yet enabled, nor is Vault. See [TODO](#todo) for a list of tasks.

## Prerequisites (on the Host)

- Vagrant [https://www.vagrantup.com/]
- VirtualBox [https://www.virtualbox.org/]
- Enough RAM and CPU cores to handle the load

> Windows Users: when using a Windows 10 host, turn _Hyper-V_
and the _Virtual Machine Platform_ features _off_ (using the
`Turn Windows features on or off` wizard), then reboot. If you
use WSL2 and/or Docker Desktop for Windows, you most definitively
want to do this, as both use Hyper-V. The reason for this is that
VirtualBox, when using Hyper-V backend, can't manipulate the
Network interfaces as required by this Repo, because of Hyper-V's
current inherent limitations.

## Create the VMs

Vagrant will take care of creating the VMs of the cluster nodes in VirtualBox
automatically. It will also provision the VMs with all required programs
and configuration files.

This is how to do it:

- Clone this repository
- `cd` into the folder with the `Vagrantfile` file.
- Change "192.168.76.*" in all files with _your_ external / bridged IP addresses. `Vagrantfile` needs to be edited, but also all config files in the subdirectories corresponding to the various nodes.
- _Windows only_: change the content of the `g_bridge` in `Vagrantfile` to reflect _your_ network adapter that you want to use as a bridge for the public network.
- Change the configuration of the VMs in the variable `servers` in `Vagrantfile` as desired, but keep in mind the resource limitations of the _host_ (especially RAM and CPU cores).
- In the directory containing the `Vagrantfile` file, invoke `vagrant up`:

```bash
$ vagrant up
```

This will first fetch and cache a small [Alpine Linux box](https://app.vagrantup.com/generic/boxes/alpine312), and use that to create 6 VMs in VirtualBox:

- master0 (192.168.76.150, 10.0.0.150)
- master1 (192.168.76.151, 10.0.0.151)
- master2 (192.168.76.152, 10.0.0.152)

- slave0 (192.168.76.160, 10.0.0.160)
- slave1 (192.168.76.161, 10.0.0.161)
- slave2 (192.168.76.162, 10.0.0.162)

The first IP address is from the public network (or bridged network) which
can be reached from other computers all over the world (or at least on the
same LAN as the VirtualBox _host_). The second IP address is from the private
network: in can _only_ be reached from the VirtualBox _host_, but not from
other computers on the WAN or the LAN.

Under the hood, each guest VM will have the following interfaces (e.g. `master0`):

- lo: 127.0.0.1/8, ::1/128, Loopback
- eth0: 10.0.2.15/24, NAT required by Vagrant
- eth1: 192.168.76.150/24, public or bridged IP
- eth2: 10.0.0.150/24, internal IP
- docker0: 172.17.0.1/24, IP for docker network

## Starting and stopping the VMs

We start and stop the VMs with `vagrant` commands.

### Vagrant commands in a multi-machine scenario

First of all, since this `Vagrantfile` is a multi-machine configuration,
invoking (whatever `COMMAND` may contain, see below)

```bash
$ vagrant ${COMMAND}
```

is equivalent to invoking `vagrant ${COMMAND}` on every configured VM:

```bash
$ vagrant ${COMMAND} master0
$ vagrant ${COMMAND} master1
$ vagrant ${COMMAND} master2
$ vagrant ${COMMAND} slave0
$ vagrant ${COMMAND} slave1
$ vagrant ${COMMAND} slave2
```

### Initial `vagrant up` and provisioning

The first time `vagrant up` is called, the VMs will not only be created, they
will also be _provisioned_, i.e. additional software such as `consul` and `nomad`
will be fetched and installed inside the VMs.

Next time `vagrant up` is called, the provisioning step will be skipped: to force
re-provisioning, call `vagrant provision` on running VMs. For example, to
re-provisioning `master0`, call:

```bash
$ vagrant provision master0
```

After changing `Vagrantfile`, the boxes should be _reloaded_ for the changes
to take effect:

```bash
$ vagrant reload
==> master0: Attempting graceful shutdown of VM...
==> master0: Checking if box 'generic/alpine312' version '3.2.6' is up to date...
==> master0: Clearing any previously set forwarded ports...
==> master0: Clearing any previously set network interfaces...
==> master0: Preparing network interfaces based on configuration...
    master0: Adapter 1: nat
    master0: Adapter 2: bridged
    master0: Adapter 3: hostonly
==> master0: Forwarding ports...
    master0: 22 (guest) => 2222 (host) (adapter 1)
==> master0: Running 'pre-boot' VM customizations...
==> master0: Booting VM...
==> master0: Waiting for machine to boot. This may take a few minutes...
    master0: SSH address: 127.0.0.1:2222
    master0: SSH username: vagrant
    master0: SSH auth method: private key
==> master0: Machine booted and ready!
==> master0: Checking for guest additions in VM...
==> master0: Configuring and enabling network interfaces...
==> master0: Mounting shared folders...
    master0: /vagrant_data => C:/Users/farid/Documents/DevOps/make-cluster/data/common
    master0: /etc/hashicorp.d => C:/Users/farid/Documents/DevOps/make-cluster/data/master0
==> master0: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> master0: flag to force provisioning. Provisioners marked to run always will still run.

(... output elided for master1, master2, slave0, slave1, slave2 ...)

```

or, if only one VM was affected:

```bash
$ vagrant reload master0
```

> Important! Always reboot the VMs after initial provisioning, for changes to take effect. In other
words: after inital `vagrant up` with provisioning (or after a manual `vagrant provision`), always
do a `vagrant halt`, followed by a `vagrant up`.

### Starting the VMs

Starting all VMs of the cluster:

```bash
$ vagrant up

```

Single VMs can be started too, e.g.:

```bash
$ vagrant up slave2
```

### Stopping the VMs

Stopping the VMs means shutting them down, but keeping their state
(i.e. virtual disk) inside VirtualBox intact.

Stopping all VMs:

```bash
$ vagrant halt
```

Stopping a single VM:

```bash
$ vagrant halt slave2
```

### Destroying the VMs

Destroying a VM means not only shutting it down, it also means
that its state will be erased. In other words, the VM in VirtualBox,
including its virtual disk file _will be removed_. Whatever was
saved in the filesystem of the VM (unless it was in a shared folder)
will also be gone.

Destroying all VMs:

```bash
$ vagrant destroy
```

Destroying a single VM:

```bash
$ vagrant destroy slave2
```

### Checking the status of the VMs

We can check which VMs are currently running of being stopped:

```bash
$ vagrant status
Current machine states:

master0                   running (virtualbox)
master1                   running (virtualbox)
master2                   running (virtualbox)
slave0                    running (virtualbox)
slave1                    running (virtualbox)
slave2                    running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

## Logging into the VMs

To ssh into one of those VMs (e.g. into `master0`), be sure on the host to `cd`
into the directory that contains `Vagrantfile` and then call:

```bash
$ vagrant ssh master0
master0:~$ hostname
master0
master0:~$ id
uid=1000(vagrant) gid=1000(vagrant) groups=102(docker),103(consul),1000(vagrant)
master0:~$ uname -a
Linux master0 5.4.99-0-virt #1-Alpine SMP Thu, 18 Feb 2021 09:48:40 UTC x86_64 Linux
```

Logging in with `vagrant ssh` instead of merely `ssh` ensures that the
correct public/private SSH key and the correct (forwarded) SSH port is
being used.

To ssh from one VM to the other, use the target IP address
(either external / bridged, or internal). Username is `vagrant`
and password is `vagrant`:

```bash
master0:~$ ssh vagrant@10.0.0.161
The authenticity of host '10.0.0.161 (10.0.0.161)' can't be established.
ECDSA key fingerprint is SHA256:9YnjobBkPIbi5hfkGXxDZ/QyXMqmNWJ8E4/NReLrPCg.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.0.0.161' (ECDSA) to the list of known hosts.
vagrant@10.0.0.161's password:
slave1:~$ exit
logout
Connection to 10.0.0.161 closed.
master0:~$
```

## Understanding Shared Folders

To ease development, and to be able to `vagrant destroy` a VM and recreating
it from scratch with `vagrant up` without too much hassle, we share some
folders between the VirtualBox host and the guest VMs:

- Guest VM `${SOMETHING}`'s _/etc/hashicorp.d_ folder is mapped to the host's _./data/${SOMETHING}_ subfolder (relative to the folder containing `Vagrantfile`). E.g. `master0`'s _/etc/hashicorp.d_ maps to the host's _./data/master0_ folder, and `slave2`'s _/etc/hashicorp.d_ maps to the host's _./data/slave2_ folder.
- All Guest VMs _/vagrant_data/_ map to the same host's folder _./data/common_.

In other words, per-host configuration files in

- _/etc/hashicorp.d/consul.d_
- _/etc/hashicorp.d/nomad.d_
- _/etc/hashicorp.d/nginx.d_

etc. are actually stored in the host, and can be easily re-used if a VM is destroyed and re-created.

When experimenting with configurations, it is easiest to edit those files from the Host, but editing
them from the Guest VM is also possible.

Other persistent state is still stored in the VMs, such as in:

- _/var/consul_
- _/var/lib/nomad_
- _/var/lib/docker_
- and everything else in the local file system on the VM.

Please keep this in mind when `vagrant destroy`-ing and recreating VMs: the configuration files
are saved on the host, but that other state will disappear.

## Starting Consul

### Creating a Shared Consul Secret Key

Before starting the Consul Service Mesh the first time, we need
to manually create a shared secret key for the Consul Gossip Protocol.
This is the protocol that the `consul` agents on the nodes use to
securely communicate between themselves.

> This needs to be done only once, and only if you don't want to use
my (throw-away) secret key. It is highly recommended to use your own
secret key though!

- On any node (e.g. `master0`), call `consul keygen` and take note
of the generated key, e.g. copying it into the clipboard.
Alternatively, redirect it into the common shared folder: `consul keygen > /vagrant_data/consul.keygen`
- Replace my secret key with the newly generated secret key in every
  -  _/etc/hashicorp.d/consul.d/server.hcl_, or
  - _/etc/hashicorp.d/consul.d/client.hcl_, or
  - on the host _./data/\${HOSTNAME}/consul.d/server.hcl_, or
  - on the host _./data/\${HOSTNAME}/consul.d/client.hcl_ file

Now you're all set to start the `consul` agents, and have them gossip
between each others with the new shared secret key.

### Starting the Consul Service Mesh (on each boot)

Each time the cluster is to be used, the `consul` agent _must_ be started
on every node. Currently, this is not done automatically upon boot time.
Instead, start the `consul` daemon on every node manually (upon every reboot).

In the following order:

- master0
- master1
- master2
- slave0
- slave1
- slave2
  
ssh into that box with `vagrant ssh ${HOSTNAME}` and then call:

```bash
$ consul agent -config-dir=/etc/hashicorp.d/consul.d
```

This should bootstrap and start the Consul service mesh (currently
not yet secured with ACLs).

### Troubleshooting Consul Cluster

Sometimes, the Raft Consensus Protocol doesn't converge, and the
Consul agents on the master nodes can't elect a leader. If this
happens:

- on every master node `master0`, `master1`, `master2`:
  - stop the consul agent (e.g. with Ctrl-C)
  - manually delete the file _/var/consul/raft/raft.db_
  - start the consul agent

This should resolve that problem.

## Starting Nomad (on each boot)

After Consul is started on every (master and slave) node of the cluster,
start Nomad on every (master and slave) node. In the following order:

- master0
- master1
- master2
- slave0
- slave1
- slave2

ssh into that box with `vagrant ssh ${HOSTNAME}` and then call:

```bash
$ sudo nomad agent -config=/etc/hashicorp.d/nomad.d
```

Note that the `nomad` agents, as currently configured, rely on
the local `consul` agents running on the same node to discover
their `nomad` peers running on the other nodes. Consul is used
as a _service discovery service_, and it is imperative that the
`consul` agents are all up and running before the `nomad` agents
start.

### Troubleshooting the Nomad Cluster

Sometimes, the Raft Consensus Protocol doesn't converge, and the
Nomad agents on the master nodes can't elect a leader. If this
happens:

- on every master node `master0`, `master1`, `master2`:
  - stop the nomad agent (e.g. with Ctrl-C)
  - manually delete the file _/var/lib/nomad/server/raft/raft.db_ (use `sudo`)
  - start the nomad agent

This should resolve that problem.

## Proxy-ing the UIs to the Host

Consul and Nomad agents come with their own web-based user interfaces (UIs), when configured to do so.

In the current configuration

- consul
- nomad
  
agents running on `master0` are UI-enabled using the `ui_config{}` stanza. 
However, these UIs can only be accessed from the loopback or internal
interface from within `master0`.


To look at them from a browser running on the host, it is necessary to
run a reverse-proxy on `master0`, which will move data back and forth.

We use [Nginx](https://www.nginx.com/) on `master0` as an HTTP reverse proxy.
To start it on demand:

```bash
master0:~$ sudo mkdir -p /run/nginx
master0:~$ sudo chown vagrant:vagrant /run/nginx
master0:~$ sudo nginx -c /etc/hashicorp.d/nginx.d/reverse-proxy
```

Then, it is easy to access it from the host: just point your browser to
- http://192.168.76.150/ui/ for the UI of the Consul agent on `master0`
- http://192.168.76.150:81/ui/ for the UI of the Nomad agent on `master0`

Here, 192.168.76.150 is the public IP / bridged IP of the `master0` node.
If you've changed it above, adjust accordingly.

## Using Nomad to Schedule Workloads

### Starting a simple container

The file _./data/common/jobs/http-echo-docker.hcl_ contains a simple
Nomad job specification, which starts a Docker container on a number
of Nomad slave nodes.

The container _hashicorp/http-echo_ listens on a port that can be
specified on the command line, and replies to every HTTP client that
connects to it by sending back a string, that can also be specified
on the command line.

When running the job `docs` in the file _http-echo-docker.hcl_, Nomad
places docs.example.count (3) instances of this container on available
Nomad slave nodes for execution. By modifying this count value in the
file, Nomad can be instructed to scale up or scale down the deployment
by either starting more containers or by killing existing ones.

To use this file, invoke _on a Nomad master node_:
- `nomad job plan http-echo-docker.hcl`
- `nomad job run -check-index ${IDX-FROM-PREVIOUS-CMD} http-echo-docker.hcl`

We first make a plan:

```bash
master0:/vagrant_data/jobs$ nomad job plan http-echo-docker.hcl
+/- Job: "docs"
+/- Stop: "true" => "false"
    Task Group: "example" (3 create)
      Task: "server"

Scheduler dry-run:
- All tasks successfully allocated.

Job Modify Index: 720
To submit the job with version verification run:

nomad job run -check-index 720 http-echo-docker.hcl

When running the job with the check-index flag, the job will only be run if the
job modify index given matches the server-side version. If the index has
changed, another user has modified the job and the plan's results are
potentially invalid.
```

Noting the index value (720 in this case), we now run the job for real:

```bash
master0:/vagrant_data/jobs$ nomad job run -check-index 720 http-echo-docker.hcl
==> Monitoring evaluation "f7623de2"
    Evaluation triggered by job "docs"
    Evaluation within deployment: "b15748f4"
    Allocation "0cc6210a" created: node "913e1e0d", group "example"
    Allocation "3d9a693d" created: node "eb1ec973", group "example"
    Allocation "5b62b06e" created: node "5bac665a", group "example"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "f7623de2" finished with status "complete"
```

This may take a while to complete. To monitor this, you can either use
the [Nomad UI](#proxy-ing-the-uis-to-the-host) or
use the command line to get a list of jobs:

```bash
master0:/vagrant_data/jobs$ nomad job status
ID    Type     Priority  Status   Submit Date
docs  service  50        running  2021-02-23T19:17:14Z
```

Now, we can drill down into the `docs` job. Your output
will look different, because I've already experimented
with multiple deployments. I've kept the output un-edited
to show a real-world example:

```bash
master0:/vagrant_data/jobs$ nomad job status docs
ID            = docs
Name          = docs
Submit Date   = 2021-02-23T19:17:14Z
Type          = service
Priority      = 50
Datacenters   = dc1
Namespace     = default
Status        = running
Periodic      = false
Parameterized = false

Summary
Task Group  Queued  Starting  Running  Failed  Complete  Lost
example     0       0         3        10      27        0

Latest Deployment
ID          = b15748f4
Status      = successful
Description = Deployment completed successfully

Deployed
Task Group  Desired  Placed  Healthy  Unhealthy  Progress Deadline
example     3        3       3        0          2021-02-23T19:27:37Z

Allocations
ID        Node ID   Task Group  Version  Desired  Status    Created     Modified
5b62b06e  5bac665a  example     17       run      running   1m1s ago    41s ago
0cc6210a  913e1e0d  example     17       run      running   1m1s ago    38s ago
3d9a693d  eb1ec973  example     17       run      running   1m1s ago    44s ago
ad78fbcc  5bac665a  example     15       stop     complete  26m20s ago  4m50s ago
55b1f3e1  eb1ec973  example     15       stop     complete  26m20s ago  4m50s ago
a1937a5f  913e1e0d  example     15       stop     complete  26m20s ago  4m50s ago
30ade182  5bac665a  example     13       stop     complete  52m56s ago  45m8s ago
213bad2b  5bac665a  example     12       stop     failed    1h19m ago   45m8s ago
966a5074  5bac665a  example     12       stop     failed    1h23m ago   45m8s ago
42ff18ee  5bac665a  example     12       stop     failed    1h25m ago   45m8s ago
7d477bbc  5bac665a  example     12       stop     failed    1h26m ago   45m8s ago
5d8d5ef7  5bac665a  example     12       stop     failed    1h27m ago   45m8s ago
66a3525f  eb1ec973  example     13       stop     complete  2h23m ago   44m54s ago
1187d448  913e1e0d  example     13       stop     complete  2h23m ago   45m ago
b8a6bd0c  5bac665a  example     11       stop     complete  2h23m ago   45m8s ago
6bdd2d31  5bac665a  example     9        stop     failed    2h24m ago   45m8s ago
2f83d4ae  eb1ec973  example     8        stop     complete  3h9m ago    44m54s ago
6720b1f1  913e1e0d  example     8        stop     complete  3h9m ago    45m ago
```

Your focus should be on the Deployed section: all 3 desired containers are
placed, and all are healthy (respond to health probes by the local consul
agent).

We can check that the containers are indeed running on the slave nodes, e.g.
by ssh-ing onto one such node, and manually checking:

```bash
slave2:~$ docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED         STATUS         PORTS      NAMES
475717d0d11c   hashicorp/http-echo   "/http-echo -listen …"   5 minutes ago   Up 5 minutes   5678/tcp   server-3d9a693d-34f2-6552-e7c4-5cfdc9371fee

slave2:~$ docker container inspect server-3d9a693d-34f2-6552-e7c4-5cfdc9371fee | jq
(... output elided ...)
```

By examining the container, we learn that it is listening on port 5678 and (local)
IP address 10.0.2.15, the IP address of the first interface. So let's try it:

```bash
slave2:~$ curl -X GET http://10.0.2.15:5678/
hello localhost world
slave2:~$ curl -X GET http://10.0.2.15:5678/health
{"status":"ok"}
```

The first `/` URL is the intended output, the `/health` URL is used as an
endpoint by the local consul agent to check the health of this container.

We can also manually simulate some failure, e.g. by killing the container
with `docker container kill server-3d9a693d-34f2-6552-e7c4-5cfdc9371fee`.
Consul's health service will notice that the container is gone, and Nomad
will start a new one automatically to keep 3 containers placed and running
at all times. 

To stop the job, issue the command `nomad job stop` followed by the
job ID or job name on a Nomad master:

```bash
master0:/vagrant_data/jobs$ nomad job status
ID    Type     Priority  Status   Submit Date
docs  service  50        running  2021-02-23T19:17:14Z

master0:/vagrant_data/jobs$ nomad job stop docs
==> Monitoring evaluation "0398c76b"
    Evaluation triggered by job "docs"
    Evaluation within deployment: "b15748f4"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "0398c76b" finished with status "complete"

master0:/vagrant_data/jobs$ nomad job status
ID    Type     Priority  Status          Submit Date
docs  service  50        dead (stopped)  2021-02-23T19:17:14Z
```

## Nomad and Consul Connect

_... TBD ..._

## TODO

- Enable Consul Connect (done)
- [Integrate Consul Connect with Nomad](https://www.nomadproject.io/docs/integrations/consul-connect)
- Install [Vault](https://www.vaultproject.io/)
- Configure Consul to use Vault and vice-versa
- Enable ACLs in Consul
- Configure Nomad to use Vault
- Enable ACLs in Nomad

## ISC License

This repository is Copyright (C) 2021 Farid Hajji. All rights reserved.

See the file [LICENSE](./LICENSE) for details.
