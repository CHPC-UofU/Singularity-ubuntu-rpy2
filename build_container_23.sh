imgname=r2py
osname=ubuntu
rm -f ${osname}_${imgname}.img
sudo /uufs/chpc.utah.edu/sys/installdir/singularity/2.3/bin/singularity create --size 3072 ${osname}_${imgname}.img
sudo /uufs/chpc.utah.edu/sys/installdir/singularity/2.3/bin/singularity bootstrap ${osname}_${imgname}.img Singularity


