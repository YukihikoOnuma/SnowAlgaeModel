!----------------------------------------------------------------------------
! MODULE NAME:
!       SnowAlgae_Global
!
!----------------------------------------------------------------------------
! PURPOSE:
!       Global variables of 
!       Snow Algae Model.
!       this module was made according to SMAP.v4.12a (Niwano et al., 2012)
!
!----------------------------------------------------------------------------
! CATEGORY:
!       Snow Algae
!
!----------------------------------------------------------------------------
! LANGUAGE:
!       fortran 90
!
!----------------------------------------------------------------------------
! CONTAINS:
!       ---------------------------------------------------------------------
!       [PUBLIC]
!       All variables are public.
!
!       ---------------------------------------------------------------------
!       [PRIVATE]
!
!----------------------------------------------------------------------------
! CREATION HISTORY:
!
!       Written by:     Yukihiko Onuma (IIS, UTokyo), 24-Jan-2022
!                                       onuma@iis.u-tokyo.ac.jp
!
!----------------------------------------------------------------------------
! Copyright (C) 2022 Yukihiko Onuma
!
!----------------------------------------------------------------------------
module SnowAlgae_Global
  implicit none

  public

  !--------------------------------------------------------------------------
  !
  ! model forcing
  !
  !--------------------------------------------------------------------------
  ! date
  !character(len=9),save :: season
  integer,save :: ttime  ! total time step
  !integer,save :: iend1, iend
  !integer,save :: year1, year2
  character(len=40),save :: date
  character(len=10),save :: ymd
  character(len=3),save :: doy
  character(len=8),save :: time

  ! meteorological and snow physical data for Snow Algae Model
  real(8),save :: swe, sst, swdown, snfall

  !--------------------------------------------------------------------------
  !
  ! snow physical states
  !
  !--------------------------------------------------------------------------
  !------------!
  !  forecast  !
  !------------!
  ! 1dim data
  real(8),save :: grtime_mal=0.0_8
  real(8),save :: cell_mal=-9999.0_8
  real(8),save :: biomass_mal=-9999.0_8
  real(8),save :: grtime_XM=0.0_8
  real(8),save :: cell_XM=-9999.0_8
  real(8),save :: biomass_XM=-9999.0_8
  real(8),save :: grtime_XMD=0.0_8
  real(8),save :: cell_XMD=-9999.0_8
  real(8),save :: biomass_XMD=-9999.0_8
  real(8),save :: grtime_XMDF=0.0_8
  real(8),save :: cell_XMDF=-9999.0_8
  real(8),save :: biomass_XMDF=-9999.0_8

  !------------!
  !  output    !
  !------------!
  real, allocatable :: rout(:,:)

end module SnowAlgae_Global
