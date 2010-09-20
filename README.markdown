About
========
This project provides an easy-to-use **Bourne Shell(`sh`) test suite**. It is used by various **CloudBase-based applications** to test their functionality but is capable of testing any UNIX application that can be executed through `sh`.

Using test.cloudbase
========
To use the framework, just put your script file into the working directory checked out. Name your script with `XXX_test_for_what.sh`, `XXX` is a serial number. Include the following two lines in your script file:  
 
    . etc/test.conf
    . etc/test.subr
 
You can set up your configuration variables in `test.conf`, which will be the centralized place to control behaviors of all the tests. `test.subr` is the core of this test suite, and you can extends your testing commands by defining functions in it.  
 
The testing commands currently supported are limited, only a few categories are implemented:  
 
 * `assert_ok`, `assert_equal` to assert expected result of command executions.
 * `push_wd`, `pop_wd` to gracefully change (temporally) working directory.
 * `benchmark`, `verbose_benchmark` to get the statistics of the command executions.
 
See `test.subr` for more implemented testing commands. 
 
The framework also provides a `daemon` command to control the daemons one application required remotely. The `daemon` assume all the ones list in the `$daemon_required` has the FreeBSD-style rc script interface, that is, it must supports `start|stop|restart|....` to control the daemon. 
 
    daemon_required='acpt webdb'
    daemon start                   # run `acpt start`, `webdb start` in order.
  
Test suite communicate with remote host mostly via SSH protocol, and settings can be found in `test.conf`. For non-standard daemons that doesn't come with a FreeBSD rc script, one has to provide it in order that `daemon` command can work correctly.  
 
The suite has already come with rc scripts for **acpt** and **webdb**(wrapper only):  
 
    etc/rc.d/acpt
    etc/rc.d/webdb
    etc/rc.conf
  
Just copy those scripts to the hosts running **acpt** or **webdb**, and set up the path/host in `test.conf`. 

Examples
=========
See the existed test scripts for more informations.
