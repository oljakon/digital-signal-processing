function lab9
    I = double(imread('bimage2.bmp')) / 255;
    figure(1); imshow(I); title('Origin Image');

    PSF = fspecial('motion', 55, 205);
    figure(2); imshow(deconvblind(I, PSF)); title('Deblurred Image');
    imwrite(deconvblind(I, PSF), 'result.png');
end