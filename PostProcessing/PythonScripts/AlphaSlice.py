#!/usr/local/bin/python
from numpy import *
from pylab import *
from matplotlib import rc, rcParams, axes
from PIL import Image, ImageDraw
import matplotlib.ticker as ticker

nx=500
nz=200

X=zeros([nz+1,nx+1])
Z=zeros([nz+1,nx+1])
alpha=zeros([nz+1,nx+1])

data=loadtxt('./RANSFiles/alphaslice.dat')
#data=loadtxt('./DNSFiles/alphaslice.dat')

for k in arange(0,nz+1,1):
	for i in arange(0,nx+1,1):
		dataindx=k*(nx+1)+i
		X[k,i]=data[dataindx,0]
		Z[k,i]=data[dataindx,1]
		alpha[k,i]=data[dataindx,2]
		if(alpha[k,i]>1.0):
			print k,i,alpha[k,i]

	
ax=contourf(X,Z,alpha,50,cmap=cm.binary,vmin=0.0,vmax=1.0)
#ax=contourf(X,Z,alpha,50,cmap=cm.jet)
#xlim([-5e-3,5e-3])
#ylim([0e-3,8e-3])
#axis('equal')
d=1.3e-3
q=6.6
We=330.0
#xlim([-d/2.0,10.0*d])
#ylim([0e-3,13.0*d])
#axis('tight')
xlim([-d,8.0*d])
ylim([0e-3,10.0*d])
axis('scaled')
xlim([-d,10.0*d])
ylim([0e-3,10.0*d])

#axis('tight')
#colorbar()

plt.clim(0,1)
#plt.colorbar(ax, fraction=0.046, pad=0.04)

# z/d=2.63*q**0.442*(x/d)**0.39*We**(-0.088)*(mu_l/mu_H20)**-0.027

xmin=0e-3
xmax=5e-3
zmin=0e-3
zmax=6e-3
npointspen=100
xpen=zeros(npointspen)
zpen1=zeros(npointspen)
zpen2=zeros(npointspen)
d=1.3e-3
q=6.6
We=330.0
delx=(xmax-xmin)/(npointspen-1)
for i in arange(0,npointspen,1):
	xpen[i]=xmin+i*delx
	zpen1[i]=d*2.63*q**0.442*(xpen[i]/d)**0.39*We**-0.088
	zpen2[i]=d*1.37*(q*xpen[i]/d)**0.5
	#zpen1[i]=d*2.45*q**0.50*(xpen[i]/d)**0.33*We**-0.061
	#zpen2[i]=d*1.5*q**0.47*(xpen[i]/d)**0.35

	
plot(xpen-d/2.0,zpen1,'r',linewidth=3.0,label='$z/d=2.63 q^{0.442}(x/d)^{0.39}We^{-0.088}$')
plot(xpen-d/2.0,zpen2,'k',linewidth=3.0,label='$z/d=1.37(qx/d)^{0.5}$')
#title('Comparison with correlations')
legend() 
#savefig('../ICLASS2018_JICF/Images/PenetrationCorrelationDNS.eps')
savefig('../ICLASS2018_JICF/Images/PenetrationCorrelationRANS.eps')
show()
