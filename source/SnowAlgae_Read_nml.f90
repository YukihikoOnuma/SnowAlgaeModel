!----------------------------------------------------------------------------
! MODULE NAME:
!       SnowAlgae_Read_nml
!
!----------------------------------------------------------------------------
! PURPOSE:
!       interface of namelist used in Snow Algae Model.
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
!       - SnowAlgae_Read_nml__fpath:
!            reading file path.
!
!       - SnowAlgae_Read_nml__bio:
!            reading algal parameter.
!
!       ---------------------------------------------------------------------
!       [PRIVATE]
!
!----------------------------------------------------------------------------
! CREATION HISTORY:
! 
!       Written by:     Yukihiko Onuma (IIS,UTokyo), 24-Apr-2022
!                                       onuma@iis.u-tokyo.ac.jp
!
!----------------------------------------------------------------------------
! Copyright (C) 2022 Yukihiko Onuma
!
!----------------------------------------------------------------------------
module SnowAlgae_Read_nml
  implicit none

  public :: SnowAlgae_Read_nml__fpath, &
       & SnowAlgae_Read_nml__mpara

  ! file path & name
  character(len=200) :: fname, infile, outfile

  ! time
  integer, save :: delt_t, dtype, cal_step

  ! snow & bio parameter
  real(8), save :: inalg_s    ! initial cell conc. [cells m-2]
  real(8), save :: gralg_s    ! algal growth rate [hour-1]
  real(8), save :: capalg_s   ! carrying capacity of algae [cells m-2]
  real(8), save :: volalg_s   ! cell volume (S. nivalodes) [mL cell-1]
  real(8), save :: abstmp    ! absolute temperature [K]

contains
  !--------------------------------------------------------------------------
  subroutine SnowAlgae_Read_nml__fpath()
    implicit none

    namelist /FPATH/ fname, infile, outfile
    
    open(26, file='file_path.nml', form='FORMATTED')
    read(26, nml=FPATH)
    close(26)
    
  end subroutine SnowAlgae_Read_nml__fpath
  
  !--------------------------------------------------------------------------
  subroutine SnowAlgae_Read_nml__mpara()
    implicit none

    namelist /MPARA/ delt_t, dtype, cal_step, &
         & inalg_s, gralg_s, capalg_s, volalg_s, &
         & abstmp
    
    open(27, file='model_param.nml', form='FORMATTED')
    read(27, nml=MPARA)
    close(27)
    
  end subroutine SnowAlgae_Read_nml__mpara
  
end module SnowAlgae_Read_nml
