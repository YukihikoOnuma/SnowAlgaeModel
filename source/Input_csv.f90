!----------------------------------------------------------------------------
! MODULE NAME:
!       Input_csv
!
!----------------------------------------------------------------------------
! PURPOSE:
!       Interface of csv file used in Snow Algae Model.
!       This code was written while referencing 
!       SMAP.v4.12a (Niwano et al., 2012).
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
!       - Input_csv__ini: 
!           initialize model input AWS data.
!
!       - Input_csv__main: 
!           return model input AWS data at specified time step.
!
!       ---------------------------------------------------------------------
!       [PRIVATE]
!       - Input_csv__data: 
!           Access to model input AWS data (csv format).
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
module Input_csv
  use SnowAlgae_Global
  use SnowAlgae_Read_nml

  !===============================================
  ! read data from AWS data.
  !===============================================
  implicit none

  private
  public :: Input_csv__ini, Input_csv__data, Input_csv__main

  character(len=30),allocatable,save :: sheader(:,:)
  real(8),allocatable,save :: relema(:,:)
  
!  integer :: n2
!  integer,allocatable,save :: year(:), month(:), day(:)
!  integer,allocatable,save :: istep(:)
!  real(8),allocatable,save :: doe_0002(:,:), doe_0010(:,:)

contains
!--------------------------------------------------------------------------
  subroutine Input_csv__ini()
    
    implicit none
    integer :: n
    
!    character(len=9) :: season
    
    call Input_csv__data(relema, sheader, n, ttime)
    
  end subroutine Input_csv__ini
  
!--------------------------------------------------------------------------
  subroutine Input_csv__data(relema1, sidehead, n1, ttime) ! out

    implicit none
    character(len=20) :: buf
    character(len=30) :: e1, e2, e3, e4, e5, e6, e7
    character(len=20), allocatable :: header(:,:)
    character(len=30), allocatable :: elema(:,:)
    character(len=30), allocatable :: sidehead(:,:)
    character(len=30) :: tmp
    character(len=100) :: ifpath

    integer :: i, j, ios
    integer :: n1, ttime

    real(8), allocatable :: relema1(:,:)

    !===========================
    ! data file's status check
    !===========================

    ifpath= trim(infile) // '/' // trim(fname) // '_i.csv'

    open(30, iostat=ios, &
         & file=ifpath, status='old', form='formatted')

    if(ios /= 0) then
       write(*,*) '=============================='
       write(*,*) 'Could not open file:', ifpath
       stop
    endif
    
    n1 = 0    
    
    do 
       read(30, fmt=*, iostat=ios) buf
       if(ios > 0) stop 'Error!'
       if(ios < 0) exit
       n1 = n1 + 1
    end do

    close(30)

    ! total time step
    !ttime = n1 - 1
    ttime = n1 - 2    ! data number minus header
    !write(16,*) 'total time step1 = ', ttime

    !==================
    ! allocate memory
    !==================
    allocate(elema(n1,6))    ! All data (sidehead+relema1)
    !allocate(sidehead(n1,3))  ! Date,Yday,Time
    allocate(sidehead(n1,2))  ! ymd,time
    allocate(relema1(n1,4))   ! Input data, 4 = data number

    !=============================
    ! read buffer from data file 
    !=============================
    open(30, iostat=ios, &
         & file=ifpath, status='old', form='formatted')
    
    if(ios /= 0) then
       write(*,*) 'Could not open file:', ifpath
       stop
    endif
    
    do i = 1, n1 
       e1 = '==='
       e2 = '==='
       e3 = '==='
       e4 = '==='
       e5 = '==='
       e6 = '==='
       
       read(30,*, iostat=ios) e1,e2,e3,e4,e5,e6

       elema(i,1) = e1
       elema(i,2) = e2
       elema(i,3) = e3
       elema(i,4) = e4
       elema(i,5) = e5
       elema(i,6) = e6
    end do
    
    close(30)

    !===============
    ! side headder
    !===============
    ! j = 1-3 -> e1-e3
    !do i = 1, n1-1
       !do j = 1, 3
          !sidehead(i,j) = elema(i+1,j)  ! exclude header
       !end do
    !end do
    do i = 1, n1-2
       do j = 1, 2
          sidehead(i,j) = elema(i+2,j)  ! exclude header
       end do
    end do

    !==========================
    ! character 2 real convert
    !==========================
    !write(16,*) 'n1 =', n1
    !do i = 1, n1-1
    do i = 1, n1-2
       do j = 1, 4
          !tmp = elema(i+1,j+3)  ! exclude header
          tmp = elema(i+2,j+2)  ! exclude header
          !write(16,*) 'tmp =', tmp
          read(tmp,*) relema1(i,j)
          !write(16,*) 'relema1 =', relema1(i,j),i,j
       end do
    end do

    !===============================
    ! return meteorological forcing
    !===============================
    return

    !===================
    ! deallocate memory
    !===================
    deallocate(elema)
    deallocate(sidehead)
    deallocate(relema1)

  end subroutine Input_csv__data

!----------------------------------------------------------------------------
  subroutine Input_csv__main(step) ! in

    implicit none

    integer :: conv_step, step, step_temp
    integer :: i, j, ios

    ! dtype: input(min), cal_step: model cal step(sec)
    ! now, only dtype=60,cal_step=3600
    conv_step = dtype / (cal_step / 60)

    if (mod(step,conv_step) == 1) then
       step_temp = (step + 1) / (dtype * 60 / cal_step)
    else
       step_temp = step / (dtype * 60 / cal_step)
    end if

    !date = trim(sheader(step_temp,1)) // ' ' // trim(sheader(step_temp,3))
    date = trim(sheader(step_temp,1)) // ' ' // trim(sheader(step_temp,2))

    ymd = trim(sheader(step_temp,1))
    !doy = trim(sheader(step_temp,2))
    !time = trim(sheader(step_temp,3))
    time = trim(sheader(step_temp,2))
    !write(16,*) 'date =' ,date
    !write(16,*) 'ymd =' ,ymd
    !write(16,*) 'time =' ,time

    !===============================
    ! set forcing data at this step
    !===============================
    swe = relema(step_temp,1)
    sst = relema(step_temp,2)
    swdown = relema(step_temp,3)
    snfall = relema(step_temp,4)

  end subroutine Input_csv__main

end module Input_csv
