{{
+-------------------------------------------------+
| JTAGulator                                      |
| Utility Object                                  |
|                                                 |
| Author: Joe Grand                               |                     
| Copyright (c) 2013-2021 Grand Idea Studio, Inc. |
| Web: http://www.grandideastudio.com             |
|                                                 |
| Distributed under a Creative Commons            |
| Attribution 3.0 United States license           |
| http://creativecommons.org/licenses/by/3.0/us/  |
+-------------------------------------------------+

Program Description:

This object provides the general purpose utility
methods for the JTAGulator.

}}


CON
  TXS_ENABLE_DELAY  = 10   ' Settling time (ms) after enabling level translators
                           ' (must wait > 200nS for TXS0108E one-shot circuitry to become operational)


OBJ
  g                 : "JTAGulatorCon"     ' JTAGulator global constants


PUB TXSEnable      ' Enable level shifter outputs
  dira[g#MAX_CHAN-1..0]~      ' Set all channels as inputs to avoid contention when driver is enabled. Pin directions will be configured by other methods as needed.
  outa[g#TXS_OE] := 1
  Pause(TXS_ENABLE_DELAY) 


PUB TXSDisable     ' Disable level shifter outputs (high impedance)
  outa[g#TXS_OE] := 0


PUB Set_Pins_High(start_ch, end_ch) | i    ' Set range of channels to output HIGH
  repeat i from start_ch to end_ch
    dira[i] := 1
    outa[i] := 1


PUB Set_Pins_Low(start_ch, end_ch) | i     ' Set range of channels to output LOW
  repeat i from start_ch to end_ch
    dira[i] := 1
    outa[i] := 0

    
PUB Set_Pins_Input(start_ch, end_ch) | i   ' Set range of channels to input
  repeat i from start_ch to end_ch
    dira[i] := 0
    

PUB Pause(ms)
  waitcnt(clkfreq / 1000 * ms + cnt)

PUB LedStatus(status)
  case status
    g#LED_ERROR:	' Odd choice to have ERR & INIT the same?
    g#LED_INIT:                 ' INIT = YELLOW^M
      outa[g#LED_R] := 1
      outa[g#LED_G] := 1
    g#LED_PROCESSING:           ' Processing - Toggle GREEN LED
      !outa[g#LED_R]
    g#LED_IDLE:                 ' Idle - GREEN on - RED off
      outa[g#LED_G] := 1
      outa[g#LED_R] := 0
    g#LED_WARN:                 ' Code appeared to go solid RED
      outa[g#LED_G] := 0
      outa[g#LED_R] := 1
    g#LED_OFF:
      outa[g#LED_G] := 0
      outa[g#LED_R] := 0

