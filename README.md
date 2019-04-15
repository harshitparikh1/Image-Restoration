# Image-Restoration
A program for restoring the image using Band Pass Filter and Band Reject Filter has been implemented.
We first took a Gray scale Image and added noise to it.
The noisy image fourier spectrum was taken out to get the information of noise present.
The Fourier Spectrum shows that the image contains components of all frequencies, but that their magnitude gets smaller for higher frequencies. Hence, low frequencies contain more image information than the higher ones. The transform image also tells us that there are two dominating directions in the Fourier image, one passing vertically and one horizontally through the center. These originate from the regular patterns in the background of the original image.
This Fourier Spectrum was then multiplied by the Band Reject Filter to get the noise present in between the two circles.
This noise is then removed through Inverse FFT to finally get the Restored Image.
