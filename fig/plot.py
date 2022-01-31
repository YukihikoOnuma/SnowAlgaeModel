#!/usr/bin/env python2.7
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os
import sys

#======================================
#========== set param
figSave = 'on'
doy_min, doy_max = 0,365	# north hemisphere

#======================================
#========== data list
fileName = 'snowalgae_2015_Livingston_wfdei_o'

"""
fileName = 'snowalgae_2012_TA_Rai_wfdei_o' 
fileName = 'snowalgae_1998_Philistine_wfdei_o'
fileName = 'snowalgae_1999_Tyndall_wfdei_o'
fileName = 'snowalgae_2000_Harding_wfdei_o'
fileName = 'snowalgae_2000_TigoaPass_wfdei_o'
fileName = 'snowalgae_2001_Gulkana_wfdei_o'
fileName = 'snowalgae_2002_Akkem_wfdei_o'
fileName = 'snowalgae_2004_Werenskioldbreen_wfdei_o'
fileName = 'snowalgae_2008_Tiefenbach_wfdei_o'
fileName = 'snowalgae_2012_Mittivakkat_wfdei_o'
fileName = 'snowalgae_2012_No.33_wfdei_o'
fileName = 'snowalgae_2012_TA_Rai_wfdei_o'
fileName = 'snowalgae_2013_Feiringbreen_wfdei_o'
fileName = 'snowalgae_2013_UM_No1_wfdei_o'
fileName = 'snowalgae_2014_QA_SB_wfdei_o'
fileName = 'snowalgae_2015_Livingston_wfdei_o'
"""

#======================================
#========== main
def main():
	#===== set path
	indir = '../output'
	outdir = '.'

	#===== read csv data
	print'### read model data (csv) ###'
	d_all,doy = rd_csv(indir,fileName)

	#=== plot figure
	#=== figure (acc)
	plot(outdir,d_all,doy,"cl")

#======================================
#===== set path & read model data
def rd_csv(indir,fileName):
	import datetime
	global ymd

	Tab_list = ['ymd','time','gt-mal[hour-1]','cl-mal[cells*m-2]','bio-mal[uL*m-2]','gt-XM[hour-1]','cl-XM[cells*m-2]','bio-XM[uL*m-2]','gt-XMD[hour-1]','cl-XMD[cells*m-2]','bio-XMD[uL*m-2]','gt-XMDF[hour-1]','cl-XMDF[cells*m-2]','bio-XMDF[uL*m-2]']

	infile = '%s/%s.csv'%(indir,fileName)

	if os.path.exists(infile):
		df = pd.read_csv(infile,encoding='UTF-8')
	else:
		print "%s does not exist"%infile 
		doy,mlt2,mlt3,mlt4 = -999,-999,-999,-999
		return doy,mlt2,mlt3,mlt4


	#=== read csv data
	ymd = df[Tab_list[0]].values.tolist()
	Nt = len(ymd)

	d_all = np.zeros((len(Tab_list),Nt))
	print d_all.shape

	for i in range(len(Tab_list)):
		d_all[i,:] = df[Tab_list[i]].values.tolist()

	d_all = d_all[:,1::]

	#=== unicode -> float
	for i in range(2,len(Tab_list)-2):
		for t in range(Nt-1):
			d_all[i+2,t] = float(d_all[i+2,t])

	ymd = str(d_all[0,0])[0:8]

	#=== date -> doy
	doy = []
	for i in range(Nt-1):
		tmp = datetime.datetime.strptime(str(d_all[0,i])[0:8],'%Y%m%d')
		doy.append((tmp - datetime.datetime(int(ymd[0:4]),1,1,12)).days + 1)  # cal doy

	d_all[np.where(d_all==0)] = np.nan

	return d_all,doy

#======================================
#===== plot figure
def plot(outdir,d_all,doy,Var):


	#=== set plot param
	fig, axes = plt.subplots(1, 1, figsize=(12,8))
	#plt.subplots_adjust(wspace=0.15,hspace=0.60) # adjust plot space

	C1 = "black"
	C2 = "orangered"
	C3 = "lime"
	C4 = "dodgerblue"

	#=== plot model result
	if Var == 'mlt':
		label1 = '$GP^{M}$ (Snow melt)'
		label2 = '$GP^{MD}$ (Snow melt + Daylight length)'
		label3 = '$GP^{MDF}$ (Snow melt + Daylight length + Snowfall)'
		y_min, y_max = 0, 3000
		txt_y = 1350
	elif Var == 'cl':
		label1 = 'mal (Snow melt)'
		label2 = '$X^{M}$ (Snow melt)'
		label3 = '$X^{MD}$ (Snow melt + Daylight length)'
		label4 = '$X^{MDF}$ (Snow melt + Daylight length + Snowfall)'
		y_min, y_max = 1e0, 1e11 	# log scale (X=694)
		tab_idx = [3,6,9,12]

	#== set axis
	axes.set_xlim(xmin=doy_min)
	axes.set_xlim(xmax=doy_max)
	xlabels = np.arange(doy_min+10,doy_max+1,30)
	axes.set_xticks(xlabels)
	axes.set_xlabel('Day of the Year (%s)'%ymd[0:4],fontsize=10)

	if Var == 'mlt':
		axes.set_ylabel('Growth period\n(hours)',fontsize=11)
	if Var == 'cl':
		axes.set_ylabel('Algal cell concentration\n(cells $\mathregular{m^{-2}}$)',fontsize=11)
		axes.set_yscale("log")
		axes.set_ylim(ymin=y_min)
		axes.set_ylim(ymax=y_max)
		axes.set_title(fileName,fontsize=15)
		axes.axhline(y=5.0e5,color='grey',ls='--')

	axes.plot(doy[::24],d_all[tab_idx[0],::24],color=C1,linestyle='-',lw=2,label=label1)
	axes.plot(doy[::24],d_all[tab_idx[1],::24],color=C2,linestyle='-',lw=2,label=label2)
	axes.plot(doy[::24],d_all[tab_idx[2],::24],color=C3,linestyle='-',lw=2,label=label3)
	axes.plot(doy[::24],d_all[tab_idx[3],::24],color=C4,linestyle='-',lw=2,label=label4)
	
#===

	plt.legend(loc='lower center', bbox_to_anchor=(0.5,-0.15),ncol=4,fontsize=9)

	if figSave == 'on':
		if os.path.isdir('%s'%outdir) == False:
			os.makedirs('%s'%outdir)	
		plt.savefig('%s/%s.png'%(outdir,fileName),bbox_inches="tight")
		print 'save %s/%s.png'%(outdir,fileName)
	else:
		print '%s/%s.png'%(outdir,fileName)
		plt.show()
	plt.close()

#======================================

if __name__=='__main__':
    main()	
	
__author__ = 'Yukihiko Onuma <yonuma613@gmail.com>'
__version__ = '1.2.0'
__date__ = 'Dec. 2021'
