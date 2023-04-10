subroutine ReadBinaryVTK(filename,yindex,zindex)

use ModReadBinaryVTK
implicit none

integer(kind=4) :: xindex,yindex,zindex
character(len=200) :: filename


	open(unit=10,file=filename,form='unformatted',access='stream',convert='big_endian')
	
	!call ReadYSliceAlpha(yindex)
	!call ReadVarVsX_alpha(yindex,zindex)
	!call ReadVarVsX_U(yindex,zindex)
	!call ReadVarVsY_U(xindex,zindex)
	!call ReadYSlice_U(yindex)

	close(10)

end subroutine ReadBinaryVTK

subroutine SkipData

use ModReadBinaryVTK
implicit none


	i=0
	call ReadHeader
	readstart_grid=readstart

	call ReadPoints
	call ReadCells
	!call ReadCellData_p_and_p_rgh
	call ReadHeader
	readstart_alpha_cell=readstart
	call ReadCellData_alpha
	call ReadCellData_U
	!call ReadPointData_p_and_p_rgh

	
	call ReadHeader
	readstart_alpha=readstart		
	call ReadPointData_alpha

	call ReadHeader
	readstart_U=readstart
	call ReadPointData_U


end subroutine SkipData

subroutine ReadGrid

use ModReadBinaryVTK
implicit none

integer :: slicenum,indx


	do ii=1,nx+1
		call CalculateSingleIndex(ii,1,1,indx)
		read(10,pos=readstart_grid+(indx-1)*12)xval(ii)	
	enddo

	do jj=1,ny+1
		call CalculateSingleIndex(1,jj,1,indx)
		read(10,pos=readstart_grid+(indx-1)*12+4)yval(jj)
	enddo

	do kk=1,nz+1
		call CalculateSingleIndex(1,1,kk,indx)
		read(10,pos=readstart_grid+(indx-1)*12+8)zval(kk)
	enddo


end subroutine ReadGrid

subroutine ReadYSliceAlpha(filename,yindex)

use ModReadBinaryVTK
implicit none

integer :: yindex,indx
character(len=200) :: filename

	open(unit=10,file=filename,form='unformatted',access='stream',convert='big_endian')

	do kk=1,nz+1
           do ii=1,nx+1
                call CalculateSingleIndex(ii,yindex,kk,indx)
                read(10,pos=readstart_alpha+(indx-1)*4)YSliceAlpha(ii,kk)
		!print*,alphaslice(ii,kk)
           enddo
        enddo

	close(10)
end subroutine ReadYSliceAlpha


subroutine ReadXSliceAlpha(filename,xindex)

use ModReadBinaryVTK
implicit none

integer :: xindex,indx
character(len=200) :: filename

        open(unit=10,file=filename,form='unformatted',access='stream',convert='big_endian')

        do kk=1,nz
           do jj=1,ny
                call CalculateSingleIndexCell(xindex,jj,kk,indx)
                read(10,pos=readstart_alpha_cell+(indx-1)*4)XSliceAlpha(jj,kk)
                !print*,alphaslice(ii,kk)
           enddo
        enddo

        close(10)
end subroutine ReadXSliceAlpha

subroutine ReadAlpha3D(filename,xindex)

use ModReadBinaryVTK
implicit none

integer :: xindex,indx
character(len=200) :: filename

        open(unit=10,file=filename,form='unformatted',access='stream',convert='big_endian')

        do kk=1,nz
           do jj=1,ny
	      do ii=1,nx
                call CalculateSingleIndexCell(ii,jj,kk,indx)
                read(10,pos=readstart_alpha_cell+(indx-1)*4)Alpha3D(ii,jj,kk)
                !print*,alphaslice(ii,kk)
	      enddo
           enddo
        enddo

        close(10)
end subroutine ReadAlpha3D


subroutine ReadYSliceU(slicenum)

use ModReadBinaryVTK
implicit none

