{
Name: Meenatchi Selvaraj
Student id: 2102767
File: litekit.spin
brief: this file contains the code to move the litekit in the intended direction and speed  according to the instructions given from cortex



}


CON

        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _Ms_001 = _ConClkFreq / 1_000


       tofsafe = 200
       ultrasafe = 300


VAR
  long  case_para,speed_m,direction,speed_c,tofMainAdd[2], ultraMainAdd[4]

OBJ
  motor        : "mecanumcontrol.spin"
  term         : "FullDuplexSerial.spin"
  comm         : "comm2control.spin"
  sensor       : "sensorctrl.spin"


PUB Main | x


   comm.CommStart(@direction, @speed_c)
   Motor.Start(@case_para,@speed_m)
   sensor.Start(@tofMainAdd, @ultraMainAdd)
   Term.Start(31,30,0,230400)


   repeat
    {
       if the litekit detects any obstacles it will stop moving and if the litekit detects a ledge it will stop moving
    }
      if((tofMainAdd[0] > 0 and tofMainAdd[0] > tofsafe) or (tofMainAdd[1] > 0 and tofMainAdd[1] > tofsafe) or (ultraMainAdd[0] > 0 and ultraMainAdd[0] < ultrasafe) or (ultraMainAdd[1] > 0 and ultraMainAdd[1] < ultrasafe) or (ultraMainAdd[2] > 0 and ultraMainAdd[2] < ultrasafe) or (ultraMainAdd[3] > 0 and ultraMainAdd[3] < ultrasafe))
        case_para := 10
        speed_m := 0
        Term.Str(String("hello"))
      else
        case_para := direction
        speed_m := speed_c
        Term.Str(String("bye"))

PRI Pause(ms) | t

  t := cnt - 1088
  repeat(ms #> 0)
    waitcnt(t += _Ms_001)
  return


DAT
name    byte  "string_data",0