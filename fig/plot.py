#!/usr/bin/env python2.7
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os
import sys

#======================================
#========== set param
figSave = 'on'

doy_min, doy_max = 0,365	

#======================================
#========== data list
fileName = 'snowalgae_2012_TA_Rai_wfdei' 
fileName = 'snowalgae_1998_Philistine_wfdei'

"""
fileName = 'snowalgae_1998_Philistine_wfdei'
fileName = 'snowalgae_1999_Tyndall_wfdei'
fileName = 'snowalgae_2000_Harding_wfdei'
fileName = 'snowalgae_2000_TigoaPass_wfdei'
fileName = 'snowalgae_2001_Gulkana_wfdei'
fileName = 'snowalgae_2002_Akkem_wfdei'
fileName = 'snowalgae_2004_Werenskioldbreen_wfdei'
fileName = 'snowalgae_2008_Tiefenbach_wfdei'
fileName = 'snowalgae_2012_Mittivakkat_wfdei'
fileName = 'snowalgae_2012_No.33_wfdei'
fileName = 'snowalgae_2012_TA_Rai_wfdei'
fileName = 'snowalgae_2013_Feiringbreen_wfdei'
fileName = 'snowalgae_2013_UM_No1_wfdei'
fileName = 'snowalgae_2014_QA_SB_wfdei'
fileName = 'snowalgae_2015_Livingston_wfdei'
"""

#======================================
#========== main
def main():
	#===== set path
	indir = '../output'
	outdir = '.'

	#===== read csv data
	print'### read model data (csv) ###'
	d1,doy = rd_csv(indir,fileName,'mal')
	d2,doy = rd_csv(indir,fileName,'xm')
	d3,doy = rd_csv(indir,fileName,'xmd')
	d4,doy = rd_csv(indir,fileName,'xmdf')

	#=== plot figure
	plot(outdir,d1,d2,d3,d4,doy,'gp')
	plot(outdir,d1,d2,d3,d4,doy,'cellA')
	plot(outdir,d1,d2,d3,d4,doy,'bioA')
	plot(outdir,d1,d2,d3,d4,doy,'cellV')
	plot(outdir,d1,d2,d3,d4,doy,'bioV')
	plot(outdir,d1,d2,d3,d4,doy,'ocV')

#======================================
#===== set path & read model data
def rd_csv(indir,fileName,model):
	import datetime
	global ymd

	Tab_list = ['ymd','time','gp','cellA','bioA','cellV','bioV','ocV']

	infile = '%s/%s_o_%s.csv'%(indir,fileName,model)

	if os.path.exists(infile):
		df = pd.read_csv(infile,encoding='UTF-8')
	else:
		print "%s does not exist"%infile 
		d_all,doy = -999,-999
		return d_all,doy

	#=== read csv data
	ymd = df[Tab_list[0]].values.tolist()
	Nt = len(ymd) - 1

	d_all = np.zeros((len(Tab_list),Nt))
	print d_all.shape

	for i in range(len(Tab_list)):
		#print Tab_list[i]
		tmp = df[Tab_list[i]].values.tolist()
		d_all[i,:] = tmp[1::]


	#=== unicode -> float
	for i in range(2,len(Tab_list)-2):
		for t in range(Nt):
			d_all[i+2,t] = float(d_all[i+2,t])

	ymd = str(d_all[0,0])[0:8]

	#=== date -> doy
	doy = []
	for i in range(Nt):
		tmp = datetime.datetime.strptime(str(d_all[0,i])[0:8],'%Y%m%d')
		doy.append((tmp - datetime.datetime(int(ymd[0:4]),1,1,12)).days + 1)  # cal doy


	return d_all,doy

