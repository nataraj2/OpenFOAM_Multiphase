program PostProcess
use ModReadBinaryVTK
implicit none

integer (kind=4) :: yindex,zindex,xindex,xindexvec(3),slicenum
character(len=200) :: filename,filealphasliceavg
integer :: docomputetrajectory,docomputeuvstatpoint,docomputedropletnumber

	nx=500
        ny=135
        nz=200

	docomputetrajectory=1
	docomputeuvstatpoint=1
	docomputedropletnumber=1

        npoints=(nx+1)*(ny+1)*(nz+1)
        ncells=nx*ny*nz

        allocate(xval(nx+1))
        allocate(yval(ny+1))
        allocate(zval(nz+1))
        allocate(YSliceAlpha(nx+1,nz+1))
        allocate(XSliceAlpha(ny,nz))
        allocate(YSliceU(nx+1,nz+1))
	allocate(YSliceAlphaTimeAvg(nx+1,nz+1))
	allocate(XSliceAlphaTimeAvg(ny,nz))
	allocate(alphaVsX(nx+1))
	allocate(UVsX(nx+1))
	allocate(UVsY(nx+1))

	YSliceAlphaTimeAvg=0.0
	XSliceAlphaTimeAvg=0.0
 
	nfiles=0

	! Reading filenames and time data

	call ReadFilenamesAndTimingData

	filename=filestr(1)
	open(unit=10,file=filename,form='unformatted',access='stream',convert='big_endian')
	print*,"------------------------"
	print*,"Skip data and read grid"
	print*,"------------------------"
        call SkipData
        call ReadGrid
        close(10)

	yindex=67

	if(docomputetrajectory.eq.1)then	
	call ComputeTrajectory(yindex)
	endif
		
	! Give variable filenames here

	if(docomputeuvstatpoint.eq.1)then	
	xindex=200
	yindex=67
	zindex=50

	open(unit=20,file='UVsTimeAtPoint1.dat')
	call ComputeUVsTimeAtPoint(xindex,yindex,zindex)
	close(20)


	xindex=266
	yindex=67
	zindex=50

	open(unit=20,file='UVsTimeAtPoint2.dat')
	call ComputeUVsTimeAtPoint(xindex,yindex,zindex)
	close(20)

	xindex=333
	yindex=67
	zindex=50

	open(unit=20,file='UVsTimeAtPoint3.dat')
	call ComputeUVsTimeAtPoint(xindex,yindex,zindex)
	close(20)


	xindex=400
	yindex=67
	zindex=50

	open(unit=20,file='UVsTimeAtPoint4.dat')
	call ComputeUVsTimeAtPoint(xindex,yindex,zindex)
	close(20)
	endif



	if(docomputedropletnumber.eq.1)then
	xindexvec(1)=200
	xindexvec(2)=266
	xindexvec(3)=333
	
	print*,"alpha slice extraction at x=",xval(xindex)

	do slicenum=1,3
		call ComputeXSliceAlphaTimeAvg(xindexvec(slicenum))
		!call ReadXSliceAlpha(filestr(3),xindexvec(slicenum))	
		!XSliceAlphaTimeAvg=XSliceAlpha
		write(filealphasliceavg,'(a,i1.1,a)') "alphaslicetimeavgX",slicenum,".dat"
		print*,filealphasliceavg
	 	open(unit=20,file=filealphasliceavg)
           	do kk=1,nz
             		do jj=1,ny
                 		write(20,*)yval(jj),zval(kk),XSliceAlphaTimeAvg(jj,kk)
             		enddo
           	enddo
          	close(20)
	enddo
	endif



end program PostProcess

subroutine ComputeUVsTimeAtPoint(xindex,yindex,zindex)

use ModReadBinaryVTK
implicit none

integer :: xindex,yindex,zindex

	do filenum=1,nfiles	
		call ReadUAtPoint(filestr(filenum),xindex,yindex,zindex)
		write(20,*)timevec(filenum),uval,vval,wval
	enddo
		
end subroutine ComputeUVsTimeAtPoint

subroutine ComputeTrajectory(yindex)
use ModReadBinaryVTK
implicit none

