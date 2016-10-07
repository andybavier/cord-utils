# cord-utils
Utilities for CORD development and testing

## run-test.sh

This script leverages the [Omni](http://trac.gpolab.bbn.com/gcf/wiki/Omni)
GENI tool to bring up an Ubuntu 14.04 bare-metal server on
[CloudLab](http://www.cloudlab.us/).  It then uses Ansible to prep the
server and launch the [CORD-in-a-Box](https://github.com/opencord/cord/blob/master/docs/quickstart.md)
installer script on that node.  

An example invocation:

```
./run-test.sh wisconsin-clab acb1
```

The above example creates a slice called `acb1` in the `XOS` project on the
[GENI Portal](https://portal.geni.net/).  It allocates a bare-metal server
running Ubuntu 14.04 on the Wisconsin CloudLab cluster to this slice. (Substitute
`clemson-clab` to use the Clemson cluster).  Finally it installs CORD-in-a-Box
on this node and saves the install logfile in `./logs`.

Sample output:
```
*** Start: Fri Oct  7 10:27:01 EDT 2016
*** Creating slice acb1
*** Creating experiment on wisconsin-clab
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: notready)
Waiting for experiment to be ready (status: notready)
Waiting for experiment to be ready (status: notready)
Waiting for experiment to be ready (status: notready)
Waiting for experiment to be ready (status: notready)
Waiting for experiment to be ready (status: notready)
Waiting for experiment to be ready (status: notready)
Waiting for experiment to be ready (status: notready)
Waiting for experiment to be ready (status: notready)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
Waiting for experiment to be ready (status: changing)
*** Renewing experiment for 8 hours
*** Creating Ansible hosts file: hosts.wisconsin-clab.acb1
*** Running Ansible playbook

PLAY [all] ***********************************************

GATHERING FACTS ******************************************
ok: [node]

TASK: [Install mosh] *************************************
changed: [node]

TASK: [Download cord-in-a-box.sh script] *****************
changed: [node]

TASK: [Run cord-in-a-box.sh script] **********************
ok: [node]
<job 676245179570.116044> polling, 14340s remaining
ok: [node]
<job 676245179570.116044> polling, 14280s remaining
...
changed: [node]
<job 676245179570.116044> finished on node

TASK: [Fetch log] ****************************************
changed: [node]

PLAY RECAP ***********************************************
node                       : ok=6    changed=3    unreachable=0    failed=0
```

Note that the script will take 2.5 - 3 hours to fully complete.  Be patient!
However you should be able to safely suspend and resume your laptop while it
runs.

### Dependencies

In order to run this script you must:
 * Install the latest version of [Omni](http://trac.gpolab.bbn.com/gcf/wiki/Omni).
    You may need to change the first couple of lines in the script to point to
    your Omni installation.
 * Gain membership in the `XOS` GENI project, or change the script to use your own project.
 * Download and install the proper GENI credentials so that you can run `omni` commands.
 * Install `jq` (on Mac: `brew install jq`)
 * Install `ansible` (on Mac: https://valdhaus.co/writings/ansible-mac-osx/)
