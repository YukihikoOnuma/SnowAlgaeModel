# Makefile for SnowAlgaeModel v1.0
# Apr.24 2022 Yukihiko Onuma

#----------------- select compiler and compile mode -----------------
# --> ifort
FC=ifort
# ----> debug & profileer check with ver12.0
#FCFLAGS = -WB -traceback -g -debug all -pg
# ----> debug new formula from ifort ver11.0 and ver12.0
FCFLAGS = -WB -traceback -g -debug all
# ----> debug old formula for till ifort ver10.0
#FCFLAGS = -CB -traceback -g -check all
# ----> optimize
#FCFLAGS = -fast
# ----> normal
#FCFLAGS=
#--------------------------------------------------------------------
# --> gfortran
#FC=gfortran
# ----> normal
#FCFLAGS = -Wall 
#--------------------------------------------------------------------

OBJS=SnowAlgae_Global.o SnowAlgae_Read_nml.o \
     Input_csv.o \
     SnowAlgae_Growth.o \
     Output_csv.o \
     SnowAlgae.o

.SUFFIXES: .f90 .o

# -c .f90 -> .o
# -o set .o file name
# $< .f90 file / $@ .o file
.f90.o: 
	$(FC) $(FCFLAGS) -c $< -o $@

make_exe: $(OBJS)
	$(FC) $(OBJS) $(FCFLAGS) -o snowalgae.bin
#	@rm -f *.o *.f90 *.mod Makefile_* print_source.sh

