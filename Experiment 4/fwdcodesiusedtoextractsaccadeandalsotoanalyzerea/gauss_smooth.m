function y = gauss_smooth(x,win)
win = win+mod(win+1,2);
k = (6/sqrt(2*pi)/win)*exp(-0.5*(6*linspace(-win/2,win/2,win)/win).^2);
conv_value = conv(x,k,'full');
y = conv_value((win-1)/2+1:length(conv_value)-(win-1)/2 );
end