integer :: slicenum,indx

	do kk=1,nz+1
           do ii=1,nx+1
                call CalculateSingleIndex(ii,slicenum,kk,indx)
                read(10,pos=readstart_U+(indx-1)*12)YSliceU(ii,kk)
           enddo
        enddo

	!print*,alphaslice(133,5)	

end subroutine ReadYSliceU

subroutine ReadUAtPoint(filename,xindex,yindex,zindex)

use ModReadBinaryVTK
implicit none

integer :: xindex,yindex,zindex,indx
character(len=200) :: filename

	open(unit=10,file=filename,form='unformatted',access='stream',convert='big_endian')

	call CalculateSingleIndex(xindex,yindex,zindex,indx)
	read(10,pos=readstart_U+(indx-1)*12)uval
	read(10,pos=readstart_U+(indx-1)*12+4)vval
	read(10,pos=readstart_U+(indx-1)*12+8)wval

	close(10)
	
end subroutine ReadUAtPoint


subroutine ReadVarVsX_alpha(yindex,zindex)

use ModReadBinaryVTK
implicit none

integer :: yindex,zindex,indx

	do ii=1,nx+1
                call CalculateSingleIndex(ii,yindex,zindex,indx)
                read(10,pos=readstart_alpha+(indx-1)*4)alphaVsX(ii)
		!print*,alphaslice(ii,kk)
        enddo
	!print*,alphaslice(133,5)	

end subroutine ReadVarVsX_alpha

subroutine ReadVarVsX_U(yindex,zindex)

use ModReadBinaryVTK
implicit none

integer :: yindex,zindex,indx

           do ii=1,nx+1
                call CalculateSingleIndex(ii,yindex,zindex,indx)
                read(10,pos=readstart_U+(indx-1)*12)UVsX(ii)
           enddo


end subroutine ReadVarVsX_U


subroutine ReadVarVsY_U(xindex,zindex)

use ModReadBinaryVTK
implicit none

integer :: xindex,zindex,indx

           do jj=1,ny+1
                call CalculateSingleIndex(xindex,jj,zindex,indx)
                read(10,pos=readstart_U+(indx-1)*12)UVsY(jj)
           enddo


end subroutine ReadVarVsY_U


subroutine ReadVolume_alpha

use ModReadBinaryVTK
implicit none

integer :: indx

	open(unit=20,file='VoxelDataJICF.bvox',form='unformatted',access='stream')
        write(20)nx+1,ny+1,nz+1,1
        !write(20)408,55,150,1
        !write(20)200,100,130,1

	!do kk=1,62!nz+1
 	  !do jj=27,81!1,ny+1
            !do ii=93,173!1,nx+1
	 do kk=1,nz+1
 	    do jj=1,ny+1!27+54
              do ii=1,nx+1!93+407
                 call CalculateSingleIndex(ii,jj,kk,indx)
                 read(10,pos=readstart_alpha+(indx-1)*4)val
		 !print*,val
		 write(20)val
	    enddo
           enddo
        enddo
	
	close(20)

end subroutine ReadVolume_alpha

subroutine CalculateSingleIndex(iindx,jindx,kindx,singleindex)

use ModReadBinaryVTK
implicit none
integer(kind=4) :: iindx,jindx,kindx,singleindex

	!singleindex=(kindx-1)*(nx+1)*(ny+1)+(ny+1-jindx+1-1)*(nx+1)+nx+1-iindx+1
	singleindex=(kindx-1)*(nx+1)*(ny+1)+(jindx-1)*(nx+1)+iindx

end subroutine CalculateSingleIndex

subroutine CalculateSingleIndexCell(iindx,jindx,kindx,singleindex)

use ModReadBinaryVTK
implicit none
integer(kind=4) :: iindx,jindx,kindx,singleindex

	singleindex=(kindx-1)*nx*ny+(jindx-1)*nx+iindx

end subroutine CalculateSingleIndexCell



subroutine ReadPoints

use ModReadBinaryVTK
implicit none
	
	do i=readstart,readstart+12*10-4,4
		!read(10,pos=i)val
		!print*,val
	enddo

	!stop
	
	print*,"points done"

