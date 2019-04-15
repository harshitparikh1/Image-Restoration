clc;
clear;
//Reading Image and Displaying it.
I=imread('F:\Recycle Bin\SEM6\IPMV\cameraman.tif');
figure,imshow(uint8(I)), title("Original Image"); 
[m,n]=size(I);
//Adding Noise to the image.
imn1 = fspecial('gaussian',15,0.9);
blur = imfilter(I,imn1,'circular');
noise = 0.01*rand(m,n,'normal');
g = blur + noise;
g = double(g);
figure,imshow(uint8(g)),title("Noisy image");
//Taking FFT of the Noisy Image
g1=fft2(g);
G = fftshift(g1);
G1=log(1+abs(G));
gm=max(G1(:));
Gk = G1/gm;
figure,imshow(im2uint8(Gk)),title("Frequency Spectrum");

H=zeros(m,n);
F2=zeros(m,n);
D0=9; //Radius of Inner Circle
D1=10; //Radius of Outer Circle

for x=1:m
    for y=1:n
        Dist=((m/2-x)^2+(n/2-y)^2)^0.5; //Formula to make a circle
        if Dist > D0 
            if Dist < D1
                H(x,y)=255; //White Circle on Black Background to form a BAND PASS FILTER
            end
        end
    end
end
figure,imshow(uint8(H)),title('BPF Circle');

for x=1:m
    for y=1:n
        H2(x,y)=255-H(x,y); //Black Circle on White Background to form a BAND REJECT FILTER
    end
end
figure,imshow(uint8(H2)),title('BRF Circle');

for x=1:m
    for y=1:n
        H33(x,y) = H2(x,y)*g1(x,y); //Multiplication of Fourier Spectrum into the BRF to get noise in between the Circles
    end
end
H2222 = ifft(H33);
//figure,imshow(uint8(H2222)),title('IFFT of BRF Circle * FFT Spectrum');

for x=1:m
    for y=1:n
        H34(x,y) = 255-H2222(x,y); //Noise removed through this process to get the restored image
    end
end
figure,imshow(uint8(real(H34))),title("Restored Image");

//Below is the process done to find the PSNR and MSE of both original image and reconstructed image
//And to check if PSNR of reconstructed image is more than that of Original Image to prove that
//The restoration is done successfully.
I = double(I);
H34 = double(H34);
MSE = zeros(m,n);
MSE1 = zeros(m,n);
H34 = real(H34);
H341 = min(H34);
for x=1:m
    for y=1:n
        H342(x,y)=H34(x,y)/ H341 //Dividing by the max value(since its negative so divided by minimum)
        H343(x,y)=H342(x,y)*255; //And then multiplying it by 255 to get all the value from 0 to 255
    end
end
H343 = double(H343);
m1 = max(H343);

for x=1:m
    for y=1:n
        MSE1(x,y) = [(I(x,y)-H343(x,y))]^2; //Formula for MSE 
    end
end
MSE2 = sum(MSE1);
MSE = MSE2/(m*n);
disp("MSE of reconstructed",MSE);
PSNR = 10*log(m1/MSE); //Formula for PSNR
disp("PSNR of reconstructed",PSNR);

MSE11 = zeros(m,n);
MSE12 = zeros(m,n);
for x=1:m
    for y=1:n
        MSE11(x,y) = (I(x,y)-g(x,y))^2; //Formula for MSE
    end
end
MSE12 = sum(MSE11);
MSE13 = MSE12/(m*n);
m2 = max(g)
disp("MSE of noisy",MSE13);
PSNR1 = 10*log(m2/MSE13); //Formula for PSNR
disp("PSNR of noisy",PSNR1);



