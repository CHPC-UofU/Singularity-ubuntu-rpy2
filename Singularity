# Defines a base Ubuntu 16 Singularity container with basic Python packages
# uses pip to install numpy so it detects and takes advantage of OpenBLAS
# OpenBLAS is optimized for multiple CPU archs, on par with MKL for SSE and AVX 
# and about 30% slower for AVX2

BootStrap: docker
From: ubuntu:16.10

#BootStrap: debootstrap
#OSVersion: xenial
#MirrorURL: http://us.archive.ubuntu.com/ubuntu/


%runscript
    echo "Arguments received: $*"
    exec /usr/bin/python "$@"


%post
    # need to create mount point for home dir
    mkdir /uufs
    mkdir /scratch
    cd /root

#    sed -i 's/$/ universe/' /etc/apt/sources.list
    apt-get update
    apt-get -y --force-yes install vim
    # Install the commonly used packages (from repo)
    apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        build-essential \
        curl \
        git \
        libopenblas-dev \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libpng-dev \
        libzmq3-dev \
        python-pip \
        pkg-config \
        python-dev \
        python-setuptools \
        rsync \
        software-properties-common \
        unzip \
        vim \
        zip \
        zlib1g-dev
    apt-get clean

    #MC issue with locale (LC_ALL, LANGUAGE), to get it right:
    apt-get install -y language-pack-en
    locale-gen "en_US.UTF-8"
    dpkg-reconfigure locales
    export LANGUAGE="en_US.UTF-8"
    echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
    echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale

    # update all packages
    apt-get dist-upgrade --yes

    # Update to the latest pip (newer than repo)
    pip install --no-cache-dir --upgrade pip
    # Install other commonly-needed python packages
    pip install --no-cache-dir --upgrade \
        future \
        matplotlib \
        scipy 
    
    # packages required for deb building and installation
    apt-get install -y --force-yes mercurial git gdebi-core 
    pip install setuptools --upgrade
    
    # install dos2unix
    apt-get install dos2unix -y --force-yes 
    
    # FFTW3 with hope that numpy may pick it
    apt-get install libfftw3-dev libtiff5-dev -y --force-yes

    #for OpenBLAS accelerated Python3 NumPy, install through pip3
    apt-get install -y python3-pip
    pip3 install --no-cache-dir --upgrade pip
    pip3 install --no-cache-dir --upgrade future matplotlib scipy

    #MC install additional dependencies
    apt-get install -y software-properties-common python-software-properties apt-transport-https
    # install the latest version of r
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu yakkety/'
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
    gpg -a --export E084DAB9 | apt-key add -
    apt-get update
    apt-get install r-base -y
    
    
    # install dependencies for numpy and matplotlib
    apt-get install -y python2.7-dev pkg-config
    
    #MC some more dependencies - lefse test needs wget
    apt-get install -y wget

    pip install --upgrade pip
    pip install rpy2 pandas

    # ---------------------------------------------------------------
    # install R packages for visualization
    # ---------------------------------------------------------------
    
    # install R packages to root R library
#    R -q -e "install.packages('vegan',repos='http://cran.r-project.org')"
    R -q -e "install.packages('ggplot2',repos='http://cran.r-project.org')"
    
    # install dependencies of EBImage (a dependency of ggtree) and then install ggtree
#    R -q -e "source('https://bioconductor.org/biocLite.R'); biocLite('EBImage'); biocLite('ggtree')"

    # LMod
    apt-get install -y liblua5.1-0 liblua5.1-0-dev lua-filesystem-dev lua-filesystem lua-posix-dev lua-posix lua5.1 tcl tcl-dev lua-term lua-term-dev lua-json

    echo "
if [ -f /uufs/chpc.utah.edu/sys/etc/profile.d/module.sh ]
then
   . /uufs/chpc.utah.edu/sys/etc/profile.d/module.sh
fi
   " > /etc/profile.d/91-chpc.sh

    echo "
. /etc/profile.d/91-chpc.sh
" >> /etc/bash.bashrc

%environment    
PATH=/usr/local/bin:$PATH
LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

%test
    # /environment does not seem to be passed to %test
    export PATH=/usr/local/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
    python -c "import rpy2"
    python -m 'rpy2.tests'
    