end subroutine ReadPoints

subroutine ReadCells

use ModReadBinaryVTK
implicit none
	
	!CELLS
	strlength=0
	strlength=len('CELLS')
	write(strdummy,*)ncells
	strlength=strlength+len(trim(adjustl(strdummy)))
	write(strdummy,*)ncells*9
	strlength=strlength+len(trim(adjustl(strdummy)))
	strlength=strlength+2

	readstart=readstart+12*npoints+strlength+2

	do i=readstart,readstart+ncells*9*4-4,4
	!read(10,pos=i)dummyint
	!print*,dummyint
	enddo

	print*,"cells done"

	!CELL_TYPES
	strlength=0
	strlength=len('CELL_TYPES')
	write(strdummy,*)ncells
	strlength=strlength+len(trim(adjustl(strdummy)))
	strlength=strlength+1

	readstart=readstart+ncells*9*4+strlength+2

	do i=readstart,readstart+ncells*4-4,4
	!read(10,pos=i)dummyint
	!print*,dummyint
	enddo

	print*,"cell_types done"

	!CELL_DATA
	readstart=i+4
	allocate(character(len=3) :: str)
	do i=readstart,readstart+200
                read(10,pos=i)str
		print*, str
                if(str.eq.'int')exit
        enddo
	print*,i,readstart,str
	deallocate(str)

	!cell ids	
	readstart=i+4
	do i=readstart,readstart+ncells*4-4,4
	!read(10,pos=i)dummyint
	!print*,dummyint
	enddo

end subroutine ReadCells

subroutine ReadCellData_p_and_p_rgh

use ModReadBinaryVTK
implicit none

	! Start reading data

	!p
	call ReadHeader

        do i=readstart,readstart+ncells*4-4,4
        !read(10,pos=i)val
        enddo

	!p_rgh

	call ReadHeader

        do i=readstart,readstart+ncells*4-4,4
        !read(10,pos=i)val
        enddo

	
end subroutine ReadCellData_p_and_p_rgh


subroutine ReadCellData_alpha

use ModReadBinaryVTK
implicit none

	
        do i=readstart,readstart+ncells*4-4,4
        !read(10,pos=i)val
        enddo

end subroutine ReadCellData_alpha

subroutine ReadCellData_U

use ModReadBinaryVTK
implicit none

	!U
        call ReadHeader
	
        do i=readstart,readstart+ncells*4*3-4,4
        !read(10,pos=i)val
	!print*,val
        enddo

end subroutine ReadCellData_U


!POINT DATA

subroutine ReadPointData_p_and_p_rgh

use ModReadBinaryVTK
implicit none

	call ReadHeader   	
	
        do i=readstart,readstart+npoints*4-4,4
        !read(10,pos=i)val
        !print*,val
        enddo

	! p_rgh

	call ReadHeader

        do i=readstart,readstart+npoints*4-4,4
        !read(10,pos=i)val
        !print*,val
        enddo

	! alpha.water
	readstart=i+4

end subroutine ReadPointData_p_and_p_rgh

subroutine ReadPointData_alpha

use ModReadBinaryVTK
implicit none

        do i=readstart,readstart+npoints*4-4,4
        !read(10,pos=i)val
        !print*,val
        enddo

end subroutine ReadPointData_alpha


subroutine ReadPointData_U

use ModReadBinaryVTK
implicit none

        do i=readstart,readstart+npoints*4*3-4,4
        !read(10,pos=i)val
        !print*,val
        enddo

	read(10,pos=readstart+npoints*4*3-12)val
	print*,val

end subroutine ReadPointData_U


subroutine ReadHeader

use ModReadBinaryVTK
implicit none

        readstart=i+4
        allocate(character(len=5) :: str)
        do i=readstart,readstart+100
                read(10,pos=i)str
                if(str.eq.'float')exit
        enddo
        print*,readstart,i,str
        !stop
        deallocate(str)

        readstart=i+6

end subroutine ReadHeader

