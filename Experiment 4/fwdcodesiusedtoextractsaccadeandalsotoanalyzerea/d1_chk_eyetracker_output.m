% devices = daq.getDevices
s = daq.createSession('ni');
addAnalogInputChannel(s,'Dev1', 'ai0', 'Voltage');
addAnalogInputChannel(s,'Dev1', 'ai1', 'Voltage');
data = s.inputSingleScan
[data,time] = s.startForeground;
figure;plot(time,data)
