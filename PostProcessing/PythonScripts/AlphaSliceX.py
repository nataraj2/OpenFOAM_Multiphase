#!/usr/local/bin/python
from numpy import *
from pylab import *
from matplotlib import rc, rcParams, axes
#from PIL import Image, ImageDraw
#import matplotlib.ticker as ticker

plt.rcParams["font.weight"] = "bold"
plt.rcParams["axes.labelweight"] = "bold"
	
ny=135
nz=200
	
Y=zeros([nz,ny])
Z=zeros([nz,ny])
alpha=zeros([nz,ny])

nbins=15
	
def Computepdf(data,slicenum):
	
	for k in arange(0,nz,1):
		for j in arange(0,ny,1):
			dataindx=k*ny+j
			Y[k,j]=data[dataindx,0]
			Z[k,j]=data[dataindx,1]
			alpha[k,j]=data[dataindx,2]
	
	alpha_min=0.01
	alpha_max=alpha.max()
	del_alpha=(alpha_max-alpha_min)/nbins
	alphaminvec=zeros(nbins)
	alphamaxvec=zeros(nbins)
	
	for binnum in arange(0,nbins,1):
		alphaminvec[binnum]=alpha_min+binnum*del_alpha
		alphamaxvec[binnum]=alpha_min+(binnum+1)*del_alpha
		#print alphaminvec[binnum],alphamaxvec[binnum]
	
	nalpha=0
	
	for k in arange(0,nz,1):
	        for j in arange(0,ny,1):
			if alpha[k,j]>=alpha_min and alpha[k,j]<=1:
				nalpha=nalpha+1
	
	nbinvec=zeros(nbins)
	for binnum in arange(0,nbins,1):
		for k in arange(0,nz,1):
	        	for j in arange(0,ny,1):
				if alpha[k,j]>=alphaminvec[binnum] and alpha[k,j]<=alphamaxvec[binnum]:
					nbinvec[binnum]=nbinvec[binnum]+1
		nbinvec[binnum]=nbinvec[binnum]/nalpha
	
		#ax=contourf(Y,Z,alpha,50,cmap=cm.jet)
	#axis('equal')
	#plt.colorbar()	
	return alphaminvec,alphamaxvec,nbinvec,del_alpha
	
vec1=zeros(nbins)
vec2=zeros(nbins)
vec3=zeros(nbins)

for slicenum in arange(1,4,1):	
	data=loadtxt('./DNSFiles/alphaslicetimeavgX%d.dat'%slicenum)
	[vec1,vec2,vec3,deltaalpha]=Computepdf(data,slicenum)

	figure(slicenum)
	plot((vec1+vec2)/2.0,vec3/deltaalpha,'-ok',label='DNS')

	data=loadtxt('./RANSFiles/alphaslicetimeavgX%d.dat'%slicenum)
	[vec1,vec2,vec3,deltaalpha]=Computepdf(data,slicenum)

	figure(slicenum)
	plot((vec1+vec2)/2.0,vec3/deltaalpha,'-or',label='RANS')

	legend()

	xlabel(r'$\alpha$',fontsize=20)
	ylabel(r'$f(\alpha)$',fontsize=20)
	#show()
        savefig('../ICLASS2018_JICF/Images/Alphapdf%d.eps'%slicenum)
	#clf()	
show()
