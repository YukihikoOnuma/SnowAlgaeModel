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
!       - SnowAlgae_Growth__mal: 
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
  public :: SnowAlgae_Growth__mal, SnowAlgae_Growth__XM, &
       & SnowAlgae_Growth__XMD, SnowAlgae_Growth__XMDF

contains
!----------------------------------------------------------------------------
  subroutine SnowAlgae_Growth__mal(swe, sst, &   ! in
       & grtime_mal, cell_mal, biomass_mal)      ! out

    implicit none

    ! in
    real(8) :: swe          ! snow water equivalent [kg m-2]
    real(8) :: sst          ! snow surface temperature [K]

    ! out
    real(8) :: grtime_mal   ! growth time of snow algal cell [hour-1]
    real(8) :: cell_mal     ! snow algal cell concentration. [cells m-2]
    real(8) :: biomass_mal  ! snow algal volume. biomass [uL m-2]

    if (swe <= 0.0_8) then
        grtime_mal = 0.0_8
    else if (sst >= abstmp) then
        grtime_mal = grtime_mal + 1.0_8
    else
        grtime_mal = grtime_mal
    end if

    ! malthusian model
    if (swe <= 0.0_8) then
        cell_mal = 0.0_8
    else
        cell_mal = inalg_s * exp(gralg_s * grtime_mal)
    end if

    ! cells m-2 -> uL m-2
    biomass_mal = cell_mal * volalg_s * 1.0e3_8

    !write(16,*) 'grtime_m_s', grtime_m_s
    !write(16,*) 'cell_m_s', cell_m_s
    !write(16,*) 'biomass_m_s', biomass_m_s

  end subroutine SnowAlgae_Growth__mal

!----------------------------------------------------------------------------
  subroutine SnowAlgae_Growth__XM(swe, sst, &    ! in
       & grtime_XM, cell_XM, biomass_XM)         ! out

    implicit none

    ! in
    real(8) :: swe         ! snow water equivalent [kg m-2]
    real(8) :: sst         ! snow surface temperature [K]

    ! out
    real(8) :: grtime_XM   ! growth time of snow algal cell [hour-1]
    real(8) :: cell_XM     ! snow algal cell concentration. [cells m-2]
    real(8) :: biomass_XM  ! snow algal volume. biomass [uL m-2]

    if (swe <= 0.0_8) then
        grtime_XM = 0.0_8
    else if (sst >= abstmp) then
        grtime_XM = grtime_XM + 1.0_8
    else
        grtime_XM = grtime_XM
    end if

    ! logistic model
    if (swe <= 0.0_8) then
        cell_XM = 0.0_8
    else
        cell_XM = capalg_s / ( 1.0_8 + ((capalg_s - inalg_s) / inalg_s) &
             & * exp(gralg_s * - grtime_XM))
    end if

    ! cells m-2 -> uL m-2
    biomass_XM = cell_XM * volalg_s * 1.0e3_8

    !write(16,*) 'grtime_l_s', grtime_l_s
    !write(16,*) 'cell_l_s', cell_l_s
    !write(16,*) 'biomass_l_s', biomass_l_s

  end subroutine SnowAlgae_Growth__XM

!----------------------------------------------------------------------------
  subroutine SnowAlgae_Growth__XMD(swe, sst, swdown, &    ! in
       & grtime_XMD, cell_XMD, biomass_XMD)               ! out

    implicit none

    ! in
    real(8) :: swe          ! snow water equivalent [kg m-2]
    real(8) :: sst          ! snow surface temperature [K]
    real(8) :: swdown       ! downward shortwave radiation [W m-2]

    ! out
    real(8) :: grtime_XMD   ! growth time of snow algal cell [hour-1]
    real(8) :: cell_XMD     ! snow algal cell concentration. [cells m-2]
    real(8) :: biomass_XMD  ! snow algal volume. biomass [uL m-2]

    if (swe <= 0.0_8) then
        grtime_XMD = 0.0_8
    else if (sst >= abstmp .and. swdown > 0.0_8 ) then
        grtime_XMD = grtime_XMD + 1.0_8
    else
        grtime_XMD = grtime_XMD
    end if

    ! logistic model
    if (swe <= 0.0_8) then
        cell_XMD = 0.0_8
    else
        cell_XMD = capalg_s / ( 1.0_8 + ((capalg_s - inalg_s) / inalg_s) &
             & * exp(gralg_s * - grtime_XMD))
    end if

    ! cells m-2 -> uL m-2
    biomass_XMD = cell_XMD * volalg_s * 1.0e3_8

    !write(16,*) 'grtime_l_s', grtime_l_s
    !write(16,*) 'cell_l_s', cell_l_s
    !write(16,*) 'biomass_l_s', biomass_l_s

  end subroutine SnowAlgae_Growth__XMD

!----------------------------------------------------------------------------
  subroutine SnowAlgae_Growth__XMDF(swe, sst, swdown, snfall, &     ! in
       & grtime_XMDF, cell_XMDF, biomass_XMDF)                      ! out

    implicit none

    ! in
    real(8) :: swe          ! snow water equivalent [kg m-2]
    real(8) :: sst          ! snow surface temperature [K]
    real(8) :: swdown       ! downward shortwave radiation [W m-2]
    real(8) :: snfall       ! snowfall rate [kg m-2 s-1]
    real(8), parameter ::          &
         & snden = 300.0_8  ! snow density [kg m-3]


    ! out
    real(8) :: grtime_XMDF   ! growth time of snow algal cell [hour-1]
    real(8) :: cell_XMDF     ! snow algal cell concentration. [cells m-2]
    real(8) :: biomass_XMDF  ! snow algal volume. biomass [uL m-2]

    ! internal value
    real(8) :: dpfct         ! snow depth factor [-]

    if (swe <= 0.0_8) then
        grtime_XMDF = 0.0_8
    else if (sst >= abstmp .and. swdown > 0.0_8 ) then
        grtime_XMDF = grtime_XMDF + 1.0_8
    else
        grtime_XMDF = grtime_XMDF
    end if

    ! logistic model
    if (swe <= 0.0_8) then
        cell_XMDF = 0.0_8
    else
        cell_XMDF = capalg_s / ( 1.0_8 + ((capalg_s - inalg_s) / inalg_s) &
             & * exp(gralg_s * - grtime_XMDF))
    end if

    ! cal depth factor to reduce cell concentration by new snow cover
    if (snfall > 0.0_8) then
        dpfct = min( ( snfall * 3600.0_8 * 1000.0_8 ) & 
             & / (snden * 20.0_8), 1.0_8 )
        ! re-cal growth time from calculated algal cell concentration and dpfct
        cell_XMDF  = max( cell_XMDF * (1.0_8 - dpfct), inalg_s )

        grtime_XMDF = log( (capalg_s / cell_XMDF - 1.0_8) / &
             & ((capalg_s - inalg_s) / inalg_s) ) / gralg_s * -1.0_8

        grtime_XMDF = max( grtime_XMDF, 0.0_8 )
    end if

    ! cells m-2 -> uL m-2
    biomass_XMDF = cell_XMDF * volalg_s * 1.0e3_8

  end subroutine SnowAlgae_Growth__XMDF

end module SnowAlgae_Growth
