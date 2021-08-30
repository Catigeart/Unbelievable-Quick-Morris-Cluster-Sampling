function row = dynamicMatRow(col,dataSize)

if nargin==1
    dataSize = 1; % default set byte(s)=1
end

bytes = java.lang.management.ManagementFactory. ...\
    getOperatingSystemMXBean().getTotalPhysicalMemorySize();
limits = round(bytes/10); % set default limitation 10% RAM

row = floor(limits/(col*dataSize));

end