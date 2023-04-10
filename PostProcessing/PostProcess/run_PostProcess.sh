#gfortran -c ModReadBinaryVTK.f90
rm -rf out
/opt/local/bin/gfortran-mp-7 ModReadBinaryVTK.f90 ReadBinaryVTK.f90 PostProcess.f90 -o out
./out 
#> postprocess.log
