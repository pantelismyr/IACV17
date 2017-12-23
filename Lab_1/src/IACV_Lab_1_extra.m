clc; clear all; close all;
addpath('Functions','Images','Images-m','Images-mat');

%% 1.3 Basis functions

% visualize a moving pixel
size = 128;
prompt = 'Do you to visualize a moving pixel? y/n : ';
str = input(prompt,'s');
if str == 'y'
    figure(1)
    title('visualize a moving pixel')
    for i=1:floor(size/2)
        for j=1:floor(size/2)
            fftwave( i,j, size );
            pause(0.001)
        end
    end
end

%% 1.7 Rotation
prompt = 'Do you to visualize a rotating rectangle? y/n : ';
str = input(prompt,'s');
if str == 'y'
    F = [zeros(60, 128); ones(8, 128); zeros(60, 128)] .* ...
        [zeros(128, 48) ones(128, 32) zeros(128, 48)];
    
    figure(2)
    title('visualize a rotating rectangle')
    for a=1:360
        subplot(1, 3, 1);
        G = rot(F, a );
        showgrey(G)
        Ghat = fft2(G);
        subplot(1, 3, 2);
        showfs(Ghat);
        Hhat = rot(fftshift(Ghat), -a );
        %
        subplot(1, 3, 3);
        showgrey(log(1 + abs(Hhat)))
        suptitle(['Rotation of F by : ' num2str(a) ' deg'])
        pause(0.005)
    end
end