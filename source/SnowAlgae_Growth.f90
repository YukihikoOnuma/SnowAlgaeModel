!----------------------------------------------------------------------------
! MODULE NAME:
!       SnowAlgae_Growth
!
!----------------------------------------------------------------------------
! PURPOSE:
!       Snow Algae model by Onuma et al. (2016, 2018, 2022)
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
!       - SnowAlgae_Growth__MAL: 
!            Snow algal cell abundance is calcultated with a malthusian model
!            using duration of snow melting.
!            Ref. Onuma et al. (2016, BGR)
!
!       - SnowAlgae_Growth__XM: 
!            Snow algal cell abundance is calcultated with a logistic model
!            using duration of snow melting.
!            Ref. Onuma et al. (2018, TC; 2022, JGR)
!
!       - SnowAlgae_Growth__XMD: 
!            Snow algal cell abundance is calcultated with a logistic model
!            using duration of snow melting and shortwave radiation.
!            Ref. Onuma et al. (2022, JGR)
!
!       - SnowAlgae_Growth__XMDF: 
!            Snow algal cell abundance is calcultated with a logistic model
!            using duration of snow melting, shortwave radiation and snowfall.
!            Ref. Onuma et al. (2022, JGR)
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
module SnowAlgae_Growth
  use SnowAlgae_Global
  use SnowAlgae_Read_nml

  implicit none

  private
  public :: SnowAlgae_Growth__MAL, SnowAlgae_Growth__XM, &
       & SnowAlgae_Growth__XMD, SnowAlgae_Growth__XMDF

contains
!----------------------------------------------------------------------------
  subroutine SnowAlgae_Growth__MAL(swe, sst, &   ! in
       & gp_mal, cellA_mal, bioA_mal, cellV_mal, bioV_mal, ocV_mal)      ! out

    implicit none

    ! in
    real(8) :: swe          ! snow water equivalent [kg m-2]
    real(8) :: sst          ! snow surface temperature [K]

    ! out
    real(8) :: gp_mal       ! growth period of snow algal cell [hour]
    real(8) :: cellA_mal    ! snow algal cell concentration per area [cells m-2]
    real(8) :: bioA_mal     ! snow algal bio-volume per area [uL m-2]
    real(8) :: cellV_mal    ! snow algal cell concentration per volume [cells L-1]
    real(8) :: bioV_mal     ! snow algal bio-volume per volume [uL L-1]
    real(8) :: ocV_mal      ! organic carbon of snow algae per volume [mg L-1]

    if (swe <= 0.0_8) then
        gp_mal = 0.0_8
    else if (sst >= abstmp) then
        gp_mal = gp_mal + 1.0_8
    else
        gp_mal = gp_mal
    end if

    ! malthusian model
    if (swe <= 0.0_8) then
        cellA_mal = 0.0_8
    else
        cellA_mal = inalg_s * exp(gralg_s * gp_mal)
    end if

    ! cells m-2 -> uL m-2
    bioA_mal = cellA_mal * volalg_s * 1.0e3_8

    ! cells m-2 -> cells L-1
    cellV_mal = cellA_mal / ( 1.0e3_8 * 0.02_8 ) ! water density * snow depth (top2cm)

    ! cells L-1 -> uL L-1
    bioV_mal = cellV_mal * volalg_s * 1.0e3_8
    
    ! cells L-1 -> mg L-1 (Onuma et al. 2020, TC, eq.3)
    ocV_mal = 5.3e-6_8 * cellV_mal + 0.0826

  end subroutine SnowAlgae_Growth__MAL

!----------------------------------------------------------------------------
  subroutine SnowAlgae_Growth__XM(swe, sst, &    ! in
       & gp_xm, cellA_xm, bioA_xm, cellV_xm, bioV_xm, ocV_xm)         ! out

    implicit none

    ! in
    real(8) :: swe         ! snow water equivalent [kg m-2]
    real(8) :: sst         ! snow surface temperature [K]

    ! out
    real(8) :: gp_xm       ! growth period of snow algal cell [hour]
    real(8) :: cellA_xm    ! snow algal cell concentration per area [cells m-2]
    real(8) :: bioA_xm     ! snow algal bio-volume per area [uL m-2]
    real(8) :: cellV_xm    ! snow algal cell concentration per volume [cells L-1]
    real(8) :: bioV_xm     ! snow algal bio-volume per volume [uL L-1]
    real(8) :: ocV_xm      ! organic carbon of snow algae per volume [mg L-1]

    if (swe <= 0.0_8) then
        gp_xm = 0.0_8
    else if (sst >= abstmp) then
        gp_xm = gp_xm + 1.0_8
    else
        gp_xm = gp_xm
    end if

    ! logistic model
    if (swe <= 0.0_8) then
        cellA_xm = 0.0_8
    else
        cellA_xm = capalg_s / ( 1.0_8 + ((capalg_s - inalg_s) / inalg_s) &
             & * exp(gralg_s * - gp_xm))
    end if

    ! cells m-2 -> uL m-2
    bioA_xm = cellA_xm * volalg_s * 1.0e3_8

    ! cells m-2 -> cells L-1
    cellV_xm = cellA_xm / ( 1.0e3_8 * 0.02_8 ) ! water density * snow depth (top2cm)

    ! cells L-1 -> uL L-1
    bioV_xm = cellV_xm * volalg_s * 1.0e3_8
    
    ! cells L-1 -> mg L-1 (Onuma et al. 2020, TC, eq.3)
    ocV_xm = 5.3e-6_8 * cellV_xm + 0.0826

  end subroutine SnowAlgae_Growth__XM

