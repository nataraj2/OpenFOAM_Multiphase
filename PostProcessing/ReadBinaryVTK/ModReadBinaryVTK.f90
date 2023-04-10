module ModReadBinaryVTK

real(kind=4) :: val
integer(kind=4) :: dummyint
integer(kind=8) :: int8
integer(kind=4) :: nx,ny,nz,npoints,ncells,nattributes
integer(kind=4) :: i,readstart,strlength
character(len=:),allocatable :: str
character(len=20) :: strdummy
integer(kind=4) :: readstart_grid,readstart_alpha,readstart_U,readstart_alpha_cell
integer(kind=4) :: ii,jj,kk
real(kind=4),allocatable :: xval(:),yval(:),zval(:),YSliceAlpha(:,:),XSliceAlpha(:,:),XSliceAlphaTimeAvg(:,:)
real(kind=4),allocatable :: YSliceU(:,:),YSliceAlphaTimeavg(:,:),YSliceTimeAvg(:,:),alphaVsX(:),UVsX(:),UVsY(:)
real(kind=4),allocatable :: Alpha3D(:,:,:),Alpha3DTimeAvg(:,:,:)
real(kind=8) :: liquidvsx

integer(kind=4) :: filenum,nfiles,reason
real (kind=8) :: dt1,dt2,timeval1,timeval2,timeval3,timestart,timeend,totaltime
real(kind=8),allocatable :: dtvec(:),timevec(:)
character (len=200) :: filestrcount
character(len=200),allocatable :: filestr(:)
real (kind=4) :: uval,vval,wval

end module ModReadBinaryVTK

