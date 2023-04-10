#!/usr/local/bin/python
from numpy import *
import glob
import os

filenames=glob.glob('*.vtk')
nfiles=size(filenames)
time=zeros(nfiles)


for filenum in arange(0,nfiles,1):
	s = filenames[filenum]
	start = s.find('Final_') + 1
	end = s.find('.v', start)
	print s[start+5:end]
	time[filenum]=float(s[start+5:end])

sortindexlist=argsort(time)

filelist=open('filelistformovie.txt','w')
for filenum in arange(0,nfiles,1):

	filenamenew=filenames[sortindexlist[filenum]]
	end = filenamenew.find('.vtk', 0)
	filenamenew=filenamenew[0:end]
	filelist.write(filenamenew + '\n')

filelist.close()

