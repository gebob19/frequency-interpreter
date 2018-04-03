# Introduction

* Purpose
  * We all love music...
  * Our project is about us dancing to the music...
  * We used an Audio Controller developed by Professor Jonathan Rose from U of T, Electrical & Computer Engineering
  * Why we didn't use FFT 

# Controls

* Switches generate frequencies and control transitions when SW[19] is LO
* Microphone control transitions when SW[19] is HI
* KEY[0] resets the fsm and clears the VGA buffer
* RED is HI, GREEN is MED, BLUE is LO

# Presentation

## GREG

* FSM states, images, and frequencies
  * Lowest state associated with low posture representing a low frequency
  * Highest state associated with high posture representing a high frequency

## BRENNAN

* Drawing images to the VGA
  * create animation by redrawing over the old image
  * draw by reading 19K bits by a chosen rate
  * each bit decides whether the pixel will be coloured or not
  * drawing as fast as the VGA can handle
  * Coordinate of the pixel is determined by the index:
  * X = I % 160
  * Y = I / 160