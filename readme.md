This Singularity container installs Python, R and rpy2.

It also implements Lmod to access CHPC modules

It can serve as a base container for other CHPC applications that need Lmod, and potentiall Python and/or R.

A few potential caveats:

- for different Ubuntu distributions, make sure to change the R repository, e.g. ```add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu yakkety/'```

For Lmod, we need to make the container to source the Lmod initialization at container start. Ended up explicilty putting this to ```/etc/bash.bashrc```. The reason for this is that Singularity initializes the shell with ```exec /bin/bash```, which is a no-login shell, which in turn does not source ```/etc/profile``` or ```/etc/profile.d/`` files.

We also need to install Ubuntu specific Lmod to the CHPC sys branch as some of the system commands have different location in Ubuntu as compared to CentOS.


