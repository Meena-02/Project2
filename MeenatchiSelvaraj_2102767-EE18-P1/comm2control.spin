{
Name: Meenatchi Selvaraj
Student id: 2102767
file: comm2Control
brief: this file contains the code to recieve and send the required information to litekit
}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _Ms_001 = _ConClkFreq / 1_000

        RxPin = 15
        TxPin = 14
        CommBaud = 115200

        start = $7A
        forward = $01
        reverse = $02
        left = $03
        right = $04
        dright_f = $05
        dright_r = $06
        dleft_f = $07
        dleft_r = $08
        turnard = $09
        stop = $AA

        key = $7F

VAR

  long cog2ID, cogstack[255]
  long rxSpeed, rxDirection, rxChecksum, rxKey, Check, rxHeader, buf_check

OBJ
  comm      : "FullDuplexSerial.spin"


PUB CommStart(Direction,Speed)

  StopCore

  cog2ID := cognew(commcon(Direction,Speed),@cogstack)

  return
PRI StopCore

  if cog2ID
    cogstop(cog2ID)

PRI commcon(Direction,Speed)

  Comm.Start(TxPin, RxPin, 0, CommBaud)

  pause(3000)

  repeat
    rxHeader := Comm.Rx   'recieves the start byte
    rxDirection := Comm.Rx 'recieves the direction byte
    rxSpeed := Comm.Rx      'recieves the speed byte
    rxCheckSum := Comm.Rx   'recieves the check sum byte
    if (rxHeader ==  start)
      Check := (rxSpeed ^ rxDirection) ^ key
      if(Check == rxCheckSum)
        case rxDirection
          forward:
             long[direction] := 1
          reverse:
             long[direction] := 2
          right:
             long[direction] := 3
          left:
             long[direction] := 4
          dright_f:
             long[direction] := 5
          dright_r:
             long[direction] := 6
          dleft_f:
             long[direction] := 7
          dleft_r:
             long[direction] := 8
          turnard:
             long[direction] := 9
          stop:
             long[direction] := 10

        long[Speed] :=  rxSpeed
    pause(100)

PRI Pause(ms) | t    'Pause Function

  t := cnt - 1088
  repeat(ms #> 0)
    waitcnt(t += _Ms_001)
  return
DAT
name    byte  "string_data",0