!----------------------------------------------------------------------------
  subroutine SnowAlgae_Growth__XMD(swe, sst, swdown, &    ! in
       & gp_xmd, cellA_xmd, bioA_xmd, cellV_xmd, bioV_xmd, ocV_xmd)               ! out

    implicit none

    ! in
    real(8) :: swe          ! snow water equivalent [kg m-2]
    real(8) :: sst          ! snow surface temperature [K]
    real(8) :: swdown       ! downward shortwave radiation [W m-2]

    ! out
    real(8) :: gp_xmd       ! growth period of snow algal cell [hour]
    real(8) :: cellA_xmd    ! snow algal cell concentration per area [cells m-2]
    real(8) :: bioA_xmd     ! snow algal bio-volume per area [uL m-2]
    real(8) :: cellV_xmd    ! snow algal cell concentration per volume [cells L-1]
    real(8) :: bioV_xmd     ! snow algal bio-volume per volume [uL L-1]
    real(8) :: ocV_xmd      ! organic carbon of snow algae per volume [mg L-1]

    if (swe <= 0.0_8) then
        gp_xmd = 0.0_8
    else if (sst >= abstmp .and. swdown > 0.0_8 ) then
        gp_xmd = gp_xmd + 1.0_8
    else
        gp_xmd = gp_xmd
    end if

    ! logistic model
    if (swe <= 0.0_8) then
        cellA_xmd = 0.0_8
    else
        cellA_xmd = capalg_s / ( 1.0_8 + ((capalg_s - inalg_s) / inalg_s) &
             & * exp(gralg_s * - gp_xmd))
    end if

    ! cells m-2 -> uL m-2
    bioA_xmd = cellA_xmd * volalg_s * 1.0e3_8

    ! cells m-2 -> cells L-1
    cellV_xmd = cellA_xmd / ( 1.0e3_8 * 0.02_8 ) ! water density * snow depth (top2cm)

    ! cells L-1 -> uL L-1
    bioV_xmd = cellV_xmd * volalg_s * 1.0e3_8
    
    ! cells L-1 -> mg L-1 (Onuma et al. 2020, TC, eq.3)
    ocV_xmd = 5.3e-6_8 * cellV_xmd + 0.0826

  end subroutine SnowAlgae_Growth__XMD

!----------------------------------------------------------------------------
  subroutine SnowAlgae_Growth__XMDF(swe, sst, swdown, snfall, &     ! in
       & gp_xmdf, cellA_xmdf, bioA_xmdf, cellV_xmdf, bioV_xmdf, ocV_xmdf)               ! out

    implicit none

    ! in
    real(8) :: swe          ! snow water equivalent [kg m-2]
    real(8) :: sst          ! snow surface temperature [K]
    real(8) :: swdown       ! downward shortwave radiation [W m-2]
    real(8) :: snfall       ! snowfall rate [kg m-2 s-1]
    real(8), parameter ::          &
         & snden = 300.0_8  ! snow density [kg m-3]

    ! out
    real(8) :: gp_xmdf       ! growth period of snow algal cell [hour]
    real(8) :: cellA_xmdf    ! snow algal cell concentration per area [cells m-2]
    real(8) :: bioA_xmdf     ! snow algal bio-volume per area [uL m-2]
    real(8) :: cellV_xmdf    ! snow algal cell concentration per volume [cells L-1]
    real(8) :: bioV_xmdf     ! snow algal bio-volume per volume [uL L-1]
    real(8) :: ocV_xmdf      ! organic carbon of snow algae per volume [mg L-1]
  
    ! internal value
    real(8) :: dpfct         ! snow depth factor [-]

    if (swe <= 0.0_8) then
        gp_xmdf = 0.0_8
    else if (sst >= abstmp .and. swdown > 0.0_8 ) then
        gp_xmdf = gp_xmdf + 1.0_8
    else
        gp_xmdf = gp_xmdf
    end if

    ! logistic model
    if (swe <= 0.0_8) then
        cellA_xmdf = 0.0_8
    else
        cellA_xmdf = capalg_s / ( 1.0_8 + ((capalg_s - inalg_s) / inalg_s) &
             & * exp(gralg_s * - gp_xmdf))
    end if

    ! cal depth factor to reduce cell concentration by new snow cover
    if (snfall > 0.0_8) then
        dpfct = min( ( snfall * 3600.0_8 * 1000.0_8 ) & 
             & / (snden * 20.0_8), 1.0_8 )
        ! re-cal growth time from calculated algal cell concentration and dpfct
        cellA_xmdf  = max( cellA_xmdf * (1.0_8 - dpfct), inalg_s )

        gp_xmdf = log( (capalg_s / cellA_xmdf - 1.0_8) / &
             & ((capalg_s - inalg_s) / inalg_s) ) / gralg_s * -1.0_8

        gp_xmdf = max( gp_xmdf, 0.0_8 )
    end if

    ! cells m-2 -> uL m-2
    bioA_xmdf = cellA_xmdf * volalg_s * 1.0e3_8

    ! cells m-2 -> cells L-1
    cellV_xmdf = cellA_xmdf / ( 1.0e3_8 * 0.02_8 ) ! water density * snow depth (top2cm)

    ! cells L-1 -> uL L-1
    bioV_xmdf = cellV_xmdf * volalg_s * 1.0e3_8
    
    ! cells L-1 -> mg L-1 (Onuma et al. 2020, TC, eq.3)
    ocV_xmdf = 5.3e-6_8 * cellV_xmdf + 0.0826

  end subroutine SnowAlgae_Growth__XMDF

end module SnowAlgae_Growth
