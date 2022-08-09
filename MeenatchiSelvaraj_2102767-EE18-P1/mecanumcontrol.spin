{
Name: Meenatchi Selvaraj
student ID: 2102767
file: mecanumcontrol
brief: this file contains the code for controlling the movement of the litekit based on the information recieved from the litekit
}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _Ms_001 = _ConClkFreq / 1_000


  'roboclaw1
  R1S1 = 3
  R1S2 = 2

  'roboclaw2
  R2S1 = 5
  R2S2 = 4

  'Simple serial
  SSBaud = 57_600

  channel1_forward = 127
  channel2_forward = 255

  channel1_reverse = 1
  channel2_reverse = 128

  ch1_stop = 64
  ch2_stop = 192

  full_stop = 0

VAR

  long cog1ID
  long cogstack[256]

OBJ
  MD[2]      : "FullDuplexSerial.spin"
  term       : "FullDuplexSerial.spin"

PUB Start(case_add,speed_num)

  StopCore


  init
  cog1ID := cognew(set(case_add,speed_num),@cogstack)

  return
PRI StopCore

  if cog1ID
    cogstop(cog1ID~)

PRI init

  MD[0].Start(R1S2, R1S1, 0, SSBaud)   'roboclaw motor1 ---> channel 1 and channel 2
  MD[1].Start(R2S2, R2S1, 0, SSBaud)   'roboclaw motor2 ---> channel 1 and channel 2

PRI set(case_add,speed_num)


  repeat
    case long[case_add]
      1:
        forward(speed_num)
        Stop
      2:
        reverse(speed_num)
        Stop
      3:
        right(speed_num)
        Stop
      4:
        left(speed_num)
        Stop
      5:
        dright_forward(speed_num)
        Stop
      6:
        dright_reverse(speed_num)
        Stop
      7:
        dleft_forward(speed_num)
        Stop
      8:
        dleft_reverse(speed_num)
        Stop
      9:
        turnard(speed_num)
        Stop
      10:
        Stop


PUB forward(speed_num) | x                     'step 5% = 5/100*50


    MD[0].Tx(ch1_stop + long[speed_num])
    MD[0].Tx(ch2_stop + long[speed_num])
    MD[1].Tx(ch1_stop + long[speed_num])
    MD[1].Tx(ch2_stop + long[speed_num])
    Pause(100)

 { repeat x from long[speed_num] to 0 step 3
    MD[0].Tx(ch1_stop + x)
    MD[0].Tx(ch2_stop + x)
    MD[1].Tx(ch1_stop + x)
    MD[1].Tx(ch2_stop + x)
    Pause(100)      }


    {repeat
      MD[0].Tx(ch1_stop + x)
      MD[0].Tx(ch2_stop + x)
      MD[1].Tx(ch1_stop + x)
      MD[1].Tx(ch2_stop + x) }

PUB reverse(speed_num) | x

  'repeat x from 0 to long[speed_num] step 3
    MD[0].Tx(ch1_stop - long[speed_num])
    MD[0].Tx(ch2_stop - long[speed_num])
    MD[1].Tx(ch1_stop - long[speed_num])
    MD[1].Tx(ch2_stop - long[speed_num])
    Pause(100)

  {repeat x from long[speed_num] to 0 step 3
    MD[0].Tx(ch1_stop - x)
    MD[0].Tx(ch2_stop - x)
    MD[1].Tx(ch1_stop - x)
    MD[1].Tx(ch2_stop - x)
    Pause(100)      }

PUB right(speed_num) | x

  'repeat x from 0 to long[speed_num] step 3
    MD[0].Tx(ch1_stop - long[speed_num])
    MD[1].Tx(ch2_stop - long[speed_num])
    MD[0].Tx(ch2_stop + long[speed_num])
    MD[1].Tx(ch1_stop + long[speed_num])
    Pause(100)
  {
  repeat x from long[speed_num] to 0 step 3
    MD[0].Tx(ch1_stop - x)
    MD[1].Tx(ch2_stop - x)
    MD[0].Tx(ch2_stop + x)
    MD[1].Tx(ch1_stop + x)
    Pause(100)      }

PUB left(speed_num) | x

  'repeat x from 0 to long[speed_num] step 3
    MD[0].Tx(ch2_stop - long[speed_num])
    MD[1].Tx(ch1_stop - long[speed_num])
    MD[0].Tx(ch1_stop + long[speed_num])
    MD[1].Tx(ch2_stop + long[speed_num])
    Pause(100)
  {
  repeat x from long[speed_num] to 0 step 3
    MD[0].Tx(ch2_stop - x)
    MD[1].Tx(ch1_stop - x)
    MD[0].Tx(ch1_stop + x)
    MD[1].Tx(ch2_stop + x)
    Pause(100)            }

PUB dright_forward(speed_num) | x

  'repeat x from 0 to long[speed_num] step 3
    MD[0].Tx(ch2_stop + long[speed_num])
    MD[1].Tx(ch1_stop + long[speed_num])
    Pause(100)

 { repeat x from long[speed_num] to 0 step 3
    MD[0].Tx(ch2_stop + x)
    MD[1].Tx(ch1_stop + x)
    Pause(100)  }

PUB dright_reverse(speed_num) | x

  'repeat x from 0 to long[speed_num] step 3
    MD[0].Tx(ch2_stop - long[speed_num])
    MD[1].Tx(ch1_stop - long[speed_num])
    Pause(100)

 { repeat x from long[speed_num] to 0 step 3
    MD[0].Tx(ch2_stop - x)
    MD[1].Tx(ch1_stop - x)
    Pause(100)  }

PUB dleft_forward(speed_num) | x

  'repeat x from 0 to long[speed_num] step 3
    MD[0].Tx(ch1_stop + long[speed_num])
    MD[1].Tx(ch2_stop + long[speed_num])
    Pause(100)
 {
  repeat x from long[speed_num] to 0 step 3
    MD[0].Tx(ch1_stop + x)
    MD[1].Tx(ch2_stop + x)
    Pause(100)    }

PUB dleft_reverse(speed_num) | x

  'repeat x from 0 to long[speed_num] step 3
    MD[0].Tx(ch1_stop - long[speed_num])
    MD[1].Tx(ch2_stop - long[speed_num])
    Pause(100)

{  repeat x from long[speed_num] to 0 step 3
    MD[0].Tx(ch1_stop - x)
    MD[1].Tx(ch2_stop - x)
    Pause(100)  }

PRI turnard(speed_num) | x

  'repeat x from 0 to long[speed_num] step 2
    MD[0].Tx(ch2_stop + long[speed_num])
    MD[1].Tx(ch2_stop + long[speed_num])
    MD[0].Tx(ch1_stop - long[speed_num])
    MD[1].Tx(ch1_stop - long[speed_num])

    Pause(100)

 { repeat x from long[speed_num] to 0 step 2
    MD[0].Tx(ch2_stop + x)
    MD[1].TX(ch2_stop + x)
    MD[0].Tx(ch1_stop - x)
    MD[1].Tx(ch1_stop - x)
    Pause(100)   }


PUB Stop

  MD[0].Tx(ch1_stop)
  MD[0].Tx(ch2_stop)
  MD[1].Tx(ch1_stop)
  MD[1].Tx(ch2_stop)

PRI Pause(ms) | t

  t := cnt - 1088
  repeat(ms #> 0)
    waitcnt(t += _Ms_001)
  return
DAT
name    byte  "string_data",0