#======================================
#===== plot figure
def plot(outdir,d1,d2,d3,d4,doy,Var):

	#=== set plot param
	fig, axes = plt.subplots(1, 1, figsize=(12,8))

	C1 = "black"
	C2 = "orangered"
	C3 = "lime"
	C4 = "dodgerblue"

	label1 = 'mal (Snow melt, no limitation)'
	label2 = 'XM (Snow melt)'
	label3 = 'XMD (Snow melt + Daylight length)'
	label4 = 'XMDF (Snow melt + Daylight length + Snowfall)'

	#=== plot model result
	if Var == 'gp':
		y_min, y_max = 0, 4000
		var_idx = 2
	elif Var == 'cellA':
		y_min, y_max = 1e0, 1e11 	
		var_idx = 3
	elif Var == 'bioA':
		y_min, y_max = 5e-6, 5e5 	
		var_idx = 4
	elif Var == 'cellV':
		y_min, y_max = 1e-1, 1e10 	
		var_idx = 5
	elif Var == 'bioV':
		y_min, y_max = 5e-7, 5e4 	
		var_idx = 6
	elif Var == 'ocV':
		y_min, y_max = 1e-2, 1e4 	
		var_idx = 7

	#== set axis
	axes.set_xlim(xmin=doy_min)
	axes.set_xlim(xmax=doy_max)
	xlabels = np.arange(doy_min+10,doy_max+1,30)
	axes.set_xticks(xlabels)
	axes.set_xlabel('Day of the Year (%s)'%ymd[0:4],fontsize=10)

	if not Var == 'gp': 
		d1[np.where(d1==0)] = np.nan
		d2[np.where(d2==0)] = np.nan
		d3[np.where(d3==0)] = np.nan
		d4[np.where(d4==0)] = np.nan

	if Var == 'gp':
		axes.set_ylabel('Growth period\n(hours)',fontsize=11)
	elif Var == 'cellA':
		axes.set_ylabel('Algal cell concentration\n(cells $\mathregular{m^{-2}}$)',fontsize=11)
		axes.set_yscale("log")
		axes.axhline(y=5.0e5,color='grey',ls='--') # Red snow appearance
	elif Var == 'bioA':
		axes.set_ylabel('Algal cell biomass\n(uL $\mathregular{m^{-2}}$)',fontsize=11)
		axes.set_yscale("log")
		axes.axhline(y=2.5,color='grey',ls='--') # Red snow appearance
	elif Var == 'cellV':
		axes.set_ylabel('Algal cell concentration\n(cells $\mathregular{L^{-1}}$)',fontsize=11)
		axes.set_yscale("log")
		axes.axhline(y=5.0e4,color='grey',ls='--') # Red snow appearance
	elif Var == 'bioV':
		axes.set_ylabel('Algal cell biomass\n(uL $\mathregular{L^{-1}}$)',fontsize=11)
		axes.set_yscale("log")
		axes.axhline(y=0.25,color='grey',ls='--') # Red snow appearance
	elif Var == 'ocV':
		axes.set_ylabel('Organic carbon\n(mg $\mathregular{L^{-1}}$)',fontsize=11)
		axes.set_yscale("log")

	axes.plot(doy[::24],d1[var_idx,::24],color=C1,linestyle='-',lw=2,label=label1)
	axes.plot(doy[::24],d2[var_idx,::24],color=C2,linestyle='-',lw=2,label=label2)
	axes.plot(doy[::24],d3[var_idx,::24],color=C3,linestyle='-',lw=2,label=label3)
	axes.plot(doy[::24],d4[var_idx,::24],color=C4,linestyle='-',lw=2,label=label4)
	
#===
	axes.set_ylim(ymin=y_min)
	axes.set_ylim(ymax=y_max)
	axes.set_title(fileName,fontsize=15)

	plt.legend(loc='lower center', bbox_to_anchor=(0.475,-0.15),ncol=4,fontsize=9)

	figN = '%s_%s'%(Var,fileName)

	if figSave == 'on':
		if os.path.isdir('%s'%outdir) == False:
			os.makedirs('%s'%outdir)	
		plt.savefig('%s/%s.png'%(outdir,figN),bbox_inches="tight")
		print 'save %s/%s.png'%(outdir,figN)
	else:
		print '%s/%s.png'%(outdir,figN)
		plt.show()
	plt.close()

#======================================

if __name__=='__main__':
    main()	
	
__author__ = 'Yukihiko Onuma <yonuma613@gmail.com>'
__version__ = '1.1.0'
__date__ = 'Jan. 2022'
