!----------------------------------------------------------------------------
! PRPGRAM NAME:
!       SnowAlgae
!
!----------------------------------------------------------------------------
! PURPOSE:
!       Snow Algae Model      
!       main program.
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
  character(len=100) :: ofpath

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
  ofpath = trim(outfile) // '/' // trim(fname) // '_o.csv'
  open(36, iostat=ios, &
       & file = ofpath, status = 'replace', form = 'formatted')
  if (ios /= 0) then
     write(16,*) 'Could noe create a file : ', ofpath
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
     call SnowAlgae_Growth__mal(swe, sst, &
          & grtime_mal, cell_mal, biomass_mal)
     call SnowAlgae_Growth__XM(swe, sst, &
          & grtime_XM, cell_XM, biomass_XM)
     call SnowAlgae_Growth__XMD(swe, sst, swdown, &
          & grtime_XMD, cell_XMD, biomass_XMD) 
     call SnowAlgae_Growth__XMDF(swe, sst, swdown, snfall, &
          & grtime_XMDF, cell_XMDF, biomass_XMDF)
   
     !=========================================
     ! >>> X.1. albedo calculation (snow, in future)
     !=========================================

     !==========================================
     !>>> 7. write model results in csv file
     !==========================================
     write(16,*) '============================================'
     write(16,*) '7. wirte output data' 
     call Output_csv__write(step)

     write(16,*) 'end step = ', step
     write(16,*) 'time = ', date

  end do

  close(36)  ! output csv file (snow)

  !============================
  !>>> 8. end of all processes
  !============================
  write(16,*) '============================================'
  write(16,*) '*. nomal end, thank you for waiting.'
  write(16,*) 'check log.txt, and ./ directory.'

  close(16)  ! log file

end program SnowAlgae
