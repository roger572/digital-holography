function [quality, quality_map] = img_qi(img1, img2, block_size)
%function [quality,CC,LD,CD, quality_map] = img_qi(img1, img2, block_size)
%
%========================================================================
%
%Copyright (c) 2001 The University of Texas at Austin
%All Rights Reserved.
% 
%This program is free software; you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation; either version 2 of the License, or
%(at your option) any later version.
% 
%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
% 
%The GNU Public License is available in the file LICENSE, or you
%can write to the Free Software Foundation, Inc., 59 Temple Place -
%Suite 330, Boston, MA 02111-1307, USA, or you can find it on the
%World Wide Web at http://www.fsf.org.
%
%Author  : Zhou Wang 
%Version : 1.0
% 
%The authors are with the Laboratory for Image and Video Engineering
%(LIVE), Department of Electrical and Computer Engineering, The
%University of Texas at Austin, Austin, TX.
%
%Kindly report any suggestions or corrections to zwang@ece.utexas.edu
%
%Acknowledgement:
%The author would like to thank Mr. Umesh Rajashekar, the Matlab master
%in our lab, for spending his precious time and giving his kind help
%on writing this program. Without his help, this program would not
%achieve its current efficiency.
%
%========================================================================
%
%This is an efficient implementation of the algorithm for calculating
%the universal image quality index proposed by Zhou Wang and Alan C. 
%Bovik. Please refer to the paper "A Universal Image Quality Index"
%by Zhou Wang and Alan C. Bovik, published in IEEE Signal Processing
%Letters, 2001. In order to run this function, you must have Matlab's
%Image Processing Toobox.
%
%Input : an original image and a test image of the same size
%Output: (1) an overall quality index of the test image, with a value
%            range of [-1, 1].
%        (2) a quality map of the test image. The map has a smaller
%            size than the input images. The actual size is
%            img_size - BLOCK_SIZE + 1.
%
%Usage:
%
%1. Load the original and the test images into two matrices
%   (say img1 and img2)
%
%2. Run this function in one of the two ways:
%
%   % Choice 1 (suggested):
%   [qi qi_map] = img_qi(img1, img2);
%
%   % Choice 2:
%   [qi qi_map] = img_qi(img1, img2, BLOCK_SIZE);
%
%   The default BLOCK_SIZE is 8 (Choice 1). Otherwise, you can specify
%   it by yourself (Choice 2).
%
%3. See the results:
%
%   qi                    %Gives the over quality index.
%   imshow((qi_map+1)/2)  %Shows the quality map as an image.
%
%========================================================================

if (nargin == 1 | nargin > 3)
   quality = -Inf;
   quality_map = -1*ones(size(img1));
   return;
end

if (size(img1) ~= size(img2))
   quality = -Inf;
   quality_map = -1*ones(size(img1));
   return;
end

if (nargin == 2)
   block_size = 8;
end

N = block_size.^2;
sum2_filter = ones(block_size);

img1_sq   = img1.*img1;
img2_sq   = img2.*img2;
img12 = img1.*img2;

img1_sum   = filter2(sum2_filter, img1, 'valid');   % N*E[x]
img2_sum   = filter2(sum2_filter, img2, 'valid');   % N*E[y]
img1_sq_sum = filter2(sum2_filter, img1_sq, 'valid'); % N*E[x^2]
img2_sq_sum = filter2(sum2_filter, img2_sq, 'valid'); % N*E[y^2]
img12_sum = filter2(sum2_filter, img12, 'valid');   % N*E[xy]

img12_sum_mul = img1_sum.*img2_sum; % N^2 E[x]E[y]
img1_sum_sq = img1_sum.*img1_sum;   % N^2 E[x]^2
img2_sum_sq = img2_sum.*img2_sum;   % N^2 E[y]^2
img12_sq_sum_mul = img1_sum_sq + img2_sum_sq; % N^2(E[x]^2 + E[y]^2)
N2sigma_xy = N*img12_sum - img12_sum_mul; % N^2(E[xy]-E[x]E[y])
numerator = 4*N2sigma_xy.*img12_sum_mul;
denominator1 = N*(img1_sq_sum + img2_sq_sum) - img12_sq_sum_mul; % N^2 (var_x + var_y)
denominator = denominator1.*img12_sq_sum_mul;

% % Agregado para diferenciar las distorsiones
% % NO ALCANZA LA PRECISION Y TIRA CUALQUIER COSA
% Nstd_x_std_y = sqrt((N*img1_sq_sum - img1_sum_sq)*(N*img2_sq_sum - img2_sum_sq)); % N * sigma_x * sigma_y
% img_CC = N2sigma_xy ./ (N * Nstd_x_std_y);
% CC = mean2(img_CC); % Coeficiente de correlacion
% img_LD = 2*img12_sum_mul ./ img12_sq_sum_mul;
% LD = mean2(img_LD); % Distorsion por luminancia
% img_CD = 2*N*Nstd_x_std_y ./ denominator1;
% CD = mean2(img_CD); % Distorsion por contraste


quality_map = ones(size(denominator));
% index = (denominator1 == 0) & (img12_sq_sum_mul ~= 0); % Esto lo saqu� yo
index = (abs(denominator1) < 1e-6) & (img12_sq_sum_mul ~= 0);
quality_map(index) = 2*img12_sum_mul(index)./img12_sq_sum_mul(index);
% index = (denominator ~= 0); % Esto lo saqu� yo
index = ~index;
quality_map(index) = numerator(index)./denominator(index);

quality = mean2(quality_map);