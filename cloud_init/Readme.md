Info
=====
cloudinit.ubuntu.001  - Simple cloud init example

cloudinit.ubuntu.002  - Example with phone home

cloudinit.ubuntu.tools - Install common tools for cloud , etc on Ubuntu/Debian

cloudinit.centos.tools - Install common tools for cloud , etc on CentOS/RHEL


Usage
====

*This works on the PVHVM images only*

On Rackspace cloud using Debian 7 (Wheezy) (PVHVM) image :-

```
nova boot --config-drive=true --user-data=cloudinit.ubuntu.tools --image=f3b267d5-9748-4d4c-937e-1518d569977c --flavor=performance1-1 c0002
```


On Rackspace cloud using CentOS 6.5 (PVHVM)  image :-

```
nova boot --config-drive=true --user-data=cloudinit.ubuntu.tools --image=41e59c5f-530b-423c-86ec-13b23de49288 --flavor=performance1-1 c0003
```


On Rackspace cloud using Ubuntu 13.10 (Saucy Salamander) (PVHVM)  image :-

```
nova boot --config-drive=true --user-data=cloudinit.ubuntu.tools --image=2ab974de-9fe5-4f5b-9d58-766a59f3de61 --flavor=performance1-1 c0004
```