integer (kind=4) :: yindex

	! Post processing begins here

	print*,"-----------------------------"
	print*,"Computing trajectory"
	print*,"-----------------------------"
	
	do filenum=1,nfiles

           call ReadYSliceAlpha(filestr(filenum),yindex)
	   
	   if(filenum.eq.1)then	
		dt1=dtvec(filenum)
		print*,"Filenum",filenum,"dt=",dt1
		YSliceAlphaTimeAvg=YSliceAlphaTimeAvg+YSliceAlpha*dt1
     	   elseif(filenum.gt.1.and.filenum.le.nfiles-1)then
		dt1=dtvec(filenum-1)
		dt2=dtvec(filenum)
		print*,"Filenum",filenum,"dt1=",dt1,"dt2=,",dt2
		YSliceAlphaTimeAvg=YSliceAlphaTimeAvg+YSliceAlpha*(dt1+dt2)
	   elseif(filenum.eq.nfiles)then
		dt1=dtvec(nfiles-1)
		print*,"Filenum",filenum,"dt=",dt1
		YSliceAlphaTimeAvg=YSliceAlphaTimeAvg+YSliceAlpha*dt1
	   endif

	  enddo

	   print*,"Total time=",totaltime
	 
	   YSliceAlphaTimeAvg=YSliceAlphaTimeAvg/(2.0D0*totaltime)
	
       	   open(unit=20,file='alphaslice.dat')
           do kk=1,nz+1
             do ii=1,nx+1
                 write(20,*)xval(ii),zval(kk),YSliceAlphaTimeAvg(ii,kk)
             enddo
           enddo
	  close(20)

end subroutine ComputeTrajectory


subroutine ComputeXSliceAlphaTimeAvg(xindex)
use ModReadBinaryVTK
implicit none

integer (kind=4) :: xindex

	! Post processing begins here

	print*,"-----------------------------"
	print*,"Computing X slice alpha avg"
	print*,"-----------------------------"

	XSliceAlphaTimeAvg=0.0D0
	
	do filenum=1,nfiles

           call ReadXSliceAlpha(filestr(filenum),xindex)
	   
	   if(filenum.eq.1)then	
		dt1=dtvec(filenum)
		print*,"Filenum",filenum,"dt=",dt1
		XSliceAlphaTimeAvg=XSliceAlphaTimeAvg+XSliceAlpha*dt1
     	   elseif(filenum.gt.1.and.filenum.le.nfiles-1)then
		dt1=dtvec(filenum-1)
		dt2=dtvec(filenum)
		print*,"Filenum",filenum,"dt1=",dt1,"dt2=,",dt2
		XSliceAlphaTimeAvg=XSliceAlphaTimeAvg+XSliceAlpha*(dt1+dt2)
	   elseif(filenum.eq.nfiles)then
		dt1=dtvec(nfiles-1)
		print*,"Filenum",filenum,"dt=",dt1
		XSliceAlphaTimeAvg=XSliceAlphaTimeAvg+XSliceAlpha*dt1
	   endif

	  enddo

	   print*,"Total time=",totaltime
	 
	  XSliceAlphaTimeAvg=XSliceAlphaTimeAvg/(2.0D0*totaltime)
	
end subroutine ComputeXSliceAlphaTimeAvg

subroutine GetTime(filename,timeval)
use ModReadBinaryVTK
implicit none
character(len=200) :: filename
real (kind=8) :: timeval
integer(kind=4) :: filetimestart,filetimestop,int2

	do dummyint=1,200
		if(filename(dummyint:dummyint+4).eq.'RANS_')then
              	  filetimestart=dummyint+6
                  exit
                endif
	enddo

        do dummyint=1,200
              if(filename(dummyint:dummyint+4).eq.'.vtk')then
                filetimestop=dummyint-1
                exit
              endif
        enddo

        print*,filetimestart,filetimestop
        read(filename(filetimestart:filetimestop),*)timeval
        print*,"Filename ",filename,"time=",timeval

end subroutine GetTime


subroutine ReadFilenamesAndTimingData
use ModReadBinaryVTK
implicit none

	print*,"-----------------------------"
	print*,"Reading file and timing data"
	print*,"-----------------------------"

	open(unit=101,file='filelist.txt')
	
	do filenum=1,1000000
	    read(101,*,iostat=reason)filestrcount
	    if(reason.eq.0)then
		nfiles=nfiles+1
	   else if(reason.lt.0)then
		exit
	   endif
	enddo

	close(101)
		
	print*,"Number of files",nfiles

	allocate(filestr(nfiles))
	allocate(dtvec(nfiles))
	allocate(timevec(nfiles))

	dtvec=0.0D0	
	open(unit=101,file='filelist.txt')
	do filenum=1,nfiles
		read(101,*)filestr(filenum)
	enddo
	close(101)

	do filenum=1,nfiles
		call GetTime(filestr(filenum),timeval1)
		timevec(filenum)=timeval1
	enddo
	do filenum=1,nfiles-1
                dtvec(filenum)=timevec(filenum+1)-timevec(filenum)
	enddo
	print*,"----------------------------"
	print*,"Reading start and end times"
	print*,"----------------------------"
	call GetTime(filestr(1),timestart)
	call GetTime(filestr(nfiles),timeend)
	totaltime=timeend-timestart
	
end subroutine ReadFilenamesAndTimingData

