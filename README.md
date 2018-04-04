# cscb58 final project

# Introduction

* Purpose
  * Our project is about us dancing to the music 
  * We analyze frequencies of audio input, which allows us to determine what kind of dance we should be doing on the screen
  * We used an Audio Controller developed by Professor Jonathan Rose from U of T, Electrical & Computer Engineering
  * Link: http://www.eecg.toronto.edu/~jayar/ece241_08F/AudioVideoCores/audio/audio.html
  
# Controls

* SW[19] is LO: Switches generate frequencies and control transitions
* SW[19] is HI: Audio input controls transitions
* KEY[0] resets the fsm and clears the VGA buffer

# How it works

* We use SW[19] as a mux to either listen to audio input, or the frequency generated from the switches
* The audio controller module reads the current frequency and transistion to the corresponding state

* We have 9 states in total
* In general we have 3 main states, where each state has its own 3 dancing states to transisiton through while the state is active
  * Lowest state (blue background) associated with low posture representing a low frequency
  * Medium state (green background) associated with medium posture representing a medium frequency
  * Highest state (red background) associated with high posture representing a high frequency

* Creating the images
  * We took pictures, and converted them into bit maps
  * Allowing us to associate a frequency level to a certain dance move
  
* Drawing images to the VGA
  * Create the dancing animation by repeatedly drawing over the old image
  * We draw by reading 19K bits
  * Each bit decides whether the pixel will be coloured (1) or not (0)
  * Coordinate of the pixel is determined by the index:
  * X = I % 160
  * Y = I / 160
