!----------------------------------------------------------------------------
! PRPGRAM NAME:
!       SnowAlgae
!
!----------------------------------------------------------------------------
! PURPOSE:
!       Snow Algae Model main program.
!
!----------------------------------------------------------------------------
! CATEGORY:
!       SnowAlgae
!
!----------------------------------------------------------------------------
! LANGUAGE:
!       fortran 90
!
!----------------------------------------------------------------------------
! CONTAINS:
!       ---------------------------------------------------------------------
!       [PUBLIC]
!
!       ---------------------------------------------------------------------
!       [PRIVATE]
!
!----------------------------------------------------------------------------
! CREATION HISTORY:
!
!       Written by:  Yukihiko Onuma
!       Institute of Industrial Science, the University of Tokyo
!                                        onuma@iis.u-tokyo.ac.jp
!       Last revised on Jan. 24, 2022
!
!----------------------------------------------------------------------------
! Copyright (C) 2022- Yukihiko Onuma
!
!----------------------------------------------------------------------------
!
program SnowAlgae
  use SnowAlgae_Global
  use SnowAlgae_Read_nml
  use Input_csv
  use SnowAlgae_Growth
  use Output_csv

  implicit none

  ! general
  integer :: i
  integer :: ios
  character(len=100) :: ofpath1, ofpath2, ofpath3, ofpath4

  ! time
  integer :: step

  ! output

  !==========================================================================
  !>>> program start !   

  ! set log file
  open(16, iostat=ios, &
       & file = 'log.txt', status = 'replace', form = 'formatted')
  if (ios /= 0) then
     write(*,*) 'Could not create a file : log.txt'
     stop
  end if
                    
  write(16,*) '============================================'
  write(16,*) '*'
  write(16,*) '* Welcome to'
  write(16,*) '*'
  write(16,*) '* Snow Algae Model'
  write(16,*) '* SnowAlgae.v1'
  write(16,*) '*'
  write(16,*) '* copyright: Yukihiko Onuma, 2022'
  write(16,*) '*'
  write(16,*) '============================================'
  write(16,*) '                                            '

  !=====================
  !>>> 1. read namelist
  !=====================
  write(16,*) '============================================'
  write(16,*) '1. read namelist'                         
  call SnowAlgae_Read_nml__fpath()  ! it is in SnowAlgae_Read_nml.f90
  call SnowAlgae_Read_nml__mpara()   ! it is in SnowAlgae_Read_nml.f90
  write(16,*) 'input file path = ', trim(infile)                        
  write(16,*) 'output file path (snow) = ', trim(outfile)                        
  write(16,*) '=== algal paramater ==='
  write(16,*) 'initial cell conc. of snow algae', inalg_s                       
  write(16,*) 'growth rate of snow algae', gralg_s                       
  write(16,*) 'carrying capacity of snow algae', capalg_s                       
  write(16,*) 'cell volume of snow algae', volalg_s                 
  write(16,*) '======================='

  !=====================
  !>>> 2. set time
  !=====================
  write(16,*) '============================================'
  write(16,*) '2. read forcing data'                  
  call Input_csv__ini()
  write(16,*) 'total time step = ', ttime

  !=======================
  !>>> 3. set output file
  !=======================
  write(16,*) '============================================'
  write(16,*) '3. set output file'    

  ! 1dim data (snow)
  ofpath1 = trim(outfile) // '/' // trim(fname) // '_o_mal.csv'
  open(36, iostat=ios, &
       & file = ofpath1, status = 'replace', form = 'formatted')
  if (ios /= 0) then
     write(16,*) 'Could noe create a file : ', ofpath1
     stop
  end if
  ofpath2 = trim(outfile) // '/' // trim(fname) // '_o_xm.csv'
  open(46, iostat=ios, &
       & file = ofpath2, status = 'replace', form = 'formatted')
  if (ios /= 0) then
     write(16,*) 'Could noe create a file : ', ofpath2
     stop
  end if
  ofpath3 = trim(outfile) // '/' // trim(fname) // '_o_xmd.csv'
  open(56, iostat=ios, &
       & file = ofpath3, status = 'replace', form = 'formatted')
  if (ios /= 0) then
     write(16,*) 'Could noe create a file : ', ofpath3
     stop
  end if
  ofpath4 = trim(outfile) // '/' // trim(fname) // '_o_xmdf.csv'
  open(66, iostat=ios, &
       & file = ofpath4, status = 'replace', form = 'formatted')
  if (ios /= 0) then
     write(16,*) 'Could noe create a file : ', ofpath4
     stop
  end if


  call Output_csv__ini()
  call Output_csv__header()

  !========================
  !>>> 4. time integration
  !========================
  write(16,*) '============================================'
  write(16,*) '4. time integration start'  

  !i1 = 1
  !*************
  do i = 1, ttime
     !=========================
     !>>> 5. get forcing data
     !=========================
     step = i
     write(16,*) '-------------------------------------------'
     ! write(16,*) '--- reading meteorological & snow physical forcing ---'
     call Input_csv__main(step) ! in
     write(16,*) 'start step = ', step
     write(16,*) 'time = ', date

     !====================================================
     !>>> 6.1. algal abundance calculation (snow)
     !====================================================
     write(16,*) '============================================'
     write(16,*) '6.1 algal abundance calculation (snow)'
     call SnowAlgae_Growth__MAL(swe, sst, &
          & gp_mal, cellA_mal, bioA_mal, cellV_mal, bioV_mal, ocV_mal)
     call SnowAlgae_Growth__XM(swe, sst, &
          & gp_xm, cellA_xm, bioA_xm, cellV_xm, bioV_xm, ocV_xm)
     call SnowAlgae_Growth__XMD(swe, sst, swdown, &
          & gp_xmd, cellA_xmd, bioA_xmd, cellV_xmd, bioV_xmd, ocV_xmd)
     call SnowAlgae_Growth__XMDF(swe, sst, swdown, snfall, &
          & gp_xmdf, cellA_xmdf, bioA_xmdf, cellV_xmdf, bioV_xmdf, ocV_xmdf)
   
     !=========================================
     ! >>> X.1. albedo calculation (snow, in future)
     !=========================================

     !==========================================
     !>>> 7. write model results in csv file
     !==========================================
     write(16,*) '============================================'
     write(16,*) '7. wirte output data' 
     call Output_csv__write(step, 'mal ', &
          & gp_mal, cellA_mal, bioA_mal, cellV_mal, bioV_mal, ocV_mal)
     call Output_csv__write(step, 'xm  ', &
          & gp_xm, cellA_xm, bioA_xm, cellV_xm, bioV_xm, ocV_xm)
     call Output_csv__write(step, 'xmd ', &
          & gp_xmd, cellA_xmd, bioA_xmd, cellV_xmd, bioV_xmd, ocV_xmd)
     call Output_csv__write(step, 'xmdf', &
          & gp_xmdf, cellA_xmdf, bioA_xmdf, cellV_xmdf, bioV_xmdf, ocV_xmdf)

     write(16,*) 'end step = ', step
     write(16,*) 'time = ', date

  end do

  close(36)  ! output csv file (mal)
  close(46)  ! output csv file (xm)
  close(56)  ! output csv file (xmd)
  close(66)  ! output csv file (xmdf)

  !============================
  !>>> 8. end of all processes
  !============================
  write(16,*) '============================================'
  write(16,*) '*. nomal end, thank you for waiting.'
  write(16,*) 'check log.txt, and ./ directory.'

  close(16)  ! log file

end program SnowAlgae
