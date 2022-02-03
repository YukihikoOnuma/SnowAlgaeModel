!----------------------------------------------------------------------------
! MODULE NAME:
!       SnowAlgae_Global
!
!----------------------------------------------------------------------------
! PURPOSE:
!       Global variables of Snow Algae Model.
!       This code was written while referencing
!       SMAP.v4.12a (Niwano et al., 2012).
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
  integer,save :: ttime  ! total time step
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
  real(8),save :: gp_mal=0.0_8
  real(8),save :: cellA_mal=-9999.0_8
  real(8),save :: bioA_mal=-9999.0_8
  real(8),save :: cellV_mal=-9999.0_8
  real(8),save :: bioV_mal=-9999.0_8
  real(8),save :: ocV_mal=-9999.0_8
  real(8),save :: gp_xm=0.0_8
  real(8),save :: cellA_xm=-9999.0_8
  real(8),save :: bioA_xm=-9999.0_8
  real(8),save :: cellV_xm=-9999.0_8
  real(8),save :: bioV_xm=-9999.0_8
  real(8),save :: ocV_xm=-9999.0_8
  real(8),save :: gp_xmd=0.0_8
  real(8),save :: cellA_xmd=-9999.0_8
  real(8),save :: bioA_xmd=-9999.0_8
  real(8),save :: cellV_xmd=-9999.0_8
  real(8),save :: bioV_xmd=-9999.0_8
  real(8),save :: ocV_xmd=-9999.0_8
  real(8),save :: gp_xmdf=0.0_8
  real(8),save :: cellA_xmdf=-9999.0_8
  real(8),save :: bioA_xmdf=-9999.0_8
  real(8),save :: cellV_xmdf=-9999.0_8
  real(8),save :: bioV_xmdf=-9999.0_8
  real(8),save :: ocV_xmdf=-9999.0_8

  !------------!
  !  output    !
  !------------!
  real, allocatable :: rout(:,:)

end module SnowAlgae_Global